// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdds/Screens/Buyer/buyerSideDrawer.dart';
import 'package:gdds/Screens/Buyer/profile.dart';
import 'package:gdds/Screens/Buyer/profiletest.dart';
import 'package:gdds/Screens/Buyer/timeline.dart';
import 'package:gdds/Screens/Buyer/upload.dart';
import 'package:gdds/Screens/Chat/pages/pages.dart';
import 'package:gdds/Screens/Traveler/sideDrawer.dart';
import 'package:gdds/Screens/register/As%20a%20traveler/sign_up_Traveler.dart';
import 'package:gdds/models/userdata.dart';

final usersRef = FirebaseFirestore.instance.collection('buyers');
final userPostRef = FirebaseFirestore.instance.collection('buyerPosts');
final DateTime timestamp = DateTime.now();
UserData? currBuyer;
final buyer = FirebaseAuth.instance.currentUser!;

final Reference storageRef = FirebaseStorage.instance.ref();

class Navigation extends StatefulWidget {
  Navigation({this.buyerPhotoUrl});
  final String? buyerPhotoUrl;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    print("This is buyer Navigation");
    if (buyer.displayName == null) {
      createManualBuyerInFirestore();
    } else {
      createUserInFirestore();
    }
  }

  createUserInFirestore() async {
    DocumentSnapshot doc = await usersRef.doc(buyer.uid).get();
    if (!doc.exists) {
      usersRef.doc(buyer.uid).set(
        {
          'id': buyer.uid,
          'username': buyer.displayName,
          'email': buyer.email,
          'photoUrl': buyer.photoURL,
          'timeStamp': timestamp
        },
      );
      doc = await usersRef.doc(buyer.uid).get();
    }
    currBuyer = UserData.fromDocument(doc);
    // print(user.photoURL!);
    // print(currUser!.username);
  }

  createManualBuyerInFirestore() async {
    DocumentSnapshot doc = await usersRef.doc(buyer.uid).get();
    print(buyer.uid);
    print(manualUserName);
    print(buyer.email);
    print(widget.buyerPhotoUrl);

    if (!doc.exists) {
      // travelerPotoLink = widget.travelerPhotoURL!;
      usersRef.doc(buyer.uid).set(
        {
          'id': buyer.uid,
          'username': manualUserName,
          'email': buyer.email,
          'photoUrl': widget.buyerPhotoUrl,
          'timeStamp': timestamp,
        },
      );
      doc = await usersRef.doc(buyer.uid).get();
    }
    currBuyer = UserData.fromDocument(doc);
    print(currBuyer!.email);
    print(currBuyer!.photoUrl);
    print(currBuyer!.username);
    print(currBuyer!.id);
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Timeline();

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


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageStorage(child: currentScreen, bucket: bucket),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo[500],
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UploadPost()));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 13.0,
          color: Colors.grey[350],
          child: Container(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = Timeline();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timeline,
                            color: Colors.indigo[500],
                          ),
                          Text(
                            "Timeline",
                            style: TextStyle(
                                color: Colors.indigo[500], fontSize: 15.0),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = SplashPage();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: Colors.indigo[500],
                          ),
                          Text(
                            "Chat",
                            style: TextStyle(
                                color: Colors.indigo[500], fontSize: 15.0),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = ProfileTest();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.feed,
                            color: Colors.indigo[500],
                          ),
                          Text(
                            "Feed",
                            style: TextStyle(
                                color: Colors.indigo[500], fontSize: 15.0),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          // currentScreen = Profile();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Profile(curentuser: currBuyer)));
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.indigo[500],
                          ),
                          Text(
                            "Profile",
                            style: TextStyle(
                                color: Colors.indigo[500], fontSize: 15.0),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
