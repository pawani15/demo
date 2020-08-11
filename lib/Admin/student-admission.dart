import 'dart:collection';
import 'dart:io';

import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';
import '../dashboard.dart';
import 'Adminstudentinformation.dart';

class StudentadmissionPage extends StatefulWidget {
  final String studid;
  StudentadmissionPage({this.studid});
  @override
  State<StatefulWidget> createState() => new _StudentadmissionPageState();
}

class _StudentadmissionPageState extends State<StudentadmissionPage> {

  @override
  void initState() {
    super.initState();
   // LoadProfile();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Students"),
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
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
              shape: BoxShape.rectangle
            ),
//            child: new Container(
//              margin: EdgeInsets.only(top: 20),
//             // child: new Text("Student Admission",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
//            ),
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 30,right: 30,bottom: 20,top: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: AddStudentsPage(type: "new",studentdetails: null,id: null,))
            //_loading ? new Constants().bodyProgress :
        ],
      ),
    );
  }

}

