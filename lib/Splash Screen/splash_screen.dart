import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ifood_seller_app/authentication/auth_screen.dart';
import 'package:ifood_seller_app/global/global.dart';
import 'package:ifood_seller_app/main%20screens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer(){
    Timer(
        const Duration(seconds: 3),
            () async {
              if (firebaseAuth.currentUser == null){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const AuthScreen()));
              }else {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const HomeScreen ()));
              }
            });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('images/splash.jpg'),
            ),

            const SizedBox(
              height: 10,
            ),

            const Padding(
              padding: EdgeInsets.all(18),
              child: Text('Sell Food Online' ,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 40,
                  fontFamily: 'Signatra',
                  letterSpacing: 3,
                ),),
            )
          ],
        ),
      ),
    );
  }
}
