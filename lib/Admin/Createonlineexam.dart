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
import 'AdminMnageonlineexams.dart';

class CreateonlineexamPage extends StatefulWidget {
  final String type;
  final Onlineexams details;
  CreateonlineexamPage({this.type,this.details});

  @override
  State<StatefulWidget> createState() => new _CreateonlineexamPageState();
}

class _CreateonlineexamPageState extends State<CreateonlineexamPage> {
  bool notification = false, locationtracking = false;
  String exam = "",
      clas = '',
      section = '',
      subject = '',classname='',sectionanme='',subjectname='',date1="",time1="",to1="";
  bool _loading = false;
  List<String> monthlist = new List(),yearlist = new List();
  String name = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    if(widget.type == "new"){
      name = "Create online exam";
    }
    else{
      name = "Edit online exam";
      title.text = widget.details.examanme;
      clas = widget.details.classname;
      section = widget.details.section;
      subject = widget.details.subject;
      date1 = widget.details.examdate;
      time1 = widget.details.examtime;
      to1 = widget.details.examto;
      minperc.text = widget.details.minperc;
      instruction.text = widget.details.instruction;
    }
    LoadCLassdetails();
  }

  Map classmap= new Map(),subjectsmap = new Map(),sectionamp= new Map();
  List<String> classlist= new List(),subjectsslist= new List(),sectionslist = new List();

  _navigatetoclasses(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Classes", classlist);

    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    if(result != null) {
      LoadSubjects(classmap[clas]);
      LoadSections(classmap[clas]);
    }
  }

  _navigatetosubjects(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Subjects", subjectsslist);
    setState(() {
      subject = result ?? subject;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      section = result ?? section;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  LoadCLassdetails() async{
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();
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
            classlist.add(data['class_id']);
            classmap[data['class_id']] = data['class_id'];
          }
        }
        if(widget.type== "edit") {
          LoadSubjects(classmap[clas]);
          LoadSections(classmap[clas]);
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

  LoadSubjects(String classid) async{
    subjectsslist.clear();
    if(widget.type=="new")
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
            subjectsmap[data['name']] = data['subject_id'];
          }
          if(widget.type=="new")
            Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadSections(String classid) async{
    sectionslist.clear();
    if(widget.type=="new")
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
          if(widget.type=="new")
            Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  TextEditingController title = new TextEditingController(),minperc = new TextEditingController(),instruction = new TextEditingController();
  DateTime date = null;
  TimeOfDay time = null,to=null;

  Future<Null> _selectDate(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != date) {
        print('date selected : ${date.toString()}');
        setState(() {
          date = picked;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }catch(e){e.toString();}
  }

  Future<Null> _selecttime(BuildContext context) async {
    try {
      TimeOfDay pickedtime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
      );

      if (pickedtime != null && pickedtime != time) {
        print('time selected : ${time.toString()}');
        setState(() {
          time = pickedtime;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }catch(e){e.toString();}
  }

  Future<Null> _selectto(BuildContext context) async {
    try {
      TimeOfDay pickedtime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedtime != null && pickedtime != to) {
        print('time selected : ${to.toString()}');
        setState(() {
          to = pickedtime;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }catch(e){e.toString();}
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat("HH:mm");  //"6:00 AM"
    return format.format(dt);
  }

  Future<Null> Createonlineexam() async {
    Constants().onLoading(context);
    var url="";
    url = await Constants().Clienturl() + Constants.CRUDOnlineexam_Admin;

    Map<String, String> body = new Map();
    if(widget.type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['online_exam_id'] = widget.details.id;
    }

    body['class_id'] = classmap[clas];
    body['section_id'] = sectionamp[section];
    body['subject_id'] = subjectsmap[subject];
    body['exam_title'] = title.text;
    body['exam_date'] = date == null ? date1 :  new DateFormat('dd-MM-yyyy').format(date);
    body['time_start'] = time == null ? time1 :  formatTimeOfDay(time);
    body['time_end'] = to == null ? to1 :  formatTimeOfDay(to);
    body['minimum_percentage'] = minperc.text;
    body['instruction'] = instruction.text;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        print("response json ${responseJson}");
        Navigator.of(context).pop();
        if(responseJson['status'].toString() == "true"){
          if(widget.type == "edit")
            Constants().ShowSuccessDialog(context, "Online exam updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Online exam added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            if(widget.type=="new") {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminManageonlineexamsPage()),
              );
            }
            else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminManageonlineexamsPage()),
              );
            }
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, responseJson['message']);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text(name),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.push(
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
                    new EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 40),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "Exam Title *",
                                    prefixIcon: new Icon(Icons.title),
                                ),
                                controller: title,
                              ),
                              ),
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
                                if(clas == ''){
                                  Constants().ShowAlertDialog(context, "Please select Class");
                                  return;
                                }
                                _navigatetosections(context);
                              },
                            )),
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "Subject *",
                                    prefixIcon: new Icon(Icons.subject),
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                ),
                                controller: TextEditingController(text: subject),
                                enabled: false,
                              ),
                              onTap: () {
                                if(clas == ''){
                                  Constants().ShowAlertDialog(context, "Please select Class");
                                  return;
                                }
                                _navigatetosubjects(context);
                                },
                            )),
                        new Container(padding: new EdgeInsets.all(5.0),
                            child : new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Exam Date *',
                                  prefixIcon: new Icon(Icons.date_range),
                                ),
                                enabled: false,
                                controller: new TextEditingController(text: date == null ? date1 :  new DateFormat('dd-MMM-yyyy').format(date)),
                              ),
                              onTap: (){
                                _selectDate(context);
                              },
                            )),
                        new Container(padding: new EdgeInsets.all(5.0),
                            child : new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Exam Time *',
                                  prefixIcon: new Icon(Icons.access_time),
                                ),
                                enabled: false,
                                controller: new TextEditingController(text: time == null ? time1 :  formatTimeOfDay(time)),
                              ),
                              onTap: (){
                                _selecttime(context);
                              },
                            )),
                        new Container(padding: new EdgeInsets.all(5.0),
                            child : new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'To *',
                                  prefixIcon: new Icon(Icons.access_time),
                                ),
                                enabled: false,
                                controller: new TextEditingController(text: to == null ? to1 :  formatTimeOfDay(to)),
                              ),
                              onTap: (){
                                _selectto(context);
                              },
                            )),
                        new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: "Minimun Percentage *",
                              prefixIcon: new Icon(FontAwesomeIcons.percentage),
                            ),
                            controller: minperc,
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Instruction",
                              prefixIcon: new Icon(Icons.list),
                            ),
                            controller: instruction,
                          ),
                        ),
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
                                          if(title.text == ''){
                                            Constants().ShowAlertDialog(context, "Please enter exam title");
                                            return;
                                          }
                                          if(clas == ''){
                                            Constants().ShowAlertDialog(context, "Please select class");
                                            return;
                                          }
                                          if(section == ''){
                                            Constants().ShowAlertDialog(context, "Please select section");
                                            return;
                                          }
                                          if(subject == ''){
                                            Constants().ShowAlertDialog(context, "Please select subject");
                                            return;
                                          }
                                          if(widget.type == "new" && date == null){
                                            Constants().ShowAlertDialog(context, "Please select exam date");
                                            return;
                                          }
                                          if(widget.type == "new" && time == null){
                                            Constants().ShowAlertDialog(context, "Please select exam time");
                                            return;
                                          }
                                          if(widget.type == "new" && to == null){
                                            Constants().ShowAlertDialog(context, "Please select to");
                                            return;
                                          }
                                          if(minperc.text == ''){
                                            Constants().ShowAlertDialog(context, "Please enter minimun percentage");
                                            return;
                                          }
                                          Createonlineexam();
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
                                            new Icon(Icons.check,size: 25,color: Colors.white,),
                                            new Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                name,
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
        ],
      )
    );
  }


}
