import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  String? phoneNumber;
  Transaction({Key? key, this.phoneNumber}) : super(key: key);

  @override
  _TransactionState createState() =>
      _TransactionState(phoneNumber: this.phoneNumber);
}

class _TransactionState extends State<Transaction> {
  String? phoneNumber;
  DateTime? pickupDate;
  DateTime? pickdate;
  String? startingdate;
  DateTime ?start;
  String ?end;
  DateTimeRange? dateTimeRange;
  DateTime? end_date;
  String? dates;
  bool? pressed = false;

  _TransactionState({this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    var investments = FirebaseFirestore.instance
        .collection("Investments")
        .doc(phoneNumber)
        .get();
    var requestinvestments =
    FirebaseFirestore.instance.collection("requestInvestments").snapshots();
    var requestWithdrawls =
    FirebaseFirestore.instance.collection("requestwithdrawls").snapshots();
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
                      child: Text(
                        "Available Amount",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: get_invests(investments, investAmount),
                  ),
                ],
              ),
            ),
          ),
          Center(

            child: Column(
              children: [

                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.25,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(right: 3.3),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(1.3)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Container(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      onPressed: () async {
                                        dateTimeRange =
                                        await showDateRangePicker(
                                          context: context,
                                          firstDate: DateTime(2022),
                                          lastDate: DateTime.now(),
                                        );
                                        setState(() {
                                          start = dateTimeRange!.start;
                                          end_date = dateTimeRange!.end;
                                          dates = DateFormat('yyyy-MM-dd')
                                              .format(dateTimeRange!.start);
                                          end = DateFormat("yyyy-MM-dd").format(
                                              dateTimeRange!.end);

                                        });
                                      },
                                      child: Icon(
                                        Icons.date_range_outlined,
                                        size: 25,
                                      ),
                                    )),
                              ),
                              Text(dateTimeRange != null
                                  ? dates.toString() + "  -  " + end.toString()
                                  : "Select date"),
                            ],
                          ),
                        ),

                      ],
                    ),
                    Center(
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blueGrey),
                          onPressed: () {
                            setState(() {
                              pressed = true;
                            });
                          },
                          child: Text("Search", style: TextStyle(color: Colors
                              .white),)),
                    )
                  ],

                ),

                pressed == true ? Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Date"),
                        Text("Transactions"),
                      ],
                    ),
                    Divider(color: Colors.grey,),
                    Container(
                      child: get_allinvestments(
                          requestinvestments, requestWithdrawls),
                    )
                  ],
                ) : Container(),

              ],
            ),
          ),
        ],
      ),
    );
  }

  get_invests(invest, investAmount) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.3),
      child: FutureBuilder<DocumentSnapshot>(
        future: invest,
        builder: (context, snap) {
          if (snap.hasData && snap.requireData.exists) {
            investAmount = snap.data;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("₹ ${investAmount!.get("InvestAmount")}",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        fontFamily: "Poppins-Medium")),
              ],
            );
          } else {
            return Container(
              child: Text("₹ " + "0.00"),
            );
          }

        },
      ),
    );
  }

  get_allinvestments(requestinvestments, requestWithdrawls) {
    return StreamBuilder<QuerySnapshot>(
        stream: requestinvestments,
        builder: (context, snap) {
          if (snap.hasData) {
            List<QueryDocumentSnapshot> userinvestments = snap.data!.docs;
            List invest_dates = get_dates(userinvestments);
            return StreamBuilder<QuerySnapshot>(
              stream: requestWithdrawls,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> userwithdrawls = snapshot.data!
                      .docs;
                  List withdrawl_dates = get_dates(userwithdrawls);
                  invest_dates.addAll(withdrawl_dates);
                  List sorting_dates = get_sort(invest_dates);
                  List selected_dates = getDaysInBetween(start!,end_date!);
                  List? transactions = get_data(selected_dates,sorting_dates,userinvestments,userwithdrawls);
                  return Container(
                   child: ListView.builder(
                       shrinkWrap: true,
                       itemCount: transactions!.length,
                       padding: EdgeInsets.zero,
                       itemBuilder: (context,index){
                       return Container(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Text(transactions[index][0]),
                             transactions[index][1][0]=="+"?Container(
                               padding: EdgeInsets.only(bottom: 12.3),
                               child: Row(
                                 children: [
                                    Container(
                                        padding: EdgeInsets.only(right: 5.3),
                                        child: Text( transactions[index][1][0],style: TextStyle(color: Colors.green,fontSize: 15),)),
                                   Text(transactions[index][2],style: TextStyle(color: Colors.green,fontSize: 15),)
                                 ],
                               ),
                             ):Container(
                               padding: EdgeInsets.only(bottom: 12.3),

                               child: Row(
                                 children: [
                                   Container(
                                       padding: EdgeInsets.only(right: 8.3),
                                       child: Text( transactions[index][1][0],style: TextStyle(color: Colors.red,fontSize: 15),)),
                                   Text(transactions[index][2],style: TextStyle(color: Colors.red),)

                                 ],
                               ),
                             )
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
          return CircularProgressIndicator();
        }
    );
  }

  get_dates(List<QueryDocumentSnapshot<Object?>> userinvestments) {
    List dates = [];
    for (int i = 0; i < userinvestments.length; i++) {
      if (userinvestments[i].get("phonenumber") == phoneNumber &&
          userinvestments[i].get("status") == "Accept") {
        var date = DateTime.fromMicrosecondsSinceEpoch(userinvestments[i]
            .get("CreatedAt")
            .microsecondsSinceEpoch);
        dates.add(date);
      }
    }
    return dates;
  }

  get_sort(List dates) {
    List format_dates = [];
    for(int i =0;i<dates.length;i++){
      dates.sort((a, b) {
        return a.compareTo(b);
      },);
    }
   for(int j =0;j<dates.length;j++){
     DateTime? dateTime = dates[j];
     var formatdate = DateFormat('dd/MM/yyyy').format(dateTime!);
     format_dates.add(formatdate);
   }
   return format_dates;
  }
  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  List? get_data(List selected_dates, List sorting_dates, List<QueryDocumentSnapshot> userinvestments,
      List<QueryDocumentSnapshot> userwithdrawls) {
   List format_dates =[];
   List all_transactions =[];
   String symbol;
    userinvestments.addAll(userwithdrawls);
     for(int i =0;i<selected_dates.length;i++){
       format_dates.add(DateFormat('dd/MM/yyyy').format(selected_dates[i]));
     }
   for(int i =0;i<userinvestments.length;i++){
     if(userinvestments[i].get("phonenumber")==phoneNumber&&userinvestments[i].get("status")=="Accept"){
       var createdAt = userinvestments[i].get("CreatedAt");
       DateTime dateTime = userinvestments[i].get("CreatedAt").toDate();
       var dateformat = DateFormat('dd/MM/yyyy').format(dateTime);
      for(int j=0;j<format_dates.length;j++){
        if(format_dates[j]==dateformat){
           if(userinvestments[i].get("Type")=="Credit"){
             symbol = "+";
           }
           else{
             symbol = "-";
           }
           var amount = userinvestments[i].get("InvestAmount");

           all_transactions.add([dateformat,[symbol],amount]);
        }
      }
     }
   }
   return all_transactions;
  }
}