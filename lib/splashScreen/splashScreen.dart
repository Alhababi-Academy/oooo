import 'dart:async';
import 'package:flutter/material.dart';
import '../Authentication/authenication.dart';
import '../Authentication/choicesScreen.dart';
import '../Store/storehome.dart';
import '../global/global.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreen createState() => _MySplashScreen();
}

class _MySplashScreen extends State<MySplashScreen> {
  displaySplash() {
    Timer(const Duration(seconds: 5), () async {
      if (firebaseAuth.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => StoreHome()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => choicesScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0XFF7fb7b6),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "img/splashScreen.jpeg",
                width: 200.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Welcome To We Serve You(WSY)",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
                textDirection: TextDirection.ltr,
              ),
              const Text(
                "is a mobile applicatino will be providing services for users, home based services.",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
