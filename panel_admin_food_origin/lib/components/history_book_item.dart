import 'package:flutter/material.dart';

import '../constants.dart';

class MyBookItem extends StatelessWidget {
  final String name, author, url;
  final bool status;
  final int seller, user, buyer;

  MyBookItem(this.name, this.author, this.url, this.status, this.seller, this.buyer, this.user);

  @override
  Widget build(BuildContext context) {
    String whatTheFuck = '';

    if(status == true) {
      if (user == seller) {
        whatTheFuck = 'فروخته شده';
      }
      else {
        whatTheFuck = 'خریده شده';
      }
    }
    else {
      whatTheFuck = 'رزرو شده';
    }

    var size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(38.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          author,
                          style: TextStyle(
                            color: kLightBlackColor,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            whatTheFuck,
                            style: TextStyle(
                              fontSize: 10,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                  FadeInImage(
                    height: 100,
                    width: 100,
                    placeholder: AssetImage('assets/images/book_unknown.png'),
                    image: (url != null)? NetworkImage(url) : AssetImage('assets/images/book_unknown.png'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 7,
            width: size.width * .65,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ],
      ),
    );
  }
}
