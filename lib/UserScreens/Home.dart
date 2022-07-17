import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:growmax/UserScreens/profits.dart';
import 'package:growmax/UserScreens/withdraw.dart';
import 'package:growmax/repositories/authentication.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Forms/bank_details.dart';
import 'Investment.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:timer_count_down/timer_controller.dart';

class Home extends StatefulWidget {
  String? id;
  String? phonenumber;
  String? bank_id;
  bool? pressed;
  SharedPreferences? prefsdata;
  SharedPreferences? prefs;
  Home({Key? key, this.id, this.phonenumber, this.bank_id,this.pressed}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  var data;

  var formatter = NumberFormat('#,##0.${"#" * 5}');
  Authentication authentication = Authentication();

  String? value;
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
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Builder(builder: (context) {
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
                    ),
                    FutureBuilder<DocumentSnapshot?>(
                      future: authentication.users(widget.phonenumber),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var users = snapshot.data;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [get_name(users)],
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.only(top: 12.3),
                          child: const Text(
                            "Welcome  --- Loading ---",
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 18.3, right: 18.3),
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
            margin: const EdgeInsets.only(right: 2.3),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      border: Border.all(color: Colors.lime.shade700),
                      borderRadius: BorderRadius.circular(12.3)),
                  margin: const EdgeInsets.only(left: 18.3, right: 18.3),
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
                              fontWeight: FontWeight.w600,
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
                              child: get_invests(),
                            ),
                            Container(
                              child: get_profit(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6.3),
                        child: Center(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  minimumSize: Size(120, 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.3))),
                              onPressed: () async {
                                var details = await authentication
                                    .bank_inf(widget.phonenumber);
                                Timestamp? date = details!.get("Currentdate");
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            profit(
                                                date: date,
                                                phonenumber:
                                                    widget.phonenumber)));
                              },
                              child: Text(
                                "View details",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Poppins-Medium'),
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.3),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                FutureBuilder<DocumentSnapshot?>(
                    future: authentication.bank_inf(widget.phonenumber),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var details = snapshot.data;
                        if (details!.get("status") == "Accept") {
                          return Column(
                            children: [
                              build_data(),
                              const SizedBox(
                                height: 40,
                              ),
                              build_Investments()
                            ],
                          );
                        } else if (details.get("status") == "pending") {
                          return const Center(
                              child: Text(
                            "--- Your bank_details status is pending --- ",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 14.6,
                                fontFamily: "Poppins-Medium"),
                          ));
                        } else if (details.get("status") == "Reject") {
                          return Center(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(12.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.3),
                                    ),
                                    backgroundColor: Colors.green),
                                onPressed: () async {

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              BankAccount(
                                                  phonenumber:
                                                      widget.phonenumber,
                                                  id: widget.id)));
                                },
                                child: const Text(
                                  " + Add Bank Details",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      letterSpacing: 0.6),
                                )),
                          );
                        }
                      }return Container(child: get_data(),);

                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  get_name(DocumentSnapshot<Object?>? users) {
    return Container(
      margin: const EdgeInsets.only(left: 12.3, right: 12.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6.0),
                child: Text(
                  "Welcome " + '${users!.get("firstname")}',
                  style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 15,
                      fontFamily: "Poppins-Medium"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 1.0),
                width: MediaQuery.of(context).size.width / 1.77,
                child: const Text(
                  "This is the way to build your Future",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontFamily: "Poppins-Medium"),
                ),
              ),
            ],
          ),
          ProfilePicture(
            name: users.get("lastname"),
            radius: 42,
            fontsize: 16,
            img: users.get("image"),
          )
        ],
      ),
    );
  }

  build_data() {
    return Container(
      margin: const EdgeInsets.only(left: 12.3, right: 12.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12.3),
            decoration: BoxDecoration(
                color: Colors.green.shade400,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2.59,
                    margin: const EdgeInsets.only(
                        top: 5.3, bottom: 3.3, left: 3.3, right: 5.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                            child: Text("Invested Amount",
                                style: TextStyle(
                                    letterSpacing: 0.9,
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: "Poppins-Medium"))),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: get_invests(),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12.3, right: 12.3),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.brown),
                borderRadius: BorderRadius.circular(5.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2.8,
                    margin: const EdgeInsets.only(
                        top: 5.3, bottom: 3.3, left: 3.3, right: 5.3),
                    child: const Center(
                        child: Text(
                      "Current Gains",
                      style: TextStyle(
                          color: Colors.brown, fontFamily:"Poppins-Light",fontWeight: FontWeight.w900),
                    ))),
                const SizedBox(
                  height: 8,
                ),
                get_gains(),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  get_invests() {
    return FutureBuilder<DocumentSnapshot?>(
      future: authentication.investments(widget.phonenumber),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          var investments = snapshot.data;
          var afterformat = formatter.format(double.parse(
              investments!.get("InvestAmount").replaceAll(",", "")));
          return Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "₹ ",
                  style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "Poppins-Light",
                      fontWeight: FontWeight.w900
                  ),
                ),
                Text(
                 afterformat,
                  style: const TextStyle(color: Colors.white, fontSize: 16.5,
                      fontFamily: "Poppins-Medium",
                      fontWeight: FontWeight.w900,
                    letterSpacing: 1.0
                  ),
                ),
              ],
            ),
          );
        }
        return Center();
      },
    );
  }

  get_profit() {
    return Container(
      child: StreamBuilder<DocumentSnapshot?>(
        stream: authentication.get_profit(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.requireData!.exists) {
            var profit = snapshot.data;
            var Todayprofit = profit!.get("Todayprofit");
            double after_profit = double.parse(Todayprofit);
            return Row(
              children: [
                after_profit.isNegative
                    ? Container(
                        margin: const EdgeInsets.only(left: 2.3),
                        child: const Icon(Icons.arrow_downward,
                            color: Colors.red, size: 25),
                      )
                    : Container(
                        margin: const EdgeInsets.only(left: 2.3),
                        child: const Icon(Icons.arrow_upward,
                            color: Colors.white, size: 20),
                      ),
                after_profit.isNegative
                    ? Text(
                        Todayprofit.toString() + "%",
                        style: TextStyle(
                            color: Colors.red,
                            letterSpacing: 1.3,
                            fontSize: 16),
                      )
                    : Text(Todayprofit.toString() + "%",
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
      ),
    );
  }

  build_Investments() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: Size(130, 45),
                elevation: 0.2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.6)),
              backgroundColor: Colors.orange,
            ),
            onPressed: () async {
              var bankDetails = await authentication.users(widget.phonenumber);
              String? username = bankDetails!.get("username");
              String? id = bankDetails.id;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => withdraw(
                          phonenumber: widget.phonenumber,
                          username: username,
                          id: id)));
            },
            child: const Text(
              "Withdrawl",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Poppins-Medium"),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: Size(125, 45),
                elevation: 0.2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.6)),
                backgroundColor: Colors.green.shade600),
            onPressed: () async {
              var bankDetails = await authentication.users(widget.phonenumber);
              String? username = bankDetails!.get("username");
              String? id = bankDetails.id;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Investment(
                        phonenumber: widget.phonenumber,
                        username: username,
                        id: id)),
              );
            },
            child: const Text(
              " + Invest More",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Poppins-Medium"),
            ),
          ),
        ],
      ),
    );
  }

  get_data() {
    print(widget.pressed);
    return widget.pressed==null?Container(
        child: Center(
      child: TextButton(
          style: TextButton.styleFrom(
              padding: const EdgeInsets.all(12.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.3),
              ),
              backgroundColor: Colors.green),
          onPressed: () async {

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => BankAccount(
                    phonenumber: widget.phonenumber, id: widget.id)));
          },
          child: const Text(
            " + Add Bank Details",
            style: TextStyle(
                color: Colors.white, fontSize: 15, letterSpacing: 0.6),
          )),
    )):Container();
  }

  get_gains() {
    return FutureBuilder<DocumentSnapshot?>(
      future: authentication.get_curentgains(widget.phonenumber),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.requireData!.exists) {
          var gains = snapshot.data;
          var afterFormat = formatter.format(double.parse(
              gains!.get("CurrentGains").replaceAll(",", "")));
          return Row(
            children: [
              const Text(
                "₹",
                style: TextStyle(color: Colors.white),
              ),
              Text(" ₹ $afterFormat",
                style: const TextStyle(color: Colors.green,
                  fontFamily: "Poppins-Medium"
                ),)
            ],
          );
        }
        return Center();
      },
    );
  }
}
