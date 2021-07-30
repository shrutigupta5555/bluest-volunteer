import 'package:blueaidngo/AdminNav.dart';
import 'package:blueaidngo/Home.dart';

import 'package:blueaidngo/adminHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/ble/ble_device_connector.dart';
import 'src/ble/ble_device_interactor.dart';
import 'src/ble/ble_scanner.dart';
import 'src/ble/ble_status_monitor.dart';
import 'src/ui/ble_status_screen.dart';
import 'src/ui/device_list.dart';

import 'package:provider/provider.dart';

import 'src/ble/ble_logger.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

Codec<String, String> stringToBase64 = utf8.fuse(base64);
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel",
  "High Importance Notifications",
  "description of notif",
  importance: Importance.high,
  playSound: true,
);

String cont = "Select Country";
final auth = FirebaseAuth.instance;
Color enabled = Colors.white;
Color disabled = Colors.grey.withOpacity(0.2);
double signupelevation = 0;
// double loginelevation = 5;
double loginelevationn = 5;
final firestoreInstance = FirebaseFirestore.instance;
String email = "", password = "", id = "";
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingbackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("bg message hehe ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final _bleLogger = BleLogger();
  final _ble = FlutterReactiveBle();
  final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
  final _monitor = BleStatusMonitor(_ble);
  final _connector = BleDeviceConnector(
    ble: _ble,
    logMessage: _bleLogger.addToLog,
  );
  final _serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: _ble.discoverServices,
    readCharacteristic: _ble.readCharacteristic,
    writeWithResponse: _ble.writeCharacteristicWithResponse,
    writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: _ble.subscribeToCharacteristic,
    logMessage: _bleLogger.addToLog,
  );

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingbackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleLogger),
        StreamProvider<BleScannerState>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Reactive BLE example',
        theme: ThemeData.dark(),
        home: Selection(),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<BleStatus>(
        builder: (_, status, __) {
          if (status == BleStatus.ready) {
            return DeviceListScreen();
          } else {
            return BleStatusScreen(status: status ?? BleStatus.unknown);
          }
        },
      );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blue Aid",
      color: Colors.blueAccent,
      debugShowCheckedModeBanner: false,
      home: Selection(),
    );
  }
}

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class Selection extends StatefulWidget {
  @override
  _SelectionState createState() => _SelectionState();
}

Future<String> getPrefs() async {
  final SharedPreferences temp = await _prefs;
  List<dynamic> arr;
  final String _vol = temp.getString("volunteer");
  final String _id = temp.getString("id");
  ;
  return _vol;
}

class _SelectionState extends State<Selection> {
  String vol;
  // getPrefs().then((value) => setState(() {
  //         vol = value;
  //       }));

  @override
  void initState() {
    super.initState();
    getPrefs().then((value) {
      setState(() {
        vol = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;

    check() {
      if (user != null) {
        return AdminNav();
      } else if ((vol != "") && (vol != null)) {
        // print(_vol);
        return HomeScreen();
      } else {
        return MyHomePage();
      }
    }

    return check();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String retrievedId;
  String retrievedPass;
  List<dynamic> retrievedData;

  //initialize shared prefs

  Future<String> _volunteer;
  Future<String> _volunteerId;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.amber,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("new notif");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: Column(
                  children: <Widget>[Text(notification.body)],
                ),
              );
            });
      }
    });
  }

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
                        color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 20),
                ),
              ),
              textfieldcontainer(w, "Volunteer ID", false, "id"),
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
                      //shared prefs
                      final SharedPreferences prefs = await _prefs;
                      //get deets from firebase
                      await FirebaseFirestore.instance
                          .collection("ngos")
                          .doc("p4c")
                          .get()
                          .then((value) => {
                                setState(() {
                                  retrievedData = value.data()["volunteer"];
                                })
                              });

                      print(retrievedData);
                      bool found = false;
                      for (int i = 0; i < retrievedData.length; i++) {
                        if (retrievedData[i]["id"] == id) {
                          found = true;
                          print(
                              "password ${retrievedData[i]["password"]} $password");

                          password = stringToBase64.encode(password);
                          if (retrievedData[i]["password"] == password) {
                            //write data
                            final String _volunteer =
                                prefs.getString("volunteer") ?? null;

                            setState(() {
                              prefs
                                  .setString(
                                      "volunteer", retrievedData[i]["name"])
                                  .then((value) {
                                prefs.setString("id", id).then((value) {
                                  //navigate

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ));
                                });
                              });
                            });
                          } else {
                            //do not nav
                            if (found == false) {
                              print("fix your shiz");
                            }
                          }
                        }
                      }

                      if (found == false) {
                        //wrong id

                      }
                    },
                    child: Text(
                      "LOG IN",
                      style: GoogleFonts.nunito(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    )),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
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
                      "as Organization",
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

textfieldcontainer(w, ht, isObs, checklol) {
  return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        height: 50,
        width: w - 100,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent),
        child: TextField(
          onChanged: (value) {
            if (checklol == "email") {
              email = value;
            } else if (checklol == "password") {
              password = value;
            } else if (checklol == "id") {
              id = value;
            }
          },
          obscureText: isObs,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            hintText: "$ht",
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ));
}
