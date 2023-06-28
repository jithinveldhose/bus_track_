import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'home.dart';


class OtpScreen extends StatefulWidget {

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  final TextEditingController _thirdController = TextEditingController();
  final TextEditingController _fourthController = TextEditingController();
  final TextEditingController _fifthController = TextEditingController();
  final TextEditingController _sixthController = TextEditingController();
  List<String> otpValues = List.filled(6, '');
  String? otpCode;
  final String verificationId = Get.arguments[0];
  FirebaseAuth auth = FirebaseAuth.instance;

   @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    _fifthController.dispose();
    _sixthController.dispose();
    super.dispose();
  }


  // verify otp
  void verifyOtp(
      String verificationId,
      String userOtp,
      ) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await auth.signInWithCredential(creds)).user;
      if (user != null) {
        Get.to(const HomePage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        e.message.toString(),
        "Failed",
        colorText: Colors.white,
      );
    }
  }

  // login
  void _login() {
    if (otpCode != null) {
      verifyOtp(verificationId, otpCode!);
    } else {
      Get.snackbar(
        "Enter 6-Digit code",
        "Failed",
        colorText: Colors.white,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Color(0xFFFFF5F1F),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.06,
              ),
              Image.asset(
                'assets/images/otp.png',
                width: screenWidth * 0.8,
              ),
              SizedBox(
                height: screenHeight * 0.12,
              ),
              // otp input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [ Pinput(
              length: 6,
              showCursor: true,
              defaultPinTheme: PinTheme(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color(0xFFEB4335),
                  ),
                ),
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              onCompleted: (value) {
                setState(() {
                  otpCode = value;
                });
              },
              ),]
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '00:30',
                      style: TextStyle(
                        color: Color(0xFFFFFAF8F),
                      ),
                    ),
                    Text(
                      'Resend OTP',
                      style: TextStyle(
                          color: Color(0xFFF3E3E3E),
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.7,
                child: ElevatedButton(
                  onPressed:_login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5F1F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}