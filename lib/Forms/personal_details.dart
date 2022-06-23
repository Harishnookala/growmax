import 'package:growmax/repositories/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameContoller =TextEditingController();
  TextEditingController fatherNameContoller =TextEditingController();
  TextEditingController motherNameContoller =TextEditingController();
 var image;
 File?image_url;
  List gender = ['Male','Female'];
   List martialStatus = ["Married","Unmarried"];
   String? selected_value;
   String?date;
   var profile_image = "profile";
   String? status;
  DateTime? pickupDate;
  bool securedValue = true;
  bool isChecked = false;
  Icon fab = const Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
  final ImagePicker _picker = ImagePicker();
  Authentication authentication = Authentication();
  bool login_success = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Container(
          margin: const EdgeInsets.all(12.3),
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
                              SizedBox(height: 10,),
                              Container(
                                child: const Text(
                                  "Profile picture : -",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.deepOrangeAccent,
                                      letterSpacing: 0.6,
                                      fontSize: 15,
                                      fontFamily: "Poppins-Medium"),
                                ),
                                margin: const EdgeInsets.only(bottom: 8.5),
                              ),
                              SizedBox(height: 20,),
                              Center(child:buildPanPhoto() ,),
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
    );
  }

  build_name() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        style: TextStyle(fontFamily: "Poppins-Light",),
        controller: nameController,
        decoration: InputDecoration(
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
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        style: TextStyle(fontFamily: "Poppins-Light",),
        controller: lastNameContoller,
        decoration: InputDecoration(
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
      height: 48,
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
              child: Icon(Icons.date_range_outlined),
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
                print(status);
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
      ),


    );

  }

  buildFatherName() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        style: TextStyle(fontFamily: "Poppins-Light",),
        controller: fatherNameContoller,
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
  buildMotherName() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width/1.2,
      child: TextFormField(
        style: TextStyle(fontFamily: "Poppins-Light",),
        controller: motherNameContoller,
        decoration: InputDecoration(
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
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                Address(firstname:nameController.text,
                    lastname:lastNameContoller.text,
                    gender: selected_value,
                    birth_date:date,
                    married_status:status,
                    fathername:fatherNameContoller.text,
                    mothername:motherNameContoller.text,
                    image :image,
                )),
          );

          },
        child: Container(
          width: 120,
           alignment: Alignment.center,
           margin: EdgeInsets.only(left: 5.3,right: 5.3),
            child: Text("Continue",style: TextStyle(color: Colors.white,fontFamily: "Poppins-Medium"),)),
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
                style: TextButton.styleFrom(backgroundColor: Colors.purple.shade400),
                onPressed: (){
                  get_permissions();
                },child: Text("Upload Pan",style: TextStyle(color: Colors.white),)),
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
    print(pickedFile!.path);
    if (pickedFile != null) {
      print(nameController.text);
      setState(() {
        image_url = File(pickedFile.path);
        image =  authentication.moveToStorage(image_url, nameController.text,profile_image);
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
        image =  authentication.moveToStorage(image_url, nameController.text,profile_image);
      });
    }
  }
}

