import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String name = "name", id = "1234";

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(248, 254, 255, 1),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Blue Aid",
                      style: GoogleFonts.nunito(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Welcome $name ,",
                          style: GoogleFonts.nunito(
                              color: Color.fromRGBO(3, 84, 102, 1),
                              fontSize: 40,
                              fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Volunteer ID: $id",
                          style: GoogleFonts.nunito(
                              color: Color.fromRGBO(3, 84, 102, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
