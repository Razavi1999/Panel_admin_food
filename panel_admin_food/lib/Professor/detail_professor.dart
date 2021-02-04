import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panel_admin_food_origin/models/plants.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'dart:convert' as convert;

class DetailPageProfessor extends StatefulWidget {
  static String id = "Professor_Details";

  final Professor professor;

  const DetailPageProfessor({Key key, this.professor}) : super(key: key);

  @override
  _DetailPageProfessorState createState() => _DetailPageProfessorState();
}

class _DetailPageProfessorState extends State<DetailPageProfessor> {
  TextEditingController controller = TextEditingController();
  Map args;
  String token, username, url = "http://172.17.3.157/api/professors/user";
  int professorId, userId, count = 0;
  Size size;

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
    professorId = args['id'];
    print("Professor_id : " + professorId.toString());
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            print('${url}/?professor_id=$professorId');

            return FutureBuilder(
              future: http.get('${url}/?professor_id=$professorId',
                  headers: {HttpHeaders.authorizationHeader: token}),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  http.Response response = snapshot.data;
                  print('***************************');
                  print("response.body" + response.body.toString());
                  print('***************************');

                  var result = convert
                      .jsonDecode(convert.utf8.decode(response.bodyBytes));

                  print("result : " + result.toString());

                  //for (var each in result) count++;
                  print("count : " + count.toString());

                  return SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          overflow: Overflow.visible,
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              right: 10,
                              top: 20,
                              child: IconButton(
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                  size: 100,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Image(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3,
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                '$baseUrl' + result['faculty_image'],
                              ),
                            ),
                            Positioned(
                              bottom: -60.0,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  '$baseUrl' + result['image'],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        ListTile(
                          title: Center(
                            child: Text(
                              "استاد " +
                                  result['first_name'] +
                                  " " +
                                  result['last_name'],
                              style: PersianFonts.Shabnam.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          subtitle: Center(
                              child: Text(
                                  "مرتبه علمی : " +
                                      result['academic_rank'].toString() ??
                                      "",
                                  style: PersianFonts.Shabnam)),
                        ),
                        FlatButton.icon(
                          onPressed: () {
                            if (Platform.isAndroid) {
                              AndroidIntent intent = AndroidIntent(
                                action: 'android.intent.action.MAIN',
                                category: 'android.intent.category.APP_EMAIL',
                              );

                              intent.launch().catchError((e) {});
                            }
                          },
                          icon: Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Email : ${result['email']}',
                            style: PersianFonts.Shabnam.copyWith(
                                color: Colors.white),
                          ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('درباره استاد:',
                                  textDirection: TextDirection.rtl,
                                  style: PersianFonts.Shabnam.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              Text("کارشناسی : " + result['bachelor'],
                                  textDirection: TextDirection.rtl,
                                  style: PersianFonts.Shabnam),
                              Text("کارشناسی ارشد : " + result['masters'],
                                  textDirection: TextDirection.rtl,
                                  style: PersianFonts.Shabnam),
                              Text("دکترا : " + result['phd'],
                                  textDirection: TextDirection.rtl,
                                  style: PersianFonts.Shabnam),
                              Text(
                                  'زمینه تحقیقاتی : ${(result['research_axes'].length != 0) ? result['research_axes'][0] : 'N/A'}',
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: PersianFonts.Shabnam),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      "تلفن دفتر دانشکده : " +
                                          replaceFarsiNumber(
                                              result['direct_telephone']),
                                      textDirection: TextDirection.rtl,
                                      style: PersianFonts.Shabnam.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(Icons.phone),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      'زمان های مراجعه : ${(result['free_times'].length != 0) ? result['free_times'][0] : 'N/A'}',
                                      textDirection: TextDirection.rtl,
                                      style: PersianFonts.Shabnam.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(Icons.timer),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: count,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              elevation: 6,
                              child: ListTile(
                                title: Text(
                                  replaceFarsiNumber(
                                      result['direct_telephone']) +
                                      replaceFarsiNumber(
                                          result['direct_telephone']),
                                  style: PersianFonts.Shabnam.copyWith(
                                      fontWeight: FontWeight.w700),
                                  textDirection: TextDirection.rtl,
                                ),
                                leading: Text(
                                  'تعداد باقیمانده: ${replaceFarsiNumber(result['phd'])}',
                                  style: PersianFonts.Shabnam.copyWith(
                                    fontWeight: FontWeight.w700,
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
                  return Container(
                    height: size.height,
                    child: Center(
                      child: SpinKitWave(
                        color: kPrimaryColor,
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return SpinKitWave(
              color: kPrimaryColor,
            );
          }
        },
      ), /*Container(
        constraints:  BoxConstraints.expand(),
        color:  Color(0xFF736AB7),
        child:  Stack (
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
            _getToolbar(context),
          ],
        ),
      ),*/
    );
  }

  // Container _getBackground() {
  //   return new Container(
  //     child: new Image.network(
  //       widget.planet.picture,
  //       fit: BoxFit.cover,
  //       height: 300.0,
  //     ),
  //     constraints: new BoxConstraints.expand(height: 295.0),
  //   );
  // }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[new Color(0x00736AB7), new Color(0xFF736AB7)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.white),
    );
  }
}
