import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jalali_calendar/jalali_calendar.dart';
import 'package:panel_admin_food_origin/components/EmptyEffect.dart';
import 'package:panel_admin_food_origin/components/OrderCard.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:persian_date/persian_date.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class FacultyScreen extends StatefulWidget {
  static String id = "Faculty_screen";

  @override
  _FacultyScreenState createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  String token , url = "$baseUrl/api/food/admin/serve/all/";
  int userId;

  ///*********************************/
  DateTime selectedDate = DateTime.now();
  PersianDate persianDate = PersianDate(format: "yyyy/mm/dd  \n DD  , d  MM  ");
  String _datetime = '';
  String _format = 'yyyy-mm-dd';

  /*************************************/

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

  void _showDatePicker() {
    final bool showTitleActions = false;
    DatePicker.showDatePicker(context,
        minYear: 1300,
        maxYear: 1450,
        confirm: Text(
          'تایید',
          style: TextStyle(color: Colors.red),
        ),
        cancel: Text(
          'لغو',
          style: TextStyle(color: Colors.cyan),
        ),
        dateFormat: _format, onChanged: (year, month, day) {
          if (!showTitleActions) {
            _datetime = '$year-$month-$day';
          }
        }, onConfirm: (year, month, day) {
          setState(() {});
          Jalali j = Jalali(year, month, day);
          selectedDate = j.toDateTime();
          print('dateTime is: $selectedDate');
          _datetime = '$year-$month-$day';
          setState(() {
            _datetime = '$year-$month-$day';
            print('time' + _datetime);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        centerTitle: true,

        title: Text("دانشکده های دانشگاه" ,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: PersianFonts.Shabnam.copyWith(
                color: Colors.white, fontSize: 20.0
              ),
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
                  future: http.get(
                      '${url}?date=${selectedDate.toString().substring(0, 10)}',
                      headers: {
                        HttpHeaders.authorizationHeader: token,
                      }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      http.Response response = snapshot.data;
                      if (response.statusCode >= 400) {
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

                      if (count == 0) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              EmptyEffect(
                                child: Icon(
                                  Icons.folder,
                                  size: 55,
                                  color: kPrimaryColor,
                                ),
                                borderColor: kPrimaryColor,
                                outermostCircleStartRadius: 20,
                                outermostCircleEndRadius: 175,
                                numberOfCircles: 4,
                                animationTime: Duration(seconds: 5),
                                delay: Duration(seconds: 6),
                                gap: 30,
                                borderWidth: 20,
                                startOpacity: 0.3,
                              ),
                              /*GifImage(
                                controller: controller,
                                image: AssetImage("images/giphy.webp"),
                              ),*/

                              Text(
                                'غذایی سرو نشده !!!',
                                style:
                                PersianFonts.Shabnam.copyWith(fontSize: 20),
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton.icon(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                color: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  _showDatePicker();
                                },
                                label: Text(
                                  'تقویم',
                                  style: PersianFonts.Shabnam.copyWith(
                                      color: Colors.white),
                                ),
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: count,
                        itemBuilder: (context, index) {
                          //print("maplist : " + mapList.toString());

                          // print('salam : ${mapList[index]['start_serve_time']}');

                          Map<String, double> my_map = Map();

                          my_map['${mapList[index]['start_serve_time']}'] =
                              double.parse(
                                  mapList[index]['remaining_count'].toString());
                          print('my_map' + my_map.toString());
                          print("Hi !!!");

                          return OrderCard(
                            data: my_map,
                            name: mapList[index]['name'],
                            cost: mapList[index]['cost'],
                            description: mapList[index]['description'],
                            image: '$baseUrl${mapList[index]['image']}',
                            onPressed: () {
                              /*navigateToFoodDetailScreen(
                                mapList[index]['serve_id'],
                                mapList[index]['food_id'],
                              );*/
                            },
                          );
                        },
                      );
                      return SizedBox();
                    } else {
                      return Center(
                          child: SpinKitWave(
                            color: kPrimaryColor,
                          )
                      );
                    }
                  },
                );
              }

              else {
                return Center(child: SpinKitWave(
                  color: kPrimaryColor,
                )
                );
              }
            },
          ),
        ),
      ),

    );
  }
}