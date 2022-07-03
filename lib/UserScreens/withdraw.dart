import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final formKey = GlobalKey<FormState>();
   bool inprogress = false;
  _withdrawState({this.phonenumber});
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot<Object?>?amount;
    var balance = FirebaseFirestore.instance
        .collection("Investments")
        .doc(phonenumber)
        .get();
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
                           amount!.get("InvestAmount");
                          print(amount.toString());
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
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16.3, bottom: 5.3),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Withdrawl Amount",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                   Form(
                    key: formKey,
                     child: Column(
                       children: [
                         SizedBox(
                           height: 70,
                           width: 300,
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
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             TextButton(
                               style: TextButton.styleFrom(
                                   minimumSize: const Size(140, 40),
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.8)),
                                   backgroundColor: Colors.deepOrange.shade400),
                               onPressed: () async {
                                 setState(() {
                                   var investamount = double.parse(amount!.get("InvestAmount"));
                                   var debit = double.parse(debitController.text);
                                   if(investamount>=debit){
                                     pressed = true;
                                     inprogress =true;
                                   }
                                   else if(investamount<debit){
                                     pressed =false;
                                     inprogress =false;
                                   }

                                 });

                                 if(formKey.currentState!.validate()&&pressed){
                                   Map<String, dynamic> data = {
                                     "phonenumber": phonenumber,
                                     "InvestAmount": debitController.text.toString(),
                                     "CreatedAt": DateTime.now(),
                                     "status": "pending",
                                     "Type" : "Debit",
                                   };
                                   await FirebaseFirestore.instance.collection("requestwithdrawls").add(data);
                                   Navigator.of(context).pushReplacement(MaterialPageRoute(
                                       builder: (BuildContext context) =>
                                           userPannel(phoneNumber: widget.phonenumber,)));
                                 }

                               },

                               child:  const Text(
                                 "Withdraw",
                                 style: TextStyle(color: Colors.white),
                               ),
                             ),
                             inprogress?const Padding(
                                 padding: EdgeInsets.only(left: 10),
                                 child: CircularProgressIndicator())
                                 : Container()
                           ],
                         ),
                       ],
                     ),
                   ),
                    pressed==false?Text("Available amount is greater than Debit Amount",style: TextStyle(color: Colors.red),):Text("")
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
