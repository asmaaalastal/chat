
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_btn.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const  id = "welcomeScreen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
 late AnimationController controller;
 Duration duration = const Duration(seconds: 1);
 late Animation animation;
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if(user != null){
        Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id,(route)=> false);
      }
    });
    controller = AnimationController(vsync: this, duration: duration);
    print(controller.value);
    controller.forward();
    controller.addListener(() {
      print(controller.value);
      setState(() { });

    });
    animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = ColorTween(begin: Colors.red,end: Colors.white).animate(controller);
    animation.addListener(() {
      setState(() { });
      print(animation.status);
    });
    print(controller.status);
    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //     controller.reverse();
    //   }
    //   if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: controller.value * 100,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                //  const Text(
                //   'Chat App',
                //   style: TextStyle(
                //     fontSize: 45.0,
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),
                 AnimatedTextKit(
                   repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText('Chat App',
                        textStyle: const TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.black
                        ),
                          speed: Duration(milliseconds: 500),
                        ),
                      ],
                    ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            MyBtn(color: Colors.lightBlueAccent, text: "Log In", onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            }),
            MyBtn(color: Colors.blueAccent, text: "Register", onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            })
          ],
        ),
      ),
    );
  }
}
