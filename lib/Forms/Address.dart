import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Login.dart';
import '../repositories/authentication.dart';
class Address extends StatefulWidget {
  String? firstname;
  String? lastname;
  String? gender;
  String? birth_date;
  String?phonenumber;
      String? married_status;
  String ?fathername;
      String ?mothername;
      var image;
  bool securedValue = true;
  bool isChecked = false;
  Icon fab = const Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
   Address({Key? key, this.phonenumber,this.firstname,this.fathername,this.lastname,this.gender,this.birth_date,this.married_status,this.mothername,this.image }) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController fatherNameContoller =TextEditingController();
  TextEditingController motherNameContoller =TextEditingController();
  final formKey = GlobalKey<FormState>();
  var image;
  File?image_url;
  var profile_image = "profile";
  final ImagePicker _picker = ImagePicker();
  Authentication authentication = Authentication();
  bool pressed =true;
  bool login_success = false;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(12.3),
          child: Form(
            key: formKey,
                child:Column(
                  children: [
                    SizedBox(height: 25,),
                    Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                    Container(
                      margin: EdgeInsets.only(left: 14.3,top: 5.3),
                      alignment: Alignment.topLeft,
                      child: const Text("Address & Communication",style: TextStyle(letterSpacing: 0.6,
                          color: Colors.indigoAccent,
                          fontFamily: "Poppins-Light",
                          fontWeight: FontWeight.w500,
                          fontSize: 16),),
                    ),
                    Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 16.3,top: 12.3),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: [
                            const SizedBox(height: 5,),
                            Container(
                              margin: EdgeInsets.only(bottom: 8.5),
                              child: const Text(
                                "Email : -",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 15,
                                    letterSpacing: 0.6,
                                    fontFamily: "Poppins-Light"),
                              ),
                            ),
                            build_email(),
                            SizedBox(height: 5,),
                            Container(
                              child: const Text(
                                "Father Name : -",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 15,
                                    letterSpacing: 0.6,
                                    fontFamily: "Poppins-Medium"),
                              ),
                              margin: EdgeInsets.only(bottom: 8.5,top: 5.6),
                            ),
                            buildFatherName(),
                            Container(
                              child: const Text(
                                "Mother Name : -",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 15,
                                    letterSpacing: 0.6,
                                    fontFamily: "Poppins-Medium"),
                              ),
                              margin: EdgeInsets.only(bottom: 8.5,top: 5.6),
                            ),
                            buildMotherName(),
                            Container(
                              margin: EdgeInsets.only(bottom: 8.5),
                              child: const Text(
                                "Address : -",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 15,
                                    letterSpacing: 0.6,
                                    fontFamily: "Poppins-Light"),
                              ),
                            ),
                            build_address(),
                            SizedBox(height: 20,),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8.5),
                              child: const Text(
                                "Profile picture : -",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepOrangeAccent,
                                    letterSpacing: 0.6,
                                    fontSize: 15,
                                    fontFamily: "Poppins-Medium"),
                              ),
                            ),
                            Center(child:buildPanPhoto() ,),
                            SizedBox(height: 10,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               pressed == true
                                   ? build_button()
                                   : Center(
                                 child: Row(
                                   crossAxisAlignment:
                                   CrossAxisAlignment.center,
                                   mainAxisAlignment:
                                   MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       decoration: BoxDecoration(
                                           color: Colors.grey,
                                           borderRadius:
                                           BorderRadius.circular(
                                               25.3)),
                                       child: Center(
                                           child: Text("Save & Continue",
                                               style: TextStyle(
                                                   color: Colors.white,
                                                   fontSize: 16),
                                               textAlign:
                                               TextAlign.center)),
                                       width: 180,
                                       height: 40,
                                     ),
                                   ],
                                 ),
                               ),
                               inProgress?const Padding(
                                   padding: EdgeInsets.only(left: 10),
                                   child: CircularProgressIndicator())
                                       : Container()
                             ],
                           )

                          ],
                        ),
                      ),
                    ),
                  ],
                ),

          ),
        ),
      ),
    );
  }


  build_email() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(fontFamily: "Poppins-Light",),
        validator: (email){
          if(email==null||email.isEmpty){
            return "please enter Email";
          }
          else if(!EmailValidator.validate(emailController.text)&&email.isNotEmpty){
             return "Please enter valid Email Address";
          }
          return null;
        },
        controller: emailController,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Email",
            labelText: "Email",
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

  build_address() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        minLines: 1,
        maxLines: 15,
        keyboardType: TextInputType.multiline,
        style: TextStyle(fontFamily: "Poppins-Light"),
        validator: (address){
          if(address==null||address.isEmpty){
            return "please enter Address";
          }
          return null;
        },
        controller: addressController,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Address",
            labelText: "Address",
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

  buildFatherName() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(fontFamily: "Poppins-Light",),
        validator: (fathername){
          if(fathername==null||fathername.isEmpty){
            return "please enter name";
          }
          return null;
        },
        controller: fatherNameContoller,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),

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
  buildMotherName() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(fontFamily: "Poppins-Light",),
        validator: (mothername){
          if(mothername==null||mothername.isEmpty){
            return "please enter name";
          }
          return null;
        },
        controller: motherNameContoller,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Mother Name",
            labelText: "Mother Name",
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
  buildPanPhoto() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image_url!=null?Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  child: Row(
                    children: [
                      Image.file(image_url!,width: 180,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 12.3),
                              child: IconButton(onPressed: (){
                                setState(() {
                                  image_url=null;
                                });
                              }, icon: Icon(Icons.close_outlined))),
                        ],
                      )
                    ],
                  )),
            ],
          ):Container(
            margin: EdgeInsets.only(bottom: 15.3),
            child: TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size(140, 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
                    backgroundColor: Colors.purple.shade400),
                onPressed: (){
                  get_permissions();
                },child: Text("Upload Profile",style: TextStyle(color: Colors.white,fontSize: 16),)),
          )
        ],
      ),
    );
  }
  get_permissions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  _getFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        image_url = File(pickedFile.path);
        image =  authentication.moveToStorage(image_url, widget.firstname,profile_image);
      });
    }
  }
  _imgFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        image_url = File(pickedFile.path);
        image =  authentication.moveToStorage(image_url, widget.firstname,profile_image);
      });
    }
  }
  build_button() {
    return Container(
      margin: EdgeInsets.only(top: 15.3),
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: Size(80, 20),
          elevation: 1.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.6)),

        ),
        onPressed: () async{
          if(formKey.currentState!.validate()&&image_url!=null){
            setState(() {
              inProgress =true;
              pressed =false;
            });
            image = await image;
            Map<String,dynamic> details ={
              "firstname":widget.firstname,
              "lastname":widget.lastname,
              "gender":widget.gender,
              "dateofbirth":widget.birth_date,
              "status":widget.married_status,
              "fathername":fatherNameContoller.text,
              "mothername":motherNameContoller.text,
              "mobilenumber":widget.phonenumber,
              "email":emailController.text,
              "address":addressController.text,
              "image":image,
              "username":null,
            };
            await FirebaseFirestore.instance.collection("Users").add(details);
            Navigator.of (context).pushReplacement(
              MaterialPageRoute (
                builder: (BuildContext context) => LoginPage(),
              ),
            );
          }
          else{
           setState(() {
             inProgress =false;
           });
          }

        },
        child: Container(
            margin: EdgeInsets.only(left: 5.3,right: 5.3,),
            child: Text("Save & Continue",style: TextStyle(color: Colors.white,fontFamily: "Poppins-Medium"),)),
      ),
    );
  }

  validate(String password) {
    bool passValid = RegExp("^(?=.*[a-z])(?=.*[0-9])(?=.{8,})") //(/^[A-Z]*$/
        .hasMatch(password);

    if (passValid) {
      return true;
    } else {
      return false;
    }
  }
  validatePhone(String phone) {
    bool passValid = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(phone);

    if (passValid) {
      return true;
    } else {
      return false;
    }
  }
}
