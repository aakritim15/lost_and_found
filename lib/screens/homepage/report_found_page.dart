import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:random_string/random_string.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoder/model.dart' as geoCodeModel;
//import 'package:permission_handler/permission_handler.dart';

class ReportFoundPage extends StatefulWidget {
  @override
  _ReportFoundPageState createState() => _ReportFoundPageState();
}

class _ReportFoundPageState extends State<ReportFoundPage> {
  GlobalKey<FormState> _reportFoundForm = GlobalKey();

  String photoUrl = '';
  String reportNo = '';
  String itemCategory = '';
  String foundItemLocation = '';
  double? foundItemLatitude;
  double? foundItemLongitude;

  bool _showImagePreview = false;

  var _foundItemNameController = TextEditingController();
  var _foundItemDescController = TextEditingController();
  int dropDownValue = 0;

  Location location = new Location();
  static bool callLocation = true;

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    reportNo = randomNumeric(10);
  }

  String getCategory(int dropDownValue) {
    if (dropDownValue == 0) {
      setState(() {
        itemCategory = "Documents";
      });
      return itemCategory;
    } else if (dropDownValue == 1) {
      setState(() {
        itemCategory = "Valuables";
      });
      return itemCategory;
    } else if (dropDownValue == 2) {
      setState(() {
        itemCategory = "Electronics";
      });
      return itemCategory;
    } else if (dropDownValue == 3) {
      setState(() {
        itemCategory = "Others";
      });
      return itemCategory;
    } else {
      return itemCategory;
    }
  }

  Future<void> uploadFoundReport() async {
    if (_reportFoundForm.currentState!.validate() && foundItemLocation != '') {
      await FirebaseFirestore.instance
          .collection("foundReport")
          .doc(reportNo)
          .set({
        "reportNumber": reportNo,
        "createdAt": FieldValue.serverTimestamp(),
        "createdBy": FirebaseAuth.instance.currentUser?.email,
        "reportLocation": foundItemLocation,
        "reportLongitude": foundItemLongitude,
        "reportLatitude": foundItemLatitude,
        "itemName": _foundItemNameController.text,
        "itemDescription": _foundItemDescController.text,
        "itemImage": photoUrl,
        "itemCategory": getCategory(dropDownValue),
      });

      Fluttertoast.showToast(msg: "Your report has been submitted");
    } else {
      Navigator.of(context).pop();

      Fluttertoast.showToast(msg: "Please fetch the location");
    }
  }

  // Future<Future<bool>> fetchLocation() async {
  //   // _serviceEnabled = await location.serviceEnabled();
  //   // if (_serviceEnabled) {
  //   //   _serviceEnabled = await location.requestService();
  //   //   if (!_serviceEnabled) {
  //   //     //return _showLocDialog();
  //   //   }
  //   // }

  //   // PermissionStatus permissionStatus = await location.requestPermission();
  //   // var _permissionGranted = await location.pe
  //   // if (_permissionGranted) {
  //   //   _permissionGranted = await location.requestPermission();
  //   //   if (!_permissionGranted) {
  //   //     //return _showMyDialog();
  //   //   }
  //   // }
  //   // if (!callLocation) {
  //   //   print("Set by Map ");
  //   //   return;
  //   // } else {
  //   //   print("Set by GPS");
  //   //   _locationData = await location.getLocation();
  //   //   print(_locationData);

  //   // }
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled!) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled!) {
  //       return Fluttertoast.showToast(msg: "Permission Denied");
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return Fluttertoast.showToast(msg: "Permission Denied");
  //     }
  //   }

  //   _locationData = await location.getLocation();
  //   final coordinates = new geoCodeModel.Coordinates(
  //       _locationData?.latitude, _locationData?.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   foundItemLatitude = _locationData?.latitude;
  //   foundItemLongitude = _locationData?.longitude;
  //   foundItemLocation = first.addressLine;
  //   setState(() {});
  //   print("CUUUUUUURRRRREEEEENNNNTTTT::::${first.addressLine}");
  // }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Submit Report',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Do you confirm it?",
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
                await uploadFoundReport();
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

  Future<void> addReportPhoto() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();

    var randomInt = Random.secure().nextInt(10000);

    PickedFile image;
    //Check Permissions
    await permission.Permission.photos.request();

    var permissionStatus = await permission.Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _imagePicker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('foundReport')
            .child("$randomInt")
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          photoUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Report Found Item",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Enter details of the item found:",
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade400),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Report Number: ",
                        style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "#$reportNo",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Form(
                  key: _reportFoundForm,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value!.length < 3) {
                            return 'Please enter a valid name';
                          } else {
                            return null;
                          }
                        },
                        controller: _foundItemNameController,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                          labelText: "Item Name",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).accentColor,
                              //fontWeight: FontWeight.w600
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).accentColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        //validator: emailValidator,
                        controller: _foundItemDescController,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                          labelText: "Item Description",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).accentColor,
                              //fontWeight: FontWeight.w600
                            ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).accentColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text("Location: ",
                              style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              "$foundItemLocation",
                              style: TextStyle(
                                  fontSize: 16,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          // fetchLocation();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // gradient: LinearGradient(
                            //     begin: Alignment.centerLeft,
                            //     end: Alignment.centerRight,
                            //     colors: [
                            //       Color(0xffff5f6d),
                            //       Color(0xffff5f6d),
                            //       Color(0xffffc371),
                            //     ],
                            //   ),
                            color: Color(0xffff5f6d),
                          ),
                          //color: Theme.of(context).accentColor,
                          child: Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on, color: Colors.white,),
                              SizedBox(width: 10),
                              Text("Fetch Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                            ],
                          )),
                        ),
                      ),
                      // Text("Location : $foundItemLocation", textAlign: TextAlign.center,),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Item Category:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          DropdownButton(
                            value: dropDownValue,
                            items: [
                              DropdownMenuItem(
                                child: Text("Documents"),
                                value: 0,
                              ),
                              DropdownMenuItem(
                                child: Text("Valuables"),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("Electronics"),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                child: Text("Other"),
                                value: 3,
                              )
                            ],
                            onChanged: (value) {
                              setState(() {
                                // dropDownValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      _showImagePreview
                          ? photoUrl != ''
                              ? Container(
                                  height: 150,
                                  width: 150,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: photoUrl,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      shape: BoxShape.circle),
                                  height: 150,
                                  width: 150,
                                  child: Center(
                                      child: Text(
                                    "Upload Photo",
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.white),
                                  )),
                                )
                          : Container(),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showImagePreview = true;
                            });
                            addReportPhoto();
                          },
                          // padding: EdgeInsets.all(0),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(6),
                          // ),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  minHeight: 50, maxWidth: double.infinity),
                              child: Text(
                                "Add Image (Optional)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _showMyDialog();
                          },
                          // padding: EdgeInsets.all(0),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(6),
                          // ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xffff5f6d),
                                  Color(0xffff5f6d),
                                  Color(0xffffc371),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                  minHeight: 50, maxWidth: double.infinity),
                              child: Text(
                                "Confirm Report",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
