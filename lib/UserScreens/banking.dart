import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growmax/Forms/edit_bankdetails.dart';
 class Banking extends StatefulWidget {
   String?phoneNumber;
    Banking({this.phoneNumber});
   @override
   _BankingState createState() => _BankingState(phoneNumber:this.phoneNumber);
 }

 class _BankingState extends State<Banking> {
   String?phoneNumber;
   _BankingState({this.phoneNumber});
   @override
   Widget build(BuildContext context) {
     var bank_details = FirebaseFirestore.instance.collection("bank_details").doc(widget.phoneNumber).get();
     var id;
     return Column(
       children: [
         SizedBox(height: 30,),
         Container(margin: EdgeInsets.all(16.3),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children:  [
             Container(
                 child: const Text("Banking Details",style: TextStyle(color: Colors.teal,fontSize: 15),),
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 6.3),
             ),
             const Divider(color: Colors.grey,thickness: 0.6),
             const SizedBox(height: 10,),
             FutureBuilder<DocumentSnapshot>(
                 future: bank_details,
                 builder:(context,snapshot){
                 if(snapshot.hasData&&snapshot.requireData.exists){
                   var details = snapshot.data;
                    id = snapshot.data!.id;
                   return details!.get("status")=="Accept"?Container(
                     child: ListView(
                       shrinkWrap: true,
                       children: [
                         Container(
                           child:Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children:  [
                               Text("Account Number :- "),
                               Text(details.get("accountnumber"))
                             ],
                           ),
                         ),
                         SizedBox(height: 15,),
                         Container(
                           child:Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children:  [
                               Text("Ifsc :- "),
                               Text(details.get("ifsc")),
                             ],
                           ),
                         ),
                         SizedBox(height: 15,),

                         Container(
                           child:Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children:  [
                               Text("Pan Number :- "),
                               Text(details.get("pannumber")),
                             ],
                           ),
                         ),
                         SizedBox(height: 15,),
                         Center(
                           child: TextButton(
                               style: TextButton.styleFrom(
                                   minimumSize: const Size(120, 20),
                                   backgroundColor: Colors.limeAccent,
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.3))
                               ),
                               onPressed: (){
                                 Navigator.push (
                                   context,
                                   MaterialPageRoute (
                                     builder: (BuildContext context) => edit_details(id: id,Accountnumber:details.get("accountnumber"),ifsc:details.get("ifsc")),
                                   ),
                                 );
                               }, child: const Text("Edit",style: TextStyle(color: Colors.black87,fontSize: 15,fontWeight: FontWeight.w600),)),
                         )
                       ],
                     ),
                   ):Container();
                 }
                 return CircularProgressIndicator();
             }),
             const SizedBox(
               height: 20,
             ),
          
           ],
         ),
         )
       ],
     );
   }
 }
