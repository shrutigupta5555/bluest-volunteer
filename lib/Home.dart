import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String id = "1234";
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<String> getPrefs() async {
  final SharedPreferences temp = await _prefs;
  final String _vol = temp.getString("volunteer");
  // print(_vol);
  return _vol;
}

class _HomeState extends State<Home> {
  // Future<String> name = getPrefs();

  String name;

  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs().then((value) {
      setState(() {
        name = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // getPrefs().then((value) {
    //   setState(() {
    //     name = value;
    //   });
    // });
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
