import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/screens/login_screen.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kAnimationDuration = Duration(milliseconds: 200);
const kBlackColor = Color(0xFF393939);
const kLightBlackColor = Color(0xFF8F8F8F);
const kIconColor = Color(0xFFF48A37);
const kProgressIndicator = Color(0xFFBE7066);

const Color yellow = Color(0xffFDC054);
const Color mediumYellow = Color(0xffFDB846);
const Color darkYellow = Color(0xffE99E22);
const Color transparentYellow = Color.fromRGBO(253, 184, 70, 0.7);
const Color darkGrey = Color(0xff202020);

const KSellBook = Color(0xFFFF0000);
const KBuyBook = Color(0xFF00FF00);

LinearGradient mainButton = LinearGradient(colors: [
  Color.fromRGBO(236, 60, 3, 1),
  Color.fromRGBO(234, 60, 3, 1),
  Color.fromRGBO(216, 78, 16, 1),
], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
];

String replaceFarsiNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (int i = 0; i < english.length; i++)
    input = input.replaceAll(english[i], farsi[i]);

  return input;
}

void discuss(BuildContext context, String message) {
  AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.RIGHSLIDE,
      headerAnimationLoop: false,
      title: 'خطا',
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red)
    ..show();
}

void warning_logout(BuildContext context, String message) {
  AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      headerAnimationLoop: false,
      animType: AnimType.TOPSLIDE,
      showCloseIcon: true,
      closeIcon: Icon(Icons.close_fullscreen_outlined),
      title: 'اخطار',
      btnOkText: 'بله',
      btnCancelText: 'خیر',
      desc: message,
      btnCancelOnPress: () {
        //Navigator.pop(context);
      },
      btnOkOnPress: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        //Navigator.pop(context);
        Navigator.popAndPushNamed(context, LoginScreen.id);
      })
    ..show();
}

void success(BuildContext context, String message) {
  AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.RIGHSLIDE,
      headerAnimationLoop: true,
      title: 'موفق شدید',
      desc: message,
      btnOkOnPress: () {

      },
      btnOkIcon: Icons.check_circle,
      btnOkColor: Colors.green)
    ..show();
}

void info(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    headerAnimationLoop: true,
    animType: AnimType.BOTTOMSLIDE,
    title: 'اطلاعات',
    desc: message,
  )..show();
}

final kHomeDecoration = BoxDecoration(
  color: Color(
    0xff453658,
  ),
  borderRadius: BorderRadius.circular(20),
);

final kShadowColor = Color(0xFFD3D3D3).withOpacity(.84);
String baseUrl = 'http://172.17.3.157';
// String baseUrl = 'http://192.168.43.126:8000';
screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}
// TODO Implement this library.
