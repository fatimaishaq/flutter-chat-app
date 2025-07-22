import 'package:flashchat/Screens/chat_screen.dart';
import 'package:flashchat/Screens/login_screen.dart';
import 'package:flashchat/Screens/welcome_screen.dart';
import 'package:flashchat/Screens/registration_screen.dart';
import 'package:flutter/material.dart';

class Routes{
  static Map<String,WidgetBuilder> routes = {
    WelcomeScreen.id : (context) => WelcomeScreen(),
    LoginScreen.id : (context) => LoginScreen(),
    RegistrationScreen.id : (context) => RegistrationScreen(),
    ChatScreen.id: (context) => ChatScreen()
  };
}