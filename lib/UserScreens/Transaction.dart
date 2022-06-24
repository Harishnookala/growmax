

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  String?phoneNumber;
   Transaction({Key? key,this.phoneNumber}) : super(key: key);

  @override
  _TransactionState createState() => _TransactionState(phoneNumber:this.phoneNumber);
}

class _TransactionState extends State<Transaction> {
  String?phoneNumber;
  _TransactionState({this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    var investments = FirebaseFirestore.instance
        .collection("Investments")
        .doc(phoneNumber)
        .get();
    var requestinvestments = FirebaseFirestore.instance
        .collection("requestInvestments").snapshots();
    var requestWithdrawls = FirebaseFirestore.instance
        .collection("requestwithdrawls").snapshots();
    var investAmount;
    return Container(
      margin: EdgeInsets.all(16.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 5.3),
              child: const Text(
                "Transactions",
                style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6),
              )),
           Divider(
            thickness: 0.6,
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.only(left: 12.3),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6.3),
                      alignment: Alignment.center,
                      child: Text("Available Amount",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500),)),
                  SizedBox(height: 5,),
                  Container(
                    alignment: Alignment.center,
                    child: get_invests(investments, investAmount),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12.3),
            child: Column(
              children: [
                Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Date"),
                    Text("Transactions"),
                  ],
                ),
                Divider(color: Colors.black,),
                   get_allinvestments(requestinvestments,requestWithdrawls)
                  ],
                ),

          ),
        ],
      ),
    );
  }
  get_invests(invest, investAmount) {
    return FutureBuilder<DocumentSnapshot>(
      future: invest,
      builder: (context, snap) {
        if (snap.hasData && snap.requireData.exists) {
          investAmount = snap.data;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "₹ ${investAmount!.get("InvestAmount")}",
                  style: TextStyle(color: Colors.green, fontWeight:FontWeight.w900,fontSize: 15,fontFamily: "Poppins-Medium")),
            ],
          );
        }
        else{
          return Container(child: Text("₹ "+"0.00"),);
        }
        return Container();
      },
    );
  }

  get_allinvestments(requestinvestments,requestwithdrawls) {
    return StreamBuilder<QuerySnapshot>(
      stream: requestinvestments,
      builder: (context, snap) {
        if (snap.hasData) {
          List<QueryDocumentSnapshot> userinvestments = snap.data!.docs;
         return StreamBuilder<QuerySnapshot>(
              stream: requestwithdrawls,
           builder: (context,snapshot){
                if(snapshot.hasData){
                  List transaction =[];
                  List<QueryDocumentSnapshot>  userwithdrawls = snapshot.data!.docs;
                  userinvestments.addAll(userwithdrawls);
                  var data = get_check(userinvestments);
                   return  Container(
                     child: ListView.builder(
                       itemCount: data.length,
                         padding: EdgeInsets.zero,
                         shrinkWrap: true,
                         itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.only(bottom: 12.3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  child: Text(data[index][0],style: TextStyle(),)),
                              Container(
                                  child: Text(data[index][1],style: TextStyle(fontSize: 15),))
                            ],
                          ),
                        );
                     }),
                   );
                }return CircularProgressIndicator();
           },
         );

        }
        return CircularProgressIndicator();
      },
    );
  }

  get_dates(QuerySnapshot<Object?>? userinvestments) {
    List dates =[];
    for(int i =0;i<userinvestments!.docs.length;i++){
      if(userinvestments.docs[i].get("phonenumber")== phoneNumber){
        if(userinvestments.docs[i].get("status")=="Accept"){
          var createdAt = userinvestments.docs[i].get("CreatedAt");
          var date = DateTime.fromMicrosecondsSinceEpoch(createdAt.microsecondsSinceEpoch);
          dates.add(date.toString());
        }
      }
    }
    return dates;
  }

  List? get_sort(List investDates) {
    for(int i =0;i<investDates.length;i++){
      investDates.sort((a, b) {
        return a.compareTo(b);
      },);
    }
    return investDates;
  }

  get_check(List<QueryDocumentSnapshot<Object?>> userinvestments) {
    List investments =[];
    List dates =[];
    var symbol;
    for(int i =0;i<userinvestments.length;i++){
      if(userinvestments[i].get("status")=="Accept"&&userinvestments[i].get("phonenumber")==phoneNumber) {
        var date = DateTime.fromMicrosecondsSinceEpoch(userinvestments[i]
            .get("CreatedAt")
            .microsecondsSinceEpoch);
       dates.add(date);
      }
      }
    for(int i =0;i<dates.length;i++){
      dates.sort((a, b) {
        return a.compareTo(b);
      },);
    }

    for(int i =0;i<userinvestments.length;i++){
      var createdAt = userinvestments[i].get("CreatedAt");
      var date = DateTime.fromMicrosecondsSinceEpoch(createdAt.microsecondsSinceEpoch);
      for(int j =0;j<dates.length;j++){
        if(userinvestments[i].get("phonenumber")== phoneNumber&&dates[j].toString()==date.toString()){
          DateTime dateTime = userinvestments[i].get("CreatedAt").toDate();
          var datetime = DateFormat('dd/MM/yyyy').format(dateTime);
          if(userinvestments[i].get("Type")=="Credit"){
            symbol ="+";
          }
          if(userinvestments[i].get("Type")=="Debit"){
            symbol ="-";
          }
          investments.add([datetime,"$symbol "+ userinvestments[i].get("InvestAmount")]);

        }
      }
    }
    return investments;
  }



  get_data(QuerySnapshot<Object?>? userinvestments, List dates) {
    List investments =[];

    for(int i =0;i<userinvestments!.docs.length;i++){
      var createdAt = userinvestments.docs[i].get("CreatedAt");
      var date = DateTime.fromMicrosecondsSinceEpoch(createdAt.microsecondsSinceEpoch);

      if(userinvestments.docs[i].get("status")=="Accept"){
        for(int j=0;j<dates.length;j++){
          if(userinvestments.docs[i].get("phonenumber")== phoneNumber&&dates[j].toString()==date.toString()){
            DateTime dateTime = userinvestments.docs[i].get("CreatedAt").toDate();
            var datetime = DateFormat('dd/MM/yyyy').format(dateTime);
            investments.add([datetime,userinvestments.docs[i].get("InvestAmount")]);
          }
        }
      }
    }

    return investments;
  }

}


