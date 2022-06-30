import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Profile extends StatefulWidget {
  String?phoneNumber;
   Profile({Key? key,this.phoneNumber}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState(phoneNumber:phoneNumber);
}

class _ProfileState extends State<Profile> {
  String?phoneNumber;
  _ProfileState({this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    var users = FirebaseFirestore.instance
        .collection("Users")
        .doc(phoneNumber)
        .get();
    return Container(
      margin: EdgeInsets.all(16.3),
      child: Column(
        children: [
          SizedBox(height: 30,),
          Container(
            alignment: Alignment.topLeft,
            child: const Text("Profile Details",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500),),
          ),
          Divider(color: Colors.grey,thickness: 0.6,),
          const SizedBox(height: 30,),

          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16.3,right: 16.3),
                child: Column(
                  children:  [
                    FutureBuilder<DocumentSnapshot>(
                      future: users,
                      builder: (context,snap){
                        if(snap.hasData){
                          var users = snap.data;
                          return Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name :-"),
                                    Text(users!.get("firstname"))
                                  ],
                                ),
                                margin: EdgeInsets.only(bottom: 8.3),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Gender:-"),
                                    Text(users.get("gender"))
                                  ],
                                ),
                                margin: EdgeInsets.only(bottom: 8.3),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Mobilenumber:-"),
                                    Text(users.get("mobilenumber"))
                                  ],
                                ),
                        margin: EdgeInsets.only(bottom: 8.3),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Email:-"),
                                    Container(
                                        child: Text(users.get("email")),
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(bottom: 8.3),

                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Dateofbirth:-"),
                                    users.get("dateofbirth".toString())==null?Container():Text(users.get("dateofbirth"))
                                  ],
                                ),
                                margin: EdgeInsets.only(bottom: 8.3),

                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Address:-"),
                                    Container(
                                        width:160,
                                        child: Text(users.get("address")))
                                  ],
                                ),
                                margin: EdgeInsets.only(bottom: 16.3),

                              ),

                            ],
                          );
                        }return CircularProgressIndicator();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),



        ],
      ),
    );
  }
}
