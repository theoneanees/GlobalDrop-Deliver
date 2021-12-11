import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdds/Screens/Buyer/bottom_nav_bar.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';
import 'package:gdds/models/travelerdata.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rating_dialog/rating_dialog.dart';

// final currentTraveler = FirebaseAuth.instance.currentUser;

class TravelerOrderScreen extends StatefulWidget {
  final String? offerId;
  late final String? travelerId;
  late final String? buyerId;
  final String? buyerUsername;
  final String? buyerEmail;
  final String? travelerUsername;
  final String? travelerEmail;
  final String? itemWeight;
  final String? arrivalDate;
  final String? itemName;
  final String? currentLocation;
  final String? destination;
  final String? currentStatus;

  TravelerOrderScreen({
    this.offerId,
    this.travelerId,
    this.buyerId,
    this.buyerUsername,
    this.buyerEmail,
    this.travelerUsername,
    this.travelerEmail,
    this.itemWeight,
    this.arrivalDate,
    this.itemName,
    this.currentLocation,
    this.destination,
    this.currentStatus,
  });

  factory TravelerOrderScreen.fromDocument(DocumentSnapshot doc) {
    return TravelerOrderScreen(
      offerId:
          doc.data().toString().contains('offerId') ? doc.get('offerId') : '',
      travelerId: doc.data().toString().contains('travelerId')
          ? doc.get('travelerId')
          : '',
      buyerId:
          doc.data().toString().contains('buyerId') ? doc.get('buyerId') : '',
      buyerUsername: doc.data().toString().contains('buyerUsername')
          ? doc.get('buyerUsername')
          : '',
      buyerEmail: doc.data().toString().contains('buyerEmail')
          ? doc.get('buyerEmail')
          : '',
      travelerUsername: doc.data().toString().contains('travelerUsername')
          ? doc.get('travelerUsername')
          : '',
      travelerEmail: doc.data().toString().contains('travelerEmail')
          ? doc.get('travelerEmail')
          : '',
      itemWeight: doc.data().toString().contains('itemWeight')
          ? doc.get('itemWeight')
          : '',
      arrivalDate: doc.data().toString().contains('arrivalDate')
          ? doc.get('arrivalDate')
          : '',
      itemName:
          doc.data().toString().contains('itemName') ? doc.get('itemName') : '',
      currentLocation: doc.data().toString().contains('currentLocation')
          ? doc.get('currentLocation')
          : '',
      destination: doc.data().toString().contains('destination')
          ? doc.get('destination')
          : '',
      currentStatus: doc.data().toString().contains('currentStatus')
          ? doc.get('currentStatus')
          : '',
    );
  }
  @override
  _TravelerOrderScreenState createState() => _TravelerOrderScreenState(
      offerId: this.offerId!,
      travelerId: this.travelerId!,
      buyerId: this.buyerId!,
      buyerUsername: this.buyerUsername!,
      buyerEmail: this.buyerEmail!,
      travelerUsername: this.travelerUsername!,
      travelerEmail: this.travelerEmail!,
      itemWeight: this.itemWeight!,
      arrivalDate: this.arrivalDate!,
      itemName: this.itemName!,
      currentLocation: this.currentLocation!,
      destination: this.destination!,
      currentStatus: this.currentStatus!);
}

class _TravelerOrderScreenState extends State<TravelerOrderScreen> {
  final String? currentUserId = traveler.uid;
  final String offerId;
  late final String travelerId;
  late final String buyerId;
  final String buyerUsername;
  final String buyerEmail;
  final String travelerUsername;
  final String travelerEmail;
  final String itemWeight;
  final String arrivalDate;
  final String itemName;
  final String currentLocation;
  final String destination;
  late final String currentStatus;

  _TravelerOrderScreenState({
    required this.offerId,
    required this.travelerId,
    required this.buyerId,
    required this.buyerUsername,
    required this.buyerEmail,
    required this.travelerUsername,
    required this.travelerEmail,
    required this.itemWeight,
    required this.arrivalDate,
    required this.itemName,
    required this.currentLocation,
    required this.destination,
    required this.currentStatus,
  });

  static String tempCurrStatus = "";

  @override
  void initState() {
    super.initState();
    tempCurrStatus = currentStatus;
  }

  buildPostHeader() {
    return FutureBuilder(
      future: travelersRef.doc(travelerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        TravelerData tuser =
            TravelerData.fromDocument(snapshot.data! as DocumentSnapshot);
        bool isPostOwner = currentUserId == travelerId;
        return ListTile(
          leading: Text(
            "\ntraveler  ".toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          title: GestureDetector(
            onTap: () => print(
                'show profile'), // showProfile(context, profileId: user.id),
            child: Text(
              // userd!.displayName!,
              // "\n" +currentTraveler!.username!,
              travelerUsername,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          subtitle: Text(
            travelerEmail,
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                fontStyle: FontStyle.italic),
          ),
          trailing: isPostOwner
              ? IconButton(
                  color: Colors.black,
                  onPressed: () =>
                      print('Delete Item'), //handleDeletePost(context),
                  icon: Icon(Icons.more_vert),
                )
              : Text(''),
        );
      },
    );
  }

  buildPostNeck() {
    return FutureBuilder(
      future: travelersRef.doc(travelerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        return ListTile(
          leading: Text(
            "buyer  ".toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          title: GestureDetector(
            onTap: () => print(
                'show profile'), // showProfile(context, profileId: user.id),
            child: Text(
              // userd!.displayName!,
              "      " + buyerUsername,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          subtitle: Text(
            " " + buyerEmail,
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                fontStyle: FontStyle.italic),
          ),
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
              "Item Name:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            // Icon(Icons.arrow_forward),
            // Text('------'),
            Text(
              itemName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Arrival Date:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              arrivalDate,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available Weight:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            // Icon(Icons.arrow_forward),
            // Text('------'),
            Text(
              itemWeight + " Kg",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current Status:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            currentStatusColor()
          ],
        ),
        acceptDeclineBtn(),
        Divider(height: 15),
        travelerStatusUpdateBtn(),
        itemHandOverBtn(),
        itemRecievedBtn(),
        rateTravelerBtn()
      ],
    );
  }

  currentStatusColor() {
    if (currentStatus.contains('ACCEPTED')) {
      return Text(
        // currentStatus,
        tempCurrStatus,
        style: TextStyle(
            color: Colors.green[800],
            fontSize: 12,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      );
    }
    if (currentStatus.contains('DECLINED')) {
      Text(
        // currentStatus,
        tempCurrStatus,
        style: TextStyle(
            color: Colors.red[700],
            fontSize: 12,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      );
    }
    return Text(
      // currentStatus,
      tempCurrStatus,
      style: TextStyle(
          color: Colors.red[700],
          fontSize: 12,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
    );
  }

  itemRecievedBtn() {
    if (tempCurrStatus.contains('HANDOVERED') && (currentTraveler == null)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.orange[700],
            elevation: 17,
            shadowColor: Colors.black),
        onPressed: () {
          FirebaseFirestore.instance.collection("orders").doc(offerId).update({
            "currentStatus": "Buyer has RECEIVED the item\nsuccessfully"
          }).then((_) {
            Fluttertoast.showToast(msg: "Item RECEIVED by buyer successfully");
            // setState(() {
            //   tempCurrStatus = "You have RECEIVED\nthe item";
            // });
          });
        },
        child: Text("I have Received the Item"),
      );
    }
    return Text("");
  }

  rateTravelerBtn() {
    if (tempCurrStatus.contains('RECEIVED') && (currentTraveler == null)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.orange[700],
            elevation: 17,
            shadowColor: Colors.black),
        onPressed: () async {
          DocumentSnapshot doc = await travelersRef
              .doc(travelerId)
              .collection("reviews")
              .doc(offerId)
              .get();
          if (doc.exists) {
            Fluttertoast.showToast(msg: "Review Already Submitted");
            return;
          }
          showDialog(
            context: context,
            barrierDismissible:
                true, // set to false if you want to force a rating
            builder: (context) => _ratingDialogue(),
          );
        },
        child: Text("Rate Traveler"),
      );
    }
    return Text("");
  }

  _ratingDialogue() => RatingDialog(
        initialRating: 1.0,
        // your app's name?
        title: Text(
          'GDDS',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        // encourage your user to leave a high rating?
        message: Text(
          'Rate the traveler',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        // your app's logo?
        image: CachedNetworkImage(
            height: 120,
            width: 220,
            imageUrl:
                "https://static.vecteezy.com/system/resources/thumbnails/000/620/372/small/aviation_logo-22.jpg"),
        submitButtonText: 'Submit',
        commentHint: 'Add Your Review here',
        onCancelled: () => print('cancelled'),
        onSubmitted: (response) async {
            print('rating: ${response.rating}, comment: ${response.comment}');
            await travelersRef
                .doc(travelerId)
                .collection("reviews")
                .doc(offerId)
                .set({
              'reviewerId': currBuyer!.username,
              'rating': response.rating,
              'comment': response.comment,
            });

            double previousRating = 0.0;

            DocumentSnapshot doc = await travelersRef.doc(travelerId).get();

            previousRating = TravelerData.fromDocument(doc).rating.toDouble();


            double newRating = (previousRating + response.rating) / 2;

            await travelersRef.doc(travelerId).update({
              'rating': newRating,
            });



            FirebaseFirestore.instance
                .collection("orders")
                .doc(offerId)
                .update({
              "currentStatus": "Your Order has\nCOMPLETED successfully"
            }).then((_) {
              Fluttertoast.showToast(msg: "Review SUBMITTED successfully");
              // setState(() {
              //   tempCurrStatus = "You order has be COMPLETED";
              // });
            });

          //for Buyer
        },
      );

  itemHandOverBtn() {
    if (tempCurrStatus.contains('PICKED') && (currBuyer == null)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.orange[700],
            elevation: 17,
            shadowColor: Colors.black),
        onPressed: () {
          FirebaseFirestore.instance.collection("orders").doc(offerId).update(
              {"currentStatus": "Traveler has HANDOVERED\nthe item"}).then((_) {
            Fluttertoast.showToast(
                msg: "Item HANDOVERED to buyer\nsuccessfully");
            // setState(() {
            //   tempCurrStatus = "You have HANDOVERED the item";
            // });
          });
        },
        child: Text("I Handed Over the Item to Buyer"),
      );
    }
    return Text("");
  }

  acceptDeclineBtn() {
    if ((currBuyer == null) ||
        (tempCurrStatus.contains('PICKED')) ||
        (tempCurrStatus.contains('RECEIVED')) ||
        (tempCurrStatus.contains('HANDOVERED')) ||
        (tempCurrStatus.contains('RECEIVED')) ||
        (tempCurrStatus.contains('ACCEPTED')) ||
        (tempCurrStatus.contains('COMPLETED')) ||
        (currentTraveler != null)) {
      return Text("");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(
          height: 37,
          thickness: 5,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.green, elevation: 17, shadowColor: Colors.black),
          onPressed: () {
            FirebaseFirestore.instance.collection("orders").doc(offerId).update(
                {"currentStatus": "Buyer has ACCEPTED the order"}).then((_) {
              Fluttertoast.showToast(msg: "Request Accepted successfully");
              // setState(() {
              //   tempCurrStatus = "You have ACCEPTED the request";
              // });
            });
          },
          child: Text("Accept"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 17,
            primary: Colors.red,
          ),
          onPressed: () {
            FirebaseFirestore.instance.collection("orders").doc(offerId).update(
                {"currentStatus": "Buyer has DECLINED the order"}).then((_) {
              Fluttertoast.showToast(msg: "Request declined successfully");
              // setState(() {
              //   tempCurrStatus = "You have DECLINED the request";
              // });
            });
          },
          child: Text("Decline"),
        ),
      ],
    );
  }

  travelerStatusUpdateBtn() {
    if ((currentStatus.contains('ACCEPTED')) && (currBuyer == null)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            height: 37,
            thickness: 5,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.orange[700],
                elevation: 17,
                shadowColor: Colors.black),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("orders")
                  .doc(offerId)
                  .update({
                "currentStatus": "Traveler has PICKED the item"
              }).then((_) {
                Fluttertoast.showToast(msg: "Item Picked successfully");
                // setState(() {
                //   tempCurrStatus = "You have PICKED the item";
                // });
              });
            },
            child: Text("I have picked the Item"),
          ),
        ],
      );
    }
    return Text("");
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
              thickness: 2,
            ),
            buildPostNeck(),
            Divider(
              height: 33,
              thickness: 3,
            ),
            buildPostBody(),
            Divider(
              height: 37,
              thickness: 5,
            ),
            buildPostFooter()
          ],
        ),
      ),
    );
  }
}
