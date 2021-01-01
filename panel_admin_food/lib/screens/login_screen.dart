

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../components/already_have_an_account_acheck.dart';
import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../components/rounded_password_field.dart';
import '../constants.dart';
import 'home_screen.dart';
import 'registeration_screen.dart';

// String myUrl = 'http://danibazi9.pythonanywhere.com/api/users-list/';
String myUrl = '$baseUrl/account/login';
class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String password = '',
      email = '';
  bool isObscured = true;
  bool showSpinner = false;

  onEyePressed() {
    if (isObscured) {
      isObscured = false;
    } else {
      isObscured = true;
    }
    print(isObscured);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkStringValueExistence();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.purple.shade200,
        child: Builder(builder: (context) {
          return Container(
            decoration: new BoxDecoration(
                color: darkGrey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                      offset: Offset(0, 3),
                      blurRadius: 6.0),
                ]),

            width: double.infinity,
            height: size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    //"assets/images/photo_2.jpeg",
                    "assets/images/asli_8.jpg",
                    width: size.width  * 1.5,
                    height: size.height * 1.1,
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      //color: Colors.blue
                    ),

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text : "به مدیریت دانشگاه من خوش آمدید",
                            style: TextStyle(fontWeight: FontWeight.bold ,
                            color: kPrimaryColor ,
                              fontSize: 20
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        RoundedInputField(
                          hintText: "پست الکترونیکی",
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        RoundedPasswordField(
                          isObscured: isObscured,
                          onPressed: onEyePressed,
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        RoundedButton(
                          text: "ورود",
                          color: kPrimaryColor,
                          press: () {
                            checkValidation(context);
                          },
                        ),
                        SizedBox(height: size.height * 0.03),
                        AlreadyHaveAnAccountCheck(
                          press: () {
                            Navigator.popAndPushNamed(
                                context, RegisterationScreen.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  checkValidation(BuildContext context) async {
    if (email.length == 0) {
      _showDialog(context, 'ایمیل را پر کنید');
      return;
    }
    if (!email.contains('@')) {
      _showDialog(context, 'فرمت ایمیل اشتباه است');
      return;
    }
    if (password.length == 0) {
      _showDialog(context, 'رمز را پر کنید');
      return;
    }
    setState(() {
      showSpinner = true;
    });
    // String baseUrl = 'http://danibazi9.pythonanywhere.com/';
    // get(baseUrl, context);
    post(baseUrl, context);
  }

  post(String url, BuildContext context) async {
    Map data = {
      'username': email.trim(),
      'password': password.trim(),
    };
    try {
      http.Response result = await http.post(
        '$url/api/account/login',
        body: convert.json.encode(data),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
      if (result.statusCode == 200) {
        setState(() {
          showSpinner = false;
        });
        var jsonResponse = convert.jsonDecode(result.body);
        print(jsonResponse['token']);
        print(jsonResponse);
        addStringToSF(jsonResponse['token'], jsonResponse['user_id'],
            jsonResponse['username'], jsonResponse['first_name'], jsonResponse['last_name']);
      } else if (result.statusCode == 400) {
        setState(() {
          showSpinner = false;
        });
        _showDialog(
            context, 'همچین ایمیلی موجود نیست و یا رمز اشتباه است');
      } else {
        setState(() {
          showSpinner = false;
        });
        _showDialog(context, result.body);
        print(result.statusCode);
        print(result.body);
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      _showDialog(context, 'مشکلی در ارتباط با سرور به وجود آمده است!');
      print("My Error: $e");
    }
  }

  addStringToSF(String token, int user_id, String username, String first_name,
      String last_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'Token $token');
    prefs.setInt('user_id', user_id);
    prefs.setString('username', username);
    prefs.setString('first_name', last_name);
    prefs.setString('last_name', first_name);
    print(prefs.getString('last_name'));
    Navigator.popAndPushNamed(context, HomeScreen.id);
  }

  checkStringValueExistence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      Navigator.popAndPushNamed(context, HomeScreen.id);
    }
    else {
      // pass
    }
  }

  _showDialog(BuildContext context, String message) {
    // Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    AlertDialog dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            message,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,
            style: PersianFonts.Shabnam.copyWith(fontSize: 20),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'باشه!',
              textDirection: TextDirection.rtl,
              style: PersianFonts.Shabnam.copyWith(
                  color: kPrimaryColor ,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(context: context, child: dialog);
  }
}
