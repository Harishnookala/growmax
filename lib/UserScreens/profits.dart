import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:growmax/UserScreens/userPannel.dart';
import 'package:intl/intl.dart';

class profit extends StatefulWidget {
  String? phonenumber;
  Timestamp? date;
  profit({
    Key? key,
    this.phonenumber,
    this.date,
  }) : super(key: key);

  @override
  State<profit> createState() => _profitState();
}

class _profitState extends State<profit> {
  var profit = FirebaseFirestore.instance.collection("Admin").get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        userPannel(phonenumber: widget.phonenumber)));
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: Colors.greenAccent,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                FutureBuilder<QuerySnapshot>(
                  future: profit,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<QueryDocumentSnapshot> listofprofits = snapshot.data!.docs;
                      DateTime? date = widget.date!.toDate();
                      List dates = getDaysInBetween(date, DateTime.now());
                      List listofdates = get_list(listofprofits, dates);
                      return Container(
                        margin: EdgeInsets.all(12.3),
                        child: Column(
                          children: [
                            Container(
                              child: Text("Today Profits",style: TextStyle(color: Colors.orange)),
                            ),
                            Divider(color: Colors.lightGreenAccent,thickness: 1.0,),
                            Container(margin: EdgeInsets.only(top: 5.3),),
                            ListView.builder(
                                 shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemCount: listofdates.length,
                                itemBuilder: (context,index){
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8.6),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(listofdates[index][0]),
                                            Text(listofdates[index][1]),

                                          ],
                                        ),
                                        const Divider(color: Colors.black,thickness: 1.0,)
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      );
                    }
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.lightGreenAccent,
                    ));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  List get_list(List<QueryDocumentSnapshot> listofprofits, List dates) {
    String? todayprofit;
    var date;
    List listoftodayprofits = [];
    List format_dates = [];
    for (int i = 0; i < dates.length; i++) {
      format_dates.add(DateFormat('yyy-dd-MMM').format(dates[i]));
    }
    for (int i = 0; i < format_dates.length; i++) {
      for (int j = 0; j < listofprofits.length; j++) {
        var id = listofprofits[j].id;
        if (id == format_dates[i]) {
          todayprofit = listofprofits[j].get("Todayprofit");
          date = format_dates[i];
          listoftodayprofits.add([date, todayprofit]);
        }
      }
    }
    return listoftodayprofits;
  }
}
