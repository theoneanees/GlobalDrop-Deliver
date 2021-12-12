import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/bottom_nav_bar.dart';
import 'package:gdds/Screens/Buyer/post.dart';
import 'package:gdds/models/userdata.dart';
import 'package:gdds/provider/g_signIn_provider.dart';
import 'package:provider/provider.dart';

Post? postda;
UserData? usidata;

class Profile extends StatefulWidget {
  Profile({this.curentuser});
  final UserData? curentuser;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Post> posts = [];
  bool isLoading = false;

  @override
  void initState() {
    getProfilePosts();
    super.initState();
  }

  getProfilePosts() async {
    // setState(() {
    //   isLoading = false;
    // });
    QuerySnapshot snapshot = await userPostRef
        .where('ownerId', isEqualTo: widget.curentuser!.id)
        .orderBy('timestamp', descending: true)
        .get();

    setState(
      () {
        // isLoading = false;
        posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
      },
    );
  }

  buildProfileHeader() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 20,
              spreadRadius: 10,
            ),
          ],
          color: Colors.indigo[500],
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          )),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 148),
                child: Container(
                  height: 105,
                  width: 105,
                  decoration: BoxDecoration(
                    color: Colors.indigo[500],
                    borderRadius: BorderRadius.circular(52.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple[700]!,
                        spreadRadius: 3.5,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(buyer.photoURL!),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            buyer.email!,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              buyer.displayName!,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Buyer',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  buildProfilePosts() {
    return Column(children: posts);
  }

  buildMyPost() async {
    // DocumentSnapshot doc = await postsRef.doc(postsRef.id).collection('userPosts').doc().get();
    DocumentSnapshot doc = await usersRef.doc(buyer.uid).get();
    currBuyer = UserData.fromDocument(doc);
    // postda = Post.fromDocument(doc);
    return Column(
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundImage: NetworkImage(currBuyer!.photoUrl!),
        ),
        Text(
          currBuyer!.username!,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.indigo[500],
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          Divider(
            height: 20.0,
          ),
          buildProfilePosts(),
        ],
      ),
    );
  }
}
