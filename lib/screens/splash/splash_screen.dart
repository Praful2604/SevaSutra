import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sevasutra_flutter/screens/logins_pages/login_options.dart';
import 'package:sevasutra_flutter/screens/logins_pages/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginOptions()),);
    });

  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/favicon.ico',
        width: 200,

        ),
      ),
    );
  }
}

