import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text(
            'Info',
            style: TextStyle(fontSize: 60),
          ),
        ),
      );
}
