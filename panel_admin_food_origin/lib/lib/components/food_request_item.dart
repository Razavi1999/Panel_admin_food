import 'package:flutter/material.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ListTile(
        leading: Column(
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5,),
            Text(
              price.toString().substring(0, price.toString().length-2) + ' تومان',
              style: TextStyle(fontSize: 12),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        title: ListView.builder(
          itemBuilder: (context, index) {
            return Text(
              foodNames[index] + ' ' + foodCounts[index].toString() + ' عدد',
              textDirection: TextDirection.rtl,
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
          child: Text('پایان خرید'),
          color: Colors.green,
        ),
      ),
    );
  }
}
