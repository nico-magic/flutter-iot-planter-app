import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SoilHumidityGraph extends StatefulWidget {
  const SoilHumidityGraph({Key? key}) : super(key: key);

  @override
  _SoilHumidityGraphState createState() => _SoilHumidityGraphState();
}

class _SoilHumidityGraphState extends State<SoilHumidityGraph> {
  List<_ChartData> chartData = <_ChartData>[];
  late DateTime _dateTime;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _dailySpecialStream;

  @override
  void initState() {
    super.initState();
    getDateTime();
    getDataFromFireStore();
    Timer.periodic(Duration(seconds: 3500), (_) => getDateTime());
  }

  getDateTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  Future<void> getDataFromFireStore() async {
    //DateFormat formattedDate = new DateFormat('d-M-yyyy');
    //DateFormat fomrattedHours = new DateFormat(':m');
    //String formattedDateString = formattedDate.format(_dateTime);
    //String formattedTimeString = fomrattedHours.format(_dateTime);

    _dailySpecialStream = _database
        .child(_dateTime.year.toString() + "/")
        .onValue
        .listen((event) {
      Map<Object?, Object?> data =
          event.snapshot.value as Map<Object?, Object?>;
      setState(() {
        List<_ChartData> temp_list = [];
        data.forEach((key, value) {
          print(key);
          if (value is Map) {
            List<dynamic> sortedKeys = value.keys.toList()
              ..sort((a, b) {
                int aHour = int.parse(a.split(":")[0]);
                int bHour = int.parse(b.split(":")[0]);
                return aHour.compareTo(bHour);
              });
            for (var i = 0; i < value.length; i++) {
              temp_list.add(_ChartData(
                  x: (sortedKeys[i] + ", " + key.toString()),
                  y: value[sortedKeys[i]]));
            }
          }
        });
        chartData = temp_list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showChart();
  }

  Widget _showChart() {
    return Scaffold(
      appBar: AppBar(),
      body: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<_ChartData, String>>[
            LineSeries<_ChartData, String>(
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y)
          ]),
    );
  }
}

class _ChartData {
  _ChartData({this.x, this.y});
  final String? x;
  final int? y;
}
