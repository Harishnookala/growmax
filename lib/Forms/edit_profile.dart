import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:growmax/Login.dart';
import 'package:growmax/UserScreens/Investment.dart';
import 'package:growmax/UserScreens/profile.dart';
import 'package:growmax/UserScreens/userPannel.dart';
import 'package:growmax/repositories/authentication.dart';
class edit_profile extends StatefulWidget {
  String? id;
  String?mobilenumber;
  String?email;
  String?status;
  String?address;
  String?username;
   edit_profile({Key? key,this.id,this.mobilenumber,
     this.email,this.status,this.address,
     this.username
   }) : super(key: key);

  @override
  State<edit_profile> createState() => _edit_profileState(status:this.status);
}

class _edit_profileState extends State<edit_profile> {
  TextEditingController? mobileController;
  TextEditingController? emailController;
  TextEditingController? addressController;
  String? Selecteditem;
  var unSelecteditem;
  Authentication authentication = Authentication();
 String?status;
  List statusofmarriage = ["Married","Unmarried"];
  _edit_profileState({this.status});
  @override
  void initState() {
    mobileController = TextEditingController();
    mobileController!.text = widget.mobilenumber!;
    emailController = TextEditingController();
    emailController!.text = widget.email.toString();
    addressController = TextEditingController();
    addressController!.text = widget.address.toString();
    Selecteditem = status;
    BackButtonInterceptor.add(myInterceptor);

    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    mobileController!.dispose();
    emailController!.dispose();
    addressController!.dispose();
    BackButtonInterceptor.remove(myInterceptor);

    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }
  bool inprogress = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
             Container(
               margin: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
               child: Column(
                 children: [
                   SizedBox(height: 20),
                   Container(
                     alignment: Alignment.topLeft,
                     child: Row(
                       children: [
                         Container(
                           child: IconButton(onPressed: (){
                             Navigator.pop(context);
                           }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.deepOrangeAccent,size: 22,)),
                         ),
                         Container(
                           child: Text("Back",style: TextStyle(color: Colors.deepOrangeAccent,
                             fontFamily: "Poppins-Medium",
                             fontWeight: FontWeight.w900
                           ),),)
                       ],
                     ),
                   ),
                   Container(
                     alignment: Alignment.topLeft,
                     child: const Text("Edit Profile Details",style: TextStyle(color: Colors.green,
                         fontWeight: FontWeight.w500,
                         fontSize: 16
                     ),),
                   ),
                   Divider(color: Colors.grey,thickness: 0.6,),
                   const SizedBox(height: 10,),
                   Form(
                    key:formKey ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.5),
                          child: const Text(
                            "Mobile number : -",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                                fontSize: 15,
                                letterSpacing: 0.6,
                                fontFamily: "Poppins-Light"),
                          ),
                        ),
                        build_mobilenumber(),
                        const SizedBox(height: 20,),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.5),
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
                        SizedBox(height: 20,),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.5),
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
                            "Martial Status  : -",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                                fontSize: 15,
                                letterSpacing: 0.6,
                                fontFamily: "Poppins-Light"),
                          ),
                        ),
                        build_status(status),
                        SizedBox(height: 15,),
                        build_buttons()
                      ],
                    ),
            ),
                 ],
               ),
             )
          ],
        ),
      ),
    );
  }

  build_mobilenumber() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0,
              horizontal: 10.0),
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
        }  else if (phone.length!= 10) {
          return "Enter 10 numbers";
        }
        return null;
      },
    );
  }



  build_email() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding:  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
      controller:emailController,
      cursorColor: Colors.orange,
      style: const TextStyle(color: Colors.deepPurpleAccent),
      validator: (email){
        if(email==null||email.isEmpty){
          return "please enter Email";
        }
        else if(!EmailValidator.validate(emailController!.text)&&email.isNotEmpty){
          return "Please enter valid Email Address";
        }
        return null;
      },
    );
  }




  build_address() {
    return TextFormField(
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
    );
  }

  build_status(String? status) {
    unSelecteditem = status;
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white, fontFamily: "Poppins-Light"),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade700, width: 1.5),
        ),
        contentPadding: EdgeInsets.zero,
      ),
      hint: Text(
        Selecteditem!,
        style: const TextStyle(fontFamily: "Poppins-Light", color: Colors.black),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      iconSize: 20,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      items: statusofmarriage.map((item) =>
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            onTap: () {
              setState(() {
                Selecteditem = item;
              });
              Selecteditem = item;
            },
          )).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select category.';
        }
      },
      onChanged: (value) {
        setState(() {

        });
      },
      onSaved: (value) {
        Selecteditem = Selecteditem;
        value = Selecteditem;
      },
    );
  }

  build_buttons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size(140, 40),
              backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.3)),
              padding: EdgeInsets.zero
            ),
            onPressed: () async{
              var value = await authentication.bank_inf(widget.mobilenumber);
              var id = value!.id;
              var investments = await authentication.investments(widget.mobilenumber);

                  if(widget.mobilenumber!=mobileController!.text){
                    setState((){
                        inprogress =true;
                    });

                     Map<String,dynamic> data ={
                       "mobilenumber":mobileController!.text,
                       "email" :emailController!.text,
                       "address":addressController!.text,
                       "status":Selecteditem,
                     };
                     Map<String,dynamic> updatephone ={
                       "phonenumber":mobileController!.text,
                     };
                    await FirebaseFirestore.instance.collection("Users").doc(widget.id).update(data);
                     await FirebaseFirestore.instance.collection("bank_details").doc(id).update(updatephone);
                     if(investments!=null){
                        await FirebaseFirestore.instance.collection("Investments").doc(widget.username).update(updatephone);
                     }

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Profile(phoneNumber: widget.mobilenumber,id: widget.id,)));
                  }
                  else{
                    setState((){
                      inprogress =true;
                    });

                    Map<String,dynamic> data ={
                      "email" :emailController!.text,
                      "address":addressController!.text,
                      "status":Selecteditem,
                    };
                   await FirebaseFirestore.instance.collection("Users").doc(widget.id).update(data);
                   Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            userPannel(phonenumber: widget.mobilenumber,pressed: true,)));
                  }
            },
             child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 16),),
          ),
          inprogress?const Padding(
              padding: EdgeInsets.only(left: 15),
              child: CircularProgressIndicator())
              : Container()
        ],
      ),
    );
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
