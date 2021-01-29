import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/Professor/NewProfessorScreen.dart';
import 'package:panel_admin_food_origin/Professor/faculty_screen.dart';

import 'Professor/Professor_screen.dart';
import 'event/event_details_screen.dart';
import 'event/events_screen.dart';
import 'event/users_screen.dart';
import 'food/food_details_screen.dart';
import 'food/history_screen.dart';
import 'screens/login_screen.dart';
import 'constants.dart';
import 'food/new_food_screen.dart';
import 'screens/registeration_screen.dart';
import 'screens/home_screen.dart';
import 'food/food_screen.dart';
import 'food/request_screen.dart';
import 'screens/guide_screen.dart';
import 'models/detailProfessor.dart';

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
        NewProfessorScreen.id : (context) => NewProfessorScreen(),
        DetailPageProfessor.id : (context) => DetailPageProfessor(),
        ProfessorList.id : (context) => ProfessorList(),
        FacultyScreen.id : (context) => FacultyScreen(),
        guide.id   :(context) => guide(),
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

