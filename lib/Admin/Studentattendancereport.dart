import 'dart:math';

import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../const.dart';
import '../dashboard.dart';

class StudentattendancereportPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StudentattendancereportPageState();
}

class _StudentattendancereportPageState extends State<StudentattendancereportPage> {
  String exam = "",classname='',sectionnamme='',clas = '',month = "",section='',
      year = '',Classname='';
  bool _loading = false;
  List<String> monthlist = new List(),yearlist = new List(),datelist=new List(),dateheadinglist=new List();
  Map runningyearmap = null;
  List Attendancelist = new List();
  Map monthmap = new Map();
  bool showreport = true;
  DateTime date = null;

  List<String> sectionslist = new List();
  Map<String,String> sectionamp = new Map();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    monthlist.add("January");
    monthlist.add("February");
    monthlist.add("March");
    monthlist.add("April");
    monthlist.add("May");
    monthlist.add("June");
    monthlist.add("July");
    monthlist.add("August");
    monthlist.add("September");
    monthlist.add("October");
    monthlist.add("November");
    monthlist.add("December");
    monthmap["January"] = "1";
    monthmap["February"] = "2";
    monthmap["March"] = "3";
    monthmap["April"] = "4";
    monthmap["May"] = "5";
    monthmap["June"] = "6";
    monthmap["July"] = "7";
    monthmap["August"] = "8";
    monthmap["September"] = "9";
    monthmap["October"] = "10";
    monthmap["November"] = "11";
    monthmap["December"] = "12";
    for(int i=1;i<=30;i++) {
      if(i==1) {
        dateheadinglist.add("Student | Date");
        datelist.add("Student Name");
      }
      else {
        dateheadinglist.add(i.toString());
        datelist.add("P");
      }
      }
    LoadClassdetails();
  }

  LoadClassdetails() async{
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();

    var url = await Constants().Clienturl() + Constants.Load_Classes;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['classes']) {
            classlist.add(data['name']);
            classmap[data['name']] = data['class_id'];
          }
        }
        GetRunningyear();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Map classmap= new Map();
  List<String> classlist= new List();
  LoadSections() async{
    sectionslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();

    var url = await Constants().Clienturl() + Constants.Load_Sections+classmap[clas];
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['sections']) {
            sectionslist.add(data['name']);
            sectionamp[data['name']] = data['section_id'];
          }
        }
        Navigator.of(context).pop();
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> Showreport() async {
    String id = await sp.ReadString("Userid");
    if (month == "") {
      Constants().ShowAlertDialog(context, "Please Select Month");
      return;
    }
    if (year == "") {
      Constants().ShowAlertDialog(context, "Please Select Year");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Load_Attendencereport+"16";
    Map<String, String> body = new Map();
    body['student_id'] = id;
    body['month'] = monthmap[month];
    body['year'] = year;

    print("url is $url" + "body--" + body.toString());

    http
        .post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson != null) {
          print("response json ${responseJson}");
          setState(() {
            Attendancelist = responseJson['result']['status'];
            Classname = responseJson['result']['class_name']+"-"+responseJson['result']['section_name'];
            showreport = false;
          });
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  Future<Null> GetRunningyear() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Runningyear+"16";
    Map<String, String> body = new Map();
    print("url is $url" + "body--" + body.toString());

    http
        .post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          runningyearmap = responseJson['result'];
          String year = runningyearmap['running_year'];
          yearlist.add(year.split("-")[0]);
          yearlist.add(year.split("-")[1]);
          setState(() {
            _loading = false;
          });
        }

      } else {
        setState(() {
          _loading = false;
        });
        print("erroe--" + response.body);
      }
    });
  }
  Future<Null> _selectDate(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-50),
          lastDate: DateTime.now());

      if (picked != null && picked != date) {
        print('date selected : ${date.toString()}');
        setState(() {
          date = picked;
        });
      }
    }catch(e){e.toString();}
  }

  _navigatetoclasses(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Classes", classlist);
    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    if(result != null)
      LoadSections();
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      section = result ?? section;
    });
    print("res--"+result.toString());
  }

  _navigatetomonth(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Month", monthlist);
    setState(() {
      month = result ?? month;
    });
    print("res--"+result.toString());
  }

  _navigatetoyear(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Year", yearlist);
    setState(() {
      year = result ?? year;
    });
    print("res--"+result.toString());
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Manage Attendance"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
        drawer: Constants().drawer(context),
      body: _loading ? new Constants().bodyProgress : new ListView(
        children: <Widget>[
          new Stack(
        children: <Widget>[
          new Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
            padding: new EdgeInsets.only(top: 20),
            child: new Text("Attendence Report of Student",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          ),
          new Card(
                    margin:
                    new EdgeInsets.only(left: 40, right: 40, bottom: 10, top: 70),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "Class *",
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                ),
                                controller: TextEditingController(text: clas),
                                enabled: false,
                              ),
                              onTap: () {
                                _navigatetoclasses(context);
                              },
                            )),
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "Section *",
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                ),
                                controller: TextEditingController(text: section),
                                enabled: false,
                              ),
                              onTap: () {
                                _navigatetosections(context);
                              },
                            )),
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "Month *",
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                ),
                                controller: TextEditingController(text: month),
                                enabled: false,
                              ),
                              onTap: () {
                                _navigatetomonth(context);
                              },
                            )),
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: "Sessional Year *",
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                ),
                                onChanged: (String val) {
                                  year = val;
                                },
                                controller: TextEditingController(text: year),
                                enabled: false,
                              ),
                              onTap: () {
                                _navigatetoyear(context);
                              },
                            )),
                        new SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: new Container(
                                    margin: new EdgeInsets.all(0.0),
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: new InkWell(
                                        onTap: () {
                                          Showreport();
                                          },
                                        child: new Container(
                                          padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(15),bottomLeft: Radius.circular(15))),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Icon(
                                              FontAwesomeIcons.edit,
                                              color: Colors.white,
                                            ),
                                            new Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "MANAGE ATTENDANCE",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        )))),
                                flex: 1,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
        ],
      ),
          showreport ? new Container() : new Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: ShapeOfView(
              shape: BubbleShape(
                  position: BubblePosition.Bottom,
                  arrowPositionPercent: 0.5,
                  borderRadius: 20,
                  arrowHeight: 15,
                  arrowWidth: 15
              ),
              child: new Container(
                color: Theme.of(context).primaryColor,
                padding: new EdgeInsets.only(top: 10,bottom: 30,right: 70,left: 70),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow[700],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.yellow,width: 3)
                      ),
                    ),
                    new SizedBox(width: 5,height: 5,),
                    new Text("Attendance Sheet",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text(Classname,style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text(month+", "+runningyearmap['sessional_year'],style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                  ],
                ),
              ),
            ),
          ),
          showreport ? new Container() : new Card(
            elevation: 5.0,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(top: 10),
                      child: new Text("Attendance Sheet",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: dateheadinglist.map((head) => DataColumn(label: Text(head))
                        ).toList(),
                        rows:  Attendancelist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                            : Attendancelist.map(
                              (user) => DataRow(
                              cells: datelist.map((date) => DataCell(
                              new Container(child: Text(date),))
                              ).toList()),
                        ).toList(),
                      ),
                    ),
                    new Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: new Container(
                                margin: new EdgeInsets.all(0.0),
                                alignment: Alignment.center,
                                width: double.infinity,
                                child:new InkWell(
                                    onTap: () {
                                      Constants().ShowAlertDialog(context, "Coming Soon!");
                                    },
                                    child: new Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                Radius.circular(15),bottomLeft: Radius.circular(15))),
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Icon(
                                              Icons.print,
                                              color: Colors.white,
                                            ),
                                            new Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "Print Attendence",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            )
                                          ],
                                        )))),
                            flex: 1,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
          ),
        ],
      )
    );
  }
}
