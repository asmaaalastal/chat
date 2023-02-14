
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_btn.dart';
import '../constants.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const  id = "registrationScreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  void getLoginStates(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if(user != null){
        Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id,(route)=> false);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your email"
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your password"
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
           MyBtn(color: Colors.blueAccent, text: "Register", onPressed: () async{
               if (email != null && password != null) {
               final newUser = await _auth.createUserWithEmailAndPassword(
                   email: email!.trim(), password: password!);
               if (newUser.user != null && mounted) {
                 // Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id,ModalRoute.withName(WelcomeScreen.id));
                 Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id,(route)=>false);

                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                   backgroundColor: Colors.green,
                     content: Text(
                         'You are logged in ${newUser.user!.email}',style: const TextStyle(
                                color: Colors.white
                            ))));
               } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       backgroundColor: Colors.red,
                         content: Text('There is an error',style: TextStyle(
                         color: Colors.white
                     ))));
               }
             }
           })
          ],
        ),
      ),
    );
  }
}
