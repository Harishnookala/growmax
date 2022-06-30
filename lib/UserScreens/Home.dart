import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:get/get.dart';
import 'package:growmax/UserScreens/withdraw.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Forms/bank_details.dart';
import 'Investment.dart';

class Home extends StatefulWidget {
  String? phoneNumber;
  Home({this.phoneNumber});

  @override
  _HomeState createState() => _HomeState(phoneNumber: this.phoneNumber);
}

class _HomeState extends State<Home> {
  String? phoneNumber;
  bool? pressed = false;
  SharedPreferences? prefsdata;
  SharedPreferences? prefs;
  var data;
  _HomeState({this.phoneNumber});
  var formatter = NumberFormat('#,##0.' + "#" * 5);
  @override
  Widget build(BuildContext context) {
    var dates = DateFormat('yyy-dd-MMM').format(DateTime.now());
    var investments = FirebaseFirestore.instance
        .collection("Investments")
        .doc(phoneNumber)
        .get();
    var profit =
        FirebaseFirestore.instance.collection("Admin").doc(dates).get();
    var users = FirebaseFirestore.instance.collection("Users").get();
    var bank_details = FirebaseFirestore.instance
        .collection("bank_details")
        .doc(phoneNumber)
        .get();
    var gains = FirebaseFirestore.instance
        .collection("Current_gains")
        .doc(phoneNumber)
        .get();

    var investAmount;
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      return IconButton(
                        icon: const Icon(
                          Icons.menu,
                          size: 32,
                          color: Colors.lightBlueAccent,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    }),
                    FutureBuilder<QuerySnapshot>(
                      future: users,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var users = snapshot.data;
                          return Expanded(
                            child: ListView.builder(
                              itemCount: users!.docs.length,
                              itemBuilder: (context, index) {
                                return users.docs[index].get("mobilenumber") ==
                                        phoneNumber
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 12.3,
                                                top: 6.3,
                                                right: 12.3),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Welcome " +
                                                          '${users.docs[index].get("firstname")}',
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.deepOrange,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Poppins-Medium"),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 1.0),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.9,
                                                      child: const Text(
                                                        "This is the way to build your Future",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                "Poppins-Medium"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ProfilePicture(
                                                  name: users.docs[index]
                                                      .get("lastname"),
                                                  radius: 38,
                                                  fontsize: 16,
                                                  img: users.docs[index]
                                                      .get("image"),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container();
                              },
                              shrinkWrap: true,
                            ),
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(top: 16.3),
                          child: Text(
                            "Welcome",
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 18.3, right: 18.3),
                  child: const Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  )),
              const SizedBox(
                height: 10,
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.green.shade400,
                border: Border.all(color: Colors.lime.shade700),
                borderRadius: BorderRadius.circular(12.3)),
            margin: EdgeInsets.only(left: 18.3, right: 18.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 12.3, left: 13.3),
                  child: const Text(
                    "Today Portfolio Value : -  ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontFamily: "Poppins-Medium"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 0.0, left: 25.3, right: 12.3),
                  child: Row(
                    children: [
                      Container(
                        child: get_invests(investments, investAmount),
                      ),
                      Container(
                        child: get_profit(profit),
                      )
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 8.3,
                          top: 8.3,
                        ),
                        width: 120,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(25.3),
                            color: Colors.orange),
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8.3, top: 8.3),
                          child: const Text(
                            'View details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ))),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<DocumentSnapshot>(
              future: bank_details,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.requireData.exists) {
                  var data = snapshot.data;
                  print(data);
                  return data!.get("status") == "pending"
                      ? Container(
                          child: Center(
                            child: Text(
                              " ---------Your bank details is Pending ------- ",
                              style: TextStyle(color: Colors.pinkAccent),
                            ),
                          ),
                        )
                      : data.get("status") == "Accept"
                          ? Container(
                              child: SizedBox(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: 12.3, right: 12.3),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      get_currentGains(
                                          investments, investAmount, gains),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    minimumSize: Size(120, 40),
                                                    elevation: 0.2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.6)),
                                                    backgroundColor:
                                                        Colors.grey.shade700),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            withdraw(
                                                              phonenumber:
                                                                  phoneNumber,
                                                            )),
                                                  );
                                                },
                                                child: const Text(
                                                  "Withdrawl",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      letterSpacing: 0.6,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                )),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    elevation: 0.5,
                                                    shadowColor: Colors.red,
                                                    minimumSize: Size(120, 40),
                                                    backgroundColor:
                                                        Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.6))),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Investment(
                                                              phonenumber:
                                                                  phoneNumber,
                                                            )),
                                                  );
                                                },
                                                child: const Text(
                                                  " + Invest More",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      letterSpacing: 0.6,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : data.get("status") == "Reject"
                              ? Column(
                                  children: [
                                    Center(
                                        child: Text(
                                      "------ Your bank details  is Rejected so  ------",
                                      style: TextStyle(color: Colors.red),
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: 180,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        26.0)),
                                            backgroundColor: Colors.green,
                                            elevation: 0.6,
                                          ),
                                          onPressed: () async {
                                            //var details = await FirebaseFirestore.instance.collection("bank_details").doc(phoneNumber).get();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BankAccount(
                                                        phonenumber:
                                                            phoneNumber,
                                                      )),
                                            );
                                          },
                                          child: Text(
                                            " + Add Bank Details",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container();
                } else {
                  return Center(
                    child: SizedBox(
                      width: 180,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26.0)),
                          backgroundColor: Colors.green,
                          elevation: 0.6,
                        ),
                        onPressed: () async {
                          //var details = await FirebaseFirestore.instance.collection("bank_details").doc(phoneNumber).get();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BankAccount(
                                      phonenumber: phoneNumber,
                                    )),
                          );
                        },
                        child: Text(
                          " + Add Bank Details",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              })
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
          DocumentSnapshot? documentSnapshot = snap.data;
          var aafterformat = formatter.format(double.parse(
              documentSnapshot!.get("InvestAmount").replaceAll(",", "")));

          return Row(
            children: [
              Text("₹ ${aafterformat}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      fontFamily: "Poppins-Medium")),
            ],
          );
        }
        return Container();
      },
    );
  }

  get_profit(profit) {
    return FutureBuilder<DocumentSnapshot>(
      future: profit,
      builder: (context, snap) {
        if (snap.hasData && snap.requireData.exists) {
          var investment = snap.data;
          var Todayprofit = investment!.get("Todayprofit");
          int profit = int.parse(Todayprofit);

          return Row(
            children: [
              profit.isNegative
                  ? const Icon(Icons.arrow_downward,
                      color: Colors.red, size: 25)
                  : const Icon(Icons.arrow_upward,
                      color: Colors.white, size: 20),
              profit.isNegative
                  ? Text(
                      Todayprofit + "%",
                      style: TextStyle(
                          color: Colors.red, letterSpacing: 1.3, fontSize: 16),
                    )
                  : Text("+$Todayprofit" + "%",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontFamily: "Poppins-Medium"))
            ],
          );
        }
        return Container();
      },
    );
  }

  Current_gains(gains) {
    return Column(
      children: [
        FutureBuilder<DocumentSnapshot>(
            future: gains,
            builder: (context, snap) {
              if (snap.hasData && snap.requireData.exists) {
                var profit = snap.data;
                return Center(
                  child: Container(
                      margin: EdgeInsets.only(bottom: 5.3),
                      child: Center(
                          child: Text(
                        "₹ " + profit!.get("CurrentGains"),
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins-Medium",
                            fontSize: 16),
                      ))),
                );
              }
              return Container();
            })
      ],
    );
  }

  get_InvestAmount(Future<DocumentSnapshot<Map<String, dynamic>>> investments,
      investAmount) {
    print(MediaQuery.of(context).size.width / 2.58);
    return Container(
      margin: const EdgeInsets.only(left: 12.3),
      decoration: BoxDecoration(
          color: Colors.green.shade200,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 2.58,
              margin: const EdgeInsets.only(
                  top: 5.3, bottom: 3.3, left: 3.3, right: 5.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text("Invested Amount",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins-Medium"))),
                ],
              )),
          const SizedBox(
            height: 5,
          ),
          Column(
            children: [
              Center(
                child: Container(
                  child: get_invests(investments, investAmount),
                  margin: EdgeInsets.only(bottom: 5.3),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  get_currentGains(
    Future<DocumentSnapshot<Map<String, dynamic>>> investments,
    investAmount,
    Future<DocumentSnapshot<Map<String, dynamic>>> gains,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        get_InvestAmount(investments, investAmount),
        Container(
          margin: EdgeInsets.only(left: 12.3, right: 12.3),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.brown),
              borderRadius: BorderRadius.circular(5.3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3,
                  margin: const EdgeInsets.only(
                      top: 5.3, bottom: 3.3, left: 3.3, right: 5.3),
                  child: const Center(
                      child: Text(
                    "Current Gains",
                    style: TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.w600),
                  ))),
              const SizedBox(
                height: 5,
              ),
              Current_gains(gains),
            ],
          ),
        ),
      ],
    );
  }

  get_data() async {
    var investments = await FirebaseFirestore.instance
        .collection("Investments")
        .doc(phoneNumber)
        .get();
    return investments.exists;
  }

  build_name(QuerySnapshot<Object?> user, int index) {
    return Container(
      child: Text(
        "Welcome " + user.docs[index].get("firstname"),
        style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins-Medium",
            fontSize: 16,
            letterSpacing: 0.3),
      ),
    );
  }
}
