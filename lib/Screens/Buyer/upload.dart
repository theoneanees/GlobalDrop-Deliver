// ignore_for_file: deprecated_member_use

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdds/Screens/Buyer/bottom_nav_bar.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:gdds/Screens/Traveler/travelerUpload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

final userdata = FirebaseAuth.instance.currentUser!;
final snackbar = SnackBar(content: Text('Post Uploaded Sucessfully'));

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController availWeightController = TextEditingController();

  String postId = Uuid().v4();
  bool isUploading = false;
  File? image;
  String address = "";
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String date1 = DateTime.now().toString().split(' ')[0];
  DateTime selectedDate1 = DateTime.now();
  String date2 = DateTime.now().toString().split(' ')[0];
  DateTime selectedDate2 = DateTime.now();

  handleTakePhoto() async {
    Navigator.pop(context);
    final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 675,
        maxWidth: 960,
        imageQuality: 85);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this.image = imageTemporary;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 960,
        maxHeight: 675,
        imageQuality: 85);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this.image = imageTemporary;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("create post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Capture a photo"),
                onPressed: () => handleTakePhoto(),
              ),
              SimpleDialogOption(
                child: Text("Choose image from Gallery"),
                onPressed: () => handleChooseFromGallery(),
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () => selectImage(context),
                child: Text('upload Image'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20.0, color: Colors.teal),
                ),
              )),
        ],
      ),
    );
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(image!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      image = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    TaskSnapshot taskSnapshot =
        await storageRef.child("post_$postId.jpg").putFile(imageFile);
    return taskSnapshot.ref.getDownloadURL();

    // UploadTask uploadTask =
    // storageRef.child("post_$postId.jpg").putFile(imageFile);
    // TaskSnapshot storageSnap = await uploadTask.whenComplete(() => null);
//     String downloadUrl = uploadTask.then((res) {
//    storageRef.getDownloadURL();
// });
    //  Future<String> url;
    // return uploadTask.whenComplete(() => url = ref.getDownloadURL());
    // //  return downloadUrl;
  }

  createPostInFirestore(
      {String? mediaUrl, String? location, String? description, String? expectedWeight}) {
    userPostRef.doc(postId).set({
      "postId": postId,
      "ownerId": userdata.uid,
      "username": userdata.displayName ?? currBuyer!.username,
      "userPhoto": userdata.photoURL ?? currBuyer!.photoUrl,
      "mediaUrl": mediaUrl ?? "",
      "description": description,
      "location": location,
      "timestamp": timestamp,
      "startDate": date1,
      "endDate": date2,
      "expectedWeight": expectedWeight,
      "desiredLocation": address
    });
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    setState(() {
      locationController.text = formattedAddress;
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    // await compressImage();
    if (image != null) {
      String mediaUrl = await uploadImage(image);
      timestampR = DateTime.now();
      address = cityValue + ",\n" + stateValue + ",\n" + countryValue;
      createPostInFirestore(
        mediaUrl: mediaUrl,
        location: locationController.text,
        description: itemNameController.text,
        expectedWeight: availWeightController.text
      );
      itemNameController.clear();
      locationController.clear();
      availWeightController.clear();
      setState(() {
        image = null;
        isUploading = false;
        postId = Uuid().v4();
      });
      Fluttertoast.showToast(msg: "Post Uploaded Successfully");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Navigation()));
      return;
    } else {
      timestampR = DateTime.now();
      createPostInFirestore(
        location: locationController.text,
        description: itemNameController.text,
        expectedWeight: availWeightController.text
      );
      itemNameController.clear();
      locationController.clear();
      availWeightController.clear();
      setState(() {
        isUploading = false;
        postId = Uuid().v4();
      });
      Fluttertoast.showToast(msg: "Post Uploaded Successfully");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Navigation()));
    }
  }

  _selectDate1(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate1,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate1)
      setState(() {
        selectedDate1 = selected;
        date1 = "$selected".split(' ')[0];
      });
  }

  _selectDate2(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate2)
      setState(() {
        selectedDate2 = selected;
        date2 = "$selected".split(' ')[0];
      });
  }

  buildUploadForm() {
    return Column(
      children: [
        isUploading ? linearProgress() : Text(""),
        imageProvidor(),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(userdata.photoURL!),
          ),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: itemNameController,
              decoration: InputDecoration(
                hintText: "Enter item name",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _selectDate1(context);
                      },
                      child: Text("Start Date"),
                    ),
                    Text(
                        "${selectedDate1.day}/${selectedDate1.month}/${selectedDate1.year}")
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _selectDate2(context);
                      },
                      child: Text("End Date"),
                    ),
                    Text(
                        "${selectedDate2.day}/${selectedDate2.month}/${selectedDate2.year}")
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Container(
            width: 220,
            child: TextField(
              controller: availWeightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Available Weight',
                label: Text("Enter available weight (Kg)"),
              ),
            ),
          ),
        ),
        Text(
          "Please select your location",
          style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        Container(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CSCPicker(
            onCountryChanged: (value) {
              setState(() {
                countryValue = value;
              });
            },
            onStateChanged: (value) {
              setState(() {
                stateValue = value ?? "";
              });
            },
            onCityChanged: (value) {
              setState(() {
                cityValue = value?? "";
              });
            },
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.pin_drop,
            color: Colors.orange,
            size: 35.0,
          ),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: "Please specify your current location",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Container(
          width: 200.0,
          height: 100.0,
          alignment: Alignment.center,
          child: RaisedButton.icon(
            label: Text(
              "Use Current Location",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.blue,
            // onPressed: getUserLocation,
            onPressed: () => getUserLocation(),
            icon: Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  imageProvidor() {
    if (image != null) {
      return Container(
        height: 220.0,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 12,
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
                  image: FileImage(image!),
                ),
              ),
            ),
          ),
        ),
      );
    } else
      return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [buildSplashScreen(), buildUploadForm()],
        ),
      ),
    );
  }
}
