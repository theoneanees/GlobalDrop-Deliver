import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.userPhoto,
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

  _PostState({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.userPhoto,
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
            backgroundImage: CachedNetworkImageProvider(mediaUrl),
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
    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.5),
                spreadRadius: 15,
                blurRadius: 18),
          ],
        ),
        child: CachedNetworkImage(
          imageUrl: mediaUrl,
        ),
      ),
      borderRadius: BorderRadius.circular(30.0),
    );
  }

  buildPostFooter() {
    return Column(
      children: [
        Text(
          description,
          style: TextStyle(color: Colors.black, fontSize: 25.0),
        ),
      ],
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
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Text('This is anno'),
            // Text('This is anno'),
            // Text('This is anno'),
            // Text('This is anno'),
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
