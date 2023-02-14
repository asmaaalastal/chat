
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/notifications_screen.dart';
import 'package:chat/screens/registration_screen.dart';
import 'package:chat/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async{
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic("breaking_news");
  runApp(FlashChat());
  }

void getFcm() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcm token $fcmToken');

}
class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getFcm();
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      // '/' ,
      routes: {
        // '/':(context) => WelcomeScreen(),
        // '/login':(context) => LoginScreen(),
        // '/register':(context)=> RegistrationScreen(),
        WelcomeScreen.id :(context) => WelcomeScreen(),
        LoginScreen.id :(context) => LoginScreen(),
        Notifications.id :(context) => Notifications(),
        RegistrationScreen.id :(context)=> RegistrationScreen(),
        ChatScreen.id :(context)=> ChatScreen(),
      },
    );
  }


}
