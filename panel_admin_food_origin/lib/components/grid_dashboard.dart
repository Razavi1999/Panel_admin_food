
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class GridDashboard extends StatelessWidget {
  final BuildContext context;
  final String username, token, firstName, lastName;
  final int user_id;

  GridDashboard(this.context, this.user_id, this.token,
      this.username, this.firstName, this.lastName);

  Items item1 = new Items(
    title: "خفت کتاب",
    subtitle: "خرید , فروش , تبادل",
    img: "assets/images/khaft.png",
    dest: null,
  );

  Items item2 = new Items(
    title: "سامانه تغذیه",
    subtitle: "رزرو اتوماتیک غذا",
    img: "assets/images/food.png",
  );
  Items item3 = new Items(
    title: "ثبت نام در رویداد ها",
    subtitle: "",
    img: "assets/images/map.png",
  );
  Items item4 = new Items(
    title: "اخبار دانشگاه",
    subtitle: "اطلاع از آخرین قوانین ",
    img: "assets/images/elmos.png",
  );
  Items item5 = new Items(
    title: "درباره ما",
    subtitle: "گروه برنامه نویسی دولاور",
    img: "assets/images/logo.png",
  );
  Items item6 = new Items(
    title: "سوالات متداول",
    subtitle: "",
    img: "assets/images/setting.png",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
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
                    color: Color(color), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 72,
                    ),
                    SizedBox(
                      height: 14,
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
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
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
