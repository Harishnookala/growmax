import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:growmax/Forms/personal_details.dart';
import 'package:growmax/Login.dart';
import 'package:growmax/UserScreens/userPannel.dart';

class mainScreen extends StatefulWidget {
  @override
  mainScreenState createState() => mainScreenState();
}

class mainScreenState extends State<mainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 120,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('assets/Images/app_image.jpg'),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                      child: Image.asset("assets/Images/wave.png")),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: SizedBox(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                elevation: 1.0,
                                side: BorderSide(color: Colors.white),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                              ), child: Text("Sign In",style: TextStyle(color: Colors.green.shade500,fontSize: 18,fontFamily: "Poppins-medium"),),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              elevation: 1.0,
                              side: BorderSide(color: Colors.white),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ), child: Text("Sign Up",style: TextStyle(color: Colors.green.shade500,fontSize: 18,),),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => personal_details()),
                              );
                            },
                          ),
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}
