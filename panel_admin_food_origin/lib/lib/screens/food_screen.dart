import 'dart:io';

import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/lib/models/bucket.dart';
import 'package:panel_admin_food_origin/lib/screens/history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../components/OrderCard.dart';
import '../constants.dart';
import 'food_details_screen.dart';
import 'new_food_screen.dart';
import 'request_screen.dart';

class OrderPage extends StatefulWidget {
  static String id = 'Order_screen';

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  String token, url = '$baseUrl/api/food/admin/serve/all/';
  int userId;
  DateTime selectedDate = DateTime.now();

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

  saveToSharedPreferences(String foodName, int count) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map map = {
      'foodName': foodName,
      'count': count,
    };
  }

  showCalendarDialog() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "لیست غذا های موجود امروز",
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
        backgroundColor: Colors.purple.shade300,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refresh();
        },
        child: FutureBuilder(
          future: getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              print(url);
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
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                    var jsonResponse = convert
                        .jsonDecode(convert.utf8.decode(response.bodyBytes));
                    // print(jsonResponse);
                    List<Map> mapList = [];
                    int count = 0;
                    // print(jsonResponse);
                    for (Map map in jsonResponse) {
                      count++;
                      mapList.add(map);
                      // print(map.toString());
                    }
                    if (count == 0) {
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
                      shrinkWrap: true,
                      itemCount: count,
                      itemBuilder: (context, index) {
                        return OrderCard(
                          name: mapList[index]['name'],
                          cost: mapList[index]['cost'],
                          description: mapList[index]['description'],
                          image: '$baseUrl${mapList[index]['image']}',
                          onPressed: () {
                            navigateToFoodDetailScreen(
                              mapList[index]['serve_id'],
                              mapList[index]['food_id'],
                            );
                          },
                        );
                      },
                    );
                    return SizedBox();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToNewFoodScreen();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            TextButton.icon(
              icon: Icon(
                Icons.history,
                color: kPrimaryColor,
              ),
              onPressed: () {
                _navigateToHistoryScreen();
              },
              label: Text(
                'تاریخچه',
                style: TextStyle(
                  color: kPrimaryColor,
                ),
              ),
            ),
            Spacer(),
            TextButton.icon(
              icon: Icon(
                Icons.clear_all,
                color: kPrimaryColor,
              ),
              onPressed: () {
                _navigateToRequestScreen();
              },
              label: Text(
                'درخواست ها',
                style: TextStyle(
                  color: kPrimaryColor,
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
      ),
    );
  }

  _navigateToRequestScreen() async {
    await Navigator.pushNamed(context, RequestScreen.id);
    setState(() {});
  }

  _navigateToHistoryScreen() {
    Navigator.pushNamed(context, HistoryScreen.id);
  }

  navigateToFoodDetailScreen(int serveId, int foodId) {
    Navigator.pushNamed(
      context,
      FoodDetailsScreen.id,
      arguments: {
        'serve_id': serveId,
        'food_id': foodId,
        'date': selectedDate.toString().substring(0, 10),
      },
    );
  }

  _navigateToNewFoodScreen() async {
    await Navigator.pushNamed(context, NewFoodScreen.id);
    setState(() {});
  }
}
