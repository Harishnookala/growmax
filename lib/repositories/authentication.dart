import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Authentication {
  String? adminAuthentication(String admin_number,String otp) {
    String? phone_number = "79952";
    String? number = "123456";
    if (admin_number == phone_number && otp == number) {
      return "Admin";
    }
    else{
      return userAuthentication(admin_number, otp);
    }
  }
  String?userAuthentication(String usernumber,String otp_number){
    List phone_numbers =["94404","89197","9550","94410"];
    List otp_numbers = ["9440","1234","1597","2345"];
    if(phone_numbers.contains(usernumber)){
      if(otp_numbers.contains(otp_number)){
        return "Valid";
      }
    }
    return "not Valid";
  }

  Future<String?> moveToStorage(
      File? imageFile, String? selecteditem, String text) async {
    print(selecteditem);
    if (imageFile != null) {
      final ref = FirebaseStorage.instance.ref("Profile_images/").child(selecteditem!+".jpeg");
      await ref.putFile(imageFile);
      print(ref);
      var url = await ref.getDownloadURL();
      return url;
    }
  }

  bank_details(File? imageFile, name) async {
    if (imageFile != null) {
      final ref = FirebaseStorage.instance.ref("Pan_images/").child(name!+".jpeg");
      await ref.putFile(imageFile);
      print(ref);
      var url = await ref.getDownloadURL();
      return url;
    }
  }

  proofs(File? image_path, proof, name) async {
    if (image_path != null) {
      final ref = FirebaseStorage.instance.ref("details/$name").child(name!+".jpeg");
      await ref.putFile(image_path);
      print(ref);
      var url = await ref.getDownloadURL();
      return url;
    }
  }
}