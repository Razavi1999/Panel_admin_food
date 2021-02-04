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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        automaticallyImplyLeading: false,

        actions: <Widget>[

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

        title: Text("اساتید دانشکده" ,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: PersianFonts.Shabnam.copyWith(
              color: Colors.white, fontSize: 20.0
          ),
        ),
      ),
      body: HomePageBody(faculty_id),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToNewProfessorScreen();
        },
      ),
    );
  }

  _navigateToNewProfessorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return NewProfessorScreen(
            token: token,
          );
        },
      ),
    );
    setState(() {});
  }
}

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 66.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + barHeight,
      child: Center(
        child: Text(
          title,
          style: PersianFonts.Shabnam.copyWith(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [const Color(0xFF3366FF), const Color(0xFF00CCFF)],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }
}
