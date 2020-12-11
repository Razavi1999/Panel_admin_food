import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../constants.dart';

class FoodDetailsScreen extends StatefulWidget {
  static String id = 'food_details_screen';

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int count = 0;
  bool isVisible;
  TextEditingController controller = TextEditingController();
  Map args;
  String token,
      username,
      text,
      messageText = 'گفت و گو',
      seller_username,
      buyer_username,
      selectedTime;
  int userId, serveId, price, foodId, selectedTimeId;
  bool isBuyer = true;
  String url = '$baseUrl/api/food';
  String timeUrl = '$baseUrl/api/food/times/';

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    //token = prefs.getString('token');
    userId = prefs.getInt('user_id');
    username = prefs.getString('username');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    serveId = args['serve_id'];
    foodId = args['food_id'];
    isVisible = args['isVisible'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        actions: [
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(
          ' جزئیات غذا',
          style: const TextStyle(
              fontFamily: 'Lemonada_Regular',
              color: Colors.white,
              //fontFamily: 'EastSeaDokdo',
              fontWeight: FontWeight.w500, fontSize: 50.0),
        ),
      ),
      body: FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            print('${url}/?food_id=$foodId');
            return SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: http.get('${url}/?food_id=$foodId',
                        headers: {HttpHeaders.authorizationHeader: token}),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        http.Response response = snapshot.data;
                        print('***************************');
                        print(response.body);
                        print('***************************');
                        List result = convert.jsonDecode(
                            convert.utf8.decode(response.bodyBytes));
                        price = result[0]['cost'];
                        count = 0;
                        for (var each in result){
                          count++;
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                child: Center(
                                  child: Banner(
                                    color: Colors.purple.shade100,
                                    message: result[0]['food']['cost'].toString(),
                                    location: BannerLocation.bottomEnd,
                                    child: FadeInImage(
                                      height: 250,
                                      width: 250,
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                          'assets/images/book-1.png'),
                                      image: NetworkImage(
                                        '$baseUrl' + result[0]['food']['image'],
                                      ),
                                    ),
                                  ),
                                ),
                                height: 200,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'نام غذا',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 39 ,
                                        fontFamily: 'Lemonada_Regular',
                                      ),
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      result[0]['food']['name'],
                                      style: TextStyle(
                                        fontSize: 29,
                                        fontFamily: 'Lemonada_Regular',
                                      ),
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 19,
                                    ),
                                    Text(
                                      result[0]['food']['cost'].toString() + ' تومان',
                                      style: TextStyle(
                                          fontSize: 32,
                                        fontFamily: 'Lemonada_Regular',
                                      ),
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'محتویات',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Lemonada_Regular',
                                            fontSize: 29),
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child : Text(
                                        result[0]['food']['description'],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Lemonada_Regular',
                                        ),
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                      ),

                                    )

                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: count,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shadowColor: kPrimaryColor,
                                    margin: EdgeInsets.only(
                                        bottom: 10, left: 20, right: 20),
                                    color: Colors.yellowAccent.shade100,
                                    elevation: 25,
                                    child: ListTile(
                                      title: Text(
                                        result[index]
                                        ['start_serve_time'] +
                                            ' تا ' +
                                            result[index]
                                            ['end_serve_time'],
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontFamily: 'Lemonada_Regular',
                                          fontSize: 30
                                        ),
                                      ),
                                      leading: Text(
                                          'تعداد باقیمانده: ${result[index]['remaining_count'].toString()}',
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontFamily: 'Lemonada_Regular',
                                            fontSize: 25
                                          ),
                                      ),
                                    ),
                                  );
                                  return SizedBox();
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _showDialog(String title) async {
    var result = await showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          title,
          textDirection: TextDirection.rtl,
        ),
        content: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'باشه !',
            style: TextStyle(color: kPrimaryColor),
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
    Navigator.pop(context, true);
  }

  _showTimesDialog() async {
    http.Response response = await http.get(timeUrl);
    var jsonResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    List<Map> mapList = [];
    int count = 0;
    for (Map each in jsonResponse) {
      count++;
      mapList.add(each);
    }
    if (count == 0) {
      showDialog(
        context: context,
        child: AlertDialog(
          content: Center(
            child: Text('بازه ی زمانی وجود ندارد'),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: 400,
            width: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectedTimeId = mapList[index]['id'];
                    setState(() {
                      selectedTime = mapList[index]['start_time'] +
                          ' تا ' +
                          mapList[index]['end_time'];
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          mapList[index]['start_time'] +
                              ' تا ' +
                              mapList[index]['end_time'],
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  cancelDialog() async {
    var result = await showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          'آیا مطمین از لغو رزرو هستید ؟',
          textDirection: TextDirection.rtl,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'آره',
                style: TextStyle(color: Colors.green),
              ),
            ),
            SizedBox(
              width: 50,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'نه',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
    if (result == true) {}
  }
}
