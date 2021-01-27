// TODO Implement this library.

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panel_admin_food_origin/models/PlanetSummary.dart';
import 'package:panel_admin_food_origin/models/detailProfessor.dart';
import 'package:panel_admin_food_origin/models/plants.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../components/OrderCard2.dart';
import 'null.dart';


class HomePageBody extends StatefulWidget {
  int faculty_id;

  HomePageBody(this.faculty_id);

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {

  String token , url = "$baseUrl/api/professors/user/all/?faculty_id=";
  int userId;
  Map args;

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


  @override
  Widget build(BuildContext context) {

    return Container(
        child: FutureBuilder(
          future: getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              //print("I m connectionState !!!");
              //print(url);
              return FutureBuilder(
                future: http.get(
                    '$url${widget.faculty_id}',
                    headers: {
                      HttpHeaders.authorizationHeader: token,
                    }),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    http.Response response = snapshot.data;
                    if (response.statusCode >= 400) {
                      print("response StatusCode : " + response.statusCode.toString());

                      return Center(
                        child: Text(
                          'مشکلی درارتباط با سرور پیش آمد',
                          style: PersianFonts.Shabnam.copyWith(fontSize: 20),
                        ),
                      );
                    }
                    var jsonResponse = convert
                        .jsonDecode(convert.utf8.decode(response.bodyBytes));

                    List<Map> mapList = [];
                    List<Professor> P = [];
                    int count = 0;

                    for (Map map in jsonResponse)
                    {
                      count++;
                      mapList.add(map);
                    }

                    //print(jsonResponse.toString());

                    for(int i = 0 ; i < count ; i++)
                    {
                       Professor professor = Professor(
                          id: mapList[i]['professor_id'],
                          name: mapList[i]['first_name'] + " " + mapList[i]['last_name'],
                          location: "مرتبه علمی : " + mapList[i]['academic_rank'] ,
                          distance: "54.6m Km",
                          gravity: "3.711 m/s ",
                          description: mapList[i]['email'],
                          image: mapList[i]['image'],
                      );

                       P.add(professor);
                       //print("professor name" + mapList[i]['first_name'] + mapList[i]['last_name']);
                    }

                    /*print("jsonresponse : " +  jsonResponse.toString());
                    print("maplist.length : " + mapList.length.toString());
                    print("count : " + count.toString());*/


                    //return Text("heig you",);

                    return ListView.builder(
                      //shrinkWrap: true,
                      itemCount: count,
                      itemBuilder: (context, index) {
                      // print("P[index] : " + P[index].id.toString());
                       return OrderCard2(
                         name: P[index].name,
                         cost: P[index].location,
                         description: P[index].description,
                         image: '$baseUrl${P[index].image}',
                         onPressed: () {
                           navigateToProfessorDetailScreen(P[index].id);
                         },
                       );

                      },
                    );
                  }

                  else {
                    return Center(
                        child: SpinKitWave(
                          color: kPrimaryColor,
                        )
                    );
                  }
                },
              );
            }

            else {
              return Center(
                  child: SpinKitWave(
                color: kPrimaryColor,
              )
              );
            }
          },
        ),
    );
  }

  void navigateToProfessorDetailScreen(int professor_id) {
    Navigator.pushNamed(
      context,
      DetailPageProfessor.id,
      arguments: {
        'id': professor_id,
      },
    );

  }
}



