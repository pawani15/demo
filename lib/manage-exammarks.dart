import 'dart:math';
import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shape_of_view/shape_of_view.dart';

import 'const.dart';
import 'dashboard.dart';

class ManageExamMarksPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _ManageExamMarksPageState();
}

class _ManageExamMarksPageState extends State<ManageExamMarksPage> {
  bool notification = false, locationtracking = false;
  String exam = "",
      clas = '',
      section = '',
      subject = '',examaname='',classname='',sectionanme='',subjectname='';
  bool _loading = false;
  List<String> monthlist = new List(),yearlist = new List();
  Map runningyearmap = null;
  List Markslist = new List();
  Map monthmap = new Map();
  bool showreport = true;
  TextEditingController totalmarks = new TextEditingController();

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
    if (exam == "") {
      Constants().ShowAlertDialog(context, "Please Select Exam");
      return;
    }
    if(clas == ''){
      Constants().ShowAlertDialog(context, "Please select Class");
      return;
    }
    if(section == ''){
      Constants().ShowAlertDialog(context, "Please select Section");
      return;
    }
    if(subject == ''){
      Constants().ShowAlertDialog(context, "Please select Subject");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Load_ExamsMarks+exammap[exam]+"/"+classmap[clas]+"/"+sectionamp[section]+"/"+subjectsmap[subject];
    Map<String, String> body = new Map();
    body['student_id'] = id;

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
            if(responseJson['result'].containsKey("marks_of_students")){
              Markslist = responseJson['result']['marks_of_students'];
            for(int i=0;i<Markslist.length;i++){
              Markslist[i]['marks'] = new TextEditingController(text: Markslist[i]['mark_obtained']);
              Markslist[i]['comment'] = new TextEditingController(text: Markslist[i]['mark_comment']);
              }
            }
            else
              Markslist = new List();
            examaname = responseJson['result']['exam_name'];
            classname = responseJson['result']['class_name'];
            subjectname = responseJson['result']['subject_name'];
            sectionanme = responseJson['result']['section_name'];
            totalmarks.text = Markslist[0]['mark_total'].toString() == "null" ? "0" : (Markslist[0]['mark_total']).toString();
            showreport = false;
          });
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  Map classmap= new Map(),subjectsmap = new Map(),sectionamp= new Map(),exammap = new Map();
  List<String> classlist= new List(),subjectsslist= new List(),sectionslist = new List(),examslist = new List();

  _navigatetoclasses(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
    );
    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    if(result != null)
      LoadSubjectsandSections();
  }

  _navigatetosubjects(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Subjects", subjectsslist);
    setState(() {
      subject = result ?? subject;
    });
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

  LoadExamdetails() async{
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();
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
        setState(() {
          _loading = false;
        });
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadSubjectsandSections() async{
    sectionslist.clear();
    subjectsslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_SubjectsandSections+classmap[clas]+"/"+await Constants().Userid();
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['subject']) {
            subjectsslist.add(data['name']);
            subjectsmap[data['name']] = data['subject_id'];
          }
          for (Map data in responseJson['result']['section']) {
            sectionslist.add(data['name']);
            sectionamp[data['name']] = data['section_id'];
          }
          Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  UpdateMarks() async{
    Constants().onLoading(context);
    Map body = new Map();
    for(int i=0;i<Markslist.length;i++){
      body['marks_obtained_${Markslist[i]['mark_id']}'] = Markslist[i]['marks'].text;
      body['comment_${Markslist[i]['mark_id']}'] = Markslist[i]['comment'].text;
      body['ttl_sub_marks'] =totalmarks.text;
    }
    var url = await Constants().Clienturl() + Constants.Update_Marks+exammap[exam]+"/"+classmap[clas]+"/"+sectionamp[section]+"/"+subjectsmap[subject];
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          Constants().ShowSuccessDialog(context, responseJson['result']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Showreport();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Manage Exam Marks"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () => Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
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
                                  hintText: "Exam *",
                                  prefixIcon: new Icon(FontAwesomeIcons.fileInvoice),
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
                                            new SvgPicture.asset("assets/clipboard.svg",color: Colors.white,width: 25,height: 25,),
                                            new Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "MANAGE MARKS",
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
          showreport ? new Container() :
          new Container(
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
                    new Text("Marks for $examaname",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text("Class- $classname : Section- $sectionanme",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
                    new Text("Subject: $subjectname",style: TextStyle(color: Colors.white),),
                    new SizedBox(width: 5,height: 5,),
//                    new Text("Total Marks: ${ Markslist[0]['mark_total'].toString() == "null" ? "0" : (Markslist[0]['mark_total']).toString()}",
//                      style: TextStyle(color: Colors.white),),
//                    new SizedBox(width: 5,height: 5,),
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
                    new Container(
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child : new Text("Total Subject Marks:",style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),)),
                          new Expanded(child:new Card(
                            elevation: 5,
                            margin: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: new Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Expanded(child: new Padding(padding: EdgeInsets.only(right: 0,left: 5,top: 0,bottom: 0),child: new TextField(
                                  controller: totalmarks,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),decoration: InputDecoration(border: InputBorder.none),
                                  style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 11,fontWeight: FontWeight.bold),),),flex: 7,),
                                new Expanded(child: new Padding(padding: EdgeInsets.all(3), child: new Icon(Icons.edit,color: Theme.of(context).primaryColor,)),flex: 3,)
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                     new Column(
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
                                        "#",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 1,
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 6),
                                        child:new Text(
                                        "ID",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 1,
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 6),
                                        child:new Text(
                                        "Name",
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
                                        "Marks Obtained",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      flex: 3,
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 6),
                                          child: new Text("Comment",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
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
                              height: 300,
                            child: new ListView.builder(
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
                                                  EdgeInsets.all(5),
                                                  child: new Text(
                                                    (Markslist[index]['mark_id']).toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11),
                                                  )),
                                              flex: 1,
                                            ),
                                            new Expanded(
                                              child: new Padding(
                                                  padding:
                                                  EdgeInsets.all(5),
                                                  child: new Text(
                                                    (Markslist[index]['student_name']).toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11),
                                                  )),
                                              flex: 2,
                                            ),
                                            new Expanded(
                                              child: new Card(
                                                elevation: 5,
                                                margin: EdgeInsets.all(5),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    new Expanded(child: new Padding(padding: EdgeInsets.only(right: 0,left: 5,top: 0,bottom: 0),child: new TextField(
                                                      controller: Markslist[index]['marks'],
                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),decoration: InputDecoration(border: InputBorder.none),
                                                      style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 11,fontWeight: FontWeight.bold),),),flex: 7,),
                                                    new Expanded(child: new Padding(padding: EdgeInsets.all(3), child: new Icon(Icons.edit,color: Theme.of(context).primaryColor,)),flex: 3,)
                                                  ],
                                                ),
                                              ),
                                              flex: 3,
                                            ),
                                            new Expanded(
                                              child: new Card(
                                                elevation: 5,
                                                margin: EdgeInsets.all(5),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    new Expanded(child: new Padding(padding: EdgeInsets.only(right: 0,left: 5,top: 0,bottom: 0),child: new TextField(
                                                  controller: Markslist[index]['comment'],
                                                      keyboardType: TextInputType.text,decoration: InputDecoration(border: InputBorder.none),
                                                      style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 11,fontWeight: FontWeight.bold),),),flex: 7,),
                                                    new Expanded(child: new Padding(padding: EdgeInsets.all(3), child: new Icon(Icons.edit,color: Theme.of(context).primaryColor,)),flex: 3,)
                                                  ],
                                                ),
                                              ),
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
                              itemCount: Markslist.length,
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
                                      UpdateMarks();
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
                                          color: Colors.green,
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
