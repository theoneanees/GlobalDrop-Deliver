// import 'package:flutter/material.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class BuyerMain extends StatefulWidget {
//   @override
//   _BuyerMainState createState() => _BuyerMainState();
// }

// final TextEditingController itemName = TextEditingController();
// final TextEditingController itemWeight = TextEditingController();
// final TextEditingController itemPrice = TextEditingController();
// final TextEditingController itemDateRange = TextEditingController();
// final datetimee = null;

// class _BuyerMainState extends State<BuyerMain> {
//   DateTime selectedDate = DateTime.now();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//       });
//   }

//   final databaseReference = FirebaseFirestore.instance;
//   Future<void> createRecord(
//       String iname, String iweight, String iprice, String idate) async {
//     await FirebaseFirestore.instance.collection("Item").doc().set({
//       'item_data': iname,
//       'item_weight': iweight,
//       'item_price': iprice,
//       'item_date': idate,
//     });

//     // DocumentReference ref = await databaseReference.collection("books")
//     //     .add({
//     //       'title': 'Flutter in Action',
//     //       'description': 'Complete Programming Guide to learn Flutter from Anno'
//     //     });
//     // print(ref.id);
//     // FirebaseFirestore.instance.collection('OrderID').doc()
//     //                                      .set({'title': 'Anos programming'});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("BUYER"),
//         centerTitle: true,
//         backgroundColor: Colors.lightBlue[500],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
//               child: TextField(
//                 controller: itemName,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter item name',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: TextField(
//                 controller: itemPrice,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter item estimated price',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: TextField(
//                 controller: itemWeight,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter item estimated weight (in grams)',
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             Container(
//               height: 65.0,
//               width: 400,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all()),
//               child: Row(
//                 children: [
//                   Text(
//                     '   click to select delivery date',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 12.0,
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.lightBlue,
//                       alignment: Alignment.centerLeft,
//                       textStyle: TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontStyle: FontStyle.italic),
//                     ),
//                     onPressed: () => _selectDate(context),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text("$selectedDate".split(' ')[0]),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 72.0),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.lightBlue,
//                 shape: StadiumBorder(),
//                 fixedSize: Size(300, 90),
//                 textStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 32,
//                     fontStyle: FontStyle.italic),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('Create Record'),
//               ),
//               onPressed: () {
//                 createRecord(itemName.text, itemWeight.text, itemPrice.text,
//                     "${selectedDate.toLocal()}".split(' ')[0]);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
