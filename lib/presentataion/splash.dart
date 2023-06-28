import 'package:flutter/material.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
      Future.delayed(Duration(seconds:3)).then((value) {
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
      });
  }
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        child: Center(
          child:Image.asset('assets/images/logo.png',width: _mediaQuery.size.width*0.75,),
        ),
      ),
    );
  }
}