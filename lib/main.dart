// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gdds/Screens/Buyer/bottom_nav_bar.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';
import 'package:gdds/page/Start_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Chat/providers/auth_provider.dart';
import 'Screens/Chat/providers/chat_provider.dart';
import 'Screens/Chat/providers/home_provider.dart';
import 'Screens/Chat/providers/setting_provider.dart';
import 'package:restart_app/restart_app.dart';

bool verifySignin = false;
bool buyerLoggedIn = false;
bool travelerLoggedIn = false;
var obtainedEmail1;
var obtainedEmail2;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPreferences prefs2 = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  obtainedEmail1 = email;
  var email2 = prefs2.getString('email2');
  obtainedEmail2 = email2;

  print(obtainedEmail1);
  print(obtainedEmail2);
  runApp(MyApp(
    prefs: prefs,
    prefs2: prefs2,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final SharedPreferences prefs2;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  // This widget is the root of your application.

  MyApp({this.prefs, this.prefs2});

  Widget getloginverify() {
    if (obtainedEmail1 != null) {
      return Navigation();
    } else if (obtainedEmail2 != null) {
      return TravelerMain();
    } else {
      return StartPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn(),
            prefs: this.prefs,
            firebaseFirestore: this.firebaseFirestore,
          ),
        ),
        Provider<SettingProvider>(
          create: (_) => SettingProvider(
            prefs: this.prefs,
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage,
          ),
        ),
        Provider<HomeProvider>(
          create: (_) => HomeProvider(
            firebaseFirestore: this.firebaseFirestore,
          ),
        ),
        Provider<ChatProvider>(
          create: (_) => ChatProvider(
            prefs: this.prefs,
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Login',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF2661FA),
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: getloginverify(),
      ),
    );

    // return ChangeNotifierProvider(
    //   create: (context) => GoogleSignInProvider(),
    // child: MaterialApp(
    //   title: 'Flutter Login',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     primaryColor: Color(0xFF2661FA),
    //     scaffoldBackgroundColor: Colors.white,
    //     visualDensity: VisualDensity.adaptivePlatformDensity,
    //   ),
    //   home: HomePage(),
    // ),
    // );
  }
}
