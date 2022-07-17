import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(100);
  Color? completd_color;
  Color? not_completed_color;
  // ignore: non_constant_identifier_names
  CustomAppBar({this.completd_color, this.not_completed_color});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      toolbarHeight: 110,
      backgroundColor: Colors.black,
      title: Container(
        margin: EdgeInsets.all(9.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child:
                    CustomText(title: "<", color: Colors.white, fontsize: 19),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 10.3,
              ),
              alignment: Alignment.topLeft,
              child: CustomText(
                title: "Signup",
                color: Color(0xfff2d493),
                letterSpacing: 1.3,
                fontsize: 24,
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Divider(
                      thickness: 1.0,
                    ),
                    alignment: Alignment.topLeft,
                    height: 3.6,
                    width: 165.0,
                    color: completd_color,
                    margin: EdgeInsets.only(right: 7.3),
                  ),
                  Container(
                    child: Divider(
                      thickness: 1.0,
                    ),
                    alignment: Alignment.topLeft,
                    height: 3.6,
                    width: 165.0,
                    color: not_completed_color,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  String? title;
  var onTap;
  TextAlign? textAlign;
  Color? color;
  double? width;
  double? letterSpacing;
  Button(
      {this.title,
      this.onTap,
      this.textAlign,
      this.color,
      this.letterSpacing,
      this.width});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(25.3),
      alignment: Alignment.center,
      width: width,
      decoration: BoxDecoration(
        color: Color(0xfff2d493),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      height: 42,
      child: Align(
        child: InkWell(
          onTap: onTap,
          child: CustomText(
            title: title!.toUpperCase(),
            color: color,
            letterSpacing: letterSpacing,
            fontWeight: FontWeight.w700,
            fontsize: 20,
          ),
        ),
      ),
    );
  }
}

class CustomText extends Text {
  String? title;
  double? letterSpacing;
  Color? color;
  double? fontsize;
  FontWeight? fontWeight;
  CustomText(
      {this.title,
      this.letterSpacing,
      this.color,
      this.fontsize,
      this.fontWeight})
      : super('');
  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      textAlign: textAlign,
      style: TextStyle(
          letterSpacing: letterSpacing,
          color: color,
          fontFamily: "Poppins",
          fontWeight: fontWeight,
          fontSize: fontsize),
    );
  }
}

class CustomTextField extends StatelessWidget {
  double? letterSpacing;
  Color? cursorcolor;
  Color? color;
  Color enabled_color;
  double? fontsize;
  EdgeInsets? margin;
  FontWeight? fontWeight;
  String? hint_text;
  InputDecoration? decoration;
  TextEditingController? controller;
  bool obscureText;
  bool filled;
  var onChanged;
  var validator;
  CustomTextField(
      {this.letterSpacing,
      this.cursorcolor,
      this.color,
      this.margin,
      this.fontsize,
      this.fontWeight,
      this.hint_text,
      this.decoration,
      this.controller,
      this.validator,
      this.onChanged,
      required this.enabled_color,
      required this.obscureText,
      required this.filled});
  @override
  Widget build(BuildContext context) {
    return Container(
       margin: margin,
      child: TextFormField(
        cursorColor: cursorcolor,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        style: TextStyle(
            color: color,
            fontWeight: fontWeight,
            fontFamily: "Poppins",
            fontSize: 17,
            letterSpacing: 1.0),
        decoration: new InputDecoration(
            filled: filled,
            hintStyle: TextStyle(
              fontSize: 14,
              letterSpacing: 1.3,
              fontFamily: "Poppins",
            ),
            hintText: hint_text,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: enabled_color, width: 1.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.5)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.5),
            )),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}