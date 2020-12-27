import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_fonts/persian_fonts.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../constants.dart';

class FoodDetailsScreen extends StatefulWidget {
  static String id = 'food_details_screen';

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {

  final Map<String, double> my_map = {
    "a": 1.2,
    "b": 2.4,
    "c" : 3.6,
    "d" : 4.8,
    "e" : 6
  };


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
      date,
      selectedTime;
  int userId, serveId, price, foodId, selectedTimeId;
  bool isBuyer = true;
  String url = '$baseUrl/api/food';
  String timeUrl = '$baseUrl/api/food/times/';

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // token = 'Token 965eee7f0022dc5726bc4d03fca6bd3ffe756a1f';
    userId = prefs.getInt('user_id');
    username = prefs.getString('username');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    serveId = args['serve_id'];
    foodId = args['food_id'];
    date=args['date'];
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
          style:  PersianFonts.Shabnam.copyWith(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 30.0),
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
                    future: http.get('${url}/?food_id=$foodId&date=$date',
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

                        for (var each in result)
                          count++;



                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                child: Center(
                                  child: Banner(
                                    color: Colors.purple.shade300,
                                    message: result[0]['food']['cost'].toString(),
                                    location: BannerLocation.bottomEnd,
                                    child: FadeInImage(
                                      height: 150,
                                      width: 150,
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
                                      style: PersianFonts.Shabnam.copyWith(
                                          color: kPrimaryColor,
                                          fontSize: 28),
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
                                      textDirection: TextDirection.rtl,
                                      style: PersianFonts.Shabnam.copyWith(
                                        color: kPrimaryColor,
                                        fontSize: 15
                                      ),
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
                                      height: 20,
                                    ),
                                    Text(
                                      result[0]['food']['cost'].toString() + ' تومان',
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      style: PersianFonts.Shabnam.copyWith(
                                        color: kPrimaryColor,
                                          fontSize: 15
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 5,
                                        ),
                                        child: Text(
                                          'محتویات',
                                          style: PersianFonts.Shabnam.copyWith(
                                              color: kPrimaryColor,
                                              fontSize: 20),
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.right,
                                        ),
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
                                    Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle(fontSize: 12.0),
                                        text: TextSpan(
                                            text: result[0]['food']['description'],
                                            style: PersianFonts.Shabnam.copyWith(
                                                color: kPrimaryColor
                                            )
                                        ),
                                      ),
                                    ),
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


                                  print("start_serve_time : " + result[index]['start_serve_time'].toString());
                                  print("remaining_count  : " + result[index]['remaining_count'].toString());

                                  print("Im here !!!!");
                                  print(my_map.toString());


                                  //my_map['${result[index]['start_serve_time'].toString()}'] = double.parse(result[index]['remaining_count'].toString());

                                  return Card(
                                    shadowColor: Colors.grey[300],
                                    margin: EdgeInsets.only(
                                        bottom: 10, left: 20, right: 20
                                    ),
                                    color: Colors.purple.shade50,
                                    elevation: 4,

                                      child: ListTile(
                                          title: Text(
                                              replaceFarsiNumber(result[index]['start_serve_time']).substring(0,5)
                                                  + ' تا ' +
                                                replaceFarsiNumber(result[index]['end_serve_time']).substring(0,5),
                                                
                                            style: PersianFonts.Shabnam.copyWith(),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          leading: Text(
                                            'تعداد باقیمانده: ${replaceFarsiNumber(result[index]['remaining_count'].toString())}',
                                            style: PersianFonts.Shabnam.copyWith(),
                                          ),
                                        ),

                                  );
                                  return SizedBox();
                                },
                              ),


                              PieChart(
                                dataMap: my_map,
                                legendFontColor: Colors.blueGrey[900],
                                legendFontSize: 10.0,
                                legendFontWeight: FontWeight.w500,
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 20.0,
                                chartRadius: MediaQuery.of(context).size.width / 2,
                                showChartValuesInPercentage: true,
                                //showChartValues: true,
                                //showChartValuesOutside: false,
                                chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
                                //colorList: colorList,
                                //showLegends: true,
                                //decimalPlaces: 1,
                                //showChartValueLabel: true,
                                //chartValueFontSize: 12,
                                //chartValueFontWeight: FontWeight.bold,
                                //chartValueLabelColor: Colors.grey[200],
                                //initialAngle: 0,
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
            style: PersianFonts.Shabnam.copyWith(color: kPrimaryColor),
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
                          style: PersianFonts.Shabnam.copyWith(
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
                style: PersianFonts.Shabnam.copyWith(color: Colors.green),
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
                style: PersianFonts.Shabnam.copyWith(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
    if (result == true) {}
  }
}
