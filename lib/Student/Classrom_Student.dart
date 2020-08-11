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
import '../Classroomstream.dart';
import '../const.dart';
import '../dashboard.dart';

class StudentClassroomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StudentClassroomPageState();
}

class _StudentClassroomPageState extends State<StudentClassroomPage> {
  bool notification = false,locationtracking = false;
  bool _loading = false;
  String classname='',sectionanme='',subjectname='';

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadclassroutinestudent();
  }

  Future<Null> Joinsession() async {
    Constants().onLoading(context);
    String classroomurl = await Constants().Classroomurl();
    String classroomsecret = await Constants().Classroomkey();

    String meetingid = (await Constants().Clienturl()+"_"+classname+"_"+  sectionamp[sectionanme]+"_"+subjectname).replaceAll(" ", "+"),name=classname+"_"+  sectionamp[sectionanme]+"_"+subjectname+"+class";
    meetingid = meetingid.replaceAll(new RegExp("[^0-9a-zA-Z]+"),'');

    print(meetingid);

    String fullname = (await sp.ReadString("username")).replaceAll(" ", "+");

    String checkparams = "meetingID="+meetingid;
    var createbytes = utf8.encode("isMeetingRunning"+ checkparams +classroomsecret); // data being hashed
    var createdigest = sha1.convert(createbytes);
    print("Digest as hex string: $createdigest");

    var url = classroomurl+"api/isMeetingRunning?"+ checkparams+"&checksum="+createdigest.toString();
    Map<String, String> body = new Map();

    print("url is $url"+"body--"+body.toString());

    http.get(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"})
        .then((response) async {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
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

          String endparams = "meetingID="+ meetingid+"&password=mp";
          var endbytes = utf8.encode("end"+ endparams +classroomsecret); // data being hashed
          var enddigest = sha1.convert(endbytes);
          String endmeetingurl = await Constants().Clienturl(); //"api/end?"+endparams+"&checksum="+enddigest.toString();

          var args = {'url': meetingurl,"endurl": endmeetingurl};
          _channel.invokeMethod('webview', args);
          Navigator.of(context).pop();
        }
        else{
          Constants().ShowAlertDialog(context, "No sessions running for this subject, please try again later.");
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> Loadclassroutinestudent() async {
    subjectsslist.clear();
    sectionslist.clear();
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + "api_students/class_routine/";
    Map<String, String> body = new Map();
    body['student_id'] = id;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          debugPrint("response json ${responseJson}");
          try {
            classname=responseJson['result'][0]['class_name'].toString();
            sectionanme=responseJson['result'][0]['section_name'].toString();
            sectionslist.add(sectionanme);
            sectionslist.add("All Sections");
            sectionamp[sectionanme] = sectionanme;
            sectionamp['All Sections'] = "ALL";

            //   sectionamp (sectionanme);

          }catch(e){
          }
        }
        LoadSubjects();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }
  
  Map classmap= new Map(),subjectsmap = new Map(),sectionamp= new Map();
  List<String> classlist= new List(),subjectsslist= new List(),sectionslist = new List();

  _navigatetosubjects(BuildContext context) async {

    String result = await Constants().Selectiondialog(context, "Subjects", subjectsslist);
    setState(() {
      subjectname = result ?? subjectname;
    });
    print("res--"+result.toString());
  }

  _navigatetosection(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Section", sectionslist);
    setState(() {
      sectionanme = result ?? sectionanme;
    });
    print("res--"+result.toString());
  }

  LoadSubjects() async{
    subjectsslist.clear();
    String id = await sp.ReadString("Userid");
    Map body = new Map();
    body['student_id'] = id;
    var url = await Constants().Clienturl() + Constants.LoadSubjects_students;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['subjects']) {
            subjectsslist.add(data['subject_name']);
            subjectsmap[data['subject_name']] = data['subject_id'];
          }
        }
        setState(() {
          _loading= false;
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
        title: Text("Online Class Room"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
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
              child: new Text("Online Class Room",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                            hintText: "Section *",
                            prefixIcon: new Icon(Icons.subject),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
                        controller: TextEditingController(text: sectionanme),
                        enabled: false,
                      ),
                      onTap: () {
                        if(sectionanme=="")
                        {
                          Constants().ShowAlertDialog(context, "Please select Section");
                          return;
                        }
                        _navigatetosection(context);
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
                                  if(subjectname == ''){
                                    Constants().ShowAlertDialog(context, "Please select Subject");
                                    return;
                                  }
                                  if(sectionanme=='')
                                  {
                                    Constants().ShowAlertDialog(context, "Please select section");
                                    return;
                                  }

                                  Joinsession();
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
                                            "Join Session",
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
