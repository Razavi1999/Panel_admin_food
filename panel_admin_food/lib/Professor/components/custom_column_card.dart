import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';

class CustomNameAndResearchFieldsCard extends StatelessWidget {
  final TextEditingController controller1, controller2;
  final String text1, text2, text3, text4;
  final node;
  final double width;
  final Function onPressed;

  CustomNameAndResearchFieldsCard({
    @required this.controller1,
    @required this.controller2,
    this.text1,
    this.text2,
    @required this.node,
    this.width,
    this.onPressed,
    this.text3,
    this.text4,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 5,
          bottom: 15,
        ),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text1,
                style: PersianFonts.Shabnam.copyWith(
                  fontSize: 18,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                // width: width ?? 150,
                child: TextFormField(
                  controller: controller1,
                  textDirection: TextDirection.rtl,
                  cursorColor: kPrimaryColor,
                  style: PersianFonts.Shabnam.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    contentPadding: EdgeInsets.only(
                      bottom: 25, // HER
                      left: 20,
                      right: 20,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                  ),
                  onEditingComplete: () =>
                      node.nextFocus(), // Move focus to next
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                text2,
                style: PersianFonts.Shabnam.copyWith(
                  fontSize: 18,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                // width: width ?? 150,
                child: TextFormField(
                  controller: controller2,
                  textDirection: TextDirection.rtl,
                  cursorColor: kPrimaryColor,
                  style: PersianFonts.Shabnam.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    contentPadding: EdgeInsets.only(
                      bottom: 25, // HER
                      left: 20,
                      right: 20,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                  ),
                  onEditingComplete: () =>
                      node.nextFocus(), // Move focus to next
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        highlightColor: Colors.transparent,
                        onTap: onPressed,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              text4,
                              textAlign: TextAlign.center,
                              style: PersianFonts.Shabnam.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    text3,
                    style: PersianFonts.Shabnam.copyWith(
                      fontSize: 15,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
