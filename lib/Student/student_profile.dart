import 'package:Edecofy/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../dashboard.dart';



class StudentProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  bool notification = false,locationtracking = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Create Profile"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),

      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Center(
              child: new Container(
                  padding: new EdgeInsets.all(5.0),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                  child: new Image.network("https://cdn4.iconfinder.com/data/icons/ionicons/512/icon-image-128.png",width: 30,height: 30,)
              ),
            ),
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 40,right: 40,bottom: 20,top: 160),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new Padding(padding: EdgeInsets.all(10.0),
              child: new ListView(
                children: <Widget>[
                  new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Username",
                        prefixIcon: new Icon(FontAwesomeIcons.user)
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: new Icon(Icons.email)
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "Contact number",
                        prefixIcon: new Icon(Icons.call)
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Address",
                        prefixIcon: new Icon(Icons.location_on)
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Language",
                        prefixIcon: new Icon(FontAwesomeIcons.language)
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Gender",
                        prefixIcon: new Icon(FontAwesomeIcons.transgender)
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.notifications),
                    title: new Text("Notifications"),
                    trailing: new Switch(value: notification, onChanged: (val){
                      setState(() {
                        notification = val;
                      });
                    }),
                  ),
                  new Divider(color: Colors.black,),
                  new TextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: new Icon(FontAwesomeIcons.lock)
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(FontAwesomeIcons.ambulance),
                    title: new Text("Location Tracking"),
                    trailing: new Switch(value: locationtracking, onChanged: (val){
                      setState(() {
                        locationtracking = val;
                      });
                    }),
                  ),
                  new Divider(color: Colors.black,),
                  new SizedBox(width: 10,height: 10,),
                  new Container(
                    margin: new EdgeInsets.all(5.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Container(margin: new EdgeInsets.all(3.0),
                            child: new RaisedButton(onPressed: (){
                              Navigator.of(context).pop();
                            },color: Colors.red,
                              splashColor: Colors.blueGrey,
                              child: new Text("Reset",style: TextStyle(color: Colors.white),),
                            )),flex: 1,),
                        new Expanded(child: new Container(margin: new EdgeInsets.all(3.0),
                            child:new RaisedButton(onPressed: (){
                            },
                                color: Theme.of(context).primaryColor,
                                splashColor: Colors.blueGrey,
                                child: new Text("Submit",style: TextStyle(color: Colors.white,),))),flex: 1,),
                      ],
                    ),
                  )
                ],
              ),),
          )
        ],
      ),
    );
  }

}