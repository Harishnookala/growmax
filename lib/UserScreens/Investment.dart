import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growmax/UserScreens/payments.dart';
import 'package:growmax/UserScreens/userPannel.dart';
import 'package:growmax/repositories/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Investment extends StatefulWidget {
  String? id;
  String? phonenumber;
  String? username;
  Investment({Key? key, this.id, this.phonenumber, this.username})
      : super(key: key);

  @override
  InvestmentState createState() => InvestmentState(id: this.id);
}

class InvestmentState extends State<Investment> {
  TextEditingController creditController = TextEditingController();
  String? id;
  int? Investments;
  bool inprogress = false;
  bool pressed = true;
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? error = "";
  var image_url;
  var image;
  InvestmentState({this.id});
  Authentication authentication = Authentication();
  DocumentSnapshot<Object?>? amount;

  @override
  Widget build(BuildContext context) {
    var upi = FirebaseFirestore.instance.collection("Upi").doc("upi").get();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 10.3),
          shrinkWrap: true,
          children: [
            Container(
                margin: EdgeInsets.all(8.3),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.deepOrangeAccent,
                            size: 19,
                          )),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Center(
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 3.5),
                                  child: const Text(
                                    "Available Amount",
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 14,
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot?>(
                      future: authentication.get_invests(widget.username),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.requireData!.exists) {
                          amount = snapshot.data;
                          return Text(
                            "₹ " + amount!.get("InvestAmount"),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontFamily: "Poppins-Medium"),
                          );
                        } else {
                          return Text(
                            "₹ 0.0",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          );
                        }
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.3, top: 10.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: const Text(
                              "Upi id : - ",
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontFamily: "Poppins-Medium"),
                            ),
                          ),
                          Expanded(
                              child: FutureBuilder<DocumentSnapshot>(
                            future: upi,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var details = snapshot.data;
                                return Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 9.3),
                                      child: Text(
                                        details!.get("upi"),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 15,
                                            fontFamily: "Poppins-Medium"),
                                      ),
                                    ),
                                    Container(
                                      child: InkWell(
                                        child: const Icon(Icons.copy_all,
                                            color: Colors.green, size: 28),
                                        hoverColor: Colors.blueAccent,
                                        highlightColor: Colors.blueAccent,
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: details.get("upi")));
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        child: TextButton(
                            style: TextButton.styleFrom(
                                minimumSize: Size(160, 38),
                                backgroundColor: Colors.deepOrange.shade500,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.3))),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return build_upi();
                                },
                              );
                            },
                            child: Text(
                              "Pay using Upi",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: const Text(
                        "Add payment Screenshot : -",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.deepOrangeAccent,
                            letterSpacing: 0.6,
                            fontSize: 15,
                            fontFamily: "Poppins-Medium"),
                      ),
                      margin: const EdgeInsets.only(bottom: 8.5),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: buildScreenshot(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: Size(160, 30),
                            backgroundColor: Colors.green.shade500,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.5))),
                        onPressed: () {
                          print(image);
                          if (image_url != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => payments(
                                        phonenumber: widget.phonenumber,
                                        username: widget.username,
                                        image: image,
                                      )),
                            );
                          }
                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Poppins-Medium"),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  build_upi() {
    return Container(
        height: 190,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () async {
                      var value = await LaunchApp.isAppInstalled(
                        androidPackageName: 'com.phonepe.app',
                      );
                      if (value) {
                        await LaunchApp.openApp(
                          androidPackageName: 'com.phonepe.app',
                        );
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/Images/phonepe.png",
                          width: 80,
                          height: 35,
                        ),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Phonepe",
                              style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ))
                      ],
                    ))
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 9.3),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        var isAppInstalledResult =
                            await LaunchApp.isAppInstalled(
                          androidPackageName:
                              'com.google.android.apps.nbu.paisa.user',
                        );
                        if (isAppInstalledResult) {
                          await LaunchApp.openApp(
                            androidPackageName:
                                'com.google.android.apps.nbu.paisa.user',
                          );
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/Images/Googlepay.png",
                            width: 80,
                            height: 35,
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Googlepay",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    color: Colors.black,
                                    fontSize: 20),
                              ))
                        ],
                      ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 9.3),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        var appInstalled = await LaunchApp.isAppInstalled(
                          androidPackageName:
                              'in.amazon.mShop.android.shopping',
                        );
                        if (appInstalled) {
                          await LaunchApp.openApp(
                            androidPackageName:
                                'in.amazon.mShop.android.shopping',
                          );
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/Images/pay.png",
                            width: 80,
                            height: 50,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 4.3),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Amazonpay",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins-Medium",
                                    fontSize: 18),
                              ))
                        ],
                      ))
                ],
              ),
            )
          ],
        ));
  }

  buildScreenshot() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image_url != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        child: Row(
                      children: [
                        Image.file(
                          image_url!,
                          width: 180,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 12.3),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        image_url = null;
                                      });
                                    },
                                    icon: Icon(Icons.close_outlined))),
                          ],
                        )
                      ],
                    )),
                  ],
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 15.3),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.purple.shade400),
                      onPressed: () {
                        get_permissions();
                      },
                      child: Text(
                        "Upload Screenshot",
                        style: TextStyle(color: Colors.white),
                      )),
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
        image = authentication.movetoinvestements(image_url, widget.username);
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
        image = authentication.movetoinvestements(image_url, widget.username);
      });
    }
  }
}
