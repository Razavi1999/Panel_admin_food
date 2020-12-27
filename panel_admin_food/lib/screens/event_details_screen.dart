import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';

class EventDetailsScreen extends StatefulWidget {
  static String id = 'event_detail_screen';

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  String token,
      startTime,
      endTime,
      organizer,
      name,
      image,
      description,
      holdType,
      location;
  int cost, capacity, remainingCapacity, eventId;
  String url = '$baseUrl/api/event/user';
  Map args = Map();

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    token = args['token'];
    eventId = args['event_id'];
    eventId = 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('جزئیات ایوند' ,
        textDirection: TextDirection.rtl,
        style: PersianFonts.Shabnam.copyWith(),
        ),
        backgroundColor: Colors.purple.shade300,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: Icon(Icons.chevron_right), onPressed: (){
            Navigator.pop(context);
          }
          )
        ],
      ),
      body: FutureBuilder(
        future: http.get('$url/?event_id=$eventId', headers: {
          HttpHeaders.authorizationHeader: token,
        }),
        builder: (context, snapshot) {
          http.Response response = snapshot.data;
          if (snapshot.hasData && snapshot.connectionState==ConnectionState.done)
          {
            var jsonResponse = convert
                .jsonDecode(convert.utf8.decode(response.bodyBytes));
            print(jsonResponse);
            name = jsonResponse['name'];
            startTime = jsonResponse['start_time'];
            endTime = jsonResponse['end_time'];
            organizer = jsonResponse['organizer'];
            description = jsonResponse['description'];
            holdType = jsonResponse['hold-type'];
            cost = jsonResponse['cost'];
            remainingCapacity = jsonResponse['remaining_capacity'];
            location = jsonResponse['location'];
            image = '${jsonResponse['image']}';

            return bodyContainer();
          }

          else
            return Center(child: CircularProgressIndicator(),);

        },
      ),
    );
  }


  Widget bodyContainer(){
    ///*
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Center(
              child: Banner(
                color: Colors.purple.shade300,
                message: name,
                location: BannerLocation.bottomEnd,
                child: FadeInImage(
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  placeholder: AssetImage(
                      'assets/images/book-1.png'),
                  image: (image==null)?AssetImage(
                      'assets/images/book-1.png'):
                  NetworkImage(
                    '$baseUrl' + image,
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
                  name,
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
                  cost.toString() + ' تومان',
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
                        text: description,
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
            //itemCount: count,
            itemBuilder: (context, index) {
              return Card(
                shadowColor: Colors.grey[300],
                margin: EdgeInsets.only(
                    bottom: 10, left: 20, right: 20
                ),
                color: Colors.purple.shade50,
                elevation: 4,
                child: ListTile(
                  title: Text(
                    startTime +
                        ' تا ' +
                        endTime,
                    style: PersianFonts.Shabnam.copyWith(),
                    textDirection: TextDirection.rtl,
                  ),
                  leading: Text(
                    'تعداد باقیمانده: ${remainingCapacity.toString()}',
                    style: PersianFonts.Shabnam.copyWith(),
                  ),
                ),
              );
              return SizedBox();
            },
          ),
        ],
      ),
    );
    //*/
  }

}
