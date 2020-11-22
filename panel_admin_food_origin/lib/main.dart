
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'constants.dart';
import 'screens/registeration_screen.dart';
import 'screens/home_screen.dart';




void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        accentColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        RegisterationScreen.id: (context) => RegisterationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id :(context) => HomeScreen(),
      },
    );
  }
}

