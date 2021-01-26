
import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:persian_fonts/persian_fonts.dart';

import '../constants.dart';
import 'home_page_body.dart';

class ProfessorList extends StatelessWidget {
  static String id = "Professor_list";
  int facultyid;
  Map args;


  //ProfessorList(this.facultyid);


  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    int facultyid = args['facultyid'];

    return  Scaffold(
      body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               GradientAppBar("اساتید دانشکده"),
               HomePageBody(facultyid),
            ],
          ),
      //),
    );

  }




}

class GradientAppBar extends StatelessWidget {


  final String title;
  final double barHeight = 66.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return  Container(
      padding:  EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + barHeight,
      child:  Center(
        child: Text(title,
          style: PersianFonts.Shabnam.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18.0
          ),
        ),
      ),
      decoration:  BoxDecoration(
        gradient:  LinearGradient(
            colors: [
              const Color(0xFF3366FF),
              const Color(0xFF00CCFF)
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
        ),
      ),
    );
  }
}


