import 'package:blueaidngo/login.dart';
import 'package:blueaidngo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class AdminHome extends StatefulWidget {
  // const AdminHome({ Key? key }) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

String newname, newid, newpass;
int numvol = 0;
List<dynamic> volunteers = [];
Map lol = Map<dynamic, dynamic>();
Map lmao = Map<dynamic, dynamic>();

class _AdminHomeState extends State<AdminHome> {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  @override
  Widget build(BuildContext context) {
    void x() {
      FirebaseFirestore.instance
          .collection('ngos')
          .doc('p4c')
          .get()
          .then((value) {
        {
          if (value.exists) {
            // print((value.data()["volunteer"])[0]['name']);
            setState(() {
              volunteers = (value.data()["volunteer"]);
              numvol = (value.data()["volunteer"]).length;
            });
            // print('Document data: ${(value.data()["name"])}');
          } else {
            print('Document does not exist on the database');
          }
        }
      });
    }

    x();
    volunteerlist(w) {
      return ListView.builder(
          itemCount: numvol,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    color: Color.fromRGBO(3, 84, 102, 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          // color: Colors.orange,
                          width: w - 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    volunteers[index]['name'].toString(),
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Volunteer ID: ${volunteers[index]['id'].toString()}",
                                    // style:,
                                  ),
                                ],
                              )
                            ],
                          )),
                      IconButton(
                          onPressed: () async {
                            lmao['id'] = volunteers[index]['id'];
                            lmao['name'] = volunteers[index]['name'];
                            lmao['password'] = volunteers[index]['password'];
                            await FirebaseFirestore.instance
                                .collection('ngos')
                                .doc('p4c')
                                .update({
                              "volunteer": FieldValue.arrayRemove([lmao])
                            }).then((_) => print("delete successful"));
                            setState(() {
                              // names.remove(names[index]);
                            });
                          },
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 30,
                          ))
                    ],
                  ),
                ));
            // return ListTile(
            //     leading: Icon(Icons.list),
            //     trailing: IconButton(icon: Icon(Icons.remove)),
            //     title: Text("List item $index"));
          });
    }

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Color.fromRGBO(229, 229, 229, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Container(
                height: 50,
                child: ListTile(
                  leading: Image.network(
                    "https://i.ibb.co/zxrC0Sv/logo.png",
                    height: 40,
                  ),
                  title: Text(
                    "Blue Aid",
                    style: GoogleFonts.nunito(
                        color: Colors.blue[700], fontWeight: FontWeight.w900),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.logout),
                      color: Colors.blue[700],
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Selection(),
                              ));
                        });
                      }),
                ),
              ),
            ),

            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "Plan4Action\nInternational Organisation",
                    style: GoogleFonts.nunito(
                        color: Color.fromRGBO(3, 84, 102, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "Number of volunteers: $numvol",
                    style: GoogleFonts.nunito(
                        color: Color.fromRGBO(3, 84, 102, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Text(
                    "Volunteer List",
                    style: GoogleFonts.nunito(
                        color: Color.fromRGBO(3, 84, 102, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          // showAboutDialog(context: context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: AlertDialog(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    content: Center(
                                        child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              MaterialButton(
                                                  minWidth: 20,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("x"))
                                            ],
                                          ),
                                          Image.network(
                                            "https://i.ibb.co/zxrC0Sv/logo.png",
                                            height: 40,
                                          ),
                                          MaterialButton(
                                              onPressed: () {},
                                              child: Text("Add Volunteer")),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                height: 50,
                                                width: w - 100,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.transparent),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    newname = value;
                                                  },
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    hintText: "Name",
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                height: 50,
                                                width: w - 100,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.transparent),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    newid = value;
                                                  },
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    hintText: "Volunteer ID",
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                height: 50,
                                                width: w - 100,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.transparent),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    newpass = value;
                                                  },
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    hintText: "Password",
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                              )),
                                          MaterialButton(
                                            elevation: 0,
                                            height: 60,
                                            color: Colors.white,
                                            minWidth: 300,
                                            onPressed: () {
                                              String encoded = stringToBase64
                                                  .encode(newpass);
                                              lol['id'] = newid;
                                              lol['name'] = newname;
                                              lol['password'] = encoded;
                                              FirebaseFirestore.instance
                                                  .collection('ngos')
                                                  .doc('p4c')
                                                  .update({
                                                'volunteer':
                                                    FieldValue.arrayUnion(
                                                        [lol]),
                                              }).then((_) =>
                                                      Navigator.pop(context));
                                              // setState(() {
                                              // names.remove(names[index]);
                                              //                       });
                                            },
                                            child: Center(
                                              child: Text(
                                                "Add",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      // ),
                                      // height: 400,
                                      // width: 500,
                                      // color: Colors.,
                                      color: Color.fromRGBO(3, 84, 102, 1),
                                    ))),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Color.fromRGBO(3, 84, 102, 1),
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Color.fromRGBO(3, 84, 102, 1),
                        )),
                  ],
                )
              ],
            ),
            // MaterialButton(
            //   onPressed: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) => Container(
            //               height: 400,
            //               color: Colors.pink,
            //               child: Column(
            //                 children: <Widget>[
            //                   IconButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       icon: Icon(Icons.crop_square_sharp)),
            //                   textfieldcontainer(
            //                       w, "Enter Email ID", false, "email"),
            //                   MaterialButton(
            //                     onPressed: () {
            //                       FirebaseFirestore.instance
            //                           .collection('ngos')
            //                           .doc('p4c')
            //                           .set({
            //                         "volunteer[$numvol]['id']": "$newid",
            //                         "volunteer[$numvol]['name']": "$newname",
            //                         "volunteer[$numvol]['password']": "$newpass"
            //                       }).then((_) => Navigator.pop(context));
            //                      setState(() {
            //                           names.remove(names[index]);
            //                                   });
            //                     },
            //                     child: Text("add"),
            //                   )
            //                 ],
            //               ),
            //             ));
            //   },
            //   child: Text(
            //     "lelele",
            //     style: GoogleFonts.nunito(
            //       color: Color.fromRGBO(3, 84, 102, 1),
            //     ),
            //   ),
            // ),
            Container(
              // color: Colors.pink,
              height: h - 260,
              child: volunteerlist(w),
            )
          ],
        ),
      ),
    ));
  }
}

// InkWell(
//                   onTap: () async {
//                     await FirebaseAuth.instance.signOut();
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => MyHomePage(),
//                         ));
//                   },
//                   child: Icon(Icons.logout),
//                 )
