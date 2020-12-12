import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/lib/components/food_history_item.dart';
import 'package:panel_admin_food_origin/lib/components/food_request_item.dart';
import 'package:panel_admin_food_origin/lib/models/food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constants.dart';

class HistoryScreen extends StatefulWidget {
  static String id = 'history_screen';

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String token,
      date,
      url = '$baseUrl/api/food/admin/order_history/all',
      historyUrl = '$baseUrl/api/food/admin/order_history';
  DateTime selectedDate = DateTime.now();
  int userId;

  showCalendarDialog() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = selectedDate.toString().substring(0, 10);
        print(selectedDate);
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
    if (date == null) {
      date = selectedDate.toString().substring(0, 10);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "غذاهای فروخته شده",
          style: TextStyle(color: Colors.white, fontSize: 23.0),
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
        backgroundColor: Colors.purple.shade300,
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
                  future: http.get('$historyUrl?date=$date', headers: {
                    HttpHeaders.authorizationHeader: token,
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      http.Response response = snapshot.data;
                      if (response.statusCode >= 400) {
                        print(response.statusCode);
                        print(response.body);
                        print('$historyUrl?date=$date');
                        return Center(
                          child: Text(
                            'مشکلی درارتباط با سرور پیش آمد',
                            style: TextStyle(fontSize: 20),
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
                        } else {
                          listFood[index].totalCount += each['total_count'];
                          listFood[index].remainingCount +=
                              each['remaining_count'];
                        }
                      }
                      print('***************************');
                      for (var each in listFood) {
                        print(each.name);
                      }

                      if (listFood.length == 0) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'غذایی فروخته نشده !!!',
                                style: TextStyle(fontSize: 20),
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
                                label: Text('تقویم', style: TextStyle(color: Colors.white),),
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
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${listFood[index].name}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'تعداد کل: ${listFood[index].totalCount}',
                                ),
                                Text(
                                  'فروش کل: ${(listFood[index].totalCount - listFood[index].remainingCount) * (listFood[index].cost)} تومان',
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'تعداد فروش یافته: ${listFood[index].totalCount - listFood[index].remainingCount} ',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'تعداد باقی مانده: ${listFood[index].remainingCount} ',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
            } else {
              return Center(child: CircularProgressIndicator());
            }
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
