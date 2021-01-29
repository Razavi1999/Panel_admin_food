

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/components/EmptyEffect.dart';
import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';



class AwesomeListItem extends StatefulWidget {
  String title;
  String content;
  Color color;
  String image;
  Function onPressed;

  AwesomeListItem({this.title, this.content, this.color, this.image,  this.onPressed});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    SizedBox(height: 100,);
    return Material(
      child: InkWell(
        onTap: widget.onPressed,
        highlightColor: Colors.transparent,
        child: new Row(
          children: <Widget>[
            new Container(width: 10.0, height: 200.0, color: widget.color),
            new Expanded(
              child: new Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(
                      widget.title,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: PersianFonts.Shabnam.copyWith(
                          color: Colors.grey.shade800,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: new Text(
                        "دانشگاه علم و صنعت ایران",
                        //widget.content,
                        style: PersianFonts.Shabnam.copyWith(
                            color: Colors.grey.shade500,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              height: 150.0,
              width: 150.0,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  new Transform.translate(
                    offset: new Offset(50.0, 0.0),
                    child: new Container(
                      height: 100.0,
                      width: 100.0,
                      color: widget.color,
                    ),
                  ),
                  new Transform.translate(
                    offset: Offset(10.0, 20.0),
                    child: Material(
                      //color: Colors.black,
                      child: InkWell(
                        onTap: widget.onPressed,
                        highlightColor: Colors.transparent,
                        child: new Card(
                          elevation: 20.0,
                            child: new Container(
                              height: 120.0,
                              width: 120.0,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 10.0,
                                      color: Colors.white,
                                      style: BorderStyle.solid),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(baseUrl +"/media/" + widget.image),
                                  )),
                            ),

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}