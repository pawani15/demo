import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../const.dart';
import '../dashboard.dart';

class StudentSubjects extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StudentSubjectsPageState();
}

class _StudentSubjectsPageState extends State<StudentSubjects>
{
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  List studentlist;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadsubjects();
    // LoadStudents();
  }

  Future<Null> Loadsubjects() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.LoadSubjects_students;
    Map<String, String> body = new Map();
    body['student_id'] = id;
//    body['class_name'] = id;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            for (Map user in responseJson['result']['subjects']) {
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

//  Future<Null> LoadStudents() async {
//    String empid = await sp.ReadString("Userid");
//    var url = await Constants().Clienturl() + Constants.Load_Teachers;
//    Map<String, String> body = new Map();
//
//    print("url is $url"+"body--"+body.toString());
//
//    http.get(url,
//        headers: {"Content-Type": "application/x-www-form-urlencoded"})
//        .then((response) {
//      if (response.statusCode == 200) {
//        print("response --> ${response.body}");
//        var responseJson = json.decode(response.body);
//        if (responseJson['status'].toString() == "true") {
//          print("response json ${responseJson}");
//          try {
//            for (Map user in responseJson['data']) {
//              _Teacherdetails.add(Teacherdetails.fromJson(user));
//            }
//            //teacherslist = responseJson['data'];
//          }catch(e){
//            _Teacherdetails = new List();
//          }
//        }
//        setState(() {
//          _loading = false;
//        });
//      }
//      else {
//        print("erroe--"+response.body);
//      }
//    });
//  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar:
      new AppBar(
        title: Text("Subject"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//
//        ),
      ),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
//          new Container(
//            height: 110,
//            width: double.infinity,
//            decoration: BoxDecoration(
//                color: Color(0xff182C61),
//                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
//                shape: BoxShape.rectangle
//            ),
////            child: Column(
////              mainAxisAlignment: MainAxisAlignment.center,
////              children: <Widget>[
////                new SizedBox(width: 15,height: 15,),
////                new Text("Subject ",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
////                new SizedBox(width: 15,height: 15,),
////                Row(
////                  mainAxisAlignment: MainAxisAlignment.center,
////                  children: <Widget>[
////                    Image.asset('assets/refresh_icon.png',),
////                    SizedBox( width: 10,),
////                    new Text("Home > Subject",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
////                  ],
////                ),
////
////              ],
////            ),
//          ),
//          new Card(
//            margin: new EdgeInsets.only(left: 15,right: 15,bottom: 10),
//            child: new ListTile(
//              leading: new Icon(Icons.search,color: Color(0xff182C61),),
//              title: new TextField(
//                controller: controller,
//                decoration: new InputDecoration(
//                    hintText: 'Search..', border: InputBorder.none,),
//                onChanged: onSearchTextChanged,
//              ),
//              trailing: new IconButton(
//                icon: new Icon(Icons.cancel),
//                onPressed: () {
//                  controller.clear();
////                  onSearchTextChanged('');
//                },
//              ),
//            ),
//          ),
          new Stack(
            children: <Widget>[
              new Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                    shape: BoxShape.rectangle
                ),
                child: new Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:18.0),
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              new Text("Subject ",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                              SizedBox(height: 5 ,width: 10,),
//                              Padding(
//                                padding: const EdgeInsets.only(left:120.0),
//                                child: Row(
//                                  children: <Widget>[
//                                    Image.asset('assets/refresh_icon.png',),
//                                    SizedBox( width: 10,),
//                                    new Text("Home > Subject",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                                  ],
//                                ),
//                              ),
//
//                            ],
//                          ),
                        )
                      ],
                    )

                ),
              ),
              new Card(
                margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10),
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
//                  trailing: new IconButton(
//                    icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                    onPressed: () {
//                      controller.clear();
//                      onSearchTextChanged('');
//                    },
//                  ),
                ),
              ),
              new Card(
                elevation: 5.0,
                margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top:70),
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                          child: new Text("Subjects List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                        ),
                        new Divider(height: 16,color: Theme.of(context).primaryColor,),
                        new Padding(padding: new EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Class",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                                new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Subject Name",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                                new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Teacher",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
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
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Subjectdetails[index].classname,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Subjectdetails[index].subject,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Subjectdetails[index].teacher,style: TextStyle(color: Colors.black,fontSize: 11),maxLines: 2,textAlign: TextAlign.center),),flex: 1,),
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
  String classname, subject, teacher,id;
  Subjectdetails({this.classname, this.subject, this.teacher,this.id});
  factory Subjectdetails.fromJson(Map<String, dynamic> json) {
    return new Subjectdetails(
        id:json['subject_id'].toString(),
        subject: json['subject_name'].toString(),
        teacher: json['teacher_name'].toString(),
        classname: json['class_name'].toString()
    );
  }
}
