
import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/components/EmptyEffect.dart';
import 'package:panel_admin_food_origin/food/new_food_screen.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:persian_fonts/persian_fonts.dart';

import '../constants.dart';
import 'new_professor_screen.dart';
import 'home_page_body.dart';


class ProfessorList extends StatefulWidget {
  static String id = "Professor_list";

  @override
  _ProfessorListState createState() => _ProfessorListState();
}

class _ProfessorListState extends State<ProfessorList> {
  int facultyid, faculty_id;
  String token;
  Map args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    int faculty_id = args['facultyid'];
    this.faculty_id = faculty_id;
    token = args['token'];
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size( double.infinity , 100),
        child: Container(
          padding:  EdgeInsets.only(top: 20),
          height: 100,
          child:  Center(
            child: Text("اساتید دانشکده",
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
        ),
      ),

      body: HomePageBody(faculty_id),

      // floatingActionButton: EmptyEffect(
      //   child: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       _navigateToNewProfessorScreen();
      //     },
      //   ),
      //   borderColor: kPrimaryColor,
      //   outermostCircleStartRadius: 20,
      //   outermostCircleEndRadius: 175,
      //   numberOfCircles: 4,
      //   animationTime: Duration(seconds: 5),
      //   delay: Duration(seconds: 6),
      //   gap: 30,
      //   borderWidth: 20,
      //   startOpacity: 0.3,
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToNewProfessorScreen();
        },
      ),
    );
  }

  _navigateToNewProfessorScreen()  {
     Navigator.pushNamed(context, NewProfessorScreen.id,arguments: {
       'token': token,
       'faculty_id': faculty_id,
     });
     setState(() {});
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


