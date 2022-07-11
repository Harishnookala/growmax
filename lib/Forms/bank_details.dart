import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../UserScreens/userPannel.dart';
import 'Pan_details.dart';

class BankAccount extends StatefulWidget {
  String?phonenumber;
  String?id;
   BankAccount({this.phonenumber,this.id });

  @override
  _BankAccountState createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
  TextEditingController accountNumbeController = TextEditingController();
  TextEditingController Reenternumber = TextEditingController();
  TextEditingController Ifsc = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Container(
          margin: const EdgeInsets.all(12.3),
          child: ListView(
            padding: EdgeInsets.zero,
             shrinkWrap: true,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          userPannel(phonenumber: widget.phonenumber,)));
                }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.deepOrangeAccent,size: 19,)),
              ),
              Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
              Container(
                  margin: EdgeInsets.all(5.3),

                  child: Container(
                      margin: const EdgeInsets.only(
                        left: 13.3,
                      ),
                      child: const Text(
                        "Bank Account Details",
                        style: TextStyle(
                            color: Colors.pinkAccent,
                            letterSpacing: 0.6,
                            fontFamily: "Poppins-Medium",
                            fontSize: 16),
                      ))),
              Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
              Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.only(left: 12.3,right: 12.3,top: 12.3),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      Container(
                        child: const Text(
                          "Account Number : -",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrangeAccent,
                              letterSpacing: 0.6,
                              fontFamily: "Poppins-Light"),
                        ),
                        margin: EdgeInsets.only(bottom: 8.5),
                      ),
                      buildAccountNumber(),
                      SizedBox(height: 12,),
                      Container(
                        child: const Text(
                          "ReEnterAccount Number : -",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrangeAccent,
                              letterSpacing: 0.6,
                              fontFamily: "Poppins-Light"),
                        ),
                        margin: EdgeInsets.only(bottom: 8.5),
                      ),
                      build_reEnternumber(),
                      SizedBox(height: 15,),
                      Container(
                        child: const Text(
                          "Ifsc  : -",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrangeAccent,
                              letterSpacing: 0.6,
                              fontFamily: "Poppins-Light"),
                        ),
                        margin: EdgeInsets.only(bottom: 8.5),
                      ),
                      build_Ifsc(),
                      SizedBox(height: 20,),
                      build_button(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildAccountNumber() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: const TextStyle(fontFamily: "Poppins-Light",),
        validator: (value) {
          if (value == null || value.isEmpty || !value.isNum) {
            return 'Please enter Valid Account number';
          }
          return null;
        },
        controller: accountNumbeController,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Account Number",
            labelText: "Account Number",
            labelStyle: const TextStyle(color: Color(0xff576630)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
            ),
            hintStyle: const TextStyle(color: Colors.brown)),
      ),
    );

  }

  build_reEnternumber() {
    return SizedBox(
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        style: TextStyle(fontFamily: "Poppins-Light",),
        validator: (value) {
          if (value == null || value.isEmpty||!value.isNum) {
            return 'Please enter Account number';
          }
          else if(accountNumbeController.text!=Reenternumber.text){
            return "Account number does not matches";
          }
          return null;
        },
        controller: Reenternumber,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "ReenterAccount Number",
            labelText: "ReenterAccount Number",
            labelStyle: const TextStyle(color: Color(0xff576630)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
            ),
            hintStyle: const TextStyle(color: Colors.brown)),
      ),
    );

  }

  build_Ifsc() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        style: TextStyle(fontFamily: "Poppins-Light",),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: Ifsc,
        decoration: InputDecoration(
            contentPadding:  const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),

            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Ifsc ",
            labelText: "Ifsc ",
            labelStyle: const TextStyle(color: Color(0xff576630)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
            ),
            hintStyle: const TextStyle(color: Colors.brown)),
      ),
    );
  }
  build_button() {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: Size(170, 48),
          elevation: 1.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.6)),

        ),
        onPressed: (){
          if (formKey.currentState!.validate()){

            Navigator.push (
              context,
              MaterialPageRoute (
                builder: (BuildContext context) =>
                    Pan_deatils(phonenumber: widget.phonenumber,
                        accountnumber:accountNumbeController.text,
                       Ifsc: Ifsc.text,
                    ),
              ),
            );
          }
        },
        child: Container(
            margin: EdgeInsets.only(left: 5.3,right: 5.3),
            child: Text("Save & Continue",style: TextStyle(color: Colors.white,
                fontSize: 15,
                fontFamily: "Poppins-Medium"),)),
      ),
    );
  }

}
