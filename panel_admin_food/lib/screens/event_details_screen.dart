import 'dart:io';

import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shamsi_date/shamsi_date.dart';

class EventDetailsScreen extends StatefulWidget {
  static String id = 'event_detail_screen';

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool hasImage = false;
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
    // eventId = 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            'جزئیات ایوند',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: PersianFonts.Shabnam.copyWith(),
          ),
        ),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {
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

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            Map result =
                convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
            print(result);

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Banner(

                        color: Colors.purple.shade300,
                        message: replaceFarsiNumber(result['cost'].toString()),
                        location: BannerLocation.bottomEnd,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage(
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: AssetImage('assets/images/book-1.png'),
                            image: (result['image'] != null)
                                ? NetworkImage('$baseUrl' + result['image'])
                                : AssetImage('assets/images/book-1.png'),
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
                          'نام رویداد',
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.w900,
                              //color: kPrimaryColor,
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
                          result['name'],
                          textDirection: TextDirection.rtl,
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.bold,
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
                          replaceFarsiNumber(result['cost'].toString()) +
                              ' تومان',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                              fontSize: 15),
                        ),
                        Text(
                          'هزینه شرکت در رویداد  ',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: PersianFonts.Shabnam.copyWith(
                              //color: kPrimaryColor,
                              fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ) ,
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 0,
                        ),
                    child: Flexible(
                      child: CreditCard(
                        cardExpiry: 'دیدار ما : ${replaceFarsiNumber(getTime(result['start_time']))}',
                        cvv: "cvv",
                        showBackSide: false,
                        frontBackground: CardBackgrounds.black,
                        backBackground: CardBackgrounds.white,
                        showShadow: true,

                        cardNumber: ("123"),
                        bankName: 'دیدار ما : ${replaceFarsiNumber(getTime(result['start_time']))}',
                        cardHolderName: 'مکان دیدار : ${result['location']}' ,

                        height: 200,
                        width: MediaQuery.of(context).size.width /1.2,

                      ),
                    ),
                  ),


                  SizedBox(
                    height: 40,
                  ),



                  Padding(
                    padding: EdgeInsets.only(right: 1, left: 5),
                    child: Row(
                      children: [
                        Text(
                          ' رویداد به صورت ${result['hold_type'] == 'Online' ? 'مجازی' : 'حضوری'} برگزار خواهد شد!  ',
                          textDirection: TextDirection.rtl,
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.bold,
                              //color: kPrimaryColor,
                              fontSize: 17),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.accessibility,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  ///*
                  Padding(
                    padding: EdgeInsets.only(
                        right: 35 ,
                        //left: 220
                    ), //*/
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${replaceFarsiNumber(getTime(result['start_time']))}',
                          textDirection: TextDirection.rtl,
                          //textAlign: TextAlign.right,
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.w100,
                              //color: kPrimaryColor,
                              fontSize: 17),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.access_alarm,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      right: 35
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${result['location']}',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.end,
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.w100,
                              //color: kPrimaryColor,
                              fontSize: 17),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.place,
                          color: kPrimaryColor,
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
                            'درباره رویداد',
                            style: PersianFonts.Shabnam.copyWith(
                                fontWeight: FontWeight.w900,
                                //color: kPrimaryColor,
                                fontSize: 28),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                            textDirection: TextDirection.rtl,
                            //overflow: TextOverflow.ellipsis,
                            strutStyle: StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                                text: result['description'],
                                style: PersianFonts.Shabnam.copyWith(
                                    fontSize: 15, color: kPrimaryColor)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),


                  Padding(
                    padding: EdgeInsets.only(right: 1, left: 5),
                    child: Row(
                      children: [
                        Text(
                          ' رویداد به صورت ${result['hold_type'] == 'Online' ? 'مجازی' : 'حضوری'} برگزار خواهد شد!  ',
                          textDirection: TextDirection.rtl,
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.bold,
                              //color: kPrimaryColor,
                              fontSize: 17),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.accessibility,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  ///*
                  Padding(
                    padding: EdgeInsets.only(
                      right: 35 ,
                      //left: 220
                    ), //*/
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${replaceFarsiNumber(getTime(result['start_time']))}',
                          textDirection: TextDirection.rtl,
                          //textAlign: TextAlign.right,
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.w100,
                              //color: kPrimaryColor,
                              fontSize: 17),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.access_alarm,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        right: 35
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${result['location']}',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.end,
                          style: PersianFonts.Shabnam.copyWith(
                              fontWeight: FontWeight.w100,
                              //color: kPrimaryColor,
                              fontSize: 17),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.place,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: Text(
                        ' منتظر حضورتان هستیم در روز \n${replaceFarsiNumber(result['start_time']).substring(0, 10)}',
                        textDirection: TextDirection.rtl,
                        style: PersianFonts.Shabnam.copyWith(
                            color: kPrimaryColor, fontSize: 20)),
                  ),

                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
  
  String getTime(String date){
    print("date : " + date);
    date = date.substring(0,10);

    List times = date.split('-');
    Gregorian g = Gregorian(int.parse(times[0]) ,
        int.parse(times[1]) ,
        int.parse(times[2]));
    Jalali j = g.toJalali();
    print(j);

    return '${j.day} / ${j.month} / ${j.year}';
    
    return j.toString().substring(7,19);
  }

  Widget bodyContainer() {
    /*
          ListView.builder(
            shrinkWrap: true,
            //itemCount: count,
            itemBuilder: (context, index) {
              return Card(
                shadowColor: Colors.grey[300],
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                color: Colors.purple.shade50,
                elevation: 4,
                child: ListTile(
                  title: Text(
                    startTime + ' تا ' + endTime,
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
    */
  }
}
