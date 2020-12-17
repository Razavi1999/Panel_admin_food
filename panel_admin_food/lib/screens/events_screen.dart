import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:panel_admin_food_origin/constants.dart';
import 'package:panel_admin_food_origin/screens/users_screen.dart';

String usersUrl = '$baseUrl/api/event/admin/auth/all/';
String eventsUrl = '$baseUrl/api/event/admin/requests/all/';
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

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    token = args['token'];
    token = 'Token dd324d7d0d603c13c34647ddf59ebb176db085c1';
    return Scaffold(
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
      return SizedBox();
    } else if (selectedItem == 2) {
      visible = false;
      return SizedBox();
    } else {
      visible = false;
      return SizedBox();
    }
  }

  Widget authorizedUsersList() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                onChanged: (value) {
                  onChange();
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'جست و جو',
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
                  var jsonResponse = convert
                      .jsonDecode(convert.utf8.decode(response.bodyBytes));
                  // print(jsonResponse);
                  List<Map> mapList = [];
                  int userCount = 0;
                  // print(jsonResponse);
                  for (Map map in jsonResponse) {
                    userCount++;
                    mapList.add(map);
                    // print(map.toString());
                  }
                  if (userCount == 0) {
                    errorWidget('شخصی دارای مجوز وجود ندارد.');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return userAuthBuilder(
                        mapList[index]['username'],
                        mapList[index]['first_name'],
                        mapList[index]['last_name'],
                        true,
                        () {
                          onPressed(true, mapList[index]['username']);
                        },
                      );
                    },
                    itemCount: userCount,
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
      ),
    );
  }

  onPressed(bool status, String username) async {
    await http.put(changeUserAccessUrl,
        body: convert.jsonEncode({
          'username': username,
          'status': !status,
        }));
    setState(() {});
  }

  Widget userAuthBuilder(String username, String firstName, String lastName,
      bool status, Function onPressed) {
    return Card(
      child: ListTile(
        onTap: onPressed,
        leading: Text('$firstName $lastName'),
        trailing: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: status ? Colors.red : Colors.green,
          onPressed: () {},
          child: Text(
            status ? 'گرفتن اجازه' : 'دادن اجازه',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
    return Container(
      child: Text(username),
    );
  }

  onChange() {
    setState(() {});
  }

  _navigateToUsersScreen() async {
    await Navigator.pushNamed(context, UsersScreen.id);
    setState(() {});
  }

  Widget errorWidget(String message) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 100),
        child: Text(
          message,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
