import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growmax/UserScreens/userPannel.dart';

class payments extends StatefulWidget{
  String?phonenumber;
  String?username;
  var image;
 payments({this.phonenumber,this.username,this.image});
  @override
  paymentsstate createState() => paymentsstate();

}
class paymentsstate extends State<payments>{
  bool inprogress = false;
  bool pressed = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController creditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body:   Column(
          children: [
            SizedBox(height: 60,),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Invest Amount",
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ),
                  SizedBox(
                    width:MediaQuery.of(context).size.width/1.3,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 5.8, left: 6.3, bottom: 14.3),
                      child: TextFormField(
                        validator: (amount) {
                          if (amount!.isEmpty||!amount.isNum) {
                            return 'Please enter Amount';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
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
                            if(amount>=10.00){
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
            ),
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
    var image = await widget.image;

    Map<String, dynamic> data = {
      "phonenumber": widget.phonenumber,
      "InvestAmount": creditController.text.toString(),
      "CreatedAt": DateTime.now(),
      "status": "pending",
      "Type":  "Credit",
      "username":widget.username,
      "image":image
    };
         var value = await FirebaseFirestore.instance.collection("requestInvestments").add(data);
         print(value.id);
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
