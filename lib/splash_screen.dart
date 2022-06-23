import 'dart:async';

import 'package:flutter/material.dart';
import 'package:growmax/Login.dart';
import 'package:growmax/UserScreens/home.dart';
import 'package:growmax/UserScreens/userPannel.dart';

import 'Forms/personal_details.dart';
import 'main_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => mainScreen())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Images/app_image.jpg",),fit: BoxFit.cover)),
      ),
    );
  }
}
