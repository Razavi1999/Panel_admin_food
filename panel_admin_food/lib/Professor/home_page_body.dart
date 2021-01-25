// TODO Implement this library.

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panel_admin_food_origin/models/PlanetSummary.dart';
import 'package:panel_admin_food_origin/models/plants.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


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

    print("url : " + url + widget.faculty_id.toString());




    return Container(
      child: FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            print(url);
            //return SizedBox(height: 10,);
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
                  List<Planet> planets = [];

                  int count = 0;

                  for (Map map in jsonResponse)
                  {
                    count++;
                    mapList.add(map);

                  }

                  print("jsonresponse : " +  jsonResponse.toString());

                 // return Text("دانیال خر است");

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: count,
                    itemBuilder: (context, index) {

                      print( "image : " + mapList[index]['image']);

                      Planet P = Planet(
                          id: "2",
                          name: "mapList[index]",
                          location: "Milkyway Galaxy",
                          distance: "54.6m Km",
                          gravity: "3.711 m/s ",
                          description: "Neptune is the eighth and farthest known planet from the Sun in the Solar System. In the Solar System, it is the fourth-largest planet by diameter, the third-most-massive planet, and the densest giant planet. Neptune is 17 times the mass of Earth and is slightly more massive than its near-twin Uranus, which is 15 times the mass of Earth and slightly larger than Neptune. Neptune orbits the Sun once every 164.8 years at an average distance of 30.1 astronomical units (4.50×109 km). It is named after the Roman god of the sea and has the astronomical symbol ♆, a stylised version of the god Neptune's trident",
                          image: "$baseUrl${mapList[index]['image']}",
                          picture: "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/images/110411main_Voyager2_280_yshires.jpg"
                      );

                      return Container(
                        child: CustomScrollView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              sliver:  SliverList(
                                delegate:  SliverChildBuilderDelegate(
                                      (context, index) =>  PlanetSummary(P),
                                  childCount: planets.length,
                                ),
                              ),
                            ),
                          ],
                        ),
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
            return Center(child: SpinKitWave(
              color: kPrimaryColor,
            )
            );
          }
        },
      ),
    );
  }
}

