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

class AttendancereportPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _AttendancereportPageState();
}

class _AttendancereportPageState extends State<AttendancereportPage> {
  bool notification = false, locationtracking = false;
  String exam = "",
      clas = '',
      section = '', examaname='',classname='',sectionname='',subjectname='';
  bool _loading = false;
  List<String> monthlist = new List(),yearlist = new List();
  Map runningyearmap = null;
  List attendancelist = new List();
  bool showreport = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadCLassdetails();
  }

  DateTime startdate = null,enddate = null;

  Future<Null> _selectstartDate(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != startdate) {
        print('date selected : ${startdate.toString()}');
        setState(() {
          startdate = picked;
        });
      }
    }catch(e){e.toString();}
  }

  Future<Null> _selectendDate(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != enddate) {
        print('date selected : ${enddate.toString()}');
        setState(() {
          enddate = picked;
        });
      }
    }catch(e){e.toString();}
  }

  Future<Null> Showreport() async {
    String id = await sp.ReadString("Userid");
    if(clas == ''){
      Constants().ShowAlertDialog(context, "Please select Class");
      return;
    }
    if (section == "") {
      Constants().ShowAlertDialog(context, "Please Select Section");
      return;
    }
    if(startdate == null){
      Constants().ShowAlertDialog(context, "Please select start date");
      return;
    }
    if(enddate == null){
      Constants().ShowAlertDialog(context, "Please select end date");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Load_Attendancereport_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = classmap[clas];
    body['from_date'] = startdate == null ? "" : new DateFormat("dd-MM-yyyy").format(startdate);
    body['to_date'] = enddate == null ? "" : new DateFormat("dd-MM-yyyy").format(enddate);
    body['section_id'] = sectionamp[section];

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
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          setState(() {
            if(responseJson['result'].containsKey("student_marks_list")){
              attendancelist = responseJson['result']['student_marks_list'];
            }
            else
              attendancelist = new List();
            showreport = false;
          });
        }
        else{
          Constants().ShowAlertDialog(context, responseJson['message']);
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  LoadSections(String classid) async{
    sectionslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['class_id'] = classid;
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            sectionslist.add(data['section_name']);
            sectionamp[data['section_name']] = data['section_id'];
          }
          Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Map classmap= new Map(),exammap = new Map(),sectionamp= new Map();
  List<String> classlist= new List(),examslist = new List(),sectionslist = new List(),subjectsslist=new List();

  _navigatetoclasses(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Classes", classlist);
    setState(() {
      clas = result ?? clas;
    });
    LoadSections(classmap[clas]);
    print("res--"+result.toString());
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      section = result ?? section;
    });
    print("res--"+result.toString());
  }

  LoadCLassdetails() async{
    Map body = new Map();

    var url = await Constants().Clienturl() + Constants.Load_Classes_Admin;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            classlist.add(data['class_name']);
            classmap[data['class_name']] = data['class_id'];
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

  List<DataColumn> getdatacolum(){
    List<DataColumn> colums = new List();
    colums.add(new DataColumn(label: Text("Student | Section")));
    for(String sub in subjectsslist)
      colums.add(new DataColumn(label: Text(sub)));

    colums.add(new DataColumn(label: Text("Total")));
    colums.add(new DataColumn(label: Text("Avg Grade Point")));
    return colums;
  }

  List<DataCell> getdatacells(Map details){
    List<DataCell> cells = new List();
    cells.add(new DataCell(Text(details['student_name'].toString()+" | " +details['section_name'].toString())));
    for(String sub in subjectsslist)
      cells.add(new DataCell(Text(details[sub].toString())));

    cells.add(new DataCell(Text(details['total_obtained_marks'].toString())));
    cells.add(new DataCell(Text(details['grade_point'].toString())));
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("ATTENDANCE REPORT"),
        backgroundColor: Color(0xff182C61),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(),),
          ),
        ),
      ),
      body:
      _loading ? new Constants().bodyProgress : new ListView(
        children: <Widget>[
          new Stack(
        children: <Widget>[
          new Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
            padding: new EdgeInsets.only(top: 10),
            child: new Container()
          ),
          new Card(
                    margin:
                    new EdgeInsets.only(left: 50, right: 50, bottom: 10, top: 40),
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
                                    prefixIcon: new Icon(Icons.class_),
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
                                    prefixIcon: new Icon(Icons.list),
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                ),
                                controller: TextEditingController(text: section),
                                enabled: false,
                              ),
                              onTap: () {
                                _navigatetosections(context);
                              },
                            )),
                        new Container(margin: new EdgeInsets.all(5.0),
                            child : new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Start Date *',
                                  prefixIcon: new Icon(FontAwesomeIcons.calendar),
                                ),
                                enabled: false,
                                controller: new TextEditingController(text: startdate == null ? "" :  new DateFormat('dd-MM-yyyy').format(startdate)),
                              ),
                              onTap: (){
                                _selectstartDate(context);
                              },
                            )),
                        new Container(margin: new EdgeInsets.all(5.0),
                            child : new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'End Date *',
                                  prefixIcon: new Icon(FontAwesomeIcons.calendar),
                                ),
                                enabled: false,
                                controller: new TextEditingController(text: enddate == null ? "" :  new DateFormat('dd-MM-yyyy').format(enddate)),
                              ),
                              onTap: (){
                                _selectendDate(context);
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
                                            new Icon(Icons.remove_red_eye,color: Colors.white,size: 25,),
                                            new Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "SHOW REPORT",
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
                    new Text("Attendance Report",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text("Class- $clas : Section- $section",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text("Date range: ${(startdate == null ? "" : new DateFormat('dd-MM-yyyy').format(startdate)) + " - " +(enddate == null ? "" :  new DateFormat('dd-MM-yyyy').format(enddate))}",style: TextStyle(color: Colors.white),),
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
            child: new Container(
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.all(5),
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: ' Attendance Report', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      )
                    ),
                    new Divider(
                      height: 3,
                      color: Theme.of(context).primaryColor),
                    new ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                        attendancelist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red)))) :
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns:getdatacolum(),
                            rows: attendancelist.map(
                                  (user) => DataRow(
                                  cells: getdatacells(user)),
                            ).toList(),
                          ),
                        ),
                      ],
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
                                          color: Colors.green,
                                        ),
                                        new Padding(
                                          padding:
                                          EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "Print Attendance Sheet",
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
                )),
          ),
        ],
      )
    );
  }


}
