import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:gdds/Screens/Traveler/travelerRatings.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';

class GetTravelerRatingsList extends StatefulWidget {
  GetTravelerRatingsList({this.travelerName});
  final String? travelerName;

  @override
  _GetTravelerRatingsListState createState() => _GetTravelerRatingsListState();
}

class _GetTravelerRatingsListState extends State<GetTravelerRatingsList> {
  List<GetTravelerRatings> travelerRatings = [];

 
    @override
  void initState() {
    super.initState();
    buildTravelerRatings();
  }
 

  buildTravelerRatings() async {
    QuerySnapshot snapshot =
        await travelersRef.
        doc(widget.travelerName).
        collection('reviews').get();

        List<GetTravelerRatings> travelerRatings = 
        snapshot.docs.map((doc) => GetTravelerRatings.fromDocument(doc)).toList();

        setState(() {
          this.travelerRatings = travelerRatings;
        });
  }

  getTravelerRatings(){
    print("travelerRatings");
      print(travelerRatings);
    if (travelerRatings.isEmpty) {
      // getNoPostMsg();
      // return getNoPostMsg();
      // return circularProgress();
}
    return ListView(children: travelerRatings);
  }

  getNoPostMsg(){
    return 
    Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 250,
          child: Text("This Traveler has no reviews yet...", 
          style: TextStyle(
            color: Colors.red[800], fontStyle: FontStyle.italic,
            fontSize: 40,
            fontWeight: FontWeight.bold
        ),
        )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("traveler Ratings".toUpperCase()),),
      body: getTravelerRatings(),
    );
  }
}
