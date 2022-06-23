import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WaveClipper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
            child:Stack(children: <Widget>[ //stack overlaps widgets
              Opacity( //semi red clippath with more height and with 0.5 opacity
                opacity: 0.5,
                child: ClipPath(
                  clipper:WaveClipperState(), //set our custom wave clipper

                ),
              ),

              ClipPath(//upper clippath with less height
                clipper:WaveClipperState(), //set our custom wave clipper.
                child:Container(
                    padding: EdgeInsets.only(bottom: 50),
                    color:Colors.cyan.shade200,
                    height:MediaQuery.of(context).size.height/3.0,
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        SizedBox(height: 40,width: 150,),
                        Container(
                          margin: EdgeInsets.only(top: 2.6,left: 16.3),
                          child: Text("Login", style: TextStyle(
                              fontSize:30,color:Colors.white,fontFamily: "Poppins-Light"
                          ),),
                        ),
                      ],
                    )
                ),
              ),
            ],)
        );
  }
}

//Costom CLipper class with Path
class WaveClipperState extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    var path = new Path();
    path.lineTo(0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}