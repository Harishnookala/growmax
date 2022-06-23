import 'package:flutter/material.dart';

class Nominee_details extends StatefulWidget {
  const Nominee_details({Key? key}) : super(key: key);

  @override
  State<Nominee_details> createState() => _Nominee_detailsState();
}

class _Nominee_detailsState extends State<Nominee_details> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController nomineeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: EdgeInsets.all(12.3),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
              Container(
                  margin: EdgeInsets.all(5.3),
                  child: Container(
                      margin: const EdgeInsets.only(
                        left: 6.3,
                      ),
                      child: const Text(
                        "Nominee Details",
                        style: TextStyle(
                            letterSpacing: 0.6,
                            color: Colors.indigoAccent,
                            fontFamily: "Poppins-Light",
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ))),
              Divider(height: 1, thickness: 1.5, color: Colors.green.shade400),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              "Name : -",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 15,
                                  letterSpacing: 0.8,
                                  fontFamily: "Poppins-Light"),
                            ),
                            margin: EdgeInsets.only(bottom: 8.5),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5.3),
                            child: build_name(),
                          ),
                          Container(

                            child: const Text(
                              "Age : -",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 15,
                                  letterSpacing: 0.8,
                                  fontFamily: "Poppins-Light"),
                            ),
                            margin: EdgeInsets.only(bottom: 9.5),
                          ),
                         Container(
                           margin: EdgeInsets.only(bottom: 6.3),
                           child: build_age(),),
                          Container(
                            child: const Text(
                              "RelationShip with Nominee : -",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 15,
                                  letterSpacing: 0.8,
                                  fontFamily: "Poppins-Light"),
                            ),
                            margin: EdgeInsets.only(bottom: 8.5),
                          ),
                          build_nominee(),
                          SizedBox(height: 13,),
                          build_button()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  build_name() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Poppins-Light",
        ),
        controller: nameController,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "First Name",
            labelText: "First Name",
            labelStyle: const TextStyle(color: Color(0xff576630)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
            ),
            hintStyle: const TextStyle(color: Colors.brown)),
      ),
    );
  }

  build_age() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Poppins-Light",
        ),
        controller:ageController ,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "First Name",
            labelText: "First Name",
            labelStyle: const TextStyle(color: Color(0xff576630)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
            ),
            hintStyle: const TextStyle(color: Colors.brown)),
      ),
    );
  }

  build_nominee() {
    return SizedBox(
      height: 53,
      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        style: TextStyle(
          fontFamily: "Poppins-Light",
        ),
        controller:nomineeController ,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.8),
            ),
            hintText: "First Name",
            labelText: "First Name",
            labelStyle: const TextStyle(color: Color(0xff576630)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xcc9fce4c), width: 1.5),
            ),
            hintStyle: const TextStyle(color: Colors.brown)),
      ),
    );

  }

  build_button() {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: Size(130, 20),
          elevation: 1.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.6)),

        ),
        onPressed: (){

        },
        child: Container(
            margin: EdgeInsets.only(left: 5.3,right: 5.3),
            child: Text("Submit",style: TextStyle(color: Colors.white,fontFamily: "Poppins-Medium"),)),
      ),
    );
  }

}
