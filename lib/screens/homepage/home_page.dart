import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lost_and_found/Services/auth_services.dart';
import 'package:lost_and_found/screens/authentication/login_page.dart';
//import 'package:lost_and_found/screens/homepage/founder_get_started.dart';
import 'package:lost_and_found/screens/homepage/profile_page.dart';
import 'package:lost_and_found/screens/homepage/report_found_page.dart';
import 'package:lost_and_found/screens/homepage/report_lost_page.dart';

import 'home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthServices _authServices = AuthServices();

  bool isLoading = false;

  getCurrentUser() {
    user = _auth.currentUser;
    print('user id : $user');
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  int _botNavIndex = 1;
  final List<String> entries = <String>['A', 'B', 'C', 'D'];

  int _selectedIndex = 0;

  Future<void> claimItems() async {
    setState(() {
      isLoading = true;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Do you want to Sign out?",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
                //CONTEnt HERE
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              //color: Colors.teal,
              child: Text(
                'Yes',
              ),
              onPressed: () async {
                await _authServices.signOut();
                Fluttertoast.showToast(msg: "Sign In Successful");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
            ),
            TextButton(
              child: Text(
                'No',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    ReportLostPage(),
    ReportFoundPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text('Lost and Found',
        //       style: TextStyle(
        //           color: Colors.black,
        //           fontSize: 20,
        //           fontWeight: FontWeight.w600)),
        //   actions: [
        //     IconButton(
        //         icon: Icon(
        //           Icons.search,
        //           color: Colors.black,
        //         ),
        //         onPressed: () {}),
        //   ],
        // ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  // rippleColor: Colors.grey[300],
                  // hoverColor: Colors.grey[100],
                  gap: 8,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Theme.of(context).accentColor,
                  tabs: [
                    GButton(
                      icon: Icons.home_outlined,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.edit,
                      text: 'Item Lost',
                    ),
                    GButton(
                      icon: Icons.report,
                      text: 'Item Found',
                    ),
                    GButton(
                      icon: Icons.person_outline_rounded,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)));
  }
}
