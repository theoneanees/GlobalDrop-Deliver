import 'package:flutter/material.dart';
import 'package:gdds/Screens/Buyer/bottom_nav_bar.dart';
import 'package:gdds/Screens/Chat/constants/color_constants.dart';
import 'package:gdds/Screens/Chat/providers/auth_provider.dart';
import 'package:gdds/Screens/Traveler/traveler_window.dart';
import 'package:gdds/Screens/register/As%20a%20traveler/uploadTravelerPic.dart';
import 'package:gdds/main.dart';
import 'package:provider/provider.dart';

import 'pages.dart';


String manualPhotoLink = "";

class SplashPage extends StatefulWidget {
  SplashPage({this.manualPhoto});
  final String? manualPhoto;
  // SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      manualPhotoLink = widget.manualPhoto!;
      // just delay for showing this slash page clearer because it too fast
      // checkSignedIn();
    });
  }

  // void checkSignedIn() async {
  //   // AuthProvider authProvider = context.read<AuthProvider>();
  //   // bool isLoggedIn = await authProvider.isLoggedIn();
  //   // if (isLoggedIn) {

  //   );

  // return;
  // }
  // Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(builder: (context) => LoginPage()),
  // );

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 18,
                    shadowColor: Colors.black,
                    primary: Colors.orange[700]),
                onPressed: () async {
                  bool isSuccess = await authProvider.handleSignIn();
                  if (isSuccess) {
                    if (travelerLoggedIn) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => TravelerMain(travelerPhotoURL: widget.manualPhoto,)),
                      );
                    } else
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Navigation(buyerPhotoUrl: widget.manualPhoto,)),
                      );
                  }
                },
                child: Text("Continue to GDDS".toUpperCase())),
          ),
          //   Container(
          //     width: 20,
          //     height: 20,
          //     child:
          //         CircularProgressIndicator(color: ColorConstants.themeColor),
          //   ),
        ],
      ),
    );
  }
}
