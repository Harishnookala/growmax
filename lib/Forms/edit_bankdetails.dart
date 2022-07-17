import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growmax/UserScreens/userPannel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Custom_widgets/wrappers.dart';

class edit_details extends StatefulWidget {
  String? id;
  String? Accountnumber;
  String? ifsc;
  String?phonenumber;
  edit_details({Key? key, this.id, this.Accountnumber, this.ifsc,this.phonenumber})
      : super(key: key);

  @override
  State<edit_details> createState() => _edit_detailsState();
}

class _edit_detailsState extends State<edit_details> {
  TextEditingController? Accountnumber;
  TextEditingController? RenterAccount;
  TextEditingController? Ifsc;
  final formKey = GlobalKey<FormState>();

  void initState() {
    Accountnumber = TextEditingController();
    Accountnumber!.text = widget.Accountnumber!;
    RenterAccount = TextEditingController();
    RenterAccount!.text = widget.Accountnumber!;
    Ifsc = TextEditingController();
    Ifsc!.text = widget.ifsc!;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Accountnumber!.dispose();
    RenterAccount!.dispose();
    Ifsc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 19.6),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Expanded(
                child: Form(
                  key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 20.6, right: 20.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Account Number",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Poppins-Light"),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      build_account(widget.Accountnumber),
                      Container(
                        child: Text(
                          "Renter Account Number",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Poppins-Light"),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      build_reenterAccount(),
                      Container(
                        child: Text(
                          "Ifsc",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Poppins-Light"),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      build_Ifsc(),

                      SizedBox(height: 13,),
                      build_button(),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ))));
  }

  build_account(String? accountnumber) {
      return SizedBox(
        width: MediaQuery.of(context).size.width/1.2,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty || !value.isNum) {
              return 'Please enter Valid Account number';
            }
            return null;
          },
          style: TextStyle(fontFamily: "Poppins-Light",),
          controller: Accountnumber,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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



  build_reenterAccount() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty||!value.isNum) {
            return 'Please enter Account number';
          }
          else if(Accountnumber!.text!=RenterAccount!.text){
            return "Account number does not matches";
          }
          return null;
        },
        style: TextStyle(fontFamily: "Poppins-Light",),
        controller: RenterAccount,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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

  build_Ifsc() {
    return SizedBox(

      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter Valid ifsc number';
          }
          return null;
        },
        inputFormatters: [
          UpperCaseTextFormatter(),
        ],
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        style: TextStyle(fontFamily: "Poppins-Light",),
        controller: Ifsc,
        decoration: InputDecoration(
            contentPadding:  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
          minimumSize: Size(80, 20),
          elevation: 1.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.6)),

        ),
        onPressed: ()async{
             if(formKey.currentState!.validate()){
               if(widget.Accountnumber!=Accountnumber!.text || widget.ifsc!=Ifsc!.text){
                 Map<String,dynamic> data = {
                   "accountnumber":Accountnumber!.text,
                   "ifsc":Ifsc!.text,
                   "status":"pending"
                 };
                 await FirebaseFirestore.instance.collection("bank_details").doc(widget.id).update(data);
                 Navigator.of(context).pushReplacement(MaterialPageRoute(
                     builder: (BuildContext context) =>
                         userPannel(phonenumber: widget.phonenumber,pressed: true,)));
               }
               else{
                 Navigator.of(context).pushReplacement(MaterialPageRoute(
                     builder: (BuildContext context) =>
                         userPannel(phonenumber: widget.phonenumber,pressed: true,)));
               }
             }

          },
        child: Container(
            margin: EdgeInsets.only(left: 5.3,right: 5.3),
            child: Text("Save & Continue",style: TextStyle(color: Colors.white,fontFamily: "Poppins-Medium"),)),
      ),
    );
  }

}

