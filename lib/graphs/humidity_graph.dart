import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot_app2/graphs/humidity_points.dart';

class HumidityGraph extends StatelessWidget {
  final List<HumidityPoint> points;
  const HumidityGraph(this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(LineChartData(
          minY: 0,
          maxY: 100,
          minX: 0,
          maxX: 23,
          titlesData: FlTitlesData(
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
          lineBarsData: [
            LineChartBarData(
                spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
                isCurved: false,
                dotData: FlDotData(show: true))
          ])),
    );
  }
}
