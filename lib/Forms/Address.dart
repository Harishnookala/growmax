import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Login.dart';
import '../UserScreens/userPannel.dart';
class Address extends StatefulWidget {
  String? firstname;
  String? lastname;
  String? gender;
  String? birth_date;
      String? married_status;
  String ?fathername;
      String ?mothername;
      var image;
   Address({Key? key, this.firstname,this.fathername,this.lastname,this.gender,this.birth_date,this.married_status,this.mothername,this.image }) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();

  bool securedValue = true;
  bool isChecked = false;
  Icon fab = const Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
  bool login_success = false;
 var image;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: EdgeInsets.all(12.3),
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                  Container(
                    margin: EdgeInsets.only(left: 14.3,top: 5.3,bottom: 5.3),
                    alignment: Alignment.topLeft,
                    child: Text("Address & Communication",style: TextStyle(letterSpacing: 0.6,
                        color: Colors.indigoAccent,
                        fontFamily: "Poppins-Light",
                        fontWeight: FontWeight.w500,
                        fontSize: 16),),
                  ),
                  Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 16.3,top: 12.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: const Text(
                            "Mobile number : -",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                                fontSize: 15,
                                letterSpacing: 0.6,
                                fontFamily: "Poppins-Light"),
                          ),
                          margin: EdgeInsets.only(bottom: 8.5),
                        ),
                        build_mobile(),
                        SizedBox(height: 5,),
                        Container(
                          child: const Text(
                            "Email : -",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                                fontSize: 15,
                                letterSpacing: 0.6,
                                fontFamily: "Poppins-Light"),
                          ),
                          margin: EdgeInsets.only(bottom: 8.5),
                        ),
                        build_email(),
                        SizedBox(height: 5,),
                        Container(
                          child: const Text(
                            "Address : -",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                                fontSize: 15,
                                letterSpacing: 0.6,
                                fontFamily: "Poppins-Light"),
                          ),
                          margin: EdgeInsets.only(bottom: 8.5),
                        ),
                        build_address(),
                        SizedBox(height: 15,),
                        Container(
                          child: const Text(
                            "Password : -",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                                fontSize: 15,
                                letterSpacing: 0.6,
                                fontFamily: "Poppins-Light"),
                          ),
                          margin: EdgeInsets.only(bottom: 8.5),
                        ),
                        build_password(),
                        SizedBox(height: 10,),
                        Container(
                          child: const Text(
                            "ReEnterPassword : -",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                                fontSize: 15,
                                letterSpacing: 0.6,
                                fontFamily: "Poppins-Light"),
                          ),
                          margin: EdgeInsets.only(bottom: 8.5),
                        ),
                        buildRenterPassword(),
                        build_button(),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  build_mobile() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
          ),
          hintText: "Mobile",
          labelText: "Mobile number",
          labelStyle: const TextStyle(color: Color(0xff576630)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
          ),
          hintStyle: const TextStyle(color: Colors.brown)),
      controller:mobileController,
      cursorColor: Colors.orange,
      style: const TextStyle(color: Colors.deepPurpleAccent),
      validator: (phone) {
        bool validate = validatePhone(phone!);
        if (phone.isEmpty) {
          return 'Please enter phone';
        } else if (!validate) {
          return "Enter a valid phone number";
        }  else if (phone.length != 10) {
          return "Enter 10 numbers";
        }
        return null;
      },
    );

  }

  build_email() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        style: TextStyle(fontFamily: "Poppins-Light",),
        controller: emailController,
        decoration: InputDecoration(
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
        minLines: 1,
        maxLines: 15,
        keyboardType: TextInputType.multiline,
        style: TextStyle(fontFamily: "Poppins-Light"),
        controller: addressController,
        decoration: InputDecoration(
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

  build_password() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: Container(
        child: TextFormField(
          style: TextStyle(fontFamily: "Poppins-Light",),
          controller: passwordController,
          decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
              ),
              hintText: "Password",
              labelText: "Password",
              labelStyle: const TextStyle(color: Color(0xff576630)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.5),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
              ),
              hintStyle: const TextStyle(color: Colors.brown)),
        ),

      ),
    );
  }

  buildRenterPassword() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
        child: TextFormField(
          style: TextStyle(fontFamily: "Poppins-Light",),
          controller: reEnterPasswordController,
          decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
              ),
              hintText: "Renter Password",
              labelText: "Reenter Password",
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
  passwordField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.9),
      child: SizedBox(
          child: Stack(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: securedValue,
                decoration: InputDecoration(
                    hintText: "Enter minimum 8 characters",
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.brown)),
                controller: passwordController,
                cursorColor: Colors.blue,
                style: const TextStyle(color: Colors.deepPurpleAccent),
                validator: (password) {
                  login_success = validate(passwordController.text);
                  if (password!.isEmpty) {
                    return 'Please enter Password';
                  } else if (password.length < 8) {
                    return "Please enter minimum of 8 characters";
                  } else if (!login_success) {
                    return "Atleast one alphabet and one number of 8 characters";
                  }

                  return null;
                },
              ),
              Positioned(
                  right: 15,
                  top: 3,
                  child: TextButton(
                    child: fab,
                    onPressed: () {
                      setState(() {
                        if (securedValue && passwordController.text.isNotEmpty) {
                          securedValue = false;
                          fab = const Icon(
                            Icons.visibility,
                            color: Colors.grey,
                          );
                        } else {
                          fab = const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          );
                          securedValue = true;
                        }
                      });
                    },
                  )),
            ],
          )),
    );
  }

  confirmPasswordField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.9),
      child: SizedBox(
          child: Stack(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Enter minimum 8 characters",
                    labelText: "Confirm Password",
                    labelStyle: const TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.brown)),
                controller: reEnterPasswordController,
                cursorColor: Colors.blue,
                style: const TextStyle(color: Colors.deepPurpleAccent),
                validator: (password) {
                  login_success = validate(passwordController.text);
                  if (password!.isEmpty) {
                    return 'Please enter Password';
                  } else if (password.length < 8) {
                    return "Please enter minimum of 8 characters";
                  } else if (passwordController.text != reEnterPasswordController.text) {
                    return "Passwords does not match";
                  } else if (!login_success) {
                    return "Atleast one alphabet and one number of 8 characters";
                  }

                  return null;
                },
              ),
            ],
          )),
    );
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
          image = await widget.image;

          Map<String,dynamic> details ={
            "firstname":widget.firstname,
            "lastname":widget.lastname,
            "gender":widget.gender,
            "dateofbirth":widget.birth_date,
            "status":widget.married_status,
            "fathername":widget.fathername,
            "mothername":widget.mothername,
            "mobilenumber":mobileController.text,
            "email":emailController.text,
            "address":addressController.text,
            "password":passwordController.text,
            "image":image
          };
          await FirebaseFirestore.instance.collection("Users").doc(mobileController.text).set(details);
          Navigator.push (
            context,
            MaterialPageRoute (
              builder: (BuildContext context) => LoginPage(),
            ),
          );
        },
        child: Container(
            margin: EdgeInsets.only(left: 5.3,right: 5.3,),
            child: Text("Save & Continue",style: TextStyle(color: Colors.white,fontFamily: "Poppins-Medium"),)),
      ),
    );
  }

  validate(String password) {
    bool passValid = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})")
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
