
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growmax/UserScreens/profile.dart';
import '../UserScreens/home.dart';
import '../Login.dart';
import 'Transaction.dart';
import 'banking.dart';
import 'drawer.dart';

class userPannel extends StatefulWidget {
  String? phoneNumber;
  userPannel({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return userPannelState(
      phoneNumber:this.phoneNumber
    );
  }
}

class userPannelState extends State<userPannel> {
  int? selectedIndex = 0;
  String? phoneNumber;
  userPannelState({this.phoneNumber,});


  bool pressed = true;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Home(phoneNumber:phoneNumber,),
      Banking(phoneNumber:phoneNumber),
      Transaction(phoneNumber:phoneNumber),
      Profile(phoneNumber:phoneNumber)
    ];
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          drawer: Drawer(
              child: Container(
            margin: const EdgeInsets.only(left: 12.3, right: 12.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                drawer(phonenumber: phoneNumber,)
              ],
            ),
          )),
          body: Container(
            child: _widgetOptions.elementAt(selectedIndex!),
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
            canvasColor: Colors.lightGreenAccent.shade100,

        ), child:BottomNavigationBar(
           backgroundColor: Colors.deepOrange,
            currentIndex: selectedIndex!,
            elevation: 15.3,
            selectedItemColor: Colors.green,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 14,
            unselectedFontSize: 12.5,
            selectedLabelStyle: TextStyle(fontFamily: "Poppins-Medium"),
            unselectedLabelStyle: TextStyle(fontFamily: "Poppins-Medium"),

            unselectedItemColor: Colors.grey.shade600,
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home_outlined),

              ),
              BottomNavigationBarItem(
                label: 'Banking',
                tooltip: "Banking",
                icon: Icon(Icons.comment_bank_rounded),
              ),
              BottomNavigationBarItem(
                label: 'Transaction',
                icon: Icon(Icons.menu_sharp),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(Icons.person),
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        )));
  }
}
