import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:growmax/UserScreens/userPannel.dart';
import 'package:growmax/repositories/authentication.dart';
import 'package:intl/intl.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class pending_requests extends StatefulWidget {
  String? phonenumber;
  String?username;
  pending_requests({Key? key, this.phonenumber,this.username}) : super(key: key);

  @override
  State<pending_requests> createState() => _pending_requestsState();
}

class _pending_requestsState extends State<pending_requests> {
  Authentication authentication = Authentication();
  var requestinvestments =
      FirebaseFirestore.instance.collection("requestInvestments").snapshots();
  var requestWithdrawls =
      FirebaseFirestore.instance.collection("requestwithdrawls").snapshots();
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Container(
              margin: EdgeInsets.all(12.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 9,),
                  IconButton(onPressed: () async{
                    var username = await FirebaseFirestore.instance.collection("bank_details").get();
                    var values = await get_data(widget.phonenumber,username);
                     if(values==null){
                       Navigator.of(context).pushReplacement(MaterialPageRoute(
                           builder: (BuildContext context) =>
                               userPannel(phonenumber: widget.phonenumber,)));
                     }else{
                       Navigator.of(context).pushReplacement(MaterialPageRoute(
                           builder: (BuildContext context) =>
                               userPannel(phonenumber: widget.phonenumber,pressed: true,)));
                     }
                  }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 20,color: Colors.lightBlueAccent,)),
                  Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                  Container(
                      margin: EdgeInsets.all(5.3),
                      child: Container(
                          margin: const EdgeInsets.only(
                            left: 6.3,
                          ),
                          child: const Text(
                            "Pending requests",
                            style: TextStyle(
                                letterSpacing: 0.6,
                                color: Colors.indigoAccent,
                                fontFamily: "Poppins-Light",
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ))),
                  Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 12.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date"),
                            Text("InvestAmount"),
                            Text("Type")
                          ],
                        ),
                      ),
                     Container(
                       margin: EdgeInsets.only(top: 6.5,bottom: 6.5),
                       child: FutureBuilder<DocumentSnapshot?>(
                         future: authentication.users(widget.phonenumber),
                         builder: (context,snap){
                           if(snap.hasData){
                             var user = snap.data;

                             return build_pendingrequests(user!.get("username"));
                           }return Container();
                         },
                       )
                     )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  build_pendingrequests(username) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: requestinvestments,
        builder: (context, snap) {
          if (snap.hasData) {
            List<QueryDocumentSnapshot> userinvestments = snap.data!.docs;
            return StreamBuilder<QuerySnapshot>(
              stream: requestWithdrawls,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> userwithdrawls =
                      snapshot.data!.docs;
                  userinvestments.addAll(userwithdrawls);
                  List dates = get_dates(userinvestments);
                  List? transactions = get_transactions(dates, userinvestments,username);

                  return Container(
                    margin: EdgeInsets.only(bottom: 5.6),
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: transactions!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(transactions[index][0]),
                                  transactions[index][1][0] == "+"
                                      ? Container(
                                         width: 100,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(right: 5.3),
                                                  child: Text(
                                                    transactions[index][1][0],
                                                    style: TextStyle(
                                                        color: Colors.grey.shade500,
                                                        fontSize: 15,
                                                      fontFamily: "Poppins-Medium",
                                                    ),
                                                  ),

                                               alignment: Alignment.center,
                                              ),
                                              Text(
                                                transactions[index][2],
                                                style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontFamily: "Poppins-Medium",
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(
                                        width: 100,
                                          child: Row(
                                            children: [
                                              Container(
                                                  child: Text(
                                                    transactions[index][1][0],
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15,
                                                      fontFamily: "Poppins-Medium",
                                                    ),
                                                  )),
                                              Text(
                                                transactions[index][2],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontFamily: "Poppins-Medium",
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                  Text(transactions[index][3]),
                                ],
                              )),
                              Padding(padding:EdgeInsets.only(top: 10.6))
                            ],
                          );
                        }),
                  );
                }
                return CircularProgressIndicator();
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  get_dates(List<QueryDocumentSnapshot<Object?>> userinvestments) {
    List dates = [];
    List all_dates = [];
    for (int i = 0; i < userinvestments.length; i++) {
      if (userinvestments[i].get("phonenumber") == widget.phonenumber &&
          userinvestments[i].get("status") == "pending") {
        var date = DateTime.fromMicrosecondsSinceEpoch(
            userinvestments[i].get("CreatedAt").microsecondsSinceEpoch);
        dates.add(date);
        all_dates = get_sort(dates);
      }
    }
    return all_dates;
  }

  get_sort(List dates) {
    for (int i = 0; i < dates.length; i++) {
      dates.sort(
        (a, b) {
          return a.compareTo(b);
        },
      );
    }

    return dates;
  }

  List? get_transactions(
      List dates, List<QueryDocumentSnapshot<Object?>> userinvestments, String? username) {
    List alltransactions = [];
    String Symbol;
    for (int i = 0; i < userinvestments.length; i++) {
      DateTime dateTime = userinvestments[i].get("CreatedAt").toDate();
      if (userinvestments[i].get("status") == "pending" &&
          userinvestments[i].get("username") == username) {
        var date = DateFormat('dd/MM/yyyy').format(dateTime);
        if (userinvestments[i].get("Type") == "Credit") {
          Symbol = "+";
        } else {
          Symbol = " - ";
        }
        var type = userinvestments[i].get("Type");
        alltransactions.add([
          date, [Symbol], userinvestments[i].get("InvestAmount"), type
        ]);
      }
    }
    return alltransactions;
  }

  get_data(String? phonenumber, QuerySnapshot<Map<String, dynamic>> username) {
    for(int i =0;i<username.docs.length;i++){
      if(username.docs[i].get("phonenumber")==phonenumber){
        if(username.docs[i].get("username")!=null){
          return true;
        }
        else{
          return null;
        }
      }
      else{
        return null;
      }
    }
  }
}
