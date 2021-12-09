import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/bottom_nav_bar.dart';
import 'package:gdds/Screens/Chat/pages/pages.dart';
import 'package:gdds/Screens/Chat/providers/setting_provider.dart';
import 'package:gdds/Screens/Traveler/travelerGetOrders.dart';
import 'package:gdds/models/userdata.dart';
import 'package:gdds/page/Start_page.dart';
import 'package:gdds/provider/g_signIn_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';

class BuyerSideDrawer extends StatelessWidget {

  final padding = EdgeInsets.symmetric(horizontal: 5);
  final user = FirebaseAuth.instance.currentUser!;
  UserData? buyerdate;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // FirebaseAuth _auth = FirebaseAuth.instance;

  late SettingProvider settingProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Column(
          children: <Widget>[
            buildHeader(
              urlImage: currBuyer!.photoUrl!,
              name: currBuyer!.username!,
              email: currBuyer!.email!,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsPage(),
              )),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.timeline_outlined, color: Colors.purple[900], size: 30,),
                ),
                GestureDetector(child: Text("Timeline",
                style: TextStyle(color: Colors.blue[900], fontSize: 28, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Navigation())),)
              ],
            ),
            Divider(height: 8, thickness: 5),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.shopping_cart_outlined, color: Colors.purple[900], size: 30,),
                ),
                GestureDetector(child: Text("My Orders",
                style: TextStyle(color: Colors.blue[900], fontSize: 25, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold,)),
                onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TravelerGetOrder())),)
              ],
            ),
            Divider(height: 8, thickness: 5),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.login_outlined, color: Colors.purple[900], size: 30,),
                ),
                GestureDetector(child: Text("Logout",
                style: TextStyle(color: Colors.blue[900], fontSize: 25, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                onTap: () async {
                      // _googleSignIn.disconnect();
                      if (user.displayName != null) {
                        await GoogleSignInProvider().logout();
                      }
                      await FirebaseAuth.instance.signOut();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      // Restart.restartApp();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => StartPage()));
                    })
              ],
            ),
            // Row(
            //   children: [
            //     Icon(Icons.login_outlined),
            //     ListTile(
            //         title: Text(
            //           "LogOut",
            //           style: TextStyle(color: Colors.white, fontSize: 20),
            //         ),
            //         onTap: () async {
            //           // _googleSignIn.disconnect();
            //           if (traveler.displayName != null) {
            //             await GoogleSignInProvider().logout();
            //           }
            //           await FirebaseAuth.instance.signOut();
            //           SharedPreferences prefs =
            //               await SharedPreferences.getInstance();
            //           prefs.clear();
            //           // _googleSignIn.signOut();

            //           // await GoogleSignInProvider().logout();
            //           // print('sign out successful');
            //           Restart.restartApp();
            //           // Navigator.push(context,
            //           //     MaterialPageRoute(builder: (context) => StartPage()));
            //         }),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 20)),
          child: Column(
            children: [
              CircleAvatar(radius: 50, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 5),
              Text(
                name,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              // Spacer(),
            ],
          ),
        ),
      );
}
