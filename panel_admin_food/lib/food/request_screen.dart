import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../components/food_request_item.dart';
import '../constants.dart';

class RequestScreen extends StatefulWidget {
  static String id = 'request_screen';

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  TextEditingController controller = new TextEditingController();

  String token;
  int userId;
  String url = '$baseUrl/api/food/admin/order';
  String search = '';

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // token = 'Token 965eee7f0022dc5726bc4d03fca6bd3ffe756a1f';
    userId = prefs.getInt('user_id');
    print(token);
    return prefs.getString('token');
  }

  Future<bool> _refresh() async {
    onChanged();
    return true;
  }

  onChanged(){
    print(url);
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: SafeArea(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 10,
                    right: 15,
                    left: 15,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                search = val;
                                onChanged();
                              },
                              controller: controller,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.end,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                                  hintText: " جستجو" ,

                              ),
                            ),
                          ),
                          /*Material(
                            type: MaterialType.transparency,
                            shape: CircleBorder(),
                            child: IconButton(
                              splashColor: Colors.grey,
                              icon: Icon(
                                Icons.chevron_right,
                                color: kPrimaryColor,
                                size: 20,
                              ),
                              onPressed: () {

                                Navigator.pop(context);
                              },
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(80)),
      body: RefreshIndicator(
        onRefresh: (){
          return _refresh();
        },
        child: FutureBuilder(
            future: getToken(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return FutureBuilder(
                    future: http.get('$url/all/?search=$search', headers: {
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
                              style: PersianFonts.Shabnam.copyWith(fontSize: 20),
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
                              child: Text('درخواست غذایی وجود ندارد !!!',
                                style: PersianFonts.Shabnam.copyWith(
                                    fontSize: 20 ,
                                    color: kPrimaryColor
                                ),
                                textDirection: TextDirection.rtl,),
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
                            return FoodRequestItem(
                              onPressed: () {
                                onPressed(mapList[index]['order_id']);
                              },
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
                        return Center(
                            child: SpinKitWave(
                              color: kPrimaryColor,
                            ));
                      }
                    });
              } else {
                return Center(
                    child: SpinKitWave(
                      color: kPrimaryColor,
                    ));
              }
            }),
      ),
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
            child: Text('!باشه' ,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      );
    }
    var jsonResponse = convert.jsonDecode(response.body);
    if (jsonResponse['done'] == true) {
      bool result = await showDialog(
        context: context,
        child: AlertDialog(
          title: Text('غذا فروخته شد', textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: PersianFonts.Shabnam.copyWith(
              color: kPrimaryColor
            ),
          ),
          content: FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('!باشه' ,
              style: PersianFonts.Shabnam.copyWith(

              ),
            ),
          ),
        ),
      );
      setState(() {

      });

    } else {}
  }
}
