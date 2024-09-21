import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_app/homepage.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key, required this.verificationId});

  final String verificationId;

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otpcontroller = TextEditingController();

  void verifyOTP() async {
    String opt = otpcontroller.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: opt);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ex.code.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Verify OTP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    maxLength: 6,
                    controller: otpcontroller,
                    decoration:
                        const InputDecoration(labelText: 'Six-digit OTP'),

                    // keyboardType: TextInputType.number,
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.allow(r'[0-9]')
                    // ],
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.allow(
                    //     RegExp(r'[0-9+]'),
                    //   ),
                    // ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.lightBlue),
                        shape: const WidgetStatePropertyAll<
                                RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))))),
                    onPressed: () {
                      verifyOTP();
                    },
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
