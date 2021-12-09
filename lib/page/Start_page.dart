import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gdds/Screens/login/login_page_Buyer.dart';
import 'package:gdds/Screens/login/login_page_Traveler.dart';
import 'package:gdds/components/background.dart';
import 'package:gdds/theme.dart';
import 'package:restart_app/restart_app.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // @override
  // void initState() {
  //   super.initState();
  // }
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
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    highlightColor: Colors.transparent,
                    splashColor: CustomTheme.loginGradientEnd,

                    onPressed: () {
                      Navigator.pushReplacement(
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
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          SizedBox(width: 22),
                          Icon(
                            FontAwesomeIcons.shoppingBag,
                            size: 30,
                            color: Colors.red[700],
                          ),
                          SizedBox(width: 45),
                          Text(
                            "BUYER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'WorkSansBold',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //second button

                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 200.0,
                  height: 2.0,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    'Or',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'WorkSansMedium'),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 200.0,
                  height: 2.0,
                ),

                //second button
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: RaisedButton(
                    highlightColor: Colors.transparent,
                    splashColor: CustomTheme.loginGradientEnd,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPageTraveler()));
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
                          Icon(Icons.flight_takeoff_outlined,
                              size: 33, color: Colors.red[700]),
                          SizedBox(width: 40),
                          Text("TRAVELER",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
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



// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           else if (snapshot.hasError)
//             return Center(
//               child: Text('something went wrong'),
//             );
//           else if (snapshot.hasData) {
//             return EmailLogIn();
//           } else
//             return GoogleSign();
//         },
//       ),

      
//     );
//   }
// }
