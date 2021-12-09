import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Chat/constants/constants.dart';
import 'package:gdds/Screens/Chat/models/models.dart';
import 'package:gdds/Screens/Chat/pages/pages.dart';
import 'package:gdds/Screens/register/As%20a%20traveler/sign_up_Traveler.dart';
import 'package:gdds/Screens/register/As%20a%20traveler/uploadTravelerPic.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.prefs,
    required this.firebaseFirestore,
  });

  String? getUserFirebaseId() {
    return prefs.getString(FirestoreConstants.id);
  }

  // Future<bool> isLoggedIn() async {
  //   bool isLoggedIn = await googleSignIn.isSignedIn();
  //   if (isLoggedIn &&
  //       prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  bool isLoggedIn() {
    String isLoggedIn = FirebaseAuth.instance.currentUser!.uid;
    if (isLoggedIn != null &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    String curTrav = FirebaseAuth.instance.currentUser!.uid;

    if (curTrav != null) {
      DocumentSnapshot doc = await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(curTrav)
          .get();

      if (!doc.exists) {
        // Writing data to server because here is a new user
        firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(curTrav)
            .set({
          FirestoreConstants.nickname: manualUserName,
          FirestoreConstants.photoUrl: manualPhotoUrl,
          FirestoreConstants.id: curTrav,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.chattingWith: null
        });

        // Write data to local storage
        // User? currentUser = firebaseUser;
        await prefs.setString(FirestoreConstants.id, curTrav);
        await prefs.setString(FirestoreConstants.nickname, manualUserName);
        await prefs.setString(FirestoreConstants.photoUrl, manualPhotoUrl);
      } else {
        // Already sign up, just get data from firestore
        // DocumentSnapshot documentSnapshot = documents[0];
        UserChat userChat = UserChat.fromDocument(doc);
        // Write data to local
        await prefs.setString(FirestoreConstants.id, userChat.id);
        await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
        await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
        await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
      }
      _status = Status.authenticated;
      notifyListeners();
      return true;
      //   } else {
      //     _status = Status.authenticateError;
      //     notifyListeners();
      //     return false;
      //   }
      // } else {
      //   _status = Status.authenticateCanceled;
      //   notifyListeners();
      //   return false;
      // }
    }
    _status = Status.authenticateError;
    notifyListeners();
    return false;
  }

  Future<bool> handleGoogleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser =
          (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Writing data to server because here is a new user
          firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set({
            FirestoreConstants.nickname: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });

          // Write data to local storage
          User? currentUser = firebaseUser;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          await prefs.setString(
              FirestoreConstants.nickname, currentUser.displayName ?? "");
          await prefs.setString(
              FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
        } else {
          // Already sign up, just get data from firestore
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          await prefs.setString(FirestoreConstants.id, userChat.id);
          await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
          await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}