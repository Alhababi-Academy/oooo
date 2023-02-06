import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsy/Authentication/authenication.dart';

import 'EditNumber.dart';

class choicesScreen extends StatefulWidget {
  @override
  _choicesScreen createState() => _choicesScreen();
}

class _choicesScreen extends State<choicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
            image: AssetImage('img/splashScreen.jpeg'), fit: BoxFit.cover),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Logo(),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                  ),
                  child: Text(
                    "WSY",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.push(context, route);
                    },
                    child: const Text("Sign up"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Log in"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Logo() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image(
          image: AssetImage('img/splashScreen.jpeg'),
          width: 12,
        ),
      ),
    );
  }

  SignIn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => EditNumberScreen()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          DefaultTextStyle(
            style: TextStyle(fontSize: 15),
            child: Text(
              "Verify Using Phone Number",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  LogIn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => AuthenticScreen()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          DefaultTextStyle(
            style: TextStyle(fontSize: 15),
            child: Text(
              "Verify Using Email",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }
}
