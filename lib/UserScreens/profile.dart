import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:growmax/repositories/authentication.dart';

import '../Forms/edit_profile.dart';
class Profile extends StatefulWidget {
  String?phoneNumber;
  String?id;
   Profile({Key? key,this.phoneNumber,this.id}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState(phoneNumber:phoneNumber);
}

class _ProfileState extends State<Profile> {
  String?phoneNumber;
  _ProfileState({this.phoneNumber});
  Authentication authentication = Authentication();
  @override
  Widget build(BuildContext context) {
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
                    FutureBuilder<DocumentSnapshot?>(
                      future: authentication.users(widget.phoneNumber),
                      builder: (context,snap){
                        if(snap.hasData){
                          var users = snap.data;
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 8.3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Username :-"),
                                    users!.get("username")!=null?Text(users.get("username")):Container()
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name :-"),
                                    Text(users.get("firstname"))
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
                                    Text("Status:-"),
                                    Text(users.get("status"))
                                  ],
                                ),
                                margin: EdgeInsets.only(bottom: 15.3),

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
                              Center(
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        minimumSize: const Size(120, 20),
                                        backgroundColor: Colors.limeAccent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.3))
                                    ),
                                    onPressed: (){
                                      var id = users.id;
                                      Navigator.push (
                                        context,
                                        MaterialPageRoute (
                                          builder: (BuildContext context) => edit_profile(id: id,
                                              mobilenumber:users.get("mobilenumber"),
                                             email :users.get("email"),
                                            status :users.get('status'),
                                            address:users.get("address"),
                                            username:users.get("username")
                                          ),
                                        ),
                                      );
                                    }, child: const Text("Edit",style: TextStyle(color: Colors.black87,fontSize: 15,fontWeight: FontWeight.w600),)),
                              )
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
