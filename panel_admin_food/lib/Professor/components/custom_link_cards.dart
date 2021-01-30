import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/Professor/components/custom_column_textfield.dart';

class CustomLinksCard extends StatelessWidget {
  final node;
  final TextEditingController controller1, controller2;
  final text1, text2;

  CustomLinksCard(
      {this.node, this.controller1, this.controller2, this.text1, this.text2});

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
          children: [
            CustomColumnTextField(
              controller: controller1,
              node: node,
              text: text1,
            ),
            SizedBox(
              height: 10,
            ),
            CustomColumnTextField(
              controller: controller2,
              node: node,
              text: text2,
            ),
          ],
        ),
      ),
    );
  }
}
