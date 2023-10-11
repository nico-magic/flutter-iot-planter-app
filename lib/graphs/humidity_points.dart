import 'package:collection/collection.dart';

class HumidityPoint {
  final double x;
  final double y;
  HumidityPoint({required this.x, required this.y});
}

List<HumidityPoint> get humidityPoints {
  final data = <double>[
    75,
    72,
    70,
    68,
    64,
    62,
    60,
    59,
    57,
    54,
    52,
    50,
    49,
    66,
    78,
    76
  ];
  return data
      .mapIndexed(
          (index, element) => HumidityPoint(x: index.toDouble(), y: element))
      .toList();
}
