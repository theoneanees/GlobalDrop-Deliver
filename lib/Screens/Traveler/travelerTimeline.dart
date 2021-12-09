// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:gdds/Screens/Traveler/sideDrawer.dart';
import 'package:gdds/Screens/Traveler/travelerFilterPage.dart';
import 'package:gdds/Screens/Traveler/travelerPost.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';

class TravelerTimeline extends StatefulWidget {
  TravelerTimeline({this.desitination, this.currLoc,  this.tArrivalDate, this.availableWeight});
  final String? desitination;
  final String? currLoc;
  final String? tArrivalDate;
  final String? availableWeight;

  @override
  State<TravelerTimeline> createState() => _TravelerTimelineState();
}

class _TravelerTimelineState extends State<TravelerTimeline> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<TravelerPost> travelerPosts = [];

  @override
  void initState() {
    super.initState();
    print("this is traveler Timeline");
    getTravelerTimeline();
    // print(manualPhotoUrl);
  }

  buildTravelerTimeline() {
    if (travelerPosts == null) {
      return circularProgress();
    } else {
      return ListView(children: travelerPosts);
    }
  }

  getTravelerTimeline() async {
    var des = widget.desitination;
    var curLck = widget.currLoc;
    var weit = widget.availableWeight;
    var dt = widget.tArrivalDate;

    if (curLck != null && des != null) {
      print('entered location and destination');
     QuerySnapshot snapshot = await travelerPostsRef
          .
          where('currentLocation', isEqualTo: widget.currLoc!.toUpperCase())
          .
          where('destination', isEqualTo: widget.desitination!.toUpperCase())
          .
          orderBy('timestamp', descending: true)
          .get();

      List<TravelerPost> travelerPosts =
          snapshot.docs.map((doc) => TravelerPost.fromDocument(doc)).toList();

      setState(() {
        this.travelerPosts = travelerPosts;
      });
      print(widget.desitination);
      print(widget.currLoc);
      return;
    } 


    if (weit != null && dt != null) {
      print('entered weight and date');
      QuerySnapshot snapshot = await travelerPostsRef.
      // orderBy('timestamp', descending: true).
          where('arrivalDate', isEqualTo: widget.tArrivalDate).
          where('availWeight', isEqualTo: widget.availableWeight).
          // where('arrivalDate', isGreaterThanOrEqualTo: widget.tArrivalDate).
          // where('arrivalDate', isLessThanOrEqualTo: widget.tArrivalDate).
          get();


      List<TravelerPost> travelerPosts =
          snapshot.docs.map((doc) => TravelerPost.fromDocument(doc)).toList();
    

      setState(() {
        this.travelerPosts = travelerPosts;
      });
      print(widget.tArrivalDate);
      print(widget.availableWeight);
      return;
    }


    print('All Traveler Posts');
       QuerySnapshot snapshot = await travelerPostsRef.
       orderBy('timestamp', descending: true).
          get();
    //       .
    //       // where('username', isEqualTo: 'try10').
    //       // where('currentLocation', isEqualTo: curLck).
    //       // where('availWeight', isGreaterThanOrEqualTo: '12').
 
       List<TravelerPost> travelerPosts =
          snapshot.docs.map((doc) => TravelerPost.fromDocument(doc)).toList();

      setState(() {
        this.travelerPosts = travelerPosts;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                Colors.blue, //This will change the drawer background to blue.
            //other styles
          ),
          child: TravelerSideDrawer()),
      appBar: AppBar(
        actions: <Widget>[
          FlatButton.icon(
            color: Colors.red[700],
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TravelerFilter()));
            },
            label: Text("Apply\nFilters", style: TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.italic),),
            icon: Icon(Icons.filter_alt_outlined, color: Colors.white, size: 36,),
          ),
        ],
        centerTitle: true,
        title: Text("Traveler Feed"),
      ),
      body: RefreshIndicator(
        onRefresh: () => getTravelerTimeline(),
        child: buildTravelerTimeline(),
      ),
    );
  }
}

// Make a list of all countries name
// then search the list for the matching name which user has searched for
// then call the url of the correspoding flag