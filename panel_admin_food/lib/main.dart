import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/screens/event_details_screen.dart';
import 'package:panel_admin_food_origin/screens/events_screen.dart';
import 'package:panel_admin_food_origin/screens/users_screen.dart';
import 'screens/food_details_screen.dart';
import 'screens/history_screen.dart';
import 'screens/login_screen.dart';
import 'constants.dart';
import 'screens/new_food_screen.dart';
import 'screens/registeration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/food_screen.dart';
import 'screens/request_screen.dart';

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
        OrderPage.id:(context) => OrderPage(),
        NewFoodScreen.id: (context) => NewFoodScreen(),
        HistoryScreen.id: (context) => HistoryScreen(),
        FoodDetailsScreen.id: (context) => FoodDetailsScreen(),
        RequestScreen.id: (context) => RequestScreen(),
        EventScreen.id: (context) => EventScreen(),
        UsersScreen.id: (context) => UsersScreen(),
        EventDetailsScreen.id: (context) => EventDetailsScreen(),
      },
    );
  }
}

