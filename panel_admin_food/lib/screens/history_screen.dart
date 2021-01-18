import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jalali_calendar/jalali_calendar.dart';
import 'package:panel_admin_food_origin/models/food.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constants.dart';
import 'package:persian_date/persian_date.dart';

class HistoryScreen extends StatefulWidget {
  static String id = 'history_screen';

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String token,
      url = '$baseUrl/api/food/admin/order_history/all',
      historyUrl = '$baseUrl/api/food/admin/order_history';
  int userId;
  ////////////////////////////
  DateTime selectedDate = DateTime.now();
  PersianDate persianDate = PersianDate(format: "yyyy/mm/dd  \n DD  , d  MM  ");
  String _datetime = '';
  String _format = 'yyyy-mm-dd';

  get colorList => [Colors.red , Colors.green];
  ////////////////////////////

  showCalendarDialog()async{
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




  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // token = 'Token 965eee7f0022dc5726bc4d03fca6bd3ffe756a1f';
    userId = prefs.getInt('user_id');
    print(token);
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "غذاهای فروخته شده",
          textAlign: TextAlign.center,
          style: PersianFonts.Shabnam.copyWith(color: Colors.white, fontSize: 23.0),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
          onPressed: () {
            showCalendarDialog();
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Container(
                margin: EdgeInsets.all(20),
                child: FutureBuilder(
                  future: http.get('$historyUrl?date=${selectedDate.toString().substring(0, 10)}', headers: {
                    HttpHeaders.authorizationHeader: token,
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      http.Response response = snapshot.data;
                      if (response.statusCode >= 400) {
                        print(response.statusCode);
                        print(response.body);
                        print('$historyUrl?date=${selectedDate.toString().substring(0, 10)}');
                        return Center(
                          child: Text(
                            'مشکلی درارتباط با سرور پیش آمد',
                            style: PersianFonts.Shabnam.copyWith(fontSize: 20),
                          ),
                        );
                      }
                      var jsonResponse = convert
                          .jsonDecode(convert.utf8.decode(response.bodyBytes));
                      print(jsonResponse);
                      List<Food> listFood = [];

                      for (Map each in jsonResponse) {
                        bool flag = false;
                        int index;
                        for (int i = 0; i < listFood.length; i++) {
                          if (listFood[i].id == each['food_id']) {
                            flag = true;
                            index = i;
                            break;
                          }
                        }
                        if (flag == false) {
                          listFood.add(Food(
                              image: '$baseUrl${each['food_image']}',
                              id: each['food_id'],
                              name: each['food_name'],
                              totalCount: each['total_count'],
                              remainingCount: each['remaining_count'],
                              cost: each['food_cost']));
                        }

                        else {
                          listFood[index].totalCount += each['total_count'];
                          listFood[index].remainingCount +=
                              each['remaining_count'];
                        }
                      }
                      
                      print('***************************');
                      for (var each in listFood)
                        print(each.name);


                      if (listFood.length == 0) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'غذایی فروخته نشده !!!',
                                style: PersianFonts.Shabnam.copyWith(fontSize: 20),
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton.icon(
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                color: kPrimaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  showCalendarDialog();
                                },
                                label: Text('تقویم',
                                  style: PersianFonts.Shabnam.copyWith(color: Colors.white),),
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
                        itemBuilder: (context, index) {
                          Map<String , double> myMap = Map();

                           myMap = {
                            " فروش یافته": double.parse((listFood[index].totalCount - listFood[index].remainingCount).toString()),
                            " باقی مانده": double.parse(listFood[index].remainingCount.toString()),
                          };

                           print("myMap : " + myMap.toString());

                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200]
                                )
                              ],
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Card(
                              shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white,

                              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              elevation: 6,

                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${listFood[index].name}',
                                      textDirection: TextDirection.rtl,
                                      style: PersianFonts.Shabnam.copyWith(
                                          fontSize: 20 ,
                                          color: kPrimaryColor
                                      ),
                                    ),
                                    Text(
                                      'تعداد کل: ${replaceFarsiNumber(listFood[index].totalCount.toString())}',
                                      textDirection: TextDirection.rtl,
                                      style: PersianFonts.Shabnam.copyWith(
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text(
                                      'فروش کل: ${replaceFarsiNumber(((listFood[index].totalCount - listFood[index].remainingCount) * (listFood[index].cost)).toString())} تومان',
                                      textDirection: TextDirection.rtl,
                                      style: PersianFonts.Shabnam.copyWith(
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),

                                    PieChart(
                                      dataMap: myMap,
                                      legendFontColor: Colors.blueGrey[900],
                                      legendFontSize: 11.0,
                                      legendFontWeight: FontWeight.w900,
                                      animationDuration: Duration(milliseconds: 800),
                                      chartLegendSpacing: 7.0,
                                      chartRadius: MediaQuery.of(context).size.width / 3,
                                      showChartValuesInPercentage: true,
                                      showChartValues: true,
                                      //showChartValuesOutside: false,
                                      chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
                                    ),

                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            ' فروش یافته: ${replaceFarsiNumber((listFood[index].totalCount - listFood[index].remainingCount).toString())}',
                                            textDirection: TextDirection.rtl,
                                            style: PersianFonts.Shabnam.copyWith(
                                              color: Colors.red,
                                                fontWeight: FontWeight.w900
                                            ),
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),

                                          Text(
                                            '  باقی مانده  ${replaceFarsiNumber( listFood[index].remainingCount.toString())} ',
                                            textDirection: TextDirection.rtl,
                                            style: PersianFonts.Shabnam.copyWith(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w900
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),



                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: listFood.length,
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            }

            else
              return Center(child: CircularProgressIndicator());

          }),
    );
  }

  onPressed(int orderId) async {
    print(orderId);
    http.Response response = await http.post(
      '$url/?order_id=$orderId',
      headers: {
        HttpHeaders.authorizationHeader: token,
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: convert.json.encode({
        'done': true,
      }),
    );
    if (response.statusCode >= 400) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'مشکلی پیش آمد.',
            textDirection: TextDirection.rtl,
          ),
          content: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('باشه!'),
          ),
        ),
      );
    }
    var jsonResponse = convert.jsonDecode(response.body);
    if (jsonResponse['done'] == true) {
      bool result = await showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'غذا فروخته شد',
            textDirection: TextDirection.rtl,
          ),
          content: FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('باشه!'),
          ),
        ),
      );
      Navigator.pop(context);
    } else {}
  }
}
