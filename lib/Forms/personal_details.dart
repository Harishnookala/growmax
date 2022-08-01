import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:growmax/repositories/authentication.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Address.dart';

class personal_details extends StatefulWidget {
  const personal_details({Key? key}) : super(key: key);

  @override
  _personal_detailsState createState() => _personal_detailsState();
}

class _personal_detailsState extends State<personal_details> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameContoller =TextEditingController();

  bool? error = true;
  List gender = ['Male','Female'];
   List martialStatus = ["Married","Unmarried"];
   String? selected_value;
   String?date;
   String? status;
  DateTime? pickupDate;
  Authentication authentication = Authentication();
  bool login_success = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Container(
          margin: const EdgeInsets.all(12.3),
             child: Form(
               key: formKey,
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                    Container(
                        margin: EdgeInsets.all(5.3),
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: 6.3, ),
                            child: const Text(
                              "Personal Details",
                              style: TextStyle(
                                  letterSpacing: 0.6,
                                  color: Colors.indigoAccent,
                                  fontFamily: "Poppins-Light",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ))),
                    Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 12.3),
                        scrollDirection: Axis.vertical,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16.3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: const Text(
                                    "First Name : -",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 15,
                                        letterSpacing: 0.8,
                                        fontFamily: "Poppins-Light"),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.5),
                                ),
                                build_name(),
                                SizedBox(height: 5,),
                                Container(
                                  child: const Text(
                                    "Last Name : -",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 15,
                                        letterSpacing: 0.6,
                                        fontFamily: "Poppins-Medium"),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.5),
                                ),
                                build_Lastname(),
                                SizedBox(height: 5,),
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
                                build_mobile(),
                                SizedBox(height: 5,),
                                Container(
                                  child: const Text(
                                    "Gender : -",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 15,
                                        letterSpacing: 0.6,
                                        fontFamily: "Poppins-Medium"),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.5,top: 4.6),
                                ),
                                buildGender(),
                                Container(
                                  child: const Text(
                                    "Date of Birth : -",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 15,
                                        letterSpacing: 0.6,
                                        fontFamily: "Poppins-Medium"),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.5,top: 5.6),
                                ),
                                build_dateofbirth(),
                                Container(
                                  child: const Text(
                                    "Martial Status : -",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 15,
                                        letterSpacing: 0.6,
                                        fontFamily: "Poppins-Medium"),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.5,top: 5.6),
                                ),
                                build_martialstatus(),
                                SizedBox(height: 20,),
                                error==true?Container():Center(
                                  child: Text("User is already registered",
                                    style: TextStyle(color: Colors.red,fontFamily: "Poppins"),),
                                ),
                                SizedBox(height: 5,),
                                build_button(),

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
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(fontFamily: "Poppins-Light",),
        validator: (name){
          if(name==null||name.isEmpty){
            return "please enter name";
          }
          return null;
        },
        controller: nameController,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "First Name",
            labelText: "First Name",
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

  build_Lastname() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(fontFamily: "Poppins-Light",),
        validator: (lastname){
          if(lastname==null||lastname.isEmpty){
            return "please enter name";
          }
          return null;
        },
        controller: lastNameContoller,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "Last Name",
            labelText: "Last Name",
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
  build_mobile() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
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
      ),
    );
  }

  buildGender() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Row(
              children:  [
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'Select Gender',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: gender
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style:  TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            style: TextStyle(color: Colors.black54,fontFamily: "Poppins-Medium",fontWeight: FontWeight.w900),
            value: selected_value,
            onChanged: (value) {
              setState(() {
                selected_value = value as String;
              });
            },
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            iconSize: 25,
            iconEnabledColor: Color(0xcc9fce4c),
            buttonHeight: 80,
            buttonWidth: 160,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                width: 1.8,
                color: Color(0xcc9fce4c),
              ),
              color: Colors.white),
            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,
            dropdownWidth: 250,
            dropdownPadding: null,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            offset: const Offset(20, 0),
          ),
        ),
      ),


    );
  }

  build_dateofbirth() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: Container(
        decoration:  BoxDecoration(border: Border.all(color: Color(0xcc9fce4c)),borderRadius: BorderRadius.circular(4.3)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
         date==null?  Container(
           margin: EdgeInsets.only(left: 16.3),
           alignment: Alignment.center,
           child: Text("Select Date",style: TextStyle(color: Colors.brown,
               fontSize:14,fontFamily: "Poppins-Light"),),):
           Container(
               margin: EdgeInsets.only(left: 16.3),
               child: Text(date!,style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: "Poppins-Light"),)),
          Container(
            margin: EdgeInsets.only(right: 16.3),
            alignment: Alignment.centerRight,
            child: InkWell(
              child: Icon(Icons.date_range_outlined,color: Colors.blue),
              onTap: ()async{
                  pickupDate = await showDatePicker(context: context,
                    initialDate:
                    DateTime.now(),
                    firstDate:
                    DateTime(1890),
                    lastDate:
                    DateTime.now(),);
                   setState(() {
                      date = DateFormat('dd / MMM / yyy').format(pickupDate!);

                   });
                  },
            ),
          ),

        ],
      ),
      ),
    );
  }

  build_martialstatus() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children:  const [
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'Select status',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: martialStatus
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style:  TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ))
              .toList(),
          style: TextStyle(color: Colors.black54,fontFamily: "Poppins-Medium",fontWeight: FontWeight.w900),
          value: status,
          onChanged: (value) {
            setState(() {
              status = value as String;
            });
          },
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          iconSize: 25,
          iconEnabledColor: Color(0xcc9fce4c),
          buttonHeight: 80,
          buttonWidth: 160,
          buttonPadding: const EdgeInsets.only(left: 14, right: 14),
          buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                width: 1.8,
                color: Color(0xcc9fce4c),
              ),
              color: Colors.white),
          itemHeight: 40,
          itemPadding: const EdgeInsets.only(left: 14, right: 14),
          dropdownMaxHeight: 200,
          dropdownWidth: 250,
          dropdownPadding: null,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          dropdownElevation: 8,
          scrollbarRadius: const Radius.circular(40),
          scrollbarThickness: 6,
          scrollbarAlwaysShow: true,
          offset: const Offset(20, 0),
        ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.6)),
        ),
        onPressed: () async {
          var user  = await get_data(mobileController.text);
             if(formKey.currentState!.validate()&&date!=null&&selected_value!=null&&status!=null){
              setState(() {
                if(user==null){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        Address(firstname:nameController.text,
                          lastname:lastNameContoller.text,
                          gender: selected_value,
                          birth_date:date,
                          phonenumber:mobileController.text,
                          married_status:status,
                        )),
                  );
                }
                else{
                  error = false;
                }
              });
             }
           },
        child: Container(
          width: 160,
           height: 25,
           alignment: Alignment.center,
           margin: EdgeInsets.only(left: 5.3,right: 5.3),
            child: Text("Continue",
              style: TextStyle(fontSize:16,color: Colors.white,
                  fontFamily: "Poppins-Medium"),)),
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

  get_data(String mobilenumber) async{
    var Users = await FirebaseFirestore.instance.collection("Users").get();
    for(int i =0;i<Users.docs.length;i++){
      if(mobilenumber == Users.docs[i].get("mobilenumber")){
        return mobilenumber;
      }
    }
    return null;
  }
}

