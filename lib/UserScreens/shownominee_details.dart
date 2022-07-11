import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:growmax/UserScreens/userPannel.dart';
class shownnominee extends StatefulWidget {
  String?phonenumber;
   shownnominee({Key? key,this.phonenumber}) : super(key: key);

  @override
  State<shownnominee> createState() => _shownnomineeState();
}

class _shownnomineeState extends State<shownnominee> {
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
    var nominee = FirebaseFirestore.instance.collection("nominee_details").doc(widget.phonenumber).get();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: nominee,
            builder: (context,snap){
              if(snap.hasData){
                var nominee_details = snap.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    IconButton(onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              userPannel(id: widget.phonenumber,)));
                    }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 20,color: Colors.lightBlueAccent,)),
                    Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                    Container(
                        margin: EdgeInsets.all(15.3),
                        child: Container(
                            margin: const EdgeInsets.only(
                              left: 6.3,
                            ),
                            child: const Text(
                              "Nominee details",
                              style: TextStyle(
                                  letterSpacing: 0.6,
                                  color: Colors.indigoAccent,
                                  fontFamily: "Poppins-Light",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ))),
                    Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
                   SizedBox(height: 40,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Text("Name:-"),
                         Text(nominee_details!.get("Name"))

                       ],

                     )  ,
                    SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Age:-"),
                        Text(nominee_details.get("Age"))

                      ],
                    ),
                    SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Relationship:-"),
                        Text(nominee_details.get("Relation"))

                      ],
                    ),
                    SizedBox(height: 30,),

                  ],
                );
              }return Center(child: CircularProgressIndicator(),);
            }
          ),
        ),
      ),
    );
  }
}
