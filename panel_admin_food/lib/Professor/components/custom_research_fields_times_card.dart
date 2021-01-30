import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';

import '../../constants.dart';

class CustomResearchFieldsAndTimesCard extends StatelessWidget {
  final String text1, text2, text3, text4;
  final Function onPressed, onPressed2;
  final List times;
  final List researchFields;

  CustomResearchFieldsAndTimesCard({
    this.text1,
    this.text2,
    this.text3,
    this.text4,
    this.onPressed,
    this.onPressed2,
    this.times,
    this.researchFields,
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
            children: [
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
                              text2,
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
                  if(times != null)...[
                    for (int i = 0; i < times.length; i++) ...{
                      Row(
                        children: [
                          Text(
                            times[i],
                            style: PersianFonts.Shabnam.copyWith(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    },
                  ],
                  Text(
                    text1,
                    style: PersianFonts.Shabnam.copyWith(
                      fontSize: 15,
                      color: kPrimaryColor,
                    ),
                  ),
                  if (researchFields != null) ...[
                    for (int i = 0; i < researchFields.length; i++) ...{
                      Row(
                        children: [
                          Text(
                            researchFields[i],
                            style: PersianFonts.Shabnam.copyWith(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    },
                  ],
                ],
              ),
              SizedBox(
                height: 10,
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
                        onTap: onPressed2,
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
