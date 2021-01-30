import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';

class CustomColumnTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final node;
  final double width;
  CustomColumnTextField(
      {@required this.controller, this.text, @required this.node, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 5,
        bottom: 15,
      ),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Text(
                text,
                textAlign: TextAlign.end,
                style: PersianFonts.Shabnam.copyWith(
                  fontSize: 15,
                  color: kPrimaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              // width: width ?? 150,
              child: TextFormField (
                controller: controller,
                textDirection: TextDirection.rtl,
                cursorColor: kPrimaryColor,
                keyboardType: TextInputType.url,
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
                onEditingComplete: () => node.nextFocus(), // Move focus to next
              ),
            ),
          ],
        ),
      ),
    );
  }
}
