import 'package:flutter/material.dart';
import 'package:gdds/Screens/Traveler/travelerTimeline.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:csc_picker/csc_picker.dart';


class TravelerFilter extends StatefulWidget {
  @override
  State<TravelerFilter> createState() => _TravelerFilterState();
}

class _TravelerFilterState extends State<TravelerFilter> {
  @override
  void initState() {
    super.initState();
    // destinationController.clear();
    locationController.clear();
    availWeightController.clear();
    print(currentTraveler!.username);
    print(currentTraveler!.email);
  }

  String date = "";
  DateTime selectedDate = DateTime.now();
  TextEditingController locationController = TextEditingController();
  // TextEditingController destinationController = TextEditingController();
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


  // putting form checks in to force traveler to submit the filled form
  handleSubmit() {
    // if (address == null ||
    //     locationController.text.isEmpty ||
    //     availWeightController.text.isEmpty) {
    //   Fluttertoast.showToast(msg: "please fill all the fields");
    //   return;
    // }
    
// Address(R), date(R), currlocation, destination

    setState(() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TravelerTimeline(
                currLoc: locationController.text,
                desitination: address,
                tArrivalDate: "$selectedDate".split(' ')[0].toString(),          // selectedDate.toString(),
                availableWeight: availWeightController.text
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Traveler Filter'),
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
                                    "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}")
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
                      "Please select your destination",
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      ),
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
                  if (address != null) {
                    address =
                      cityValue! + ",\n" + stateValue! + ",\n" + countryValue!;
                    handleSubmit();
                  }
                  handleSubmit();
                  
                  // printAdress();
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.blue,
                ),
                label: const Text(
                  'Apply Filters',
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
      });
  }
}
