import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../constants.dart';

class UsersScreen extends StatefulWidget {
  static String id = 'users_screen';

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String usersUrl = '$baseUrl/api/event/admin/auth/all/';
  String userSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: usersList(),
    );
  }

  Widget usersList() {
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
              future: http.get("$usersUrl&search=$userSearch"),
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
                      }
                      else {
                        return errorWidget(
                            'sth else');
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
                      return userBuilder();
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
                  return Center(
                    child: Text('شخصی دارای مجوز وجود ندارد.',
                        textDirection: TextDirection.rtl),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget userBuilder() {
    return Container();
  }

  onChange() {
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
