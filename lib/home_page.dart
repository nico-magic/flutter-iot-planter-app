import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _displayText = 0;
  double _displayTemeperature = 0;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _dailySpecialStream;

  @override
  void initState() {
    super.initState();
    _activateListener();
  }

  // void _activateListener() {
  //   _dailySpecialStream =
  //       _database.child('PlantInfo/values/humidity').onValue.listen((event) {
  //     int humidity = event.snapshot.value as int;
  //     setState(() {
  //       _displayText = humidity;
  //     });
  //   });
  // }

  void _activateListener() {
    _dailySpecialStream =
        _database.child('PlantInfo/values/').onValue.listen((event) {
      Map<Object?, Object?> data =
          event.snapshot.value as Map<Object?, Object?>;
      final humidity = data['humidity'] as int;
      final temperature = data['temperature'] as double;
      setState(() {
        _displayText = humidity;
        _displayTemeperature = temperature;
      });
    });
  }

  void activateOnDown() async {
    await _database.child("PlantInfo/monitors/").update({
      "isPressed": 1,
    });
  }

  void activateOnUp() async {
    await _database.child("PlantInfo/monitors/").update({
      "isPressed": 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Vlhkosť:", style: const TextStyle(fontSize: 20)),
          Text(_displayText.toString(), style: const TextStyle(fontSize: 60)),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GestureDetector(
              child: Container(
                width: 200,
                height: 200,
                child: Center(
                  child: Text(
                    'Zavlaž',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
              onTapDown: (details) => activateOnDown(),
              onTapCancel: () => activateOnUp(),
              onTapUp: (details) => activateOnUp(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Teplota:", style: TextStyle(fontSize: 20)),
          Text(_displayTemeperature.toString() + " °C",
              style: const TextStyle(fontSize: 25)),
        ],
      )),
    );
  }

  @override
  void deactivate() {
    _dailySpecialStream.cancel();
    super.deactivate();
  }
}
