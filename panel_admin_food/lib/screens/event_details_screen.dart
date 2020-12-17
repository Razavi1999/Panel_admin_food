import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:panel_admin_food_origin/constants.dart';

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
        backgroundColor: Colors.purple.shade300,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: Icon(Icons.chevron_right), onPressed: (){
            Navigator.pop(context);
          })
        ],
      ),
      body: FutureBuilder(
        future: http.get('$url/?event_id=$eventId', headers: {
          HttpHeaders.authorizationHeader: token,
        }),
        builder: (context, snapshot) {
          http.Response response = snapshot.data;
          if (snapshot.hasData && snapshot.connectionState==ConnectionState.done){
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
            image = '$baseUrl${jsonResponse['image']}';
            return bodyContainer();
          }
          else {
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }

  // هر جور میخواین نمایش بدین  even رو
  Widget bodyContainer(){
    return Container();
  }

}
