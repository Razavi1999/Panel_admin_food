import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  String name, image, description;
  int cost;
  final Function onPressed;

  OrderCard({this.name, this.image, this.onPressed, this.cost,this.description});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          elevation: 2,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'قیمت :   ' +
                      widget.cost.toString(),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(
                          fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
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
