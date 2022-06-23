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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Name:- "),

                    Text("Harish")
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.only(left: 16.3,right: 16.3),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:const [
                        Text("Mobile Number:-"),
                        Text("7995289160")
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.only(left: 16.3,right: 15.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("Email:-"),
                    SizedBox(

                        child: Text("nookalasaiharish@gmail.com"))
                  ],
                ),
              ),
            ],
          ),

          Column(
            children: [
              SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.only(bottom: 16.3,left: 16.3,right: 16.3),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Address:- "),

                        Container(
                            width: 180,
                            child: Text("Survey No. 746, Mungamur Road, Kadanuthala - 524 142, Bogole (Mandal) Nellore (Dist), Andhra Pradesh, India"))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
           Center(child: TextButton(
               style: TextButton.styleFrom(
                      minimumSize: Size(120, 20),
                   backgroundColor: Colors.greenAccent.shade200,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.3))),
               onPressed: (){},child: Text("Edit",style: TextStyle(color: Colors.black87,fontSize: 15),)),)
        ],
      ),
    );
  }
}
