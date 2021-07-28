import 'package:blueaidngo/adminHome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

String name;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/mainbg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  child: Text(
                    "Blue Aid",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 20),
                ),
              ),
              textfieldcontainer(w, "Enter Email ID", false, "email"),
              textfieldcontainer(w, "Enter Password", true, "password"),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Colors.white,
                    height: 50,
                    minWidth: w - 100,
                    onPressed: () async {
                      await auth
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then((value) {
                        if (value.user != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminHome(),
                              ));
                        } else {
                          print("cannot navigate");
                        }
                      }).catchError((err) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text(err.message),
                                // content:
                                //     Text("Invalid content, try again!"),
                                actions: [
                                  TextButton(
                                    child: Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      });
                    },
                    child: Text(
                      "LOG IN",
                      style: GoogleFonts.nunito(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    )),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login ",
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[300]),
                    ),
                    Text(
                      "as Volunteer",
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
