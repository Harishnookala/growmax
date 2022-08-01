import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Forms/personal_details.dart';
import 'UserScreens/userPannel.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _mobile = TextEditingController();
  TextEditingController _otp = TextEditingController();
  String? verificationId;
  bool inProgress = false;
  String errorMessage = "";
  bool error = false;
  User? user;
  SharedPreferences? prefsdata;
  String? status;
  var id;
  var mobilenumber;
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

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
                            fontSize: 16.6,
                            color: Colors.black,
                            fontFamily: "Poppins-Light"),
                        controller: _mobile,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
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
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontFamily: "Poppins-Medium"),
                          controller: _otp,
                          decoration: InputDecoration(

                            labelText: "OTP",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey)),
                          ),
                        ),
                      )
                    ],
                    verificationId!=null?Container(
                      padding: EdgeInsets.only(bottom: 13),
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: (){
                          get_otp(verificationId);
                        },
                        child: const Text("Resend Otp",style: TextStyle(color: Colors.pinkAccent,
                            fontSize: 16,
                            decoration: TextDecoration.underline,fontWeight: FontWeight.w600),),
                      ),
                    ):Container(),
                    GestureDetector(

                      onTap: () async {
                         get_data();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.all(const Radius.circular(5.0))),
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
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                        child: Text(
                          errorMessage,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.red,fontFamily: "Poppins-Medium"),
                          textAlign: TextAlign.center,
                        )),

                     TextButton(
                         style: TextButton.styleFrom(
                           minimumSize: Size(150, 40),
                           elevation: 2.0,
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
                         fontSize: 16.5,
                          fontWeight: FontWeight.w900,
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
    if (!regExp.hasMatch(input)&&input.length!=10) return "Please enter valid phone number";
    return null;
  }

   get_data() async{
     prefsdata = await SharedPreferences.getInstance();

     setState(() {
       errorMessage = "";
       error = false;
     });

     var Users = await FirebaseFirestore.instance.collection("Users").get();

     for(int i =0;i<Users.docs.length;i++){
       if(Users.docs[i].get("mobilenumber")==_mobile.text){
         id = Users.docs[i].id;
         mobilenumber = Users.docs[i].get("mobilenumber");
       }
     }
      if(id!=null){
        id = id;
        mobilenumber = mobilenumber;
      }
      else{
        id = null;
      }
     FirebaseAuth auth = FirebaseAuth.instance;
     if (phoneValidator(_mobile.text) != null) {
       setState(() {
         errorMessage = phoneValidator(_mobile.text)!;
         error = true;
       });
       return;
     }
     else if(id==null){

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
         verificationCompleted: (PhoneAuthCredential credential) async {

            var userCredential = await auth.signInWithCredential(credential);
            var user = userCredential.user!.providerData[0].phoneNumber;
              if(user!=null){
                prefsdata!.setString('phonenumber', _mobile.text);
                 Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return userPannel(
                            id: id,
                            phonenumber: mobilenumber,
                          );
                        }));
              }
            },
         verificationFailed: (FirebaseAuthException e) {

           setState(() {
             inProgress = true;
             errorMessage = e.message!;
             error = true;
           });
         },
         codeSent: (String verificationId, int? resendToken) {
           setState(() {
             errorMessage =
             "Please enter the OTP sent to your mobile number.";
             error = false;
             inProgress = false;
             this.verificationId = verificationId;
           });
         },
         codeAutoRetrievalTimeout: (String? verificationId) {
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
           prefsdata!.setString('phonenumber', _mobile.text);
           Navigator.of(context).pushReplacement(
               MaterialPageRoute(
                   builder: (BuildContext context) {
                     return userPannel(
                       id: id,
                       phonenumber: _mobile.text,
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
   }

   get_otp(String? verificationId) async {
     prefsdata = await SharedPreferences.getInstance();
     FirebaseAuth auth =FirebaseAuth.instance;
     if (verificationId != null) {
       await FirebaseAuth.instance.verifyPhoneNumber(
         phoneNumber: '+91' + _mobile.text,
         timeout: const Duration(seconds: 20),
         verificationCompleted: (PhoneAuthCredential credential) async {

           var userCredential = await auth.signInWithCredential(credential);
           var user = userCredential.user!.providerData[0].phoneNumber;
           if(user!=null){
             prefsdata!.setString('phonenumber', _mobile.text);
             Navigator.of(context).pushReplacement(
                 MaterialPageRoute(
                     builder: (BuildContext context) {
                       return userPannel(
                         id: id,
                         phonenumber: mobilenumber,
                       );
                     }));
           }
         },
         verificationFailed: (FirebaseAuthException e) {
           setState(() {
             errorMessage = e.message!;
             error = true;
           });
         },
         codeSent: (String verificationId, int? resendToken) {
           setState(() {
             errorMessage =
             "Please enter the OTP sent to your mobile number.";
             error = false;
             inProgress = false;
             this.verificationId = verificationId;
           });
         },
         codeAutoRetrievalTimeout: (String? verificationId) {
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

         PhoneAuthCredential credential =
         PhoneAuthProvider.credential(
             verificationId: verificationId!,
             smsCode: _otp.text);

         try {
           UserCredential user =
               await auth.signInWithCredential(credential);
           Navigator.of(context).pushReplacement(
               MaterialPageRoute(
                   builder: (BuildContext context) {
                     return userPannel(
                       id:id,
                         phonenumber:_mobile.text
                     );
                   }));
           if (user.user!.phoneNumber != null) {
             setState(() {
               inProgress = false;
             });
           }
         } catch (e) {
           setState(() {
             errorMessage = "Failed to validate OTP";
           });
         }
       }
     }
   }
}
