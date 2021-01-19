import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';

class HomeItem extends StatelessWidget {
  String img, title, subtitle;
  Size size;
  HomeItem({this.img, this.subtitle, this.title, this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          img,
          width: size.width*0.2,
        ),
        SizedBox(
          height: 1,
        ),
        Text(
            title,
            textAlign: TextAlign.center,
            style: PersianFonts.Shabnam.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)
        ),

        SizedBox(
          height: 8,
        ),
        Text(
            subtitle,
            textAlign: TextAlign.center,
            style: PersianFonts.Shabnam.copyWith(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.w600
            )
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
