import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:growmax/Login.dart';
import 'package:growmax/UserScreens/pending_requests.dart';
import 'package:growmax/repositories/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    Authentication authentication = Authentication();
    var Creditpendings =
        FirebaseFirestore.instance.collection("requestInvestments").get();
    var Debitpendings =
        FirebaseFirestore.instance.collection("requestwithdrawls").get();
    var users;
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
                    FutureBuilder<DocumentSnapshot?>(
                      future: authentication.users(widget.phonenumber),
                      builder: (context, snapshot) {
                        if (snapshot.hasData&&snapshot.requireData!.exists) {
                           users = snapshot.data!;
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
                                      pending_requests(phonenumber: widget.phonenumber)));
                            },
                            child: Text(
                              "Pending requests",
                              style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontFamily: "Poppins-Medium"),
                            )),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Container(
                      margin: EdgeInsets.only(left: 15.3),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange.shade400,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.3)),
                            minimumSize: Size(120, 30)
                          ),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }, child: Text("Log Out",style:
                      TextStyle(color: Colors.white,fontSize: 16,
                          fontFamily: "Poppins-Medium"),)),
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
