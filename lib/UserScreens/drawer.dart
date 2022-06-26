import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:growmax/UserScreens/pending_requests.dart';

import '../Forms/nominee_details.dart';

// ignore: camel_case_types
class drawer extends StatefulWidget {
  String? phonenumber;
  drawer({Key? key, this.phonenumber}) : super(key: key);

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    var users = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.phonenumber)
        .get();
    var Creditpendings =
        FirebaseFirestore.instance.collection("requestInvestments").get();
    var Debitpendings =
        FirebaseFirestore.instance.collection("requestwithdrawls").get();
    return Container(
      margin: EdgeInsets.all(12.3),
      child: Container(
        child: Column(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    Text(
                      "Hi ,",
                      style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 16,
                          fontFamily: "Poppins-Medium"),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: users,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var users = snapshot.data!;
                          return Text(
                            users.get("firstname"),
                            style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 16,
                                fontFamily: "Poppins-Medium"),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 3.3)),
                Container(
                  margin: const EdgeInsets.only(top: 1.0),
                  width: MediaQuery.of(context).size.width / 1.9,
                  child: const Text(
                    "This is the way to build your Future",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontFamily: "Poppins-Medium"),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade500,
                  thickness: 1.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(bottom: 12.3, top: 12.3),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                   Nominee_details(phonenumber: widget.phonenumber,)));
                        },
                        child: Text(
                          "Nominee Details",
                          style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontFamily: "Poppins-Medium"),
                        )),
                    Row(
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(bottom: 12.3, top: 12.3),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      pending_requests(phonenumber: widget.phonenumber,)));
                            },
                            child: Text(
                              "Pending requests",
                              style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontFamily: "Poppins-Medium"),
                            )),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  get_requests() async {
    int count = 0;
    CollectionReference users =
        await FirebaseFirestore.instance.collection('requestInvestments');
    QuerySnapshot query = await users.get();
    for (int i = 0; i < query.docs.length; i++) {
      if (query.docs[i].get("status") == "pending" &&
          widget.phonenumber == query.docs[i].get("phonenumber")) {
        count++;
      }
    }
    count.toString();
    return count.toString();
  }
}
