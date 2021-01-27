import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panel_admin_food_origin/models/plants.dart';

import 'package:panel_admin_food_origin/models/separator.dart';
import 'package:panel_admin_food_origin/models/text_style.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'dart:convert' as convert;
import 'PlanetSummary.dart';

class DetailPageProfessor extends StatefulWidget {
  static String id = "Professor_Details";

  final Professor planet;

  const DetailPageProfessor({Key key, this.planet}) : super(key: key);

  @override
  _DetailPageProfessorState createState() => _DetailPageProfessorState();
}

class _DetailPageProfessorState extends State<DetailPageProfessor> {
  TextEditingController controller = TextEditingController();
  Map args;
  String token, username , url = "http://172.17.3.157/api/professors/user";
  int Professor_id, userId , count = 0;

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
    Professor_id = args['id'];
    print("Professor_id : " + Professor_id.toString());

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
          ' جزئیات استاد',
          style: PersianFonts.Shabnam.copyWith(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 30.0),
        ),
      ),
      body: FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            print('${url}/?professor_id=$Professor_id');



            return SingleChildScrollView(
              child: Column(
                  children: [
                    FutureBuilder(
                      future: http.get('${url}/?professor_id=$Professor_id',
                          headers: {HttpHeaders.authorizationHeader: token}),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          http.Response response = snapshot.data;
                          print('***************************');
                          print("response.body" + response.body.toString());
                          print('***************************');

                          var result = convert.jsonDecode(
                              convert.utf8.decode(response.bodyBytes));

                          print("result : " + result.toString());


                          //for (var each in result) count++;
                          print("count : " + count.toString());


                          return Column(
                              children: [
                                Container(
                                  child: Center(
                                    child: Banner(
                                      color: Colors.purple.shade300,
                                      message:
                                          result['first_name'].toString(),
                                      location: BannerLocation.bottomEnd,
                                      child: FadeInImage(
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                        placeholder: AssetImage(
                                            'assets/images/book-1.png'),
                                        image: NetworkImage(
                                          '$baseUrl' + result['image'],
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
                                            color: kPrimaryColor, fontSize: 28),
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
                                        result['last_name'],
                                        textDirection: TextDirection.rtl,
                                        style: PersianFonts.Shabnam.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: kPrimaryColor,
                                            fontSize: 15),
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
                                        replaceFarsiNumber(result['academic_rank'].toString()) ,
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                        style: PersianFonts.Shabnam.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: kPrimaryColor,
                                            fontSize: 15),
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
                                              color: kPrimaryColor, fontSize: 28),
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
                                              text: result['email'],
                                              style:
                                                  PersianFonts.Shabnam.copyWith(
                                                      fontWeight: FontWeight.w800,
                                                      color: kPrimaryColor)),
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
                                          replaceFarsiNumber(result['direct_telephone']) +
                                              replaceFarsiNumber(result['direct_telephone']),
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


          else {
            return Center(
              child: SpinKitWave(
                color: kPrimaryColor,
              ),
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

  Container _getBackground() {
    return new Container(
      child: new Image.network(
        widget.planet.picture,
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints: new BoxConstraints.expand(height: 295.0),
    );
  }

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

  Container _getContent() {
    final _overviewTitle = "Overview".toUpperCase();
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          new PlanetSummary(
            widget.planet,
            horizontal: false,
          ),
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _overviewTitle,
                  style: Style.headerTextStyle,
                ),
                new Separator(),
                new Text(widget.planet.description,
                    style: Style.commonTextStyle),
              ],
            ),
          ),
        ],
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
