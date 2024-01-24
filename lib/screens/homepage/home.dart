import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lost_and_found/Services/auth_services.dart';
import 'package:lost_and_found/widgets/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;

  User? user;

  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthServices _authServices = AuthServices();

  String? lostTime;
  String? foundTime;
  String? lostLocation;
  String? foundLocation;
  String? lostCategory;
  String? foundCategory;

  Future<void> _showMyDialog(String reportNumber, String itemName,
      String itemDescrption, String category) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Claim Item',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Do you want to claim this item?",
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
                claimReport(reportNumber, itemName, itemDescrption, category);
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

  getLostReportDetails(String category) {
    FirebaseFirestore.instance
        .collection("lostReport")
        .where("createdBy", isEqualTo: _auth.currentUser?.email)
        .where("itemCategory", isEqualTo: category)
        .get()
        .then((snapshot) {
      setState(() {});
    });
  }

  // getReportDetails(
  //     String lostReport, String foundReport, String category) async {
  //   StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance
  //         .collection("lostReport")
  //         .where("itemCategory", isEqualTo: category)
  //         .where("reportNumber", isEqualTo: lostReport)
  //         .snapshots(),
  //     // builder: (context, snapshot1) {
  //       // return StreamBuilder<QuerySnapshot>(
  //       //   stream: FirebaseFirestore.instance
  //       //       .collection("foundReport")
  //       //       .where("itemCategory", isEqualTo: category)
  //       //       .where("reportNumber", isEqualTo: foundReport)
  //       //       .snapshots(),
  //       //   builder: (context, snapshot2) {},
  //       // );
  //     // },
  //   );
  // }

  claimReport(String reportNo, String itemName, String itemDescription,
      String itemCategory) {
    FirebaseFirestore.instance.collection("claimReport").add({
      "claimBy": _auth.currentUser?.email,
      "claimedAt": FieldValue.serverTimestamp(),
      "foundReportNo": reportNo,
      "itemName": itemName,
      "itemDescription": itemDescription,
      "itemCategory": itemCategory
    });
    Fluttertoast.showToast(msg: "Your claim has been submitted");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onPressed: () {},
            label: Text(
              "Search",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xffff5f6d),
              ),
            ),
            icon: Icon(
              Icons.search,
              color: Color(0xffff5f6d),
            ),
          ),
          // child: Row(
          //   children: [
          //     Text(
          //       "Search",
          //       style: TextStyle(
          //           fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xffff5f6d),),
          //     ),
          //     SizedBox(width:10),

          //   ],
          // ),
        ),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("foundReport")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data?.docs == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    print("snapshot error: ${snapshot.error}");
                  }

                  if (snapshot.data?.docs.length == 0) {
                    return Center(
                      child: Text("No Reports",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("${ds['itemName']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("${ds['itemDescription']}"),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Chip(
                                            label:
                                                Text("${ds['itemCategory']}")),
                                      ]),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  color: Theme.of(context).accentColor,
                                  padding: EdgeInsets.all(10),
                                  elevation: 3,
                                  onPressed: () {
                                    _showMyDialog(
                                        ds['reportNumber'],
                                        ds['itemName'],
                                        ds['itemDescription'],
                                        ds['itemCategory']);
                                  },
                                  child: Text(
                                    'Claim',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                              // height: 100,
                              // decoration: BoxDecoration(
                              //     border: Border(
                              //         left: BorderSide(color: Theme.of(context).accentColor,, width: 3))),
                              // child: ListTile(
                              //   trailing: MaterialButton(
                              //     padding: EdgeInsets.all(10),
                              //     elevation: 3,
                              //     onPressed: () {},
                              //     child: Text(
                              //       'Claim',
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(8.0),
                              //     ),
                              //     color: Theme.of(context).accentColor,,
                              //   ),
                              //   title: Text('Lost item'),
                              //   subtitle: Text('Description'),
                              // ),
                            ),
                          ),
                        ),
                      );
                    },
                    //separatorBuilder: (BuildContext context, int index) => const Divider(),
                  );
                })),
      ],
    ));
  }
}
