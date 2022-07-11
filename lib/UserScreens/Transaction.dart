import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growmax/repositories/authentication.dart';
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
  DateTime? start;
  String? end;
  DateTimeRange? dateTimeRange;
  DateTime? end_date;
  String? dates;
  bool? pressed = false;
  var formatter = NumberFormat('#,##0.' + "#" * 5);
  _TransactionState({this.phoneNumber});
  var requestinvestments =
  FirebaseFirestore.instance.collection("requestInvestments").snapshots();
  var requestWithdrawls =
  FirebaseFirestore.instance.collection("requestwithdrawls").snapshots();
  Authentication authentication = Authentication();
  var username;
  @override
  Widget build(BuildContext context) {
    var investAmount;
    return Container(
      margin: EdgeInsets.all(16.3),
      child: ListView(
        padding: EdgeInsets.zero,
         shrinkWrap: true,
        physics: ScrollPhysics(),
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
                  fontSize: 15.5,
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
                    child: get_invests(),
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
                          width: MediaQuery.of(context).size.width / 1.25,
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
                                    dateTimeRange = await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime(2022),
                                      lastDate: DateTime.now().add(Duration(days: 1)),
                                    );
                                    setState(() {
                                      start = dateTimeRange!.start;
                                      end_date = dateTimeRange!.end;
                                      dates = DateFormat('yyyy-MM-dd')
                                          .format(dateTimeRange!.start);
                                      end = DateFormat("yyyy-MM-dd")
                                          .format(dateTimeRange!.end);
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
                    Container(
                      margin: EdgeInsets.only(top: 12.3),
                      child: Center(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size(110, 40),
                                backgroundColor: Colors.blueGrey.shade500),
                            onPressed: () {
                              setState(() {
                                pressed = true;

                              });

                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white,fontFamily: "Poppins-Medium",fontSize: 15 ),
                            )),
                      ),
                    ),
                    pressed!?
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Date"),
                            Text("Transactions"),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Container(
                          child: get_allinvestments(
                              requestinvestments, requestWithdrawls),
                        )
                      ],
                    )
                        : Container(
                      margin: EdgeInsets.zero,
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  get_invests() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.3),
      child: FutureBuilder<DocumentSnapshot?>(
        future: authentication.investments(widget.phoneNumber),
        builder: (context, snap) {
          if (snap.hasData && snap.requireData!.exists) {
            DocumentSnapshot? documentSnapshot = snap.data;
            var afterformat = formatter.format(double.parse(
                documentSnapshot!.get("InvestAmount").replaceAll(",", "")));
            username = documentSnapshot.get("username");
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("₹ ${afterformat}",
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
            return start!=null?StreamBuilder<QuerySnapshot>(
              stream: requestWithdrawls,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> userwithdrawls =
                      snapshot.data!.docs;
                  userinvestments.addAll(userwithdrawls);
                  List selected_dates = getDaysInBetween(start!, end_date!);
                  List dates = get_dates(userinvestments);
                  List? transactions =
                      get_transactions(dates, selected_dates, userinvestments);
                  return ListView.builder(
                        itemCount: transactions!.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(transactions[index][0]),
                              transactions[index][1][0] == "+"
                                  ? Container(
                                      padding: EdgeInsets.only(bottom: 12.3),
                                      child: Row(
                                        children: [
                                          Container(
                                              padding:
                                                  EdgeInsets.only(right: 5.3),
                                              child: Text(
                                                transactions[index][1][0],
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 15),
                                              )),
                                          Text(
                                            transactions[index][2],
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(bottom: 12.3),
                                      child: Row(
                                        children: [
                                          Container(
                                              padding:
                                                  EdgeInsets.only(right: 8.3),
                                              child: Text(
                                                transactions[index][1][0],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15),
                                              )),
                                          Text(
                                            transactions[index][2],
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    )
                            ],
                          );
                        });

                }
                return Container();
              },
            ):Container();
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  get_dates(List<QueryDocumentSnapshot<Object?>> userinvestments) {
    List dates = [];
    List all_dates = [];
    for (int i = 0; i < userinvestments.length; i++) {
      if (userinvestments[i].get("username") == username &&
          userinvestments[i].get("status") == "Accept") {
        var date = DateTime.fromMicrosecondsSinceEpoch(
            userinvestments[i].get("CreatedAt").microsecondsSinceEpoch);
        dates.add(date);
        all_dates = get_sort(dates);
      }
    }

    return all_dates;
  }

  get_sort(List dates) {
    List format_dates = [];
    for (int i = 0; i < dates.length; i++) {
      dates.sort(
        (a, b) {
          return a.compareTo(b);
        },
      );
    }

    return dates;
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  List? get_transactions(List dates, List selected_dates,
      List<QueryDocumentSnapshot<Object?>> userinvestments) {
    List format_dates = [];
    List all_transactions = [];
    List all_dates = [];
    String symbol;
    List afterSort = [];
    String? dateformat;

    for (int i = 0; i < selected_dates.length; i++) {
      format_dates.add(DateFormat('dd/MM/yyyy').format(selected_dates[i]));
    }
    for(int j=0;j<dates.length;j++){
      dateformat = DateFormat('dd/MM/yyyy').format(dates[j]);
      for(int k=0;k<format_dates.length;k++){
        if(dateformat==format_dates[k]){
          for(int l =0;l<userinvestments.length;l++){
            DateTime dateTime = userinvestments[l].get("CreatedAt").toDate();
            if(userinvestments[l].get("status")=="Accept"&&dates[j]==dateTime){
              var datetime = DateFormat('dd/MM/yyyy').format(dateTime);
              if(userinvestments[l].get("Type")=="Credit"){
                symbol ="+";
              }
              else{
                symbol= " - ";
              }
              all_transactions.add([dateformat,[symbol],userinvestments[l].get("InvestAmount")]);
            }
          }
        }
      }
    }

    return all_transactions;
  }
}
