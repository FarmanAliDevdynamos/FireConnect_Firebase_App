// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:login_app/auth_with_phone/verifyOTP.dart';

// class SignInWithPhone extends StatefulWidget {
//   const SignInWithPhone({super.key});

//   @override
//   State<SignInWithPhone> createState() => _SignInWithPhoneState();
// }

// class _SignInWithPhoneState extends State<SignInWithPhone> {
//   TextEditingController phonecontroller = TextEditingController();
//   void sendOTP() async {
//     String phone =  phonecontroller.text.trim();

//     await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: phone,
//         codeSent: (verificationId, resendToken) {
//           Navigator.push(
//               context,
//               CupertinoPageRoute(
//                   builder: (context) => VerifyOTP(
//                         verificationId: verificationId,
//                       )));
//         },
//         verificationCompleted: (credential) {},
//         verificationFailed: (ex) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(ex.code.toString()),
//               backgroundColor: Colors.red,
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (verificationId) {},
//         timeout: const Duration(seconds: 60));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Sign In With Phone',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.lightBlue,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: ListView(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: phonecontroller,
//                     decoration:
//                         const InputDecoration(labelText: 'Phone Number'),
//                     // keyboardType: TextInputType.number,
//                     // inputFormatters: <TextInputFormatter>[
//                     //   FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
//                     // ],
//                   ),
//                   const SizedBox(
//                     height: 35,
//                   ),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor:
//                             WidgetStateProperty.all<Color>(Colors.lightBlue),
//                         shape: const WidgetStatePropertyAll<
//                                 RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(7))))),
//                     onPressed: () {
//                       sendOTP();
//                     },
//                     child: const Text(
//                       'Sign In',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:login_app/auth_with_phone/verifyOTP.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({super.key});

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  TextEditingController phoneController = TextEditingController();

  void sendOTP() async {
    String phone = '+92${phoneController.text.trim()}';

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => VerifyOTP(
                        verificationId: verificationId,
                      )));
        },
        verificationCompleted: (credential) {
          // Auto verification completed (e.g., on Android)
        },
        verificationFailed: (ex) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ex.message ?? "Verification failed"),
              backgroundColor: Colors.red,
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sign In With Phone',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              ],
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.lightBlue),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              onPressed: sendOTP,
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
