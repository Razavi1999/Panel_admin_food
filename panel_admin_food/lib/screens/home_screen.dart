import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panel_admin_food_origin/Professor/faculty_screen.dart';
import 'package:panel_admin_food_origin/components/home_item.dart';
import 'package:panel_admin_food_origin/event/events_screen.dart';
import 'package:panel_admin_food_origin/screens/guide_screen.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as convert;

import '../components/grid_dashboard.dart';
import '../constants.dart';
import '../food/food_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String token, username, firstName, lastName, role;
  int userId;

  Size size;

  AnimationController _controller;
  Animation<double> _animation1;
  Animation<double> _animation2;
  Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    // )..repeat(reverse: true);
    );
    _animation1 = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease
    );
    _animation2 = CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5 ,1.0, curve: Curves.ease)
    );
    _animation3 = CurvedAnimation(
        parent: _controller,
        curve: Interval(0.8 ,1.0, curve: Curves.ease)
    );
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');
    firstName = prefs.getString('first_name');
    lastName = prefs.getString('last_name');
    userId = prefs.getInt('user_id');
    role = prefs.getString('role');
    print(token);
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          return Stack(
            children: [
              Transform.rotate(
                origin: Offset(40, -60),
                angle: 2.4,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 75,
                    top: 40,
                  ),
                  height: size.height * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      colors: [Color(0xff6f35a5), Color(0xFFA885FF)],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/elmos_3.png",
                          width: 72,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Image.asset(
                          "assets/images/logo.png",
                          width: 72,
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 14,
                    ),

                    Text(
                      "اپلیکیشن جامع دانشگاه من",
                      style: PersianFonts.Shabnam.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      " خوش آمدید " + lastName + " " + firstName,
                      //textDirection: TextDirection.rtl,
                      style: PersianFonts.Shabnam.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        //color: Colors.white
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    bodyContainer(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bodyContainer(){
    if(role == null || role.toLowerCase() == 'admin'){
      return Container(
        height: size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _animation1,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, OrderPage.id, arguments: {
                            'token': token,
                            'user_id': userId,
                            'first_name': firstName,
                            'last_name': lastName,
                          });
                        },
                        child: Container(
                          height: size.height * 0.22,
                          width: size.width * 0.45,
                          child: HomeItem(
                            title: "سامانه تغذیه",
                            subtitle: "اتوماسیون سلف آزاد",
                            img: "assets/images/food.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: _animation1,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, EventScreen.id, arguments: {
                            'token': token,
                            'user_id': userId,
                            'first_name': firstName,
                            'last_name': lastName,
                          });
                        },
                        child: Container(
                          height: size.height * 0.22,
                          width: size.width * 0.45,
                          child: HomeItem(
                            title: "سامانه رویدادها",
                            subtitle: "رویداد برای تحکیم فردا",
                            img: "assets/images/Event.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _animation2,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, guide.id, arguments: {
                            'token': token,
                            'user_id': userId,
                            'first_name': firstName,
                            'last_name': lastName,
                          });
                        },
                        child: Container(
                          height: size.height * 0.22,
                          width: size.width * 0.45,
                          child: HomeItem(
                            title: "راهنمای برنامه" ,
                            subtitle: "توضیحات برنامه",
                            img: "assets/images/question.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: _animation2,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, FacultyScreen.id, arguments: {
                            'token': token,
                            'user_id': userId,
                            'first_name': firstName,
                            'last_name': lastName,
                          });
                        },
                        child: Container(
                          height: size.height * 0.22,
                          width: size.width * 0.45,
                          child: HomeItem(
                            title: "اساتید دانشکده" ,
                            subtitle: "زمینه های تحقیقاتی اساتید",
                            img: "assets/images/professor.jfif",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _animation3,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          showLogoutDialog();
                        },
                        child: Container(
                          height: size.height * 0.18,
                          width: size.width * 0.5,
                          child: HomeItem(
                            title: "خروج از برنامه",
                            subtitle: "" ,
                            img: "assets/images/shut_down.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    else if(role.toLowerCase() == 'food_manager'){
      return Container(
        height: size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _animation2,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, OrderPage.id, arguments: {
                            'token': token,
                            'user_id': userId,
                            'first_name': firstName,
                            'last_name': lastName,
                          });
                        },
                        child: Container(
                          height: size.height * 0.22,
                          width: size.width * 0.45,
                          child: HomeItem(
                            title: "سامانه تغذیه",
                            subtitle: "اتوماسیون سلف آزاد",
                            img: "assets/images/food.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: _animation2,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, guide.id, arguments: {
                            'token': token,
                            'user_id': userId,
                            'first_name': firstName,
                            'last_name': lastName,
                          });
                        },
                        child: Container(
                          height: size.height * 0.22,
                          width: size.width * 0.45,
                          child: HomeItem(
                            title: "راهنمای برنامه" ,
                            subtitle: "توضیحات برنامه",
                            img: "assets/images/question.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _animation3,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          showLogoutDialog();
                        },
                        child: Container(
                          height: size.height * 0.18,
                          width: size.width * 0.5,
                          child: HomeItem(
                            title: "خروج از برنامه",
                            subtitle: "" ,
                            img: "assets/images/shut_down.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    else if(role.toLowerCase() == 'event_manager'){
      return Container(
        height: size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _animation2,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, EventScreen.id, arguments: {
                            'token': token,
                            'user_id': userId,
                            'first_name': firstName,
                            'last_name': lastName,
                          });
                        },
                        child: Container(
                          height: size.height * 0.22,
                          width: size.width * 0.45,
                          child: HomeItem(
                            title: "سامانه رویدادها",
                            subtitle: "رویداد برای تحکیم فردا",
                            img: "assets/images/Event.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: _animation2,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, guide.id, arguments: {
                            'token': token,
                            'user_id': userId,
                            'first_name': firstName,
                            'last_name': lastName,
                          });
                        },
                        child: Container(
                          height: size.height * 0.22,
                          width: size.width * 0.45,
                          child: HomeItem(
                            title: "راهنمای برنامه" ,
                            subtitle: "توضیحات برنامه",
                            img: "assets/images/question.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _animation3,
                  child: Container(
                    decoration: kHomeDecoration,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          showLogoutDialog();
                        },
                        child: Container(
                          height: size.height * 0.18,
                          width: size.width * 0.5,
                          child: HomeItem(
                            title: "خروج از برنامه",
                            subtitle: "" ,
                            img: "assets/images/shut_down.png",
                            size: size,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  showLogoutDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'خارج می شوید؟ ',
                        textDirection: TextDirection.rtl,
                        style: PersianFonts.Shabnam.copyWith(
                            color: kPrimaryColor, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, LoginScreen.id);
                    logoutApp();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'بله‌',
                          textDirection: TextDirection.rtl,
                          style: PersianFonts.Shabnam.copyWith(
                              color: kPrimaryColor, fontSize: 18),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    //selectFromGallery();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'خیر',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: PersianFonts.Shabnam.copyWith(
                              color: kPrimaryColor, fontSize: 18),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void logoutApp() async {
    http.Response response;
    response = await http.post(
      "http://danibazi9.pythonanywhere.com/api/account/logout",
      headers: {
        HttpHeaders.authorizationHeader: token,
        "Accept": "application/json",
        "content-type": "application/json",
      },
    );
    print(response.statusCode);
    print(token);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
