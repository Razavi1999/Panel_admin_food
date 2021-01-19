import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:panel_admin_food_origin/constants.dart';
import 'file:///D:/FlutterProjects/admin/panel_admin_food/lib/event/event_details_screen.dart';
import 'file:///D:/FlutterProjects/admin/panel_admin_food/lib/event/users_screen.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import '../screens/EmptyEffect.dart';

String usersUrl = '$baseUrl/api/event/admin/auth/all/';
String eventsUrl = '$baseUrl/api/event/admin/requests/all/';
String eventChangeUrl = '$baseUrl/api/event/admin/requests/';
String authorizedUsersUrl = '$baseUrl/api/event/admin/auth/all/?state=true';
String changeUserAccessUrl = '$baseUrl/api/event/admin/auth/';
String authSearch = '';

class EventScreen extends StatefulWidget {
  static String id = 'event_screen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int selectedItem = 0;
  bool visible = true;
  String token;
  Map args = Map();
  String eventSearch = '', cartableSearch = '';

  TextEditingController userController = TextEditingController();
  TextEditingController eventController = TextEditingController();
  TextEditingController cartableController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    token = args['token'];
    //token = 'Token dd324d7d0d603c13c34647ddf59ebb176db085c1';
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: selectedBodyItem(),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            _navigateToUsersScreen();
          },
          child: Icon(Icons.add),
        ),
        visible: visible,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF6200EE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: selectedItem,
        onTap: (value) {
          selectedItem = value;
          setState(() {});
          print(value);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility), label: 'دسترسی'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'کارتابل'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'ایوند'),
        ],
      ),
    );
  }

  Widget selectedBodyItem() {
    if (selectedItem == 0) {
      visible = true;
      return authorizedUsersList();
    } else if (selectedItem == 1) {
      visible = false;
      return cartableList();
    } else if (selectedItem == 2) {
      visible = false;
      return eventList();
    } else {
      visible = false;
      return SizedBox();
    }
  }

  Widget cartableList() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: cartableController,
              onChanged: (value) {
                cartableSearch = cartableController.text;
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText:
                    '                                                  جستجو',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: http
                .get('$eventsUrl?state=false&search=$cartableSearch', headers: {
              HttpHeaders.authorizationHeader: token,
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                http.Response response = snapshot.data;
                print(response.body);
                if (response.statusCode >= 400) {
                  print(response.statusCode);
                  print(response.body);
                  try {
                    String jsonResponse = convert
                        .jsonDecode(convert.utf8.decode(response.bodyBytes));
                    if (jsonResponse.startsWith('ERROR: You haven\'t been')) {
                      return errorWidget(
                          'شما به عنوان ارشد دانشکده انتخاب نشدید.');
                    } else {
                      return errorWidget('sth else');
                    }
                  } catch (e) {
                    print(e);
                    return errorWidget('مشکلی درارتباط با سرور پیش آمد');
                  }
                }
                var jsonResponse =
                    convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
                // print(jsonResponse);
                List<Map> mapList = [];
                int cartableCount = 0;
                // print(jsonResponse);
                for (Map map in jsonResponse) {
                  cartableCount++;
                  mapList.add(map);
                  // print(map.toString());
                }
                if (cartableCount == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),

                      Icon(
                          Icons.folder,
                          size: 45,
                          color: Colors.purple,
                        ),


                      Text('ایوندی وجود ندارد' ,
                        style: PersianFonts.Shabnam.copyWith(
                          color: kPrimaryColor,
                          fontSize: 25,


                        ),
                      )
                    ],
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return cartableBuilder(
                        '$baseUrl${mapList[index]['image']}',
                        mapList[index]['name'],
                        mapList[index]['remaining_capacity'],
                        mapList[index]['event_id'],
                        (mapList[index]['image'] == null) ? false : true,
                      );
                    },
                    itemCount: cartableCount,
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
  }

  Widget eventList() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              //textAlign: TextAlign.right,
              //textDirection: TextDirection.rtl,
              controller: eventController,
              onChanged: (value) {
                eventSearch = eventController.text;
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText:
                    '                                                  جستجو',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          FutureBuilder(
            future:
                http.get('$eventsUrl?state=true&search=$eventSearch', headers: {
              HttpHeaders.authorizationHeader: token,
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                http.Response response = snapshot.data;
                if (response.statusCode >= 400) {
                  print(response.statusCode);
                  print(response.body);
                  try {
                    String jsonResponse = convert
                        .jsonDecode(convert.utf8.decode(response.bodyBytes));
                    if (jsonResponse.startsWith('ERROR: You haven\'t been')) {
                      return errorWidget(
                          'شما به عنوان ارشد دانشکده انتخاب نشدید.');
                    } else {
                      return errorWidget('sth else');
                    }
                  } catch (e) {
                    print(e);
                    return errorWidget('مشکلی درارتباط با سرور پیش آمد');
                  }
                }
                var jsonResponse =
                    convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
                // print(jsonResponse);
                List<Map> mapList = [];
                int eventCount = 0;
                // print(jsonResponse);
                for (Map map in jsonResponse) {
                  eventCount++;
                  mapList.add(map);
                  // print(map.toString());
                }
                if (eventCount == 0) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      EmptyEffect(
                        child: Icon(
                          Icons.folder,
                          size: 45,
                          color: Colors.purple,
                        ),
                        borderColor: kPrimaryColor,
                        outermostCircleStartRadius: 15,
                        outermostCircleEndRadius: 175,
                        numberOfCircles: 4,
                        animationTime: Duration(seconds: 5),
                        delay: Duration(seconds: 1),
                        gap: 30,
                        borderWidth: 20,
                        startOpacity: 0.3,
                      ),
                      Text('ایوندی وجود ندارد' ,
                        style: PersianFonts.Shabnam.copyWith(
                          color: kPrimaryColor,
                          fontSize: 25,


                        ),
                      )
                    ],
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return eventBuilder(
                        '$baseUrl${mapList[index]['image']}',
                        mapList[index]['name'],
                        mapList[index]['remaining_capacity'],
                        //mapList[index][''],
                        mapList[index]['event_id'],
                        (mapList[index]['image'] == null) ? false : true,
                      );
                    },
                    itemCount: eventCount,
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
  }

  declineEvent(int eventId) async {
    print('accepted');
    http.Response response = await http.post(eventChangeUrl,
        body: convert.jsonEncode({
          'verified': false.toString(),
          'event_id': eventId,
        }),
        headers: {
          HttpHeaders.authorizationHeader: token,
          "Accept": "application/json",
          "content-type": "application/json",
        });
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      _showDialog('مشکلی پیش آمد');
      print(response.statusCode);
      print(response.body);
    }
  }

  Widget eventBuilder(String imageUrl, String eventName, int remainingCapacity,
      int eventId, bool imageIsAvailable) {
    Map<String, double> eventMap = Map();

    eventMap = {
      "صندلی خالی": double.parse((200 - remainingCapacity).toString()),
      " صندلی پر": double.parse(remainingCapacity.toString()),
    };

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      elevation: 12,
      child: InkWell(
        onTap: () {
          _navigateToEventDetailScreen(eventId, token);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      //textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(fontSize: 20.0),

                      text: TextSpan(
                          text: eventName,
                          style: PersianFonts.Shabnam.copyWith(
                            color: kPrimaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      replaceFarsiNumber(remainingCapacity.toString()) +
                          ' :ظرفیت ',
                      textAlign: TextAlign.right,
                      style: PersianFonts.Shabnam.copyWith(
                          fontSize: 16.0, color: Colors.black87),
                    ),
                    PieChart(
                      dataMap: eventMap,
                      legendFontColor: Colors.blueGrey[900],
                      legendFontSize: 11.0,
                      legendFontWeight: FontWeight.w900,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 7.0,
                      chartRadius: MediaQuery.of(context).size.width / 7,
                      showChartValuesInPercentage: true,
                      showChartValues: true,
                      //showChartValuesOutside: false,
                      chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                height: 110.0,
                width: 90.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    //height: 80,
                    //width: 100,
                    placeholder: AssetImage('assets/images/junk.jpeg'),
                    image: NetworkImage(imageUrl),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  acceptEvent(int eventId) async {
    print('accepted');
    http.Response response = await http.post(eventChangeUrl,
        body: convert.jsonEncode({
          'verified': true.toString(),
          'event_id': eventId,
        }),
        headers: {
          HttpHeaders.authorizationHeader: token,
          "Accept": "application/json",
          "content-type": "application/json",
        });

    if (response.statusCode == 200)
      setState(() {});
    else {
      _showDialog('مشکلی پیش آمد');
      print(response.statusCode);
      print(response.body);
    }
  }

  Widget cartableBuilder(String imageUrl, String eventName,
      int remainingCapacity, int eventId, bool imageIsAvailable) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 12,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: InkWell(
        onTap: () {
          _navigateToEventDetailScreen(eventId, token);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    RichText(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(fontSize: 20.0),
                      text: TextSpan(
                          text: eventName,
                          style: PersianFonts.Shabnam.copyWith(
                              //fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: kPrimaryColor)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Switch(
                              activeTrackColor: Colors.green,
                              activeColor: Colors.green,
                              inactiveTrackColor: Colors.white,
                              value: true,
                              onChanged: (value) {
                                acceptEvent(eventId);
                                success(context, 'رویداد با موفقیت اضافه شد');
                              },
                            ),
                          ),
                        ),
                        Text(
                          'قبول درخواست : ',
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          style: PersianFonts.Shabnam.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                height: 110.0,
                width: 90.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    //height: 50,
                    placeholder: AssetImage('assets/images/junk.jpeg'),
                    image: NetworkImage(imageUrl),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget authorizedUsersList() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              textDirection: TextDirection.rtl,
              controller: userController,
              onChanged: (value) {
                onChange();
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText:
                    '                                                  جستجو',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          FutureBuilder(
            future:
                http.get("$authorizedUsersUrl&search=$authSearch", headers: {
              HttpHeaders.authorizationHeader: token,
            }),
            builder: (context, snapshot) {
              // print('*$authorizedUsersUrl&search=$authSearch*');
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                http.Response response = snapshot.data;
                if (response.statusCode >= 400) {
                  print(response.statusCode);
                  print(response.body);
                  try {
                    String jsonResponse = convert
                        .jsonDecode(convert.utf8.decode(response.bodyBytes));
                    if (jsonResponse.startsWith('ERROR: You haven\'t been')) {
                      return errorWidget(
                          'شما به عنوان ارشد دانشکده انتخاب نشدید.');
                    } else {
                      return errorWidget('sth else');
                    }
                  } catch (e) {
                    print(e);
                    return errorWidget('مشکلی درارتباط با سرور پیش آمد');
                  }
                }
                var jsonResponse =
                    convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
                // print(jsonResponse);
                List<Map> mapList = [];
                int userCount = 0;
                // print(jsonResponse);
                for (Map map in jsonResponse) {
                  userCount++;
                  mapList.add(map);
                  // print(map.toString());
                }
                if (userCount == 0) errorWidget('شخصی دارای مجوز وجود ندارد.');

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return userAuthBuilder(
                        mapList[index]['username'],
                        mapList[index]['first_name'],
                        mapList[index]['last_name'],
                        mapList[index]['grant'],
                        () {
                          grantDeclineUserAccess(mapList[index]['grant'],
                              mapList[index]['user_id']);
                        },
                      );
                    },
                    itemCount: userCount,
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  grantDeclineUserAccess(bool status, int userId) async {
    print('user_id: $userId');
    Map map = Map();
    map['user_id'] = userId;
    map['grant'] = (!status).toString();
    http.Response response = await http
        .post(changeUserAccessUrl, body: convert.json.encode(map), headers: {
      HttpHeaders.authorizationHeader: token,
      "Accept": "application/json",
      "content-type": "application/json",
    });

    if (response.statusCode == 200)
      setState(() {});
    else {
      print(response.statusCode);
      print(response.body);
    }
  }

  Widget userAuthBuilder(String username, String firstName, String lastName,
      bool status, Function onPressed) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 12,
      shadowColor: Colors.grey[400],
      //color: Color.fromRGBO(216, 228 , 240, 50),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      //margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Align(
        child: ListTile(
          leading: Text(
            '$firstName $lastName',
            textAlign: TextAlign.center,
            style: PersianFonts.Shabnam.copyWith(fontSize: 16),
          ),
          trailing: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: status ? Colors.red : Colors.green,
            onPressed: onPressed,
            child: Text(
              status ? 'گرفتن اجازه' : 'دادن اجازه',
              style: PersianFonts.Shabnam.copyWith(
                  color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        alignment: Alignment.center,
      ),
    );
    return Container(
      child: Text(username),
    );
  }

  onChange() {
    authSearch = userController.text;
    setState(() {});
  }

  _navigateToUsersScreen() async {
    print("_navigateToUsersScreen : " + token);

    await Navigator.pushNamed(context, UsersScreen.id, arguments: {
      'token': token,
    });
    setState(() {});
  }

  Widget errorWidget(String message) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 100),
        child: Text(
          message,
          textDirection: TextDirection.rtl,
          style: PersianFonts.Shabnam.copyWith(fontSize: 20),
        ),
      ),
    );
  }

  _showDialog(String message) {
    // Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    AlertDialog dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            message,
            style: PersianFonts.Shabnam.copyWith(fontSize: 20),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              '!باشه',
              style: PersianFonts.Shabnam.copyWith(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
    showDialog(context: context, child: dialog);
  }

  _navigateToEventDetailScreen(int eventId, String token) {
    Navigator.pushNamed(context, EventDetailsScreen.id, arguments: {
      'event_id': eventId,
      'token': token,
    });
  }
}
