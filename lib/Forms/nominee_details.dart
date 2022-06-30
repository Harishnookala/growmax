import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growmax/UserScreens/drawer.dart';
import 'package:growmax/UserScreens/userPannel.dart';

class Nominee_details extends StatefulWidget {
  String? phonenumber;
  Nominee_details({Key? key, this.phonenumber}) : super(key: key);

  @override
  State<Nominee_details> createState() => _Nominee_detailsState();
}

class _Nominee_detailsState extends State<Nominee_details> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController fathernameController = TextEditingController();
  TextEditingController mothernameController = TextEditingController();

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
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }
  @override
  Widget build(BuildContext context) {
    print(widget.phonenumber);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Form(
          key: formKey,
          child: Container(
            margin: EdgeInsets.all(12.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 9,),
                IconButton(onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          userPannel(phoneNumber: widget.phonenumber,)));
                }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 20,color: Colors.lightBlueAccent,)),
                Divider(
                    height: 1, thickness: 1.5, color: Colors.green.shade400),
                Container(
                    margin: EdgeInsets.all(5.3),
                    child: Container(
                        margin: const EdgeInsets.only(
                          left: 6.3,
                        ),
                        child: const Text(
                          "Nominee Details",
                          style: TextStyle(
                              letterSpacing: 0.6,
                              color: Colors.indigoAccent,
                              fontFamily: "Poppins-Light",
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ))),
                Divider(
                    height: 1, thickness: 1.5, color: Colors.green.shade400),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 16.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const Text(
                                "Name : -",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 15,
                                    letterSpacing: 0.8,
                                    fontFamily: "Poppins-Light"),
                              ),
                              margin: EdgeInsets.only(bottom: 8.5),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5.3),
                              child: build_name(),
                            ),
                            Container(
                              child: const Text(
                                "Age : -",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 15,
                                    letterSpacing: 0.8,
                                    fontFamily: "Poppins-Light"),
                              ),
                              margin: EdgeInsets.only(bottom: 9.5),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 6.3),
                              child: build_age(),
                            ),
                            Container(
                              child: const Text(
                                "RelationShip with Nominee : -",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 15,
                                    letterSpacing: 0.8,
                                    fontFamily: "Poppins-Light"),
                              ),
                              margin: EdgeInsets.only(bottom: 8.5),
                            ),
                            build_nominee(),
                            SizedBox(
                              height: 13,
                            ),
                            build_button()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  build_name() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Poppins-Light",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: nameController,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
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

  build_age() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Poppins-Light",
        ),
        validator: (value) {
          if (value == null || !value.isNum) {
            return 'Please enter Age';
          }
          return null;
        },
        controller: ageController,
        decoration: InputDecoration(
          contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Age",
            labelText: "Age",
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

  build_nominee() {
    return SizedBox(

      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Poppins-Light",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter Relation';
          }
          return null;
        },
        controller: relationController,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Relation with You ",
            labelText: "Relation",
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
          minimumSize: Size(130, 20),
          elevation: 1.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.6)),
        ),
        onPressed: () async {

          if (formKey.currentState!.validate()) {
            Map<String,dynamic>data ={
              "Name":nameController.text,
              "Age":ageController.text,
              "Relation":relationController.text
            };
            await FirebaseFirestore.instance.collection("nominee_details").doc(widget.phonenumber.toString()).set(data);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    userPannel(phoneNumber: widget.phonenumber,)));
          }
        },
        child: Container(
            margin: EdgeInsets.only(left: 5.3, right: 5.3),
            child: Text(
              "Submit",
              style:
                  TextStyle(color: Colors.white, fontFamily: "Poppins-Medium"),
            )),
      ),
    );
  }

  build_fathername() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Poppins-Light",
        ),
        controller: fathernameController,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Father Name",
            labelText: "Father Name",
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
}
