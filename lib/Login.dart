import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:growmax/UserScreens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Forms/personal_details.dart';
import 'UserScreens/userPannel.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _otp = new TextEditingController();
  String? verificationId;
  bool inProgress = false;
  String errorMessage = "";
  bool error = false;
  User? user;
  SharedPreferences? prefsdata;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(flex: 1,child: Container(),),
                    Text("Welcome", style: Theme.of(context).textTheme.headline5),
                    Text("Please Login First",
                        style: Theme.of(context).textTheme.headline5),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 20),
                      child: TextField(
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: "Poppins-Light"),
                        controller: _mobile,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: new InputDecoration(
                          labelText: "Mobile Number",
                          labelStyle: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 14,
                              fontFamily: "Poppins-Light",
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey)),
                        ),
                      ),
                    ),
                    if (verificationId != null) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 20),
                        child: TextField(
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontFamily: "Poppins-Medium"),
                          controller: _otp,
                          decoration: new InputDecoration(

                            labelText: "OTP",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey)),
                          ),
                        ),
                      )
                    ],
                    GestureDetector(
                      onTap: () async {
                        prefsdata = await SharedPreferences.getInstance();

                        setState(() {
                          errorMessage = "";
                          error = false;
                        });
                        var valid;

                        var users = await FirebaseFirestore.instance.collection("Users").doc(_mobile.text).get();

                        if(users.exists){
                          valid = users.get("mobilenumber");
                         }
                        else{
                          valid = null;
                        }
                      print(valid);

                        FirebaseAuth auth = FirebaseAuth.instance;
                        if (phoneValidator(_mobile.text) != null) {
                          setState(() {
                            errorMessage = phoneValidator(_mobile.text)!;
                            error = true;
                          });
                          return;
                        }
                        else if(valid==null){

                          setState(() {
                            errorMessage = "User is not registered";
                            error = true;
                          });
                          return;
                        }
                        if (verificationId == null) {
                          setState(() {
                            inProgress = true;
                          });
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+91' + _mobile.text,
                            timeout: Duration(minutes: 1),
                            verificationCompleted: (PhoneAuthCredential credential) async {
                              await auth.signInWithCredential(credential).then((value) async {
                                if (value.user!.providerData[0].phoneNumber != null) {
                                  prefsdata!.setString('phonenumber', _mobile.text);

                                  return Navigator.of(context).pushReplacement(
                                       MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return userPannel(
                                      phoneNumber: _mobile.text,
                                    );
                                  }));
                                } //Here
                              });
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              print(e.message);
                              setState(() {
                                inProgress = true;
                                errorMessage = e.message!;
                                error = true;
                              });
                              print("Verification Failed");
                            },
                            codeSent: (String verificationId, int? resendToken) {
                              print("Code Sent " + verificationId);
                              setState(() {
                                errorMessage =
                                    "Please enter the OTP sent to your mobile number.";
                                error = false;
                                inProgress = false;
                                this.verificationId = verificationId;
                              });
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {
                              print("Code Auto Retrieval Timeout " + verificationId);
                            },
                          );
                        } else {
                          if (this.verificationId != null) {
                            if (_otp.text.isEmpty || _otp.text.length < 6) {
                              setState(() {
                                errorMessage =
                                    "Please enter a valid OTP.\nIt should be at least 6 digits.";
                              });
                              return;
                            }
                            setState(() {
                              inProgress = true;
                            });
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId!,
                                    smsCode: _otp.text);

                            try {
                              UserCredential user =
                                  await auth.signInWithCredential(credential);
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return userPannel(
                                  phoneNumber: _mobile.text,
                                );
                              }));
                              if (user.user!.phoneNumber != null) {
                                setState(() {
                                  inProgress = false;
                                });
                              }
                            } catch (e) {
                              setState(() {
                                inProgress = false;
                                errorMessage = "Failed to validate OTP";
                              });
                            }
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (this.verificationId == null)
                                  ? "Send OTP"
                                  : "Validate OTP",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            inProgress
                                ? Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: CircularProgressIndicator())
                                : Container()
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.all(const Radius.circular(5.0))),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                        child: Text(
                          errorMessage,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.red),
                          textAlign: TextAlign.center,
                        )),

                     TextButton(
                         style: TextButton.styleFrom(
                           minimumSize: Size(150, 40),
                           elevation: 1.0,
                           backgroundColor: Colors.deepOrange.shade600,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.3))
                         ),
                         onPressed: (){
                            Navigator.of(context).pushReplacement(
                               MaterialPageRoute(
                                   builder: (BuildContext context) {
                                     return personal_details();
                                   }));
                         }, child: Text("Signup",style:
                     TextStyle(color: Colors.white,
                         fontFamily: "Poppins-Light",
                         fontSize: 15,
                          fontWeight: FontWeight.w600,
                     ),)),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  String? phoneValidator(String input) {
    final String regexSource = r'[0-9]{10}';
    RegExp regExp = RegExp(regexSource);
    if (input == null || input.trim().isEmpty)
      return "Please enter valid phone number";
    if (!regExp.hasMatch(input)) return "Please enter valid phone number";
    return null;
  }
}
