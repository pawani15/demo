import 'dart:math';

import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../const.dart';
import '../dashboard.dart';


class ManageTabulationsheetPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _ManageTabulationsheetPageState();
}

class _ManageTabulationsheetPageState extends State<ManageTabulationsheetPage> {
  bool notification = false, locationtracking = false;
  String exam = "",
      clas = '',
      section = '', examaname='',classname='',sectionname='',subjectname='';
  bool _loading = false;
  List<String> monthlist = new List(),yearlist = new List();
  Map runningyearmap = null;
  List Tabulationlist = new List();
  bool showreport = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadExamdetails();
  }

  Future<Null> Showreport() async {
    String id = await sp.ReadString("Userid");
    if(clas == ''){
      Constants().ShowAlertDialog(context, "Please select Class");
      return;
    }
    if (exam == "") {
      Constants().ShowAlertDialog(context, "Please Select Exam");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Load_Tabulationsheet_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = classmap[clas];
    body['exam_id'] = exammap[exam];
    body['section_id'] = section == "" ? "all" : sectionamp[section];

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
              Tabulationlist = responseJson['result']['student_marks_list'];
            }
            else
              Tabulationlist = new List();
            examaname = responseJson['result']['exam_name'];
            classname = responseJson['result']['class_name'];
            sectionname = responseJson['result']['section_name'];
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
    LoadSubjects(classmap[clas]);
    print("res--"+result.toString());
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      section = result ?? section;
    });
    print("res--"+result.toString());
  }

  _navigatetoexams(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Exams",duplicateitems: examslist,)),
    );
    //String result = await Constants().Selectiondialog(context, "Exams", examslist);
    setState(() {
      exam = result ?? exam;
    });
    print("res--"+result.toString());
  }

  LoadSubjects(String classid) async{
    subjectsslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['class_id'] = classid;
    var url = await Constants().Clienturl() + Constants.Load_Subjects_Admin;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            subjectsslist.add(data['name']);
          }
          Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadExamdetails() async{
    Map body = new Map();

    var url = await Constants().Clienturl() + Constants.Load_Exams_Teacher;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        try {
          var responseJson = json.decode(response.body);
          if (responseJson['status'].toString() == "true") {
            print("response json ${responseJson}");
            for (Map data in responseJson['result']['exams']) {
              examslist.add(data['name']);
              exammap[data['name']] = data['exam_id'];
            }
          }
        }catch(e){
          examslist = new List();
        }
        LoadCLassdetails();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadCLassdetails() async{
    Map body = new Map();

    var url = await Constants().Clienturl() + Constants.Load_Classes;
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
        title: Text("Tabulation Sheet"),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(),),
          ),
        ),*/
      ),
        drawer: Constants().drawer(context),
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
                                  hintText: "Exam *",
                                  prefixIcon: new Icon(Icons.list),
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                              ),
                                controller: TextEditingController(text: exam),
                                enabled: false,
                              ),
                              onTap: () {
                                _navigatetoexams(context);
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
                                                "VIEW TABULATION SHEET",
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
                    new Text("Tabulation Sheet",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text("Class- $classname : Section- $sectionname",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text("Exam: $examaname",style: TextStyle(color: Colors.white),),
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
                            TextSpan(text: ' Manage Exam Marks', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      )
                    ),
                    new Divider(
                      height: 3,
                      color: Theme.of(context).primaryColor),
                     /*new Column(
                          children: <Widget>[
                            new Padding(
                                padding: new EdgeInsets.all(0),
                                child: new Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: new Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 6),
                                        child:new Text(
                                        "Student | Section",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 4,
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 6),
                                        child:new Text(
                                        "Maths",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 2,
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 6),
                                        child:new Text(
                                        "Total",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 2,
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 6),
                                          child:new Text(
                                        "Avg Grade Point",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 2,
                                    ),
                                  ],
                                )),
                            new Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            new ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return new Column(
                                  children: <Widget>[
                                    new Padding(
                                        padding: new EdgeInsets.all(5),
                                        child: new Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.all(5),
                                                  child: new Text(
                                                    Tabulationlist[index]['student_name'].toString()+" | "+Tabulationlist[index]['section_name'].toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 11),
                                                  )),
                                              flex: 4,
                                            ),
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.all(5),
                                                  child: new Text(
                                                    (Tabulationlist[index]['maths']).toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11),
                                                  )),
                                              flex: 2,
                                            ),
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.all(5),
                                                  child: new Text(
                                                    (Tabulationlist[index]['total_obtained_marks']).toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11),
                                                  )),
                                              flex: 2,
                                            ),
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.all(5),
                                                  child: new Text(
                                                    (Tabulationlist[index]['grade_point']).toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11),
                                                  )),
                                              flex: 2,
                                            ),
                                          ],
                                        )),
                                    new Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ],
                                );
                              },
                              itemCount: Tabulationlist.length,
                            )
                          ],
                        ),*/
                    new ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                        Tabulationlist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red)))) :
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns:getdatacolum(),
                            rows: Tabulationlist.map(
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
                                            "Print Tabulation Sheet",
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
