import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_and_found/Services/auth_services.dart';

/* 

*/

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _emailController = TextEditingController();

  AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                "Please enter your email address, We'll send you the Reset link",
                maxLines: 2,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40),
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: _emailController,
                //obscureText: true,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Theme.of(context).accentColor,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).accentColor,),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              padding: EdgeInsets.only(),
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _authServices.forgotPassword(_emailController.text);
                  Fluttertoast.showToast(msg: "Email has been sent");
                },
                // padding: EdgeInsets.all(0),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xffff5f6d),
                        Color(0xffff5f6d),
                        Color(0xffffc371),
                      ],
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        maxWidth: double.infinity, minHeight: 50),
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(6),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
