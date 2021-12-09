import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/bottom_nav_bar.dart';
import 'package:gdds/Screens/Buyer/progress.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';
import 'package:gdds/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

final presentTravelerData = FirebaseAuth.instance.currentUser!;
String manualPhotoUrl = "";

class UploadTravelerPic extends StatefulWidget {
  @override
  _UploadTravelerPicState createState() => _UploadTravelerPicState();
}

class _UploadTravelerPicState extends State<UploadTravelerPic> {
  bool isUploading = false;
  File? image;
  String photoId = Uuid().v4();

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
            title: Text("Upload Photo"),
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
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/uploadpic.jpg'),
            height: 650.0,
          ),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () => selectImage(context),
                child: Text('upload Profilel Picture'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20.0, color: Colors.teal),
                ),
              )),
        ],
      ),
    );
  }

  Future<String> uploadImage(imageFile) async {
    TaskSnapshot taskSnapshot =
        await storageRef.child("post_$photoId.jpg").putFile(imageFile);
    return taskSnapshot.ref.getDownloadURL();
  }

  // uploadPhotoInFirestore({String? photoUrl}) {
  //   travelersRef.doc(presentTravelerData.uid).set({
  //     "photoUrl": photoUrl,
  //   });
  // }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    // await compressImage();
    String mediaUrl = await uploadImage(image);
    manualPhotoUrl = mediaUrl;
    // uploadPhotoInFirestore(
    //   photoUrl: mediaUrl,
    // );
    setState(() {
      image = null;
      isUploading = false;
      photoId = Uuid().v4();

      if (travelerLoggedIn) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TravelerMain(travelerPhotoURL: mediaUrl)));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Navigation(buyerPhotoUrl: mediaUrl)));
      }
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Upload Profile picture",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => handleSubmit(),
            child: Text(
              "Upload Profile Picture",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          isUploading ? linearProgress() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(image!),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return image == null ? buildSplashScreen() : buildUploadForm();
  }
}
