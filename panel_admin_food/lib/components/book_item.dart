import 'dart:math';

import 'package:flutter/material.dart';

import '../constants.dart';

class BookItem extends StatelessWidget {
  final String name, url, author, faculty, publisher, cost, timeStamp;
  final int book_id, seller_id;
  final Function onPressed;

  BookItem({this.name,
    this.url,
    this.faculty,
    this.publisher,
    this.book_id,
    this.seller_id,
    this.author,
    this.cost,
    this.timeStamp,
    this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 150,
        margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Banner(
                  color: Colors.purple.shade300,
                  message: cost,
                  location: BannerLocation.bottomEnd,
                  child: ClipRRect(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(5),
                    //   border: Border.all(
                    //     color: Colors.grey,
                    //     width: 1,
                    //   ),
                    // ),

                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage(
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/book_unknown.png'),
                      image: NetworkImage(url),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(name),
                      Text(author),
                      Text(publisher),
                      Text(timeStamp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
