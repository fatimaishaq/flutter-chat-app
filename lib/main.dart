//import 'package:flashchat/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat/firebase_options.dart';
import 'package:flashchat/routes.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/Screens/welcome_screen.dart';
//import 'package:go_router/go_router.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flashchat/screens/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //     bodyMedium: TextStyle(color: Colors.black),
      //   ),
      // ),
      //routerConfig: Routing.router,
      initialRoute: WelcomeScreen.id,
      routes: Routes.routes,
    );
  }
}
