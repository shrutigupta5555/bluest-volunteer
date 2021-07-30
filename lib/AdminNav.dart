import 'package:blueaidngo/Broadcast.dart';
import 'package:blueaidngo/adminHome.dart';
import 'package:blueaidngo/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNav extends StatefulWidget {
  @override
  _AdminNavState createState() => _AdminNavState();
}

String newCalamity, newRegion, newDate, newMessage;

class _AdminNavState extends State<AdminNav> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 254, 255, 1),
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(color: Colors.amber),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image(
                          image: AssetImage('assets/logo.png'),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Blue Aid",
                          style: GoogleFonts.nunito(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                    IconButton(
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
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: GoogleFonts.nunito(
                          fontSize: 24.0,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Container(
                  width: 450,
                  height: 200,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage('assets/lol.png'))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(40.0, 30.0, 8.0, 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Manage Volunteer",
                              style: GoogleFonts.nunito(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 8.0, 45.0, 30.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Broadcast Disaster ",
                                  style: GoogleFonts.nunito(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "alerts anytime",
                                  style: GoogleFonts.nunito(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                ElevatedButton.icon(
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        MaterialButton(
                                            minWidth: 20,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("x"))
                                      ],
                                    ),
                                    Image.asset(
                                      'assets/logo.png',
                                      height: 40,
                                    ),
                                    MaterialButton(
                                        onPressed: () {},
                                        child: Text("BroadCast Alert")),
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          height: 50,
                                          width: w - 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.transparent),
                                          child: TextField(
                                            onChanged: (value) {
                                              newCalamity = value;
                                            },
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              hintText: "Type of Calamity",
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
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
                                                  BorderRadius.circular(12),
                                              color: Colors.transparent),
                                          child: TextField(
                                            onChanged: (value) {
                                              newRegion = value;
                                            },
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              hintText: "Impact Region",
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
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
                                                  BorderRadius.circular(12),
                                              color: Colors.transparent),
                                          child: TextField(
                                            onChanged: (value) {
                                              newDate = value;
                                            },
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              hintText: "Date and Time",
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          height: 150,
                                          width: w - 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.transparent),
                                          child: TextField(
                                            onChanged: (value) {
                                              newMessage = value;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                            minLines: 3,
                                            maxLines: 5,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              hintText: "Any message",
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        )),
                                    MaterialButton(
                                      elevation: 0,
                                      height: 60,
                                      color: Colors.white,
                                      minWidth: 300,
                                      onPressed: () {
                                        lol['calamity'] = newCalamity;
                                        lol['region'] = newRegion;
                                        lol['time'] = newDate;
                                        lol['message'] = newMessage;
                                        FirebaseFirestore.instance
                                            .collection('broadcast')
                                            .doc('bcast')
                                            .update({
                                          'alerts':
                                              FieldValue.arrayUnion([lol]),
                                        }).then((_) => Navigator.pop(context));
                                        // setState(() {
                                        // names.remove(names[index]);
                                        //                       });
                                      },
                                      child: Center(
                                        child: Text(
                                          "Add",
                                          style: TextStyle(color: Colors.black),
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
                  icon: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 15.0, 0.0, 15.0),
                    child: Icon(Icons.warning),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                    child: Text('Broadcast Alert'),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(3, 84, 102, 1)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminHome(),
                        ));
                  },
                  icon: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 15.0, 0.0, 15.0),
                    child: Icon(Icons.people),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                    child: Text('Manage Volunteers'),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(3, 84, 102, 1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
