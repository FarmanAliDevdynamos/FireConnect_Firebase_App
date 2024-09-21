import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/auth_with_phone/signin_with_phone.dart';
import 'package:login_app/firebase_options.dart';
import 'package:login_app/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore firestore = FirebaseFirestore.instance;

// // Add Data In FireStore
//   // QuerySnapshot snapshot =
//   //     await FirebaseFirestore.instance.collection('users').get();
//   // for (var doc in snapshot.docs) {
//   //   print(doc.data().toString());
//   // }

//   Map<String, dynamic> newuserData = {
//     "name": "Imran Khan",
//     "email": "imrankhan@gmail.com",
//   };
//   // await _firestore.collection("users").doc("Your_id_here").set(newuserData); await _firestore.collection("users").add(newuserData); to add data with automatically generated id
//   await _firestore
//       .collection("users")
//       .doc("Your_id_here")
//       .update({'email': 'imrankhan@yahoo.com'});

//   print("User Updated ");

//   await _firestore.collection("users").doc("30BPRlaugLg2CShRGajW").delete();
//   print("User Deleted ");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (FirebaseAuth.instance.currentUser != null)
          ? const HomePage()
          : const SignInWithPhone(),
      //HomeScreen(),
    );
  }
}
