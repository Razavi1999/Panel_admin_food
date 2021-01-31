import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:pie_chart/pie_chart.dart';





class OrderCard2 extends StatefulWidget {
  String name, image, description;
  Map<String , double> data;
  String cost;
  final Function onPressed;

  OrderCard2({
    this.name, this.image, this.onPressed, this.cost,this.description ,
    this.data
  });

  @override
  _OrderCard2State createState() => _OrderCard2State();
}

class _OrderCard2State extends State<OrderCard2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        elevation: 6,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          widget.name,
                          textAlign: TextAlign.right,
                          style: PersianFonts.Shabnam.copyWith(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: 5.0,
                        ),

                        Text(
                          replaceFarsiNumber(widget.cost.toString()) ,
                          textDirection: TextDirection.rtl,
                          style: PersianFonts.Shabnam.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor
                          ),
                        ),

                        SizedBox(
                          height: 5.0,
                        ),


                        RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 12.0),
                          textAlign: TextAlign.right,
                          text: TextSpan(
                              text: widget.description,
                              style: PersianFonts.Shabnam.copyWith(
                                  color: kPrimaryColor
                              )
                          ),
                        ),



                        SizedBox(
                          height: 5.0,
                        ),


                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                  ),

                  Container(
                    height: 95.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child:  CircleAvatar(
                      maxRadius: 50,
                      backgroundImage: NetworkImage( widget.image , ),
                    ),
                  ),

                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
