import 'dart:io';

import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/lib/components/food_history_item.dart';
import 'package:panel_admin_food_origin/lib/components/food_request_item.dart';
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

  String token, date, url='$baseUrl/api/food/admin/order_history/all';
  DateTime selectedDate = DateTime.now();
  int userId;

  showCalendarDialog()async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = selectedDate.toString().substring(0,10);
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
    if(date == null){
      date = selectedDate.toString().substring(0,10);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تاریخچه غذا های فروخته شده",
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
      body: FutureBuilder(
          future: getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return FutureBuilder(
                  future: http.get('$url/?date=$date', headers: {
                    HttpHeaders.authorizationHeader: token,
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      http.Response response = snapshot.data;
                      if (response.statusCode >= 400) {
                        print(response.statusCode);
                        print(response.body);
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
                      List<Map> mapList = [];
                      int count = 0;
                      // print(jsonResponse);
                      for (Map map in jsonResponse) {
                        count++;
                        mapList.add(map);
                        // print(map.toString());
                      }
                      if (count == 0) {
                        return Container(
                          child: Center(
                            child: Text('غذایی در تاریخ  ' + date + ' فروخته نشده.', textDirection: TextDirection.rtl,),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          List items = mapList[index]['items'];
                          List foodNames = [];
                          List foodCounts = [];
                          int counter = 0;
                          for (var each in items) {
                            foodNames.add(each["name"]);
                            foodCounts.add(each["count"]);
                            counter++;
                          }
                          return FoodHistoryItem(
                            name: mapList[index]['customer_username'],
                            student_number: mapList[index]
                            ['customer_student_id'],
                            price: mapList[index]['total_price'],
                            requestId: mapList[index]['order_id'],
                            foodCounts: foodCounts,
                            foodNames: foodNames,
                            counter: counter,
                          );
                        },
                        itemCount: count,
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  });
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
    if(response.statusCode >= 400){
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('مشکلی پیش آمد.', textDirection: TextDirection.rtl,),
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
          title: Text('غذا فروخته شد', textDirection: TextDirection.rtl,),
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
