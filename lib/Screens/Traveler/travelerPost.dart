import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdds/Screens/Chat/models/user_chat.dart';
import 'package:gdds/Screens/Chat/pages/pages.dart';
import 'package:gdds/Screens/Traveler/getTravelerRatingsList.dart';
import 'package:gdds/Screens/Traveler/travelerRatings.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

final currentTraveler = FirebaseAuth.instance.currentUser;
DocumentSnapshot? curdoc;

class TravelerPost extends StatefulWidget {
  final String? postId;
  final String? ownerId;
  final String? username;
  final String? userPhoto;
  final String? availWeight;
  final String? currentLocation;
  final String? destination;
  final String? arrivalDate;
  final num? rating;

  TravelerPost(
      {this.postId,
      this.ownerId,
      this.username,
      this.userPhoto,
      this.availWeight,
      this.currentLocation,
      this.destination,
      this.arrivalDate,
      this.rating});

  factory TravelerPost.fromDocument(DocumentSnapshot doc) {
    return TravelerPost(
      postId: doc.data().toString().contains('postId') ? doc.get('postId') : '',
      ownerId:
          doc.data().toString().contains('ownerId') ? doc.get('ownerId') : '',
      username:
          doc.data().toString().contains('username') ? doc.get('username') : '',
      userPhoto: doc.data().toString().contains('userPhoto')
          ? doc.get('userPhoto')
          : '',
      availWeight: doc.data().toString().contains('availWeight')
          ? doc.get('availWeight')
          : '',
      currentLocation: doc.data().toString().contains('currentLocation')
          ? doc.get('currentLocation')
          : '',
      destination: doc.data().toString().contains('destination')
          ? doc.get('destination')
          : '',
      arrivalDate: doc.data().toString().contains('arrivalDate')
          ? doc.get('arrivalDate')
          : '',
      rating:
          doc.data().toString().contains('rating') ? doc.get('rating') : 0.0,
    );
  }
  @override
  _TravelerPostState createState() => _TravelerPostState(
        postId: this.postId!,
        ownerId: this.ownerId!,
        username: this.username!,
        userPhoto: this.userPhoto!,
        availWeight: this.availWeight!,
        currentLocation: this.currentLocation!,
        destination: this.destination!,
        arrivalDate: this.arrivalDate!,
        rating: this.rating,
      );
}

class _TravelerPostState extends State<TravelerPost> {
  final String currentUserId = currentTraveler!.uid;
  final String postId;
  final String ownerId;
  final String username;
  final String userPhoto;
  final String availWeight;
  final String currentLocation;
  final String destination;
  final String arrivalDate;
  final num? rating;

  _TravelerPostState(
      {required this.postId,
      required this.ownerId,
      required this.username,
      required this.userPhoto,
      required this.availWeight,
      required this.currentLocation,
      required this.destination,
      required this.arrivalDate,
      this.rating});

  buildPostHeader() {
    return FutureBuilder(
      future: travelersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        // TravelerData tuser =
        //     TravelerData.fromDocument(snapshot.data! as DocumentSnapshot);
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
                  fontStyle: FontStyle.italic),
            ),
          ),
          subtitle: GestureDetector(
            child: SmoothStarRating(
                allowHalfRating: true,
                starCount: 5,
                rating: rating!.toDouble(),
                size: 20.0,
                isReadOnly: true,
                color: Colors.yellow[900],
                borderColor: Colors.yellow[900],
                spacing: 0.0),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GetTravelerRatingsList(
                  travelerName: ownerId,
                ),
              ),
            ),
          ),
          trailing: isPostOwner
              ? IconButton(
                  onPressed: () => FirebaseFirestore.instance
                      .runTransaction((transaction) async =>
                          transaction.delete(travelerPostsRef.doc(postId)))
                      .then((value) => print(
                          "document deletted")), //handleDeletePost(context),
                  icon: Icon(Icons.more_vert),
                )
              : Text(''),
        );
      },
    );
  }

  buildPostBody() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
        flex: 1,
        child: Container(
            color: Colors.grey[350],
            // width: 60,
            child: Column(
              children: [
                Text(
                  "$currentLocation",
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
      ),
      Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.double_arrow_outlined),
            Icon(
              Icons.airplanemode_on_rounded,
              size: 40,
            ),
            Icon(Icons.double_arrow_outlined),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
            color: Colors.grey[350],
            // width: 60,
            child: Column(
              children: [
                Text(
                  "$destination",
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
      ),
    ]);
  }

  buildPostFooter() {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('dd-MMM-yyyy').format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Arrival Date",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              arrivalDate,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available Weight",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              availWeight + " Kg",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        chatWithTravelerBtn()
      ],
    );
  }

  chatWithTravelerBtn(){
    bool isPostOwner = currentUserId == ownerId;
    if (!isPostOwner) {
      return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
            onPressed: () async {
              DocumentSnapshot doc = await FirebaseFirestore.instance
                  .collection('chatUsers')
                  .doc(ownerId)
                  .get();

              UserChat userChat = UserChat.fromDocument(doc);

              WidgetsBinding.instance!.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      peerId: userChat.id,
                      peerAvatar: userChat.photoUrl,
                      peerNickname: userChat.nickname,
                    ),
                  ),
                );
              });
            },
            child: Text("Chat with Traveler"),
            style: ElevatedButton.styleFrom(
                primary: Colors.orange[800],
                shadowColor: Colors.red,
                elevation: 17,
                fixedSize: Size.fromHeight(27)),
          ),
        );
    }
    else
      return Text("data");
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
              color: Colors.grey[350]!,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPostHeader(),
            Divider(
              height: 33,
              thickness: 5,
            ),
            buildPostBody(),
            Divider(
              height: 33,
              thickness: 5,
            ),
            buildPostFooter()
          ],
        ),
      ),
    );
  }
}
