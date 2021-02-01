import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';

import '../constants.dart';

class guide extends StatefulWidget {
  static String id = "guide_screen";

  @override
  _guideState createState() => _guideState();
}

class _guideState extends State<guide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Center(
          child: Text(
            "راهنمای دانشگاه من",
            textDirection: TextDirection.rtl,
            //textAlign: TextAlign.center,
            style: PersianFonts.Shabnam.copyWith(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              //color: Colors.grey[200]
              ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),

              Center(
                child: Text(
                  "راهنمای اپلیکیشن دانشگاه من",
                  textDirection: TextDirection.rtl,
                  style: PersianFonts.Shabnam.copyWith(
                    color: kPrimaryColor,
                    fontSize: 20.0,
                  ),
                ),
              ),

              SizedBox(
                height: 40,
              ),

              //Expanded(
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "  با فشاردادن دکمه + باتوجه به زمان های سلف آزاد به   میزان مورد نیاز غذا اضافه نمود.",
                  textDirection: TextDirection.rtl,
                  style: PersianFonts.Shabnam.copyWith(
                    color: kPrimaryColor,
                    fontSize: 20.0,
                  ),
                ),
              ),
              // ),

              SizedBox(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "   با فشار دادن دکمه تقویم نیز میتوان وضعیت غذاهای سرو شده در روز انتخاب شده را مشاهده کرد!",
                  textDirection: TextDirection.rtl,
                  style: PersianFonts.Shabnam.copyWith(
                    color: kPrimaryColor,
                    fontSize: 20.0,
                    //fontFamily: 'Lemonada_Regular'
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "می توانید از صفحه تاریخچه برای بررسی فاز آماری و از صفحه درخواست برای درخواست های دانشجویان استفاده کنید",
                  textDirection: TextDirection.rtl,
                  style: PersianFonts.Shabnam.copyWith(
                    color: kPrimaryColor,
                    fontSize: 20.0,
                    //fontFamily: 'Lemonada_Regular'
                  ),
                ),
              ),

              SizedBox(
                height: 40,
              ),

              Image(
                image: AssetImage("assets/images/ahmad_guide.jpg"),
                width: 400,
                height: 400,
              ),

              SizedBox(
                height: 50,
              ),

              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "صفحه تاریخچه که کاملا فاز آماری دارد",
                  textDirection: TextDirection.rtl,
                  style: PersianFonts.Shabnam.copyWith(
                    color: kPrimaryColor,
                    fontSize: 20.0,
                    //fontFamily: 'Lemonada_Regular'
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Image(
                image: AssetImage("assets/images/ahmad_history.jpg"),
                width: 400,
                height: 400,
              ),

              SizedBox(
                height: 50,
              ),

              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "   با انتخاب غذا مورد نظر و تعداد کافی آن با توجه به ساعت های موجود سلف آزاد آن را در دسترس دانشجویان قرار دهید",
                  textDirection: TextDirection.rtl,
                  style: PersianFonts.Shabnam.copyWith(
                    color: kPrimaryColor,
                    fontSize: 20.0,
                    //fontFamily: 'Lemonada_Regular'
                  ),
                ),
              ),

              Image(
                image: AssetImage("assets/images/ahmad_new.jpg"),
                width: 400,
                height: 400,
              ),

              SizedBox(
                height: 50,
              ),

              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "مدیر می تواند با مراجعه به کارتابل،"
                  " لیست رویداد های متقاضی، "
                  " "
                  "مراجعه به ایونت رویداد های قبول شده  ،"
                  " و با مراجعه به دسترسی ، "
                  "به افراد اجازه ایجاد رویداد را بدهند ",
                  textDirection: TextDirection.rtl,
                  style: PersianFonts.Shabnam.copyWith(
                    color: kPrimaryColor,
                    fontSize: 20.0,
                    //fontFamily: 'Lemonada_Regular'
                  ),
                ),
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: AssetImage("assets/images/ahmad_event.jpg"),
                  width: 400,
                  height: 400,
                ),
              ),

              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
