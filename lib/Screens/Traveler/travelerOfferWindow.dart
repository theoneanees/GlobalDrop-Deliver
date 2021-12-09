// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdds/Screens/Buyer/bottom_nav_bar.dart';
import 'package:gdds/Screens/Buyer/buyer_window.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:gdds/Screens/Traveler/travelerTimeline.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';
import 'package:gdds/models/userdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';

DateTime timestampR = DateTime.now();

class OfferWindow extends StatefulWidget {
  OfferWindow({this.buyerId});
  final String? buyerId;

  @override
  _OfferWindowState createState() => _OfferWindowState();
}

class _OfferWindowState extends State<OfferWindow> {
  UserData ? crntBuyer;
  String? buyerEmail;
  String? buyerName;
  String date = DateTime.now().toString().split(' ')[0];
  DateTime selectedDate = DateTime.now();
  TextEditingController locationController = TextEditingController();
  String? address;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  TextEditingController availWeightController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();

  String travelerOfferId = Uuid().v4();

   @override
  void initState() {
    super.initState();
    getBuyerNameAndEmail();
    print("buyer Data");
    // print(buyerEmail);
    // print(buyerName);
  }

  getBuyerNameAndEmail () async {
    DocumentSnapshot doc = await usersRef.doc(widget.buyerId).get();
    print("doc");
    print(doc.id);
    crntBuyer = UserData.fromDocument(doc);
    buyerName = crntBuyer!.username;
    buyerEmail = crntBuyer!.email;
    print(buyerName);
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    setState(() {
      locationController.text = formattedAddress;
    });
  }

  createTravelerOfferInFirestore(
      {String? arrivalDate,
      String? destination,
      String? currentLocation,
      String? itemWeight,
      String? itemName
      }) {
    travelerOffersRef.doc(travelerOfferId).set({
      "offerId": travelerOfferId,
      "travelerId": traveler.uid,
      "buyerId": widget.buyerId,
      "buyerUsername": buyerName,
      "buyerEmail" : buyerEmail,
      "travelerUsername": traveler.displayName ?? currentTraveler!.username,
      "travelerEmail": traveler.email ?? currentTraveler!.email,
      "itemWeight": itemWeight,
      "arrivalDate": arrivalDate,
      "itemName": itemName,
      "currentLocation": currentLocation!.toUpperCase(),
      "destination": destination!.toUpperCase(),
      "timestamp": timestampR,
      "currentStatus": "Waiting for buyer's response"
    });
  }

  handleSubmit() {
    if (address == null ||
        locationController.text.isEmpty ||
        availWeightController.text.isEmpty) {
      Fluttertoast.showToast(msg: "please fill all the fields");
      return;
    }
    timestampR = DateTime.now();
    createTravelerOfferInFirestore(
        arrivalDate: date,
        destination: address,
        currentLocation: locationController.text,
        itemWeight: availWeightController.text, 
        itemName: itemNameController.text
        );

    setState(() {
      travelerOfferId = Uuid().v4();
      locationController.clear();
      availWeightController.clear();
      itemNameController.clear();
      Fluttertoast.showToast(msg: "Offer Created Successfully");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TravelerTimeline(
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Traveler OFFER'.toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: usersRef.doc(widget.buyerId).get(),
          builder: (context, snapshot){
            if (!snapshot.hasData) {
              return linearProgress();
            }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  height: 560,
                  child: Column(
                    children: [
                      Container(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your\nData".toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "username : " +
                                currentTraveler!.username! +
                                "\nemail : " +
                                currentTraveler!.email!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      Divider(height: 15, thickness: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Buyer\nData".toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "username : " +
                                buyerName! +
                                "\nemail : " +
                                buyerEmail!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.5,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(height: 15, thickness: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: Container(
                                width: 50,
                                child: TextField(
                                  controller: availWeightController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Item Weight',
                                    label: Text("Enter item weight (Kg)"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                    child: Text("Choose Date"),
                                  ),
                                  Text(
                                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: itemNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Item Name',
                          label: Text("Item Name"),
                        ),
                      ),
                      Container(height: 7),
                      Text(
                        "Select your location",
                        style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(height: 7),
                      CSCPicker(
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                      
                      Container(height: 18),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your current city',
                            label: Text("Current City"),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 60.0,
                        alignment: Alignment.center,
                        child: RaisedButton.icon(
                          label: Text(
                            "Use Current Location",
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.blue,
                          // onPressed: getUserLocation,
                          onPressed: () => getUserLocation(),
                          icon: Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 5,
                      offset: Offset.zero,
                    )
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    address =
                        cityValue! + ",\n" + stateValue! + ",\n" + countryValue!;
                    print(address);
                    handleSubmit();
                    // printAdress();
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'Create Offer',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      fixedSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
              ),
            ],
          );
          }
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        date = "$selected".split(' ')[0];
      });
  }
}
