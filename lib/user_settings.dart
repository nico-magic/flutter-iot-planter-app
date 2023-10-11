import 'dart:async';
import 'package:flutter_iot_app2/widgets/my_number_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot_app2/widgets/my_switch.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _minHumidityValue = 0;
  int _maxHumidityValue = 0;
  int _currentValueMinHumidity = 0;
  int _currentValueMaxHumidity = 0;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  late StreamSubscription _dailySpecialStream;

  @override
  void initState() {
    super.initState();
    _activateListener();
  }

  void _activateListener() {
    _dailySpecialStream =
        _database.child('PlantInfo/monitors').onValue.listen((event) {
      Map<Object?, Object?> data =
          event.snapshot.value as Map<Object?, Object?>;

      final minHumidity = data['minHumidity'] as int;
      final maxHumidity = data['maxHumidity'] as int;
      setState(() {
        _minHumidityValue = minHumidity;
        _maxHumidityValue = maxHumidity;
        _currentValueMinHumidity = minHumidity;
        _currentValueMaxHumidity = maxHumidity;
      });
    });
  }

  void openDialogWindow() {}

  void changeValues() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("PlantInfo/monitors/");
    await ref.update({
      "maxHumidity": _currentValueMaxHumidity,
      "minHumidity": _currentValueMinHumidity,
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Minimálna vlhkosť",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: GestureDetector(
                      onTap: () async {
                        await _showMinHumidityDialog();
                      },
                      child: Text(_minHumidityValue.toString(),
                          style: TextStyle(fontSize: 30))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      Text("Maximálna vlhkosť", style: TextStyle(fontSize: 18)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: GestureDetector(
                      onTap: () async {
                        await _showMaxHumidityDialog();
                      },
                      child: Text(_maxHumidityValue.toString(),
                          style: TextStyle(fontSize: 30))),
                )
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Expanded(child: MySwitches())],
            )
          ],
        ),
      );

  Future _showMinHumidityDialog() => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Zvoľte dolnú hranicu vlhkosti"),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return MyNumberPicker(
                    firstValue: _minHumidityValue,
                    limitValue: _maxHumidityValue);
              }),
            );
          }).then((value) {
        if (value != null) {
          setState(() {
            _currentValueMinHumidity = value;
            changeValues();
          });
        }
      });

  Future _showMaxHumidityDialog() => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Zvolte hornu hranicu vlhkosti"),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return MyNumberPicker(
                    firstValue: _maxHumidityValue,
                    limitValue: _minHumidityValue);
              }),
            );
          }).then((value) {
        if (value != null) {
          setState(() {
            _currentValueMaxHumidity = value;
            changeValues();
          });
        }
      });
}
