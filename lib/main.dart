import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:growmax/Forms/Address.dart';
import 'package:growmax/Forms/nominee_details.dart';
import 'package:growmax/UserScreens/userPannel.dart';
import 'package:growmax/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('phonenumber');
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: token==null?SplashScreen():userPannel(phonenumber: token,)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home:SplashScreen()
    );
  }
}


