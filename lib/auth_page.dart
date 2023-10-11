import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot_app2/home_page.dart';
import 'package:flutter_iot_app2/login_page.dart';
import 'package:flutter_iot_app2/main.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHomePage(
              title: "Domovská obrazovka",
            );
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
