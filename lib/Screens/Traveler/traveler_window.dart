import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/services.dart';
import 'package:gdds/Screens/Chat/pages/pages.dart';
import 'package:gdds/Screens/Traveler/travelerTimeline.dart';
import 'package:gdds/Screens/Traveler/travelerUpload.dart';
import 'package:gdds/Screens/register/As%20a%20traveler/sign_up_Traveler.dart';
import 'package:gdds/models/travelerdata.dart';

final travelersRef = FirebaseFirestore.instance.collection('travelers');
final travelerPostsRef = FirebaseFirestore.instance.collection('travelerPosts');
final travelerOffersRef = FirebaseFirestore.instance.collection('orders');
final traveler = FirebaseAuth.instance.currentUser!;
final DateTime timestamp = DateTime.now();
TravelerData? currentTraveler;
String travelerPotoLink = "";

class TravelerMain extends StatefulWidget {
  final String? travelerPhotoURL;
  TravelerMain({this.travelerPhotoURL});

  @override
  State<TravelerMain> createState() => _TravelerMainState();
}

class _TravelerMainState extends State<TravelerMain> {
  @override
  void initState() {
    super.initState();

    print(traveler.displayName);
    // print(currentTraveler!.username);
    // if ((traveler.displayName == null) && (verifySignin == false)) {
    if (traveler.displayName == null) {
      createManualTravelerInFirestore();
    } else {
      createTravelerInFirestore();
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirm Exit?',
                style: new TextStyle(color: Colors.black, fontSize: 20.0)),
            content: new Text(
                'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  // this line exits the app.
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: new Text('Yes', style: new TextStyle(fontSize: 18.0)),
              ),
              new FlatButton(
                onPressed: () =>
                    Navigator.pop(context), // this line dismisses the dialog
                child: new Text('No', style: new TextStyle(fontSize: 18.0)),
              )
            ],
          ),
        ) ??
        false;
  }

  createTravelerInFirestore() async {
    DocumentSnapshot doc = await travelersRef.doc(traveler.uid).get();

    if (!doc.exists) {
      travelersRef.doc(traveler.uid).set(
        {
          'id': traveler.uid,
          'username': traveler.displayName,
          'email': traveler.email,
          'photoUrl': traveler.photoURL,
          'timeStamp': timestamp,
          'rating': 0.0
        },
      );
      doc = await travelersRef.doc(traveler.uid).get();
    }
    currentTraveler = TravelerData.fromDocument(doc);
    // print(currentTraveler!.email);
  }

  getManualTravelerPhotoUrl() {}

  createManualTravelerInFirestore() async {
    DocumentSnapshot doc = await travelersRef.doc(traveler.uid).get();
    print(traveler.uid);
    print(manualUserName);
    print(traveler.email);
    print(widget.travelerPhotoURL);

    if (!doc.exists) {
      travelerPotoLink = widget.travelerPhotoURL!;
      travelersRef.doc(traveler.uid).set(
        {
          'id': traveler.uid,
          'username': manualUserName,
          'email': traveler.email,
          'photoUrl': widget.travelerPhotoURL,
          'timeStamp': timestamp,
        },
      );
      doc = await travelersRef.doc(traveler.uid).get();
    }
    currentTraveler = TravelerData.fromDocument(doc);
    print(currentTraveler!.email);
    print(currentTraveler!.photoUrl);
    print(currentTraveler!.username);
    print(currentTraveler!.id);
  }

  int currentIndex = 0;

  List listOfColors = [
    //Timeline(),
    TravelerTimeline(),
    TravelerUpload(),
    // Container(color: Colors.red,),
    HomePage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          animationDuration: Duration(milliseconds: 2000),
          selectedIndex: currentIndex,
          onItemSelected: (index) => setState(
            () {
              currentIndex = index;
            },
          ),
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text('Timeline'),
                icon: Icon(Icons.home),
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                title: Text('Upload'),
                icon: Icon(Icons.add_box),
                activeColor: Colors.red,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                title: Text('Chats'),
                icon: Icon(Icons.message),
                activeColor: Colors.pinkAccent,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                title: Text('Setting'),
                icon: Icon(Icons.settings),
                activeColor: Colors.green,
                inactiveColor: Colors.black),
          ],
        ),
        body: listOfColors[currentIndex],
      ),
    );
  }
}
