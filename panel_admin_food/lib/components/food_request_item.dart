import 'package:flutter/material.dart';
import 'package:persian_fonts/persian_fonts.dart';

import '../constants.dart';

class FoodRequestItem extends StatelessWidget {
  final String name;
  final int requestId, student_number, counter;
  final double price;
  final Function onPressed;
  final String time_period;
  final List foodNames, foodCounts;

  FoodRequestItem({
    this.name,
    this.requestId,
    this.student_number,
    this.onPressed,
    this.time_period,
    this.foodCounts,
    this.foodNames,
    this.counter,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white,
      elevation: 16,

      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      child: ListTile(
        leading: Column(
          children: [
            Text(
               name,
              style: PersianFonts.Shabnam.copyWith(fontSize: 13),
            ),

            SizedBox(height: 15,),

            Text(
              replaceFarsiNumber(price.toString().substring(0, price.toString().length-2)) + ' تومان',
              style: PersianFonts.Shabnam.copyWith(fontSize: 16),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        title: ListView.builder(
          itemBuilder: (context, index) {
            return Text(
              foodNames[index] + ' ' + replaceFarsiNumber(foodCounts[index].toString()) + ' عدد',
              textDirection: TextDirection.rtl,
              style: PersianFonts.Shabnam.copyWith(
                fontWeight: FontWeight.w200
              ),
            );
          },
          itemCount: counter,
          shrinkWrap: true,
        ),
        // subtitle: Text(student_number.toString()),
        trailing: FlatButton(
          onPressed: onPressed,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('پایان خرید' ,
            style: PersianFonts.Shabnam.copyWith(
              color: Colors.white
            ),
          ),
          color: Colors.green,
        ),
      ),
    );
  }
}
