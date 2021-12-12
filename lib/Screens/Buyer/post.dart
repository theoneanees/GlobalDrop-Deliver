import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdds/Screens/Buyer/buyer_window.dart';
import 'package:gdds/models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:gdds/Screens/Buyer/upload.dart';

import 'bottom_nav_bar.dart';

final userd = FirebaseAuth.instance.currentUser;

class Post extends StatefulWidget {
  final String? postId;
  final String? ownerId;
  final String? username;
  final String? location;
  final String? description;
  final String? mediaUrl;
  final String? userPhoto;
  final String? startDate;
  final String? endDate;
  final String? expectedWeight;
  final String? desiredLocation;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.userPhoto,
    this.startDate,
    this.endDate,
    this.expectedWeight, this.desiredLocation
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc.data().toString().contains('postId') ? doc.get('postId') : '',
      ownerId:
          doc.data().toString().contains('ownerId') ? doc.get('ownerId') : '',
      username:
          doc.data().toString().contains('username') ? doc.get('username') : '',
      location:
          doc.data().toString().contains('location') ? doc.get('location') : '',
      description: doc.data().toString().contains('description')
          ? doc.get('description')
          : '',
      mediaUrl:
          doc.data().toString().contains('mediaUrl') ? doc.get('mediaUrl') : '',
      userPhoto: doc.data().toString().contains('userPhoto')
          ? doc.get('userPhoto')
          : '',
      startDate: doc.data().toString().contains('startDate')
          ? doc.get('startDate')
          : '',
      endDate: doc.data().toString().contains('endDate')
          ? doc.get('endDate')
          : '',
      expectedWeight: doc.data().toString().contains('expectedWeight')
          ? doc.get('expectedWeight')
          : '',
      desiredLocation: doc.data().toString().contains('desiredLocation')
          ? doc.get('desiredLocation')
          : '',
    );
  }
  @override
  _PostState createState() => _PostState(
        postId: this.postId!,
        ownerId: this.ownerId!,
        username: this.username!,
        location: this.location!,
        description: this.description!,
        mediaUrl: this.mediaUrl!,
        userPhoto: this.userPhoto!,
        startDate: this.startDate!,
        endDate: this.endDate!,
        expectedWeight: this.expectedWeight!,
        desiredLocation: this.desiredLocation!
      );
}

class _PostState extends State<Post> {
  final String currentUserId = userdata.uid;
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final String userPhoto;
  final String startDate;
  final String endDate;
  final String expectedWeight;
  final String desiredLocation;

  _PostState({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.userPhoto,
    required this.startDate,
    required this.endDate,
    required this.expectedWeight,
    required this.desiredLocation
  });

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        UserData user =
            UserData.fromDocument(snapshot.data! as DocumentSnapshot);
        bool isPostOwner = currentUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userPhoto),
            backgroundColor: Colors.grey,
            radius: 25,
          ),
          title: GestureDetector(
            onTap: () => print(
                'show profile'), // showProfile(context, profileId: user.id),
            child: Text(
              // userd!.displayName!,
              username,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(
            location,
            style: TextStyle(fontSize: 16.0, color: Colors.grey[900]),
          ),
          trailing: isPostOwner
              ? IconButton(
                  onPressed: () =>
                      print('Delete Item'), //handleDeletePost(context),
                  icon: Icon(Icons.more_vert),
                )
              : Text(''),
        );
      },
    );
  }

  buildPostImage() {
    if (mediaUrl != "") {
  return AspectRatio(
        aspectRatio: 16/14,
        child: Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 14,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                      ),
                    ],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(mediaUrl),
                    ),
                  ),
                ),
              ),
            ),
          ),
  );
}
else
return Text("");
  }

  buildPostFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Item Name",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              description,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Expected Weight",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              expectedWeight + " Kg",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Start Date",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              startDate,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "End Date",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              endDate,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Desired Location",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              desiredLocation,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current Location",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              location,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            buildPostHeader(),
            buildPostImage(),
            buildPostFooter(),
            Divider()
          ],
        ),
      ),
    );
  }
}
