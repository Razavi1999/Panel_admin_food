import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../constants.dart';
String changeUserAccessUrl = '$baseUrl/api/event/admin/auth/';

class UsersScreen extends StatefulWidget {
  static String id = 'users_screen';

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String usersUrl = '$baseUrl/api/event/admin/auth/all/';
  String userSearch = '';
  int selectedItem = 0;
  bool visible = true;
  String token;
  Map args = Map();

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    token = args['token'];
    token = 'Token dd324d7d0d603c13c34647ddf59ebb176db085c1';
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
                controller: controller,
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
              future: http.get("$usersUrl?search=$userSearch", headers: {
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
                      LinkedHashMap jsonResponse = convert
                          .jsonDecode(convert.utf8.decode(response.bodyBytes));
                      if (jsonResponse['detail'].startsWith('ERROR: You haven\'t been')) {
                        return errorWidget(
                            'شما به عنوان ارشد دانشکده انتخاب نشدید.');
                      }
                      else if(jsonResponse['detail'].startsWith('Authentication credentials')){
                        return errorWidget('متاسفانه شما شناسایی نشده اید.');
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
                      print(mapList[index]['user_id']);
                      return Card(
                        child: ListTile(
                          leading: Text('${mapList[index]['first_name']} ${mapList[index]['last_name']}'),
                          trailing: FlatButton(
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: mapList[index]['grant'] ? Colors.red : Colors.green,
                            onPressed: () {
                              print(mapList[index]['user_id']);
                              onPressed(mapList[index]['grant'], mapList[index]['user_id']);
                            },
                            child: Text(
                              mapList[index]['grant'] ? 'گرفتن اجازه' : 'دادن اجازه',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
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

  onPressed(bool status, int userId) async {
    print('here');
    http.Response response = await http.post(changeUserAccessUrl,
        body: convert.jsonEncode({
          'user_id': userId,
          'grant': (!status).toString(),
        }),
        headers: {
          HttpHeaders.authorizationHeader: token,
          "Accept": "application/json",
          "content-type": "application/json",
        });
    if (response.statusCode == 200) {
      setState(() {});
    }
    else {
      print(response.statusCode);
      print(response.body);
    }
  }

  Widget userBuilder(String username, String firstName, String lastName,
      bool status, Function onPressed) {
    return Card(
      child: ListTile(
        onTap: (){
          onPressed();
        },
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
    userSearch = controller.text;
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
