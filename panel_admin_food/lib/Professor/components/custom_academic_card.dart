import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_textfield.dart';
import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';

class CustomRankCard extends StatelessWidget {
  final TextEditingController controller1,
      controller2,
      controller3,
      controller4;
  final node;

  CustomRankCard({
    this.controller1,
    this.controller2,
    this.controller3,
    this.controller4,
    this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      elevation: 5,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 15, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: Text(
                'تحصیلات آموزشی',
                style: PersianFonts.Shabnam.copyWith(
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
            ),
            CustomTextField(controller: controller1, node: node, text: 'کارشناسی',),
            CustomTextField(controller: controller2, node: node, text: ' کارشناسی ارشد',),
            CustomTextField(controller: controller3, node: node, text: 'دکتری',),
            CustomTextField(controller: controller4, node: node, text: 'پسا دکتری',),
          ],
        ),
      ),
    );
  }
}
