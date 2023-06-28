import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'otp.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        // authentication successful, do something
      },
      verificationFailed: (FirebaseAuthException e) {
        // authentication failed, do something
      },
      codeSent: (String verificationId, int? resendToken) async {
        // code sent to phone number, save verificationId for later use
        String smsCode = ''; // get sms code from user
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        Get.to(OtpScreen(), arguments: [verificationId]);
        await auth.signInWithCredential(credential);
        // authentication successful, do something
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


  //country code

   Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
  
  //user login
  void _userLogin() async {
    String mobile = phoneController.text;
    if (mobile == "") {
      Get.snackbar(
        "Please enter the mobile number!",
        "Failed",
        colorText: Colors.white,
      );
    } else {
      signInWithPhoneNumber("+${selectedCountry.phoneCode}$mobile");
    }
  }

   @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
     phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.1,
              ),
              Image.asset(
                'assets/images/loginbanner.png',
                width: screenSize.width * 0.9,
              ),
              SizedBox(height: screenSize.height * 0.07),
              Container(
                height: screenSize.height * 0.06,
                margin:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
                child:  TextFormField(
                  controller:phoneController ,
                  keyboardType: TextInputType.number,
                   onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Mobile No',
                    labelStyle:const TextStyle(
                      color: Color(0xFFFA0A0A0),
                      fontWeight: FontWeight.w500,
                    ),
                     filled: true,
                    enabledBorder:const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEB4335),
                      ),
                    ),
                    focusedBorder:const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEB4335),
                      ),
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 550,
                              ),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              SizedBox(
                height: screenSize.height * 0.05,
                width: screenSize.width * 0.7,
                child: ElevatedButton(
                  onPressed:_userLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5F1F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Text('Login'),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.04,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: screenSize.width * 0.2,
                        right: screenSize.width * 0.03,
                      ),
                      child:const Divider(
                        color: Color(0xFFFFFAF8F),
                        height: 10,
                      ),
                    ),
                  ),
                const  Text(
                    "OR",
                    style: TextStyle(color: Color(0xFFFEB4335)),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: screenSize.width * 0.03,
                        right: screenSize.width * 0.2,
                      ),
                      child: Divider(
                        color: Color(0xFFFFFAF8F),
                        height: 10,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'sign up With Google',
                  style: TextStyle(
                    fontSize: screenSize.height * 0.02,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFF000000),
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              CircleAvatar(
                radius: screenSize.height * 0.015,
                backgroundImage: AssetImage('assets/images/googlelogo.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}