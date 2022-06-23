
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
                "Invest Amount Transaction",
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
                   get_allinvestments(requestinvestments)
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
                  "₹ " + investAmount!.get("InvestAmount").toString(),
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

  get_allinvestments(requestinvestments) {
    return StreamBuilder<QuerySnapshot>(
      stream: requestinvestments,
      builder: (context, snap) {
        if (snap.hasData) {
          var userinvestments = snap.data;
          List dates  = get_dates(userinvestments);
          List invests = get_data(userinvestments,dates);
          print(invests);
          return Container(
              margin: EdgeInsets.only(left: 12.3,right: 5.3),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                physics: ScrollPhysics(),
                  itemCount: invests.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(invests[index][0]),
                        Text("+ "+ invests[index][1])
                      ],
                    ),
                  );
              }),
            );

        }
        return Container();
      },
    );
  }

  get_data(QuerySnapshot<Object?>? userinvestments, List dates) {
    List investments =[];

    DateFormat format = DateFormat("yyyy-MM-dd");
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

  get_dates(QuerySnapshot<Object?>? userinvestments) {
    List dates =[];
    List listofdates=[];
    for(int i =0;i<userinvestments!.docs.length;i++){
      if(userinvestments.docs[i].get("phonenumber")== phoneNumber){
        if(userinvestments.docs[i].get("status")=="Accept"){
          var createdAt = userinvestments.docs[i].get("CreatedAt");
          var date = DateTime.fromMicrosecondsSinceEpoch(createdAt.microsecondsSinceEpoch);
          dates.add(date.toString());
        }
      }
    }
    for(int i =0;i<dates.length;i++){
      String single = dates[i];
      listofdates.add(single.toString());
    }
    for(int i =0;i<listofdates.length;i++){
      listofdates.sort((a, b) {
        return a.compareTo(b);
      },);
    }
    return listofdates;
  }



}
