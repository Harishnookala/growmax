import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growmax/UserScreens/userPannel.dart';

class Investment extends StatefulWidget {
  String? phonenumber;
  Investment({Key? key, this.phonenumber}) : super(key: key);

  @override
  InvestmentState createState() => InvestmentState(phonenumber: this.phonenumber);
}

class InvestmentState extends State<Investment> {
  TextEditingController creditController = TextEditingController();
  String? phonenumber;
  int? Investments;

  bool pressed = true;
  final formKey = GlobalKey<FormState>();

  InvestmentState({this.phonenumber});
  @override
  Widget build(BuildContext context) {
    var  balance = FirebaseFirestore.instance
        .collection("Investments")
        .doc(phonenumber)
        .get();
    DocumentSnapshot<Object?>?amount;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
                margin: EdgeInsets.all(12.3),
                child: Column(
                  children: [
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
                    FutureBuilder<DocumentSnapshot>(
                      future: balance,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.requireData.exists) {
                          amount = snapshot.data;
                          return Text(
                            amount!.get("InvestAmount"),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontFamily: "Poppins-Medium"),
                          );
                        }
                        else{
                          return Text("₹ 0.00",style: TextStyle(fontFamily: "Poppins-Light",fontSize: 16),);
                        }

                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16.3, bottom: 5.3),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Invest Amount",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                    Form(
                        key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                           width:MediaQuery.of(context).size.width/1.3,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 5.8, left: 6.3, bottom: 12.3),
                              child: TextFormField(
                                validator: (amount) {
                                  if (amount!.isEmpty||!amount.isNum) {
                                    return 'Please enter Amount';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    prefix: Container(
                                      margin: const EdgeInsets.only(right: 8.3),
                                      child: const Text("₹",
                                          style: TextStyle(fontSize: 15)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent, width: 2.0),
                                    ),
                                    labelText: "Enter Amount",
                                    labelStyle:
                                    const TextStyle(color: Color(0xff576630)),
                                    border: OutlineInputBorder(
                                      gapPadding: 1.3,
                                      borderRadius: BorderRadius.circular(4.5),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xcc9fce4c), width: 1.5),
                                    ),
                                    hintStyle: const TextStyle(color: Colors.brown)),
                                controller: creditController,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                minimumSize: const Size(140, 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.8)),
                                backgroundColor: Colors.deepOrange.shade400),
                            onPressed: () async {
                              if(formKey.currentState!.validate()){
                                get_data();
                              }
                            },

                            child:  Text(
                              "Invest",
                              style: TextStyle(color: Colors.white,fontSize: 15,fontFamily: "Poppins-Medium"),
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                )),
          ],
        ),
      ),
    );
  }


  Future<String?> get_investments() async {
    String? remaing_amount;
    CollectionReference _collectionRef =
    await FirebaseFirestore.instance.collection('savingsAmount');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      remaing_amount = querySnapshot.docs[i].get('SavingAmount');
      return remaing_amount;
    }
  }

  get_data() async {
    Map<String, dynamic> data = {
      "phonenumber": phonenumber,
      "InvestAmount": creditController.text.toString(),
      "CreatedAt": DateTime.now(),
      "status": "pending",
      "Type":  "Credit",
    };
    await FirebaseFirestore.instance.collection("requestInvestments").add(data);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => userPannel(
            phoneNumber: phonenumber,
          )),
    );
  }
}


