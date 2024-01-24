import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/Services/auth_services.dart';
import 'found_status.dart';
class Myfound extends StatefulWidget {
  @override
  _MyfoundState createState() => _MyfoundState();
}

class _MyfoundState extends State<Myfound> {
  User? user;

  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthServices _authServices = AuthServices();
 @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  getCurrentUser() {
    user = _auth.currentUser;
    print('here');
    print('user id : $user');
  }

  Widget build(BuildContext context) {
    
  
 
    return Scaffold(
      resizeToAvoidBottomInset: false,
    
      body:SafeArea(
              child: Container(
          padding: EdgeInsets.all(15.0),

                child: Column(
          children: [

                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "Found Items",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
            Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("foundReport")
                              .where('createdBy', isEqualTo: user?.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot == null) {
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
                                                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FoundStatus(ds['reportNumber'])));
                                            },
                                            child: Text(
                                              'Status',
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
        ),
              ),
      )
    );
  }
}