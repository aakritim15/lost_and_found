import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 16.0,
          ),
          Text(
            "Loading, Please wait...",
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
