import 'package:flashchat/Screens/login_screen.dart';
import 'package:flashchat/Screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../Components/rounded_button.dart';
//import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: 2),
        vsync: this,
        //upperBound: 100.0,
    );
    //animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    controller.forward();
    // animation.addStatusListener((status){
    //   if(status == AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }else if (status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });
    controller.addListener((){
      setState(() {
      });
      //print(controller.value);
    });
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
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                      ),
                      speed: Duration(milliseconds: 120),
                    )
                  ],
                  repeatForever: true,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
                //context.go('/login');
              },
              btnClr: Colors.lightBlueAccent,
              btnText: 'Log In',
            ),
            RoundedButton(
                btnClr: Colors.blueAccent,
                btnText: 'Register',
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id );
                  //context.go('/register');
                },
            ),

          ],
        ),
      ),
    );
  }
}


