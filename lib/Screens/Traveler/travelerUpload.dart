import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdds/Screens/Traveler/travelerTimeline.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:csc_picker/csc_picker.dart';

DateTime timestampR = DateTime.now();

class TravelerUpload extends StatefulWidget {
  @override
  State<TravelerUpload> createState() => _TravelerUploadState();
}

class _TravelerUploadState extends State<TravelerUpload> {
  @override
  void initState() {
    super.initState();
    locationController.clear();
    availWeightController.clear();
    print(currentTraveler!.username);
    print(currentTraveler!.email);
    print(currentTraveler!.rating);
  }

  String date = DateTime.now().toString().split(' ')[0];
  DateTime selectedDate = DateTime.now();
  TextEditingController locationController = TextEditingController();
  String? address;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  TextEditingController availWeightController = TextEditingController();

  String travelerpostId = Uuid().v4();

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

  createTravelerPostInFirestore(
      {String? arrivalDate,
      String? destination,
      String? currentLocation,
      String? availWeight}) {
    travelerPostsRef.doc(travelerpostId).set({
      "postId": travelerpostId,
      "ownerId": traveler.uid,
      "username": traveler.displayName ?? currentTraveler!.username,
      "userPhoto": traveler.photoURL ?? currentTraveler!.photoUrl,
      "availWeight": availWeight,
      "currentLocation": currentLocation!.toUpperCase(),
      "destination": destination!.toUpperCase(),
      "arrivalDate": arrivalDate,
      "timestamp": timestampR,
      "rating": currentTraveler!.rating
    });
  }

  printAdress() {
    print(address);
  }

  // putting form checks in to force traveler to submit the filled form
  handleSubmit() {
    if (address == null ||
        locationController.text.isEmpty ||
        availWeightController.text.isEmpty) {
      Fluttertoast.showToast(msg: "please fill all the fields");
      return;
    }
    timestampR = DateTime.now();
    createTravelerPostInFirestore(
        arrivalDate: date,
        destination: address,
        currentLocation: locationController.text,
        availWeight: availWeightController.text);

    setState(() {
      travelerpostId = Uuid().v4();
      Fluttertoast.showToast(msg: "Post Uploaded Successfully");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TravelerTimeline(
                currLoc: locationController.text,
                desitination: address,
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Traveler Upload'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
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
                // color: Colors.grey[400],
                height: 480,
                child: Column(
                  children: [
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
                                  hintText: 'Available Weight',
                                  label: Text("Enter available weight (Kg)"),
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
                    // Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    //   child: TextField(
                    //     controller: destinationController,
                    //     decoration: InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       hintText: 'Enter your destination city',
                    //       label: Text("Destination City"),
                    //     ),
                    //   ),
                    // ),
                    Container(height: 18),
                    Text(
                      "Please select your location",
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(height: 12),
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
                      height: 100.0,
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
                  print(date);
                  handleSubmit();
                  // printAdress();
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.blue,
                ),
                label: const Text(
                  'Post Request',
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
}//"$selectedDate".split(' ')[0].toString()
