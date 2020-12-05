
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/food_screen.dart';



class GridDashboard extends StatelessWidget {
  final BuildContext context;
  final String username, token, firstName, lastName;
  final int user_id;

  GridDashboard(this.context, this.user_id, this.token,
      this.username, this.firstName, this.lastName);


  Items item1 = new Items(
    title: "سامانه تغذیه",
    subtitle: "ایجاد تعداد غذا",
    img: "assets/images/food.png",
    dest: OrderPage.id,
  );

  Items item2 = new Items(
    title: "ثبت نام در رویداد ها",
    subtitle: "رویداد برای تحکیم فردا",
    img: "assets/images/Event.png",
  );


  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.4,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 1,
          //childAspectRatio: (itemWidth / itemHeight),
          crossAxisSpacing: 5,
          mainAxisSpacing: 8,
          children: myList.map((data) {
            return InkWell(
              onTap: (){
                print('user_id : $user_id');
                Navigator.pushNamed(context, data.dest, arguments: {
                  'token': token,
                  'user_id': user_id,
                  'first_name': firstName,
                  'last_name': lastName,
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(color), borderRadius: BorderRadius.circular(20)),
                ///*
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 72,
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                //*/
              ),
            );
          }).toList()),
    );
  }
}



class Items {
  String title;
  String subtitle;
  String img;
  String dest;

  Items({
    this.title,
    this.subtitle,
    this.img,
    this.dest,
  });
}
