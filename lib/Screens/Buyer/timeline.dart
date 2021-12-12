// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/buyerFilterPage.dart';
import 'package:gdds/Screens/Buyer/buyerSideDrawer.dart';
import 'package:gdds/Screens/Buyer/post.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:gdds/models/userdata.dart';
import 'bottom_nav_bar.dart';

class Timeline extends StatefulWidget {
  final UserData? currentUser;
  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  buildTimeline() {
    if (posts == null) {

      return circularProgress();
    } 
    else {
      return ListView(children: posts);
    }
  }
  
  getTimeline() async {
        QuerySnapshot snapshot = await userPostRef
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts =
        snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
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
          child: BuyerSideDrawer()),
        appBar: AppBar(title: Text('Timeline'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuyerFilter()));
            },
            label: Text("Filters", style: TextStyle(color: Colors.white, fontSize: 18),),
            icon: Icon(Icons.filter_alt_outlined, color: Colors.white, size: 30,),
          ),
        ],),
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline(),),);
  }
}
