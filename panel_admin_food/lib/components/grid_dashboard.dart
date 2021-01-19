
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panel_admin_food_origin/Professor/faculty.dart';
import 'file:///D:/FlutterProjects/admin/panel_admin_food/lib/event/event_details_screen.dart';
import 'file:///D:/FlutterProjects/admin/panel_admin_food/lib/event/events_screen.dart';
import 'package:panel_admin_food_origin/screens/guide_screen.dart';
import 'package:panel_admin_food_origin/screens/login_screen.dart';
import 'package:persian_fonts/persian_fonts.dart';


import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../constants.dart';
import '../food/food_screen.dart';
import '../screens/home_screen.dart';



class GridDashboard extends StatelessWidget {
  final BuildContext context;
  final String username, token, firstName, lastName;
  final int user_id;

  GridDashboard(this.context, this.user_id, this.token,
      this.username, this.firstName, this.lastName);


  Items item1 = new Items(
    title: "سامانه تغذیه",
    subtitle: "اتوماسیون سلف آزاد",
    img: "assets/images/food.png",
    dest: OrderPage.id,
    b: false
  );

  Items item2 = new Items(
    title: "ثبت نام در رویدادها",
    subtitle: "رویداد برای تحکیم فردا",
    img: "assets/images/Event.png",
    dest: EventScreen.id,
      b: false
  );

  Items item3 = new Items(
    title: "خروج از برنامه",
    subtitle: "" ,
    img: "assets/images/shut_down.png",
    b:  true

  );

  Items item4 = new Items(
    title: "راهنمای برنامه" ,
    subtitle: "توضیحات برنامه",
    img: "assets/images/question.png",
    b : false,
    dest:guide.id
  );

  Items item5 = new Items(
      title: "اساتید دانشکده" ,
      subtitle: "زمینه های تحقیقاتی اساتید",
      img: "assets/images/professor.jfif",
      b : false,
      dest:Faculty.id
  );


  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2 , item5 , item4 , item3];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          //childAspectRatio: (itemWidth / itemHeight),
          crossAxisSpacing: 5,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return InkWell(
              onTap: (){
                if(data.b){
                  showlogoutDialog();

                }

                print('user_id : $user_id');
                Navigator.pushNamed(context, data.dest, arguments: {
                  'token': token,
                  'user_id': user_id,
                  'first_name': firstName,
                  'last_name': lastName,
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(color), borderRadius: BorderRadius.circular(20)),
                ///*
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 72,
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      data.title,
                        textAlign: TextAlign.center,
                      style: PersianFonts.Shabnam.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)
                    ),

                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                          textAlign: TextAlign.center,
                          style: PersianFonts.Shabnam.copyWith(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w600
                          )
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                //*/
              ),
            );
          }).toList()),
    );
  }


  showlogoutDialog(){
    showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'خارج می شوید؟ ',
                        textDirection:
                        TextDirection.rtl,
                        style: PersianFonts.Shabnam.copyWith(
                            color: kPrimaryColor ,
                            fontSize: 20
                        ),
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
                    padding:
                    EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [
                        Text(
                          'بله‌',
                          textDirection:
                          TextDirection.rtl,
                          style: PersianFonts.Shabnam.copyWith(
                              color: kPrimaryColor ,
                              fontSize: 18
                          ),
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
                    padding:
                    EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: [
                        Text(
                          'خیر',
                          textDirection:
                          TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: PersianFonts.Shabnam.copyWith(
                              color: kPrimaryColor ,
                              fontSize: 18
                          ),
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

  void logoutApp() async{
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



class Items {
  String title;
  String subtitle;
  String img;
  String dest;
  bool b = false;

  Items({
    this.title,
    this.subtitle,
    this.img,
    this.dest,
    this.b
  });
}


