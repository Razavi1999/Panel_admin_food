import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jalali_calendar/jalali_calendar.dart';
import 'package:panel_admin_food_origin/components/AwesomeListItem.dart';
import 'package:panel_admin_food_origin/components/EmptyEffect.dart';
import 'package:panel_admin_food_origin/components/OrderCard.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:persian_date/persian_date.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'new_professor_screen.dart';
import 'professor_screen.dart';

var COLORS = [
  Color(0xFFB892FF),
  Color(0xFFB892FF),
  Color(0xFFFFC2E2),
  Color(0xFFB892FF),
  Color(0xFFB892FF)
];

class FacultyScreen extends StatefulWidget {
  static String id = "Faculty_screen";

  @override
  _FacultyScreenState createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  String token, url = "$baseUrl/api/professors/faculties/";
  int userId;

  ///*********************************/

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // token = 'Token 965eee7f0022dc5726bc4d03fca6bd3ffe756a1f';
    userId = prefs.getInt('user_id');
    print(token);
    return prefs.getString('token');
  }

  Future<bool> _refresh() async {
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(
          "دانشکده های دانشگاه",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: PersianFonts.Shabnam.copyWith(
              color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refresh();
        },
        child: Container(
          decoration: BoxDecoration(
              /*image: DecorationImage(
              fit: BoxFit.cover,
              image : AssetImage("assets/images/ahmad_12.jpg",
              ),
            )*/
              ),
          child: FutureBuilder(
            future: getToken(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                print(url);
                //return SizedBox(height: 10,);
                return FutureBuilder(
                  future: http.get('${url}', headers: {
                    HttpHeaders.authorizationHeader: token,
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      http.Response response = snapshot.data;
                      if (response.statusCode >= 400) {
                        print("response StatusCode : " +
                            response.statusCode.toString());

                        return Center(
                          child: Text(
                            'مشکلی درارتباط با سرور پیش آمد',
                            style: PersianFonts.Shabnam.copyWith(fontSize: 20),
                          ),
                        );
                      }
                      var jsonResponse = convert
                          .jsonDecode(convert.utf8.decode(response.bodyBytes));

                      List<Map> mapList = [];
                      int count = 0;

                      for (Map map in jsonResponse) {
                        count++;
                        mapList.add(map);
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: count,
                        itemBuilder: (context, index) {
                          // mapList[index]['image'] =   mapList[index]['image'];

                          //print( "image : " + mapList[index]['image']);
                          //print( "name : " + mapList[index]['name']);

                          return AwesomeListItem(
                            title: mapList[index]['name'],
                            //cost: mapList[index]['cost'],
                            //content: mapList[index]['description'],
                            image: mapList[index]['image'],
                            color: COLORS[Random().nextInt(5)],
                            onPressed: () {
                              _navigateToProfessorListScreen(
                                  mapList[index]['id']);
                            },
                          );
                        },
                      );
                      return SizedBox();
                    } else {
                      return Center(
                          child: SpinKitWave(
                        color: kPrimaryColor,
                      ));
                    }
                  },
                );
              } else {
                return Center(
                    child: SpinKitWave(
                  color: kPrimaryColor,
                ));
              }
            },
          ),
        ),
      ),
    );
  }

  _navigateToProfessorListScreen(int facultyid) {
    Navigator.pushNamed(
      context,
      ProfessorList.id,
      arguments: {
        'facultyid': facultyid,
        'token': token,
      },
    );
  }
}
