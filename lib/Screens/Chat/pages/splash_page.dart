import 'package:flutter/material.dart';
import 'package:gdds/Screens/Chat/constants/color_constants.dart';
import 'package:gdds/Screens/Chat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'pages.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    bool isSuccess = await authProvider.handleSignIn();
                    if (isSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  },
                  child: Text("Continue to chat")),
            ),
            //   Container(
            //     width: 20,
            //     height: 20,
            //     child:
            //         CircularProgressIndicator(color: ColorConstants.themeColor),
            //   ),
          ],
        ),
      ),
    );
  }
}
