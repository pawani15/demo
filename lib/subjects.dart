import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'const.dart';
import 'dashboard.dart';

class SubjectsPage extends StatefulWidget {
  final String classname,id;
  SubjectsPage({this.classname,this.id});
  @override
  State<StatefulWidget> createState() => new _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadsubjects();
  }

  Future<Null> Loadsubjects() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Subjects+widget.id+"/"+id;
    Map<String, String> body = new Map();
    body['teacher_id'] = id;
    body['class_id'] = widget.id;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"})
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            for (Map user in responseJson['result']['subject']) {
              _Subjectdetails.add(Subjectdetails.fromJson(user));
            }
          }catch(e){
            _Subjectdetails = new List();
          }
        }
        setState(() {
          _loading = false;
        });
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Subject"),
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
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
              shape: BoxShape.rectangle
            ),
//            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 15,height: 15,),
//                    new Container(
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        color: Colors.orange
//                      ),
//                      child: new Icon(Icons.subject,color: Colors.white,size: 25,),
//                      padding: new EdgeInsets.all(5),
//                      margin: EdgeInsets.all(5),
//                    ),
//                    new Text("Subject",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search ', border: InputBorder.none),
                onChanged: onSearchTextChanged,
              ),
//              trailing: new IconButton(
//                icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                onPressed: () {
//                  controller.clear();
//                  onSearchTextChanged('');
//                },
//              ),
            ),
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 90),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.all(5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Class",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Subject",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Teacher",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Expanded(child: _searchResult.length != 0 || controller.text.isNotEmpty ?
                    new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(5),
                              child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_searchResult[index].classname,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_searchResult[index].subject,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_searchResult[index].teacher,style: TextStyle(color: Colors.black,fontSize: 11),maxLines: 2,textAlign: TextAlign.center),),flex: 1,),
                                ],
                          )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount: _searchResult == null ? 0 : _searchResult.length,
                    ) : _Subjectdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(5),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Subjectdetails[index].classname,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Subjectdetails[index].subject,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Subjectdetails[index].teacher,style: TextStyle(color: Colors.grey,fontSize: 11),maxLines: 2,textAlign: TextAlign.center),),flex: 1,),
                                ],
                              )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount:_Subjectdetails == null ? 0 : _Subjectdetails.length,
                    )
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Subjectdetails.forEach((vehicleDetail) {
      if (vehicleDetail.subject.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.teacher.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.classname.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Subjectdetails> _searchResult = [];
  List<Subjectdetails> _Subjectdetails = [];

}

class Subjectdetails {
  String classname, subject, teacher;
  Subjectdetails({this.classname, this.subject, this.teacher});
  factory Subjectdetails.fromJson(Map<String, dynamic> json) {
    return new Subjectdetails(
        subject: json['subject_name'].toString(),
        teacher: json['teacher_name'].toString(),
        classname: json['class_name'].toString()
    );
  }
}