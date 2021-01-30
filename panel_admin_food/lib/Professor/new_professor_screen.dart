import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//import 'package:flutter_picker/Picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

//import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_academic_card.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_column_card.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_column_image.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_link_cards.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_textfield.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as convert;
import 'dart:ui' as ui;

class NewProfessorScreen extends StatefulWidget {
  static String id = 'new_professor_screen';

  @override
  _NewProfessorScreenState createState() => _NewProfessorScreenState();
}

class _NewProfessorScreenState extends State<NewProfessorScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bachelorController = TextEditingController();
  TextEditingController masterController = TextEditingController();
  TextEditingController phdController = TextEditingController();
  TextEditingController postPhdController = TextEditingController();
  TextEditingController webPageLinkController = TextEditingController();
  TextEditingController googleScholarController = TextEditingController();
  String facultyName = 'دانشکده ای انتخاب نشده',
      academicRank = 'رنکی مشخص نکرده اید';
  int facultyId, academicRankId;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    File imageFile;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        title: Text(
          'ثبت استاد جدید',
          // textDirection: TextDirection.rtl,
          style: PersianFonts.Shabnam.copyWith(color: kPrimaryColor),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Column(
              children: [
                CustomColumnCard(
                  controller1: firstNameController,
                  controller2: lastNameController,
                  node: node,
                  text1: 'نام',
                  text2: 'نام خانوادگی',
                  text3: 'دانشکده',
                  text4: facultyName,
                  onPressed: () {},
                ),
                SizedBox(
                  height: 10,
                ),
                CustomColumnImageCard(
                  onPressed: () {},
                  node: node,
                  academicRank: academicRank,
                  imageFile: imageFile,
                  phoneController: phoneController,
                  onImageTapped: () {},
                ),
                SizedBox(
                  height: 10,
                ),
                CustomColumnCard(
                  controller1: emailController,
                  controller2: addressController,
                  node: node,
                  text1: 'آدرس ایمیل',
                  text2: 'آدرس دفتر',
                  text3: '  زمان های آزاد   ',
                  text4: 'زمان ها',
                  onPressed: () {},
                ),
                SizedBox(
                  height: 10,
                ),
                CustomRankCard(
                  controller1: bachelorController,
                  controller2: masterController,
                  controller3: phdController,
                  controller4: postPhdController,
                  node: node,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomLinksCard(
                  controller1: webPageLinkController,
                  controller2: googleScholarController,
                  node: node,
                  text1: 'لینک وبسایت',
                  text2: 'لینک گوگل اسکالر',
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  color: kPrimaryColor,
                  onPressed: () {},
                  child: Text(
                    'ثبت اطلاعات',
                    textAlign: TextAlign.center,
                    style: PersianFonts.Shabnam.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
