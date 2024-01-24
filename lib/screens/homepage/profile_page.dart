import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found/screens/homepage/my_claims.dart';
import 'my_found.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_and_found/Services/auth_services.dart';
import 'package:lost_and_found/screens/authentication/login_page.dart';
import 'package:lost_and_found/screens/homepage/account.dart';
import 'package:lost_and_found/screens/homepage/rewards_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = '';
  String photoUrl = '';

  AuthServices _authServices = AuthServices();

  getUserName() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((snapshot) {
      setState(() {
        userName = snapshot.data()?['fullName'];
        photoUrl = snapshot.data()?['profilePhoto'];
      });
      print(photoUrl);
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
                Fluttertoast.showToast(msg: "Sign out Successful");
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

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: <Widget>[
        Center(
          child: photoUrl != ''
              ? Container(
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle),
                  height: 150,
                  width: 150,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: photoUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle),
                  height: 150,
                  width: 150,
                  child: ClipOval(
                    child: Image.network(
                      "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png",
                      height: 150,
                      width: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
        ),
        Center(
          child: Text(
            userName,
            style: optionStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyClaims()));
            },
            leading: Icon(
              Icons.plagiarism_outlined,
              color: Colors.green,
            ),
            title: Text('My Claims'),
            trailing: Icon(Icons.navigate_next),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Myfound()));
            },
            leading: Icon(
              Icons.pages_outlined,
              color: Colors.blueGrey,
            ),
            title: Text('Found items'),
            trailing: Icon(Icons.navigate_next),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RewardsPage()));
            },
            leading: Icon(
              Icons.local_attraction_outlined,
              color: Colors.yellow,
            ),
            title: Text('Rewards'),
            trailing: Icon(Icons.navigate_next),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Account()));
            },
            leading: Icon(
              Icons.account_circle_outlined,
              color: Colors.blue,
            ),
            title: Text('Account'),
            trailing: Icon(Icons.navigate_next),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Divider(),
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ListTile(
            onTap: () {
              _showMyDialog();
            },
            leading: Icon(
              Icons.power_settings_new,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Log Out'),
            trailing: Icon(Icons.navigate_next),
          ),
        ),
      ], //leading: Text('profile'),
    ));
  }
}
