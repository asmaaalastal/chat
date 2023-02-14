import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_btn.dart';
import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const  id = " loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool showSpinner = false;
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
      body: showSpinner? const Center(
        child: CircularProgressIndicator(),
      ) :
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
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
            MyBtn(color: Colors.lightBlueAccent, text: "Log In", onPressed: ()async{
              if(email !=  null && password != null) {
                setState(() {
                  showSpinner = true;
                });
              try {
                final user = await _auth.signInWithEmailAndPassword(
                    email: email!.trim(), password: password!);
                if (user != null && mounted) {
                  // Navigator.pushNamed(context, ChatScreen.id);
                  Navigator.pushNamedAndRemoveUntil(
                      context, ChatScreen.id, (r) => false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                          'You are logged in ${user.user!.email}',
                          style: const TextStyle(
                              color: Colors.white))));
                }
              }
              catch (e){
                print(e);
              }}
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('There is an error,CHECK Your CREDENTIAL',style: TextStyle(
                            color: Colors.white
                        ))));
              }
            })
          ],
        ),
      ),
    );
  }
}