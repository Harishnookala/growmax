import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growmax/UserScreens/userPannel.dart';
import 'package:growmax/repositories/authentication.dart';

class Investment extends StatefulWidget {
  String? id;
  String?phonenumber;
  String?username;
  Investment({Key? key, this.id,this.phonenumber,this.username}) : super(key: key);

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

  String? error ="";
  InvestmentState({this.id});
  Authentication authentication =Authentication();
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot<Object?>?amount;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.all(12.3),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.deepOrangeAccent,size: 19,)),
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
                      future: authentication.get_invests(widget.username) ,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.requireData!.exists) {
                          amount = snapshot.data;
                          return Text("₹ " +
                            amount!.get("InvestAmount"),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontFamily: "Poppins-Medium"),
                          );
                        } else{
                          return Text("₹ 0.0",style: TextStyle(color: Colors.blue,fontSize: 16),);
                        }


                      },
                    ),
                    const SizedBox(
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: const Size(130, 40),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.8)),
                                    backgroundColor: Colors.deepOrange.shade400),
                                onPressed: () async {
                                  setState(() {
                                    var amount = double.parse(creditController.text);
                                    if(amount>=10000.00){
                                      pressed = true;
                                    }
                                    else{
                                      pressed = false;
                                      inprogress = false;
                                    }

                                  });
                                  if(formKey.currentState!.validate()&&pressed){
                                    setState((){
                                      inprogress =true;
                                    });
                                    var data = await get_data();
                                  }

                                },

                                child: const Text(
                                  "Invest",
                                  style: TextStyle(color: Colors.white,fontSize: 15,fontFamily: "Poppins-Medium"),
                                ),
                              ),
                              inprogress?const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: CircularProgressIndicator())
                                  : Container()
                            ],
                          ),
                          SizedBox(height: 10,),
                          pressed==true?const Text(""):Text("Minimum amount of investment is 10,000 ")
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
      "phonenumber": widget.phonenumber,
      "InvestAmount": creditController.text.toString(),
      "CreatedAt": DateTime.now(),
      "status": "pending",
      "Type":  "Credit",
      "username":widget.username,
    };
    int amount = int.parse(creditController.text);
    if(amount>=10000){
      await FirebaseFirestore.instance.collection("requestInvestments").add(data);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => userPannel(
              phonenumber: widget.phonenumber,
              pressed: true,
            )),
      );
    }

  }


}


