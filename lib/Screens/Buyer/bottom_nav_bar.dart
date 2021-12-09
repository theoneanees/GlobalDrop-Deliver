import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/buyerSideDrawer.dart';
import 'package:gdds/Screens/Buyer/profile.dart';
import 'package:gdds/Screens/Buyer/profiletest.dart';
import 'package:gdds/Screens/Buyer/timeline.dart';
import 'package:gdds/Screens/Buyer/upload.dart';
import 'package:gdds/Screens/Chat/pages/pages.dart';
import 'package:gdds/Screens/Traveler/sideDrawer.dart';
import 'package:gdds/Screens/register/As%20a%20traveler/sign_up_Traveler.dart';
import 'package:gdds/models/userdata.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final userPostRef =
    postsRef.doc(postsRef.id).collection('userPosts').doc().get();
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
    // print(currUser!.photoUrl);
    // print(currUser!.email);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
