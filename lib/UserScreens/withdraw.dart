import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growmax/UserScreens/userPannel.dart';

class withdraw extends StatefulWidget {
  String? phonenumber;
  withdraw({Key? key, this.phonenumber}) : super(key: key);

  @override
  _withdrawState createState() => _withdrawState(phonenumber: this.phonenumber);
}

class _withdrawState extends State<withdraw> {
  TextEditingController debitController = TextEditingController();
  String? phonenumber;
  int? Investments;

  bool pressed = true;
  _withdrawState({this.phonenumber});
  @override
  Widget build(BuildContext context) {
    var balance = FirebaseFirestore.instance
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
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16.3, bottom: 5.3),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Withdrawl Amount",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 300,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 5.8, left: 6.3, bottom: 12.3),
                        child: TextFormField(
                          validator: (amount) {
                            if (amount!.isEmpty) {
                              return 'Please enter Amount';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
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
                          controller: debitController,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size(80, 30),
                          backgroundColor: Colors.deepOrange),
                      onPressed: () async {
                        setState(() {
                          var investamount = double.parse(amount!.get("InvestAmount"));
                          var debit = double.parse(debitController.text);
                          if(investamount>=debit){
                            pressed = true;
                          }

                        });
                          if(pressed){
                            Map<String, dynamic> data = {
                              "phonenumber": phonenumber,
                              "InvestAmount": debitController.text.toString(),
                              "CreatedAt": DateTime.now(),
                              "status": "pending",
                              "Type" : "Debit",
                            };
                            await FirebaseFirestore.instance.collection("requestwithdrawls").add(data);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => userPannel(
                                    phoneNumber: phonenumber,
                                  )),
                            );
                          }

                        },

                      child:  Text(
                        "Withdraw",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                  ],
                )),
          ],
        ),
      ),
    );
  }

  bool ?get_data(double investamount, double debit) {
    if(investamount>=debit){
      return true;
    }
    else{
      return false;
    }
  }
}
