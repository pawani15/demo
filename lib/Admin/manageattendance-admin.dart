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

class ManageAdminattendancePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _ManageAdminattendancePageState();
}

class _ManageAdminattendancePageState extends State<ManageAdminattendancePage> {
  bool notification = false, locationtracking = false;
  String exam = "",classname='',sectionnamme='',status='Select',section = '',classid='',sectionid='',timestamp='',clas = '';
  bool _loading = false;
  List<String> monthlist = new List(),yearlist = new List();
  Map runningyearmap = null;
  List Attendancelist = new List();
  Map monthmap = new Map();
  bool showreport = true;
  DateTime date = null;

  List<String> sectionslist = new List();
  Map<String,String> sectionamp = new Map(),statusmap = new Map(),leavetypeamp = new Map();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    statusmap['Present'] = "1";
    statusmap['Absent'] = "2";
    leavetypeamp['Sick Leave'] = "1";
    leavetypeamp['Casual Leave'] = "2";
    leavetypeamp['Other'] = "3";
    LoadClassdetails();
  }

  LoadClassdetails() async{
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

  Map classmap= new Map();
  List<String> classlist= new List();
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
        }
        Navigator.of(context).pop();
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Updateattendance() async{
    Constants().onLoading(context);
    Map body = new Map();
    for(int i=0;i<Attendancelist.length;i++){
      body['status_${Attendancelist[i]['attendance_id']}'] = statusmap[Attendancelist[i]['l_status']];
      body['present_${Attendancelist[i]['attendance_id']}'] = statusmap[Attendancelist[i]['l_status']];
      body['leave_${Attendancelist[i]['attendance_id']}'] = leavetypeamp[Attendancelist[i]['leavetype']] == null ? "" :leavetypeamp[Attendancelist[i]['leavetype']] ;
      body['leave_reason_${Attendancelist[i]['attendance_id']}'] = Attendancelist[i]['otherreason'].text;
    }

    Map body1 = new Map();
    body1['class_id'] = classmap[clas];
    body1['section_id'] = sectionamp[section];
    body1['timestamp'] = (date.millisecondsSinceEpoch/1000).toStringAsFixed(0);
    body1['studnet_attendance_data']  = json.encode(body);

    var url = await Constants().Clienturl() + Constants.UpdateAttendance_Admin;
    print("url--"+url+'body is${json.encode(body1)} $body1');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body1)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          Constants().ShowSuccessDialog(context, responseJson['message']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            ShowAttendance();
          }
          new Timer(duration, handleTimeout);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> ShowAttendance() async {
    String id = await sp.ReadString("Userid");
    if(clas == null){
      Constants().ShowAlertDialog(context, "Please select class");
      return;
    }
    if(section == null){
      Constants().ShowAlertDialog(context, "Please select section");
      return;
    }
    if(date == null){
      Constants().ShowAlertDialog(context, "Please select date");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.LoadAttendance_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = classmap[clas];
    body['section_id'] = sectionamp[section];
    body['timestamp'] = (date.millisecondsSinceEpoch/1000).toStringAsFixed(0);

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
            if(responseJson['result'].containsKey("attendance_result")) {
              Attendancelist = responseJson['result']['attendance_result'];
              for(int i=0;i<Attendancelist.length;i++){
                Attendancelist[i]['l_status'] = 'Select';
                if(Attendancelist[i]['status'] == "1")
                  Attendancelist[i]['l_status'] = 'Present';
                else if(Attendancelist[i]['status'] == "2")
                  Attendancelist[i]['l_status'] = 'Absent';

                Attendancelist[i]['leavetype'] = 'Select';
                Attendancelist[i]['otherflag'] = false;
                Attendancelist[i]['otherreason'] = new TextEditingController();
                if(Attendancelist[i]['leave_type'] == "1")
                  Attendancelist[i]['leavetype'] = 'Sick Leave';
                else if(Attendancelist[i]['leave_type'] == "2")
                  Attendancelist[i]['leavetype'] = 'Casual Leave';
                else if(Attendancelist[i]['leave_type'] == "3") {
                  Attendancelist[i]['otherreason'].text =
                  Attendancelist[i]['leave_reason'];
                  Attendancelist[i]['leavetype'] = 'Other';
                  Attendancelist[i]['otherflag'] = true;
                };

              }
            }
            else
              Attendancelist = new List();
            classname = responseJson['result']['class_name'];
            sectionnamme = responseJson['result']['section_name'];
            timestamp = responseJson['result']['date'].toString();
            showreport = false;
          });
        }
        else
          Constants().ShowAlertDialog(context, responseJson['message']);
      } else {
        Navigator.of(context).pop();
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
      LoadSections(classmap[clas]);
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      section = result ?? section;
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
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () =>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(),),
          ),
        ),*/
      ),
        drawer: Constants().drawer(context),
        body: _loading ? new Constants().bodyProgress : new ListView(
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
                        new Container(margin: new EdgeInsets.all(5.0),
                            child : new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Date *',
                                  suffixIcon: new Icon(FontAwesomeIcons.calendar),
                                ),
                                enabled: false,
                                controller: new TextEditingController(text: date == null ? "" :  new DateFormat('dd-MMM-yyyy').format(date)),
                              ),
                              onTap: (){
                                _selectDate(context);
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
                                          ShowAttendance();
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
                    new Text("Attendance of $classname",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text("Section: $sectionnamme",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text(date == null ? "" :  new DateFormat('dd-MMM-yyyy').format(date),style: TextStyle(color: Colors.white),),
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
                     new Column(
                          children: <Widget>[
                            new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Container(
                                      margin: new EdgeInsets.all(0.0),
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              for(int i=0;i<Attendancelist.length;i++){
                                                Attendancelist[i]['l_status'] = 'Absent';
                                              }
                                            });
                                          },
                                          child: new Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow[800],
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(15))),
                                              child: new Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Icon(Icons.close,color: Colors.white,),
                                                  new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("MARK ALL ABSENT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
                                                ],
                                              )))),flex: 1,),
                                  new Expanded(child:new Container(
                                      margin: new EdgeInsets.all(0.0),
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              for(int i=0;i<Attendancelist.length;i++){
                                                Attendancelist[i]['l_status'] = 'Present';
                                              }
                                            });
                                          },
                                          child: new Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.only(
                                                    topRight:
                                                    Radius.circular(15),)),
                                              child: new Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Icon(Icons.check,color: Colors.white,),
                                                  new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("MARK ALL PRESENT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
                                                ],
                                              )))),flex: 1,),
                                ],
                              ),
                            ),
                            new SizedBox(width: 10,height: 10,),
                            new Padding(
                                padding: new EdgeInsets.all(0),
                                child: new Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child:new Padding(
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 3,vertical: 6),child: new Text(
                                        "#",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 1,
                                    ),
                                    new Expanded(
                                      child:new Padding(
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 3,vertical: 6),child: new Text(
                                        "ID",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 1,
                                    ),
                                    new Expanded(
                                      child:new Padding(
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 3,vertical: 6),child: new Text(
                                        "Name",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 2,
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(
                                        "Status",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 2,
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 3,vertical: 6),child: new Text(
                                        "Leave Type",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 3,
                                    ),
                                  ],
                                )),
                            new Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            new SizedBox(
                              height: 350,
                            child: new ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return new Column(
                                  children: <Widget>[
                                    new Padding(
                                        padding: new EdgeInsets.all(0),
                                        child: new Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(horizontal: 3,vertical: 6),
                                                  child: new Text(
                                                    (index+1).toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 11),
                                                  )),
                                              flex: 1,
                                            ),
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(horizontal: 3,vertical: 6),
                                                  child: new Text(
                                                    (Attendancelist[index]['attendance_id']).toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 11),
                                                  )),
                                              flex: 1,
                                            ),
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(horizontal: 3,vertical: 6),
                                                  child: new Text(
                                                    (Attendancelist[index]['stuent_first_name']).toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 11),
                                                  )),
                                              flex: 2,
                                            ),
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(horizontal: 3,vertical: 6),
                                                  child: new DropdownButton(
                                                            value: Attendancelist[index]['l_status'].toString(),
                                                            isDense: true,
                                                            isExpanded: true,
                                                            onChanged: (String newValue) {
                                                              setState(() {
                                                                Attendancelist[index]['l_status'] = newValue;
                                                              });
                                                              FocusScope.of(context).requestFocus(FocusNode());
                                                            },
                                                            items: <String>['Select', 'Present', 'Absent','Undefined']
                                                                .map<DropdownMenuItem<String>>((String value) {
                                                              return new DropdownMenuItem(
                                                                value: value,
                                                                child: new Text(value,style: TextStyle(fontSize: 10),),
                                                              );
                                                            }).toList(),
                                                          ),
                                              ),
                                              flex: 2,
                                            ),
                                            new Expanded(
                                              child: Attendancelist[index]['l_status'].toString() == "Absent" ? new Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(horizontal: 3,vertical: 6),
                                                  child: Attendancelist[index]['otherflag'] ?
                                                  new Card(
                                                      elevation: 5,
                                                      margin: EdgeInsets.all(5),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                                      child:new Padding(
                                                        padding:EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                                                            child: new TextField(
                                                        keyboardType: TextInputType.text,
                                                        decoration: InputDecoration(
                                                            hintText: "Reason",
                                                            border: InputBorder.none
                                                        ),
                                                        style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 11,fontWeight: FontWeight.bold),                                                        controller: Attendancelist[index]['otherreason'],)
                                                  ) ):
                                                  new DropdownButton(
                                                    value: Attendancelist[index]['leavetype'].toString(),
                                                    isDense: true,
                                                    isExpanded: true,
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        Attendancelist[index]['leavetype'] = newValue;
                                                        if(newValue == "Other")
                                                          Attendancelist[index]['otherflag'] = true;
                                                      });
                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                    },
                                                    items: <String>['Select', 'Sick Leave', 'Casual Leave','Other']
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return new DropdownMenuItem(
                                                        value: value,
                                                        child: new Text(value,style: TextStyle(fontSize: 10),),
                                                      );
                                                    }).toList(),
                                                  )) : new Container(),
                                              flex: 3,
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
                              itemCount: Attendancelist.length,
                            ))
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
                                      bool check = false;
                                      bool checkleavetype = false;
                                      for(int i=0;i<Attendancelist.length;i++){
                                        if( Attendancelist[i]['l_status'] == 'Select'){
                                          check = true;
                                          break;
                                        }
                                        if(Attendancelist[i]['l_status'] == 'Absent' && Attendancelist[i]['leavetype'] == 'Select'){
                                          checkleavetype = true;
                                          break;
                                        }
                                      }

                                      if(check) {
                                        Constants().ShowAlertDialog(context,
                                            "Please select status for all stundents");
                                        return;
                                      }
                                      if(checkleavetype) {
                                        Constants().ShowAlertDialog(context,
                                            "Please select leave type for all stundents");
                                        return;
                                      }
                                      else {
                                        Updateattendance();
                                        FocusScope.of(context).requestFocus(FocusNode());
                                      }
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
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        new Padding(
                                          padding:
                                          EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "Save Changes",
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
