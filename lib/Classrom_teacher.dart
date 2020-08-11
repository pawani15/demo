import 'dart:math';

import 'package:Edecofy/search.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xml_parser/xml_parser.dart';

import 'Classroomstream.dart';
import 'const.dart';
import 'dashboard.dart';

class TeacherClassroomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TeacherClassroomPageState();
}

class _TeacherClassroomPageState extends State<TeacherClassroomPage> {
  bool notification = false,locationtracking = false;
  bool _loading = false;
  String classname='',sectionanme='',subjectname='';

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadCLassdetails();
  }

  Future<Null> Createsession() async {
    String fullname = (await sp.ReadString("username")).replaceAll(" ", "+");
    String classroomurl = await Constants().Classroomurl();
    String classroomsecret = await Constants().Classroomkey();
    String meetingid = (await Constants().Clienturl()+"_"+classname+"_"+sectionamp[sectionanme]+"_"+subjectname).replaceAll(" ", "+"),name=(classname+"_"+sectionamp[sectionanme]+"_"+subjectname+"+class").replaceAll(" ", "+"),welcome=("WELCOME+TO+"+subjectname+"+CLASS").replaceAll(" ", "+");
    meetingid = meetingid.replaceAll(new RegExp("[^0-9a-zA-Z]+"),'');
    print(meetingid);
    String checkparams = "meetingID="+meetingid;
    var meetingrunnigbytes = utf8.encode("isMeetingRunning"+ checkparams +classroomsecret); // data being hashed
    var meetingrunnigdigest = sha1.convert(meetingrunnigbytes);
    print("Digest as hex string: $meetingrunnigdigest");
    var url1 = classroomurl+"api/isMeetingRunning?"+ checkparams+"&checksum="+meetingrunnigdigest.toString();
    print("url is $url1"+"body--");

    Constants().onLoading(context);
    http.get(url1,
        headers: {"Content-Type": "application/x-www-form-urlencoded"})
        .then((response) async {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        XmlDocument xmlDocument = XmlDocument.fromString(response.body);
        print("val--"+xmlDocument.getElement("response").getElement("returncode").text);
        if(xmlDocument.getElement("response").getElement("returncode").text == "SUCCESS" && xmlDocument.getElement("response").getElement("running").text == "true"){
          String pw= "";
          if(Constants.logintype == "teacher")
            pw = "mp";
          else
            pw = "ap";
          String joinparams = "fullName="+fullname+"&meetingID="+ meetingid+"&password="+pw+"&redirect=true";
          var joinbytes = utf8.encode("join"+ joinparams +classroomsecret); // data being hashed
          var joindigest = sha1.convert(joinbytes);
          String meetingurl = classroomurl+"api/join?"+joinparams+"&checksum="+joindigest.toString();
          const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');
          var args = {'url': meetingurl,"endurl": await Constants().Clienturl()};
          _channel.invokeMethod('webview', args);
        }
        else{
          Constants().onLoading(context);
          Random random = new Random();
          int randomNumber = random.nextInt(100000);
          String createparams = "allowStartStopRecording=true&attendeePW=ap&autoStartRecording=false&logoutURL="+await Constants().Clienturl()+"&meetingID="+meetingid+"&moderatorPW=mp&name="+name+"&record=false&voiceBridge="+randomNumber.toString()+"&welcome="+welcome;
          var createbytes = utf8.encode("create"+ createparams +classroomsecret); // data being hashed
          var createdigest = sha1.convert(createbytes);
          print("Digest as hex string: $createdigest");
          var url = classroomurl+"api/create?"+ createparams+"&checksum="+createdigest.toString();
          Map<String, String> body = new Map();
          print("url is $url"+"body--"+body.toString());
          http.post(url,
              headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
              .then((response) async {
            if (response.statusCode == 200) {
              print("response --> ${response.body}");
              XmlDocument xmlDocument = XmlDocument.fromString(response.body);
              print("val--"+xmlDocument.getElement("response").getElement("returncode").text);
              if(xmlDocument.getElement("response").getElement("returncode").text == "SUCCESS"){
                String pw= "";
                if(Constants.logintype == "teacher")
                  pw = "mp";
                else
                  pw = "ap";
                String joinparams = "fullName="+fullname+"&meetingID="+ meetingid+"&password="+pw+"&redirect=true";
                var joinbytes = utf8.encode("join"+ joinparams +classroomsecret); // data being hashed
                var joindigest = sha1.convert(joinbytes);
                String meetingurl = classroomurl+"api/join?"+joinparams+"&checksum="+joindigest.toString();
                const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');
                var args = {'url': meetingurl,"endurl": await Constants().Clienturl()};
                _channel.invokeMethod('webview', args);
                Navigator.of(context).pop();
              }
              else{
                Constants().ShowAlertDialog(context, "Session creation failed.");
              }
            }
            else {
              print("erroe--"+response.body);
            }
          });

        }
      }
      else {
        print("erroe--"+response.body);
      }
    });

  }

  Map classmap= new Map(),subjectsmap = new Map(),sectionamp= new Map();
  List<String> classlist= new List(),subjectsslist= new List(),sectionslist = new List();

  _navigatetoclasses(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Classes", classlist);
    setState(() {
      classname = result ?? classname;
    });
    print("res--"+result.toString());
    if(result != null)
      LoadSubjectsandSections();
  }

  _navigatetosubjects(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Subjects", subjectsslist);
    setState(() {
      subjectname = result ?? subjectname;
    });
    print("res--"+result.toString());
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      sectionanme = result ?? sectionanme;
    });
    print("res--"+result.toString());
  }

  LoadCLassdetails() async{
    classlist.clear();
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
            classlist.add(data['class_id']);
            classmap[data['class_id']] = data['class_id'];
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
    subjectsslist.clear();
    sectionslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_SubjectsandSections+classmap[classname]+"/"+await Constants().Userid();
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          print("respons::$responseJson");
          for (Map data in responseJson['result']['subject']) {
            subjectsslist.add(data['name']);
            subjectsmap[data['name']] = data['subject_id'];
          }
          sectionamp['All Sections'] = "ALL";
          sectionslist.add("All Sections");
          for (Map data in responseJson['result']['section']) {
            print("harsha::${data.toString()}");
            sectionslist.add(data['name']);
            sectionamp[data['name']] = data['name'];
            print("data of::::$sectionslist");
            print("test:::$sectionamp");
          }
          Navigator.of(context).pop();
        }
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
        title: Text("Class Room"),
        backgroundColor: Color(0xff182C61),

      ),
      drawer:  Constants().drawer(context),
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
            child: new Center(
              child: new Text("Class Room",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
            ),
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 40,right: 40,bottom: 20,top: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress : new ListView(
              shrinkWrap: true,
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
                        controller: TextEditingController(text: classname),
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
                        controller: TextEditingController(text: sectionanme),
                        enabled: false,
                      ),
                      onTap: () {
                        if(classname == ''){
                          Constants().ShowAlertDialog(context, "Please select class");
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
                        controller: TextEditingController(text: subjectname),
                        enabled: false,
                      ),
                      onTap: () {
                        if(classname == ''){
                          Constants().ShowAlertDialog(context, "Please select class");
                          return;
                        }
                        _navigatetosubjects(context);
                      },
                    )),
                new SizedBox(
                  width: 20,
                  height: 20,
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
                                  if(classname == ''){
                                    Constants().ShowAlertDialog(context, "Please select Class");
                                    return;
                                  }
                                  if(sectionanme == ''){
                                    Constants().ShowAlertDialog(context, "Please select Section");
                                    return;
                                  }
                                  if(subjectname == ''){
                                    Constants().ShowAlertDialog(context, "Please select Subject");
                                    return;
                                  }
                                  Createsession();
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
                                        new Icon(FontAwesomeIcons.camera, color: Colors.white,size: 25,),
                                        new Padding(
                                          padding:
                                          EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "Create Session",
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
            ),),
        ],
      ),
    );
  }

}
