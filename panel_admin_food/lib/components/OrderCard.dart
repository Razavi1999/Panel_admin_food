import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/constants.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:pie_chart/pie_chart.dart';





class OrderCard extends StatefulWidget {
  String name, image, description;
  Map<String , double> data;
  int cost;
  final Function onPressed;

  OrderCard({
    this.name, this.image, this.onPressed, this.cost,this.description ,
    this.data
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]
            )
          ]
        ),
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
                           replaceFarsiNumber(widget.cost.toString()) + ' ریال  ' ,
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


                      PieChart(
                        dataMap: widget.data,
                        legendFontColor: Colors.blueGrey[900],
                        legendFontSize: 10.0,
                        legendFontWeight: FontWeight.w500,
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: 7.0,
                        chartRadius: MediaQuery.of(context).size.width / 10,
                        showChartValuesInPercentage: true,
                        //showChartValues: true,
                        //showChartValuesOutside: false,
                        chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
                        //colorList: colorList,
                        //showLegends: true,
                        //decimalPlaces: 1,
                        //showChartValueLabel: true,
                        //chartValueFontSize: 12,
                        //chartValueFontWeight: FontWeight.bold,
                        //chartValueLabelColor: Colors.grey[200],
                        //initialAngle: 0,
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
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    //height: 50,
                    placeholder: AssetImage('assets/images/food.png'),
                    image: NetworkImage(widget.image),
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
    );
  }
}
