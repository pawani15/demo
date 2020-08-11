import 'package:Edecofy/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dashboard.dart';

class UploadProfilepic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _UploadProfilepicState();
}

class _UploadProfilepicState extends State<UploadProfilepic> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Profile Pic"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
        drawer: Constants().drawer(context),
      body: new Card(
            elevation: 5.0,
            margin: new EdgeInsets.all(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new Padding(padding: EdgeInsets.all(10.0),
            child: new ListView(
              children: <Widget>[
                new SizedBox(width: 30,height: 30,),
                new Text("Upload Profile Picture",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                new SizedBox(width: 40,height: 40,),
                new InkWell(
                  child: new Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle
                  ),
                    padding: new EdgeInsets.all(10),
                    child: Image.asset("assets/user.png",height: 90,width: 90,),
                ),onTap: (){

                },
                ),
                new SizedBox(width: 30,height: 30,),
                new Text("Upload a Photo",style: TextStyle(fontSize: 14,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                new SizedBox(width: 5,height: 5,),
                new Text("with your phone",style: TextStyle(fontSize: 12,color: Colors.grey,fontWeight: FontWeight.normal),textAlign: TextAlign.center,),
                new SizedBox(width: 30,height: 30,),
                new Text("Take a Photo",style: TextStyle(fontSize: 14,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                new SizedBox(width: 5,height: 5,),
                new Text("with your cam",style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.normal),textAlign: TextAlign.center,),
                new SizedBox(width: 50,height: 50,),
                new InkWell(onTap: null,
                child: new Container(child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(FontAwesomeIcons.arrowRight,color: Colors.white,),
                    Padding(child: new Text("Finish",style: TextStyle(color: Colors.white,fontSize: 14),),padding: EdgeInsets.only(left: 5.0),),
                  ],
                ),
                  padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                  margin: EdgeInsets.only(left: 70,right: 70,top: 10,bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                      boxShadow: [new BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10.0,
                      ),]
                  ),
                ),
                ),
              ],
            ),),
          )
    );
  }

}