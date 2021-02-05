import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final node;
  final double width;
  CustomTextField(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              // height: 50,
              // width: width ?? 150,
              child: TextFormField (
                controller: controller,
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
                onEditingComplete: () => node.nextFocus(), // Move focus to next
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: PersianFonts.Shabnam.copyWith(
                fontSize: 15,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
