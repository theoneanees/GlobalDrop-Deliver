import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gdds/Screens/login/login_page_Buyer.dart';
import 'package:gdds/components/background.dart';
import 'package:gdds/provider/g_signIn_provider.dart';
import 'package:gdds/theme.dart';
import 'package:provider/provider.dart';

class GoogleSign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: <Color>[
                    CustomTheme.loginGradientStart,
                    CustomTheme.loginGradientEnd
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 1.0),
                  stops: <double>[0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/images/gdds_logo.png')),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: RaisedButton(
                    highlightColor: Colors.transparent,
                    splashColor: CustomTheme.loginGradientEnd,
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    // textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 63.0,
                      width: size.width * 0.65,
                      // decoration: new BoxDecoration(
                      //     borderRadius: BorderRadius.circular(80.0),
                      //     gradient: new LinearGradient(colors: [
                      //       // Color.fromARGB(255, 230, 0, 5),
                      //       // Color.fromARGB(255, 230, 0, 5),
                      //       Color.fromARGB(230, 255, 136, 34),
                      //       Color.fromARGB(255, 255, 177, 41)
                      //     ])),
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          SizedBox(width: 18),
                          Icon(FontAwesomeIcons.google,
                              size: 28, color: Colors.red[700]),
                          SizedBox(width: 19),
                          Text(
                            "REGISTER WITH GOOGLE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'WorkSansBold',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: RaisedButton(
                    highlightColor: Colors.transparent,
                    splashColor: CustomTheme.loginGradientEnd,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPageBuyer()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    // textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 63.0,
                      width: size.width * 0.65,
                      // decoration: new BoxDecoration(
                      //     borderRadius: BorderRadius.circular(80.0),
                      //     gradient: new LinearGradient(colors: [
                      //       // Color.fromARGB(15, 0, 0, 0),
                      //       // Color.fromARGB(15, 0, 0, 0),
                      //       Color.fromARGB(255, 255, 136, 34),
                      //       Color.fromARGB(255, 255, 177, 41)
                      //     ])),
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          SizedBox(width: 18),
                          Icon(Icons.logout_outlined,
                              size: 33, color: Colors.red[700]),
                          SizedBox(width: 19),
                          Text("GO TO LOGIN PAGE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'WorkSansBold',
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
