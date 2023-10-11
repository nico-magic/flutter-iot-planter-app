import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iot_app2/widgets/my_button.dart';
import 'package:flutter_iot_app2/widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void SignUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == "user-not-found") {
        wrongEmailMessage();
      } else if (e.code == "wrong-password") {
        wrongPasswordMessage();
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Zlý email"),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Zlé heslo"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 233, 217),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Icon(
                Icons.grass_rounded,
                size: 100,
              ),
              SizedBox(height: 50),
              Text(
                "Vitajte",
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 50),
              MyTextfield(
                controller: emailController,
                hintText: 'E-mail:domosajaplaja@gmail.com',
                obscureText: false,
              ),
              SizedBox(height: 10),
              MyTextfield(
                controller: passwordController,
                hintText: 'Heslo:testpass1231',
                obscureText: true,
              ),
              SizedBox(height: 40),
              MyButton(
                onTap: SignUserIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
