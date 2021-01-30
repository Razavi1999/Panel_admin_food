import 'dart:io';

import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';

import '../../constants.dart';

class CustomColumnImageCard extends StatelessWidget {
  final File imageFile;
  final String academicRank;
  final node;
  final Function onPressed, onImageTapped;
  final TextEditingController phoneController;

  CustomColumnImageCard({
    this.imageFile,
    this.academicRank,
    this.node,
    this.onPressed,
    this.phoneController,
    this.onImageTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 10,
          bottom: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (imageFile != null) ...[
              Material(
                child: InkWell(
                  highlightColor: Colors.transparent,
                  onTap: onImageTapped,
                  child: Center(
                    child: CircleAvatar(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.file(
                          imageFile,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Material(
                child: InkWell(
                  highlightColor: Colors.transparent,
                  onTap: onImageTapped,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.blueGrey[100],
                      radius: 60,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image(
                          image: AssetImage('assets/images/add_image.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: Row(
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
                        highlightColor: Colors.transparent,
                        onTap: onPressed,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          child: Center(
                            child: Text(
                              academicRank,
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
                    width: 20,
                  ),
                  Text(
                    'رنک آموزشی',
                    style: PersianFonts.Shabnam.copyWith(
                      fontSize: 18,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20, left: 20,),
              child: Text(
                'راه ارتباطی(تلفن)',
                style: PersianFonts.Shabnam.copyWith(
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              // width: width ?? 150,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
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
          ],
        ),
      ),
    );
  }
}
