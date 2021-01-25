import 'package:flutter/material.dart';
import 'package:panel_admin_food_origin/models/plants.dart';
import 'package:panel_admin_food_origin/models/separator.dart';
import 'package:panel_admin_food_origin/models/text_style.dart';

import 'detailProfessor.dart';


class PlanetSummary extends StatelessWidget {

  final Planet planet;
  final bool horizontal;

  PlanetSummary(this.planet, {this.horizontal = true});

  PlanetSummary.vertical(this.planet): horizontal = false;


  @override
  Widget build(BuildContext context) {

    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(
          vertical: 16.0
      ),
      alignment: horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: new Hero(
        tag: "planet-hero-${planet.id}",
        child:  FadeInImage(
              image:  NetworkImage(planet.image),
              placeholder: AssetImage('assets/images/food.png'),
            height: 92.0,
            width: 92.0,
        ),
      ),
    );



    Widget _planetValue({String value, String image}) {
      //return Text("Ahmad Ahmad");
      return  Container(
        //height: 100,
        child:  Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               FadeInImage(
                   image:  NetworkImage(image),
                   placeholder: AssetImage('assets/images/food.png'),
                   height: 12.0
               ),
               Container(width: 8.0),
               Text(planet.gravity, style: Style.smallTextStyle),
            ]
        ),
      );
    }


    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(horizontal ? 76.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(planet.name, style: Style.titleTextStyle),
          new Container(height: 10.0),
          new Text(planet.location, style: Style.commonTextStyle),
          new Separator(),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  flex: horizontal ? 1 : 0,
                  child: _planetValue(
                      value: planet.distance,
                      image: 'assets/images/ic_distance.png')

              ),
              new Container(
                width: horizontal ? 8.0 : 32.0,
              ),
              new Expanded(
                  flex: horizontal ? 1 : 0,
                  child: _planetValue(
                      value: planet.gravity,
                      image: 'assets/images/ic_gravity.png')
              )
            ],
          ),
        ],
      ),
    );


    final planetCard = new Container(
      child: planetCardContent,
      height: horizontal ? 124.0 : 154.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 46.0)
          : new EdgeInsets.only(top: 72.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    //return Text("Salam");


    return new GestureDetector(
        onTap: horizontal
            ? () => Navigator.of(context).push(
          new PageRouteBuilder(
            pageBuilder: (_, __, ___) =>  DetailPageProfessor(planet),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            new FadeTransition(opacity: animation, child: child),
          ) ,
        )
            : null,
        child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard,
              planetThumbnail,
            ],
          ),
        )
    );
  }
}
