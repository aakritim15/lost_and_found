import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
//import 'package:lost_and_found/screens/homepage/founder_get_started.dart';
//import 'package:lost_and_found/screens/getstarted/founder_get_started.dart';
import 'package:lost_and_found/screens/homepage/home_page.dart';
import 'package:lost_and_found/screens/authentication/login_page.dart';
import 'package:lost_and_found/screens/homepage/report_found_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LostAndFound());
}

class LostAndFound extends StatefulWidget {
  @override
  _LostAndFoundState createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFound> {
  User? user;

  FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() {
    user = _auth.currentUser!;
    print('user id : $user');
  }

  final onboardingPagesList = [
    PageModel(
      image: Image.asset('assets/images/try1.png'),
      title: Text('Lost a Precious Item?'),
      info: Text("Don't worry, we can help you find it."),
    ),
    PageModel(
      image: Image.asset('assets/images/try2.png'),
      title: Text('Found Something Precious?'),
      info: Text('Use our app to make sure it reaches the correct owner.'),
    ),
    PageModel(
      image: Image.asset('assets/images/try3.png'),
      title: Text('Connect with each other securely'),
      info: Text('So that '),
    ),
    PageModel(
      image: Image.asset('assets/images/try4.png'),
      title: Text('So you can Rest Easy'),
      info: Text('Example'),
    ),
  ];

  @override
  void initState() {
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ProductSans',
        primaryColor: Color(0xff1e1e1e),
        accentColor: Color(0xffff5f6d),
      ),
      //  home: ReportLostPage(),
      // home: user != null
      //     ? Onboarding(
      //         proceedButtonStyle: ProceedButtonStyle(
      //             proceedButtonRoute: (context) {
      //               return Navigator.pushAndRemoveUntil(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => HomePage(),
      //                 ),
      //                 (route) => false,
      //               );
      //             },
      //             proceedButtonText: 'Continue'),
      //         pages: onboardingPagesList,
      //         indicator: Indicator(
      //           indicatorDesign: IndicatorDesign.line(
      //             lineDesign: LineDesign(
      //               lineType: DesignType.line_uniform,
      //             ),
      //           ),
      //         ),
      //       )
      //     : LoginPage(),
      home: user != null ? HomePage() : LoginPage(),
      //home: GetStarted(),
    );
  }
}
