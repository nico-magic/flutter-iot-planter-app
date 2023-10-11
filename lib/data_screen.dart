import 'package:flutter/material.dart';
import 'package:flutter_iot_app2/graphs/humidity_graph.dart';
import 'package:flutter_iot_app2/graphs/humidity_points.dart';
import 'package:flutter_iot_app2/graphs/soil_humidity_graph.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text("Graf vlhkosti", style: TextStyle(fontSize: 40)),
                  ),
                ],
              ),
              Row(
                children: [
                  Center(
                    child: SizedBox(
                      height: 400,
                      width: 400,
                      //child: HumidityGraph(humidityPoints),
                      child: SoilHumidityGraph(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
}
