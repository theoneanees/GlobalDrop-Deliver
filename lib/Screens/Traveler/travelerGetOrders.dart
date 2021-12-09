import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:gdds/Screens/Traveler/travelerOrderScreen.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';

class TravelerGetOrder extends StatefulWidget {
  @override
  _TravelerGetOrderState createState() => _TravelerGetOrderState();
}

class _TravelerGetOrderState extends State<TravelerGetOrder> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<TravelerOrderScreen> travelerOrders = [];

  @override
  void initState() {
    super.initState();
    print("this is Get Order Window");
    getYourOrderList();
    // print(manualPhotoUrl);
  }
  buildYourOrderList(){
    if (travelerOrders == null) {
      return circularProgress();
    }
    return ListView(children: travelerOrders);
  }

  getYourOrderList() async{
    QuerySnapshot snapshot = await travelerOffersRef.get();

    List<TravelerOrderScreen> travelerOrders =
          snapshot.docs.map((doc) => TravelerOrderScreen.fromDocument(doc)).toList();

      setState(() {
        this.travelerOrders = travelerOrders;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Orders'.toUpperCase()),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => getYourOrderList(),
        child: buildYourOrderList(),
      ),
    );
  }
}
