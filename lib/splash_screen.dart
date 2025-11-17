import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // timer for splash screen
    Timer(Duration(seconds: 3), () {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 120, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Messaging Chatboard',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Socialize. Share. Connect.',
              style: TextStyle(fontSize: 20, color: Colors.grey[200]),
            ),
          ],
        ),
      ),
    );
  }
}
