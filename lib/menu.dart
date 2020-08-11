import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Navigation",style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xff182C61),
      ),
      body: new Container(
        padding: EdgeInsets.all(10),
          child: new ListView(
        children: <Widget>[
          new Container(
              margin: EdgeInsets.all(5),
              child: new Row(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: new Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white,width: 3),
                      color: Theme.of(context)
                          .primaryColor),
                  child: new SvgPicture.asset("assets/dashboard.svg",width: 20,height: 20,color: Colors.white,),
                  padding: EdgeInsets.all(10),
                ),flex: 3,
              ),
              Expanded(
                child: new Container(child: new Text("Dashboard",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,),),margin: EdgeInsets.only(left: 5),),flex: 17,
              ),
            ],)),
          GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(1, (index) {
                return new Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  color: Colors.white,
                  child: new Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    child:  new Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: new Container(
                          padding: EdgeInsets.all(3),
                          child: new SvgPicture.asset("assets/dashboard.svg",width: 50,height: 50,color: Colors.green,),
                        )),
                        new Container(
                          padding: EdgeInsets.all(3),
                          child: new Text("Dashboard",style: TextStyle(color: Colors.green,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                  ),
                );
              })
          ),
          /*new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                color: Colors.white,
                child: new Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(3),
                        child: new SvgPicture.asset("assets/student.svg",width: 50,height: 50,color: Colors.green,),
                      ),
                      new Container(
                        padding: EdgeInsets.all(3),
                        child: new Text("Dashboard",style: TextStyle(color: Colors.green,fontSize: 12)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),*/
          GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(6, (index) {
                return new Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  color: Colors.white,
                  child: new Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    child:  new Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: new Container(
                          padding: EdgeInsets.all(3),
                          child: new SvgPicture.asset("assets/student.svg",width: 50,height: 50,color: Colors.green,),
                        )),
                        new Container(
                          padding: EdgeInsets.all(3),
                          child: new Text("Student",style: TextStyle(color: Colors.green,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                  ),
                );
              })
          )
        ],
      )),
    );
  }

}