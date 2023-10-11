import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MySwitches extends StatefulWidget {
  const MySwitches({super.key});

  @override
  State<MySwitches> createState() => _MySwitchesState();
}

class _MySwitchesState extends State<MySwitches> {
  bool statusWatering = false;
  bool statusArduino = false;
  late StreamSubscription _dailySpecialStream;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

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

      final status = data['status'] as int;
      final wateringStatus = data['automaticWatering'] as int;
      setState(() {
        statusArduino = status == 1;
        statusWatering = wateringStatus == 1;
      });
    });
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  void changeValuesWatering() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("PlantInfo/monitors/");
    int val;
    if (statusWatering) {
      val = 1;
    } else {
      val = 0;
    }
    await ref.update({
      "automaticWatering": val,
    });
  }

  void changeValuesStatus() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("PlantInfo/monitors/");
    int val;
    if (statusArduino) {
      val = 1;
    } else {
      val = 0;
    }
    await ref.update({
      "status": val,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text("Automatické zavlažovanie",
                  style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Switch(
                // This bool value toggles the switch.
                value: statusWatering,
                activeColor: Colors.blue,
                onChanged: (bool value) {
                  setState(() {
                    if (statusArduino) {
                      statusWatering = value;
                      changeValuesWatering();
                    }
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Stav zariadenia", style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Switch(
                // This bool value toggles the switch.

                thumbIcon: thumbIcon,
                value: statusArduino,
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                onChanged: (bool value) {
                  setState(() {
                    if (!value) {
                      statusWatering = value;
                      changeValuesWatering();
                    }
                    statusArduino = value;
                    changeValuesStatus();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
