import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class Authentication {
  String? adminAuthentication(String adminNumber, String otp) {
    String? phoneNumber = "79952";
    String? number = "123456";
    if (adminNumber == phoneNumber && otp == number) {
      return "Admin";
    } else {
      return userAuthentication(adminNumber, otp);
    }
  }

  String? userAuthentication(String usernumber, String otpNumber) {
    List phoneNumbers = ["94404", "89197", "9550", "94410"];
    List otpNumbers = ["9440", "1234", "1597", "2345"];
    if (phoneNumbers.contains(usernumber)) {
      if (otpNumbers.contains(otpNumber)) {
        return "Valid";
      }
    }
    return "not Valid";
  }

  Future<String?> moveToStorage(
      File? imageFile, String? selecteditem, String text) async {
    if (imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref("Profile_images/")
          .child(selecteditem! + ".jpeg");
      await ref.putFile(imageFile);
      var url = await ref.getDownloadURL();
      return url;
    }
  }

  bank_details(File? imageFile, name) async {
    if (imageFile != null) {
      final ref =
          FirebaseStorage.instance.ref("Pan_images/").child(name! + ".jpeg");
      await ref.putFile(imageFile);
      var url = await ref.getDownloadURL();
      return url;
    }
  }

  proofs(File? imagePath, proof, name) async {
    if (imagePath != null) {
      final ref =
          FirebaseStorage.instance.ref("details/$name").child(name! + ".jpeg");
      await ref.putFile(imagePath);
      var url = await ref.getDownloadURL();
      return url;
    }
  }

  Future<DocumentSnapshot?> bank_inf(String? phonenumber) async {
    var details =
        await FirebaseFirestore.instance.collection("bank_details").get();
    var id;
    for (int i = 0; i < details.docs.length; i++) {
      id = details.docs[i].id;
      if (id != null && details.docs[i].get("phonenumber") == phonenumber) {
        if (details.docs[i].exists) {
          var bankDetails = await FirebaseFirestore.instance
              .collection("bank_details")
              .doc(id)
              .get();
          return bankDetails;
        }
      } else {
        if (!details.docs[i].exists) {
          return null;
        }
      }
    }
  }

  Future<DocumentSnapshot?> investments(String? phonenumber) async {
    var investments =
        await FirebaseFirestore.instance.collection("Investments").get();
    for (int i = 0; i < investments.docs.length; i++) {
      if (investments.docs[i].get("phonenumber") == phonenumber) {
        var id = investments.docs[i].id;
        var invest = await FirebaseFirestore.instance.collection("Investments").doc(id).get();
        return invest;
      }
    }
     return null;
  }

  Future<DocumentSnapshot?>? users(String? phonenumber) async {
    var id;
    var User = await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < User.docs.length; i++) {
      id = User.docs[i].id;
      if (id != null && User.docs[i].get('mobilenumber') == phonenumber) {
        if (User.docs[i].exists) {
          var details = await FirebaseFirestore.instance
              .collection("Users")
              .doc(id.toString())
              .get();
          return details;
        }
      }
    }
  }

  Future<DocumentSnapshot?> get_invests(String? username) async {
    var id;
    var investments =
        await FirebaseFirestore.instance.collection("Investments").get();
    for (int j = 0; j < investments.docs.length; j++) {
      if (username == investments.docs[j].get("username")) {
        id = investments.docs[j].id;
        return FirebaseFirestore.instance
            .collection("Investments")
            .doc(id)
            .get();
      }
    }

    if (id == null) {
      return null;
    }
    return null;
  }


  Stream<DocumentSnapshot>? get_profit() async* {
    var dates = DateFormat('yyy-dd-MMM').format(DateTime.now());
    var profit =
        await FirebaseFirestore.instance.collection("Admin").doc(dates).get();
    yield profit;
  }

  Future<DocumentSnapshot?> get_curentgains(String? phonenumber) async {
    var id;
    var bank_details =
        await FirebaseFirestore.instance.collection("bank_details").get();
    for (int i = 0; i < bank_details.docs.length; i++) {

      if (bank_details.docs[i].get("phonenumber") == phonenumber) {
        id = bank_details.docs[i].get("username");
      }
    }
    if (id != null) {
      return await FirebaseFirestore.instance
          .collection("Current_gains")
          .doc(id.toString())
          .get();
    }
    return null;
  }

 Future<String?> movetoinvestements(image_url, name) async {
    if (image_url != null) {
      final ref =
      FirebaseStorage.instance.ref("details/$name").child(name! + ".jpeg");
      await ref.putFile(image_url);
      var url = await ref.getDownloadURL();
      return url;
    }
  }

  Future<String>username(String? phonenumber) async {
    var username;
    var bank_details =
        await FirebaseFirestore.instance.collection("bank_details").get();
    for (int i = 0; i < bank_details.docs.length; i++) {
      if (bank_details.docs[i].get("phonenumber") == phonenumber) {
        username = bank_details.docs[i].get("username");
      }
    }
     return username;
  }
}
