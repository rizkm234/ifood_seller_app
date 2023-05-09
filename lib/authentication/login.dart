import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifood_seller_app/global/global.dart';
import 'package:ifood_seller_app/main%20screens/home_screen.dart';
import 'package:ifood_seller_app/widgets/error_dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_textField.dart';
import '../widgets/loading_dialog.dart';
import 'auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation(){
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      loginNow();
    }else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please enter valid data",
            );
          });
    }
  }

  loginNow ()async{
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Checking Data",
          );
        });
    User? currentUser ;
    await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    ).then((auth) {
      currentUser = auth.user!;
    }).catchError((err){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: err.message.toString(),
            );
          });
    });
    if (currentUser != null){
      readDataAndSetDataLocally(currentUser!);
    }

  }

  Future readDataAndSetDataLocally(User currentUser)async{
    await FirebaseFirestore.instance.collection('sellers')
        .doc(currentUser.uid)
        .get().then((snapshot)async{
      if(snapshot.exists){
        await sharedPreferences!.setString('uid', currentUser.uid);
        await sharedPreferences!.setString('name', snapshot.data()!['sellerName']);
        await sharedPreferences!.setString('photoUrl', snapshot.data()!['sellerAvatarUrl']);
        await sharedPreferences!.setString('phone', snapshot.data()!['phone']);
        await sharedPreferences!.setString('email', snapshot.data()!['sellerEmail']);
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
      }else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const AuthScreen()));
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: 'No account exists for this data, Sign up please.',
              );
            });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // const SizedBox(height: 10,),
          Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'images/seller.png',
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                ),
              )),
          Form(
            key: _formKey,
              child: Column(
              children: [
              CustomTextField(
                controller: emailController,
                data: Icons.mail,
                hintText: 'Email',
                isObscure: false,
                enabled: true,
              ),
              CustomTextField(
                controller: passwordController,
                data: Icons.lock,
                hintText: 'Password',
                isObscure: true,
                enabled: true,
              ),
            ],
          )),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
            child: const Text(
              'Log in',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
