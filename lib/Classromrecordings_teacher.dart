import 'package:Edecofy/search.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xml2json/xml2json.dart';
import 'package:xml_parser/xml_parser.dart';
import 'Classroomstream.dart';
import 'const.dart';
import 'dashboard.dart';
class TeacherClassroomrecordingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TeacherClassroomrecordingsPageState();
}

class _TeacherClassroomrecordingsPageState extends State<TeacherClassroomrecordingsPage> {
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

  List recordingslist = new List();
  bool showreport = true;

  Future<Null> Getrecordings() async {
    Constants().onLoading(context);
    recordingslist.clear();
    String classroomurl = await Constants().Classroomurl();
    String classroomsecret = await Constants().Classroomkey();
    String meetingid = (await Constants().Clienturl()+"_"+classname+"_"+sectionamp[sectionanme]+"_"+subjectname).replaceAll(" ", "+");
    meetingid = meetingid.replaceAll(new RegExp("[^0-9a-zA-Z]+"),'');
    print(meetingid);
    String createparams = "meetingID="+meetingid/*+"&recordID="+meetingid*/;
    var createbytes = utf8.encode("getRecordings"+ createparams +classroomsecret); // data being hashed
    var createdigest = sha1.convert(createbytes);
    print("Digest as hex string: $createdigest");
    var url = classroomurl+"api/getRecordings?"+ createparams+"&checksum="+createdigest.toString();
    Map<String, String> body = new Map();
    print("url is $url"+"body--"+body.toString());
    http.get(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        XmlDocument xmlDocument = XmlDocument.fromString(response.body);
        print("val--"+xmlDocument.getElement("response").getElement("returncode").text);
        Xml2Json xml2json = new Xml2Json();
        xml2json.parse(response.body);
        Map json1 = json.decode(xml2json.toGData());
        print("json--"+json1.toString());
        if(xmlDocument.getElement("response").getElement("returncode").text == "SUCCESS"){
          if(xmlDocument.getElement("response").getElement("recordings").hasChildren){
            setState(() {
            try{
              recordingslist = json1['response']['recordings']['recording'];
            }catch(e){
              recordingslist.add(json1['response']['recordings']['recording']);
            }
            showreport = false;
            });
            print("33"+recordingslist.toString());
          }
          else {
            setState(() {
              showreport = true;
            });
            Constants().ShowAlertDialog(context, xmlDocument
                .getElement("response")
                .getElement("message")
                .text);
          }
        }
        else{
          Constants().ShowAlertDialog(context, "No records found.");
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> DeleteAPi(String recordid) async {
    Constants().onLoading(context);
    String classroomurl = await Constants().Classroomurl();
    String classroomsecret = await Constants().Classroomkey();

    String createparams = "recordID="+recordid/*+"&recordID="+meetingid*/;
    var createbytes = utf8.encode("deleteRecordings"+ createparams +classroomsecret); // data being hashed
    var createdigest = sha1.convert(createbytes);
    print("Digest as hex string: $createdigest");
    var url = classroomurl+"api/deleteRecordings?"+ createparams+"&checksum="+createdigest.toString();
    Map<String, String> body = new Map();
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        XmlDocument xmlDocument = XmlDocument.fromString(response.body);
        print("val--"+xmlDocument.getElement("response").getElement("returncode").text);
        if(xmlDocument.getElement("response").getElement("returncode").text == "SUCCESS"){
          Navigator.of(context).pop();
          Getrecordings();
          }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  deletedialog(String recordid) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
          backgroundColor: Colors.transparent,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget>[
                new Stack(
                    children: <Widget>[
                      new Container(margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 5.0,
                            ),]
                        ),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(width: 20,height: 20,),
                            new Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor),
                              child: new Icon(
                                Icons.folder_open,
                                color: Colors.white,
                                size: 40,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            new SizedBox(width: 10,height: 10,),
                            new Container(padding: EdgeInsets.all(5), child: new Text("Are you sure, you want to delete this file?",style: TextStyle(fontSize: 16),)),
                            new SizedBox(width: 20,height: 20,),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new InkWell(
                                    onTap: () {
                                      DeleteAPi(recordid);
                                    },
                                    child: new Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all( Radius.circular(20) )),
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Icon(Icons.delete,color: Colors.white,),
                                            new Padding(padding: EdgeInsets.only(left: 10.0),child: Text("Delete",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),)
                                          ],
                                        )))
                              ],
                            ),
                            new SizedBox(width: 20,height: 20,),
                          ],
                        ),
                      ),
                      new Align(
                          alignment: Alignment.topRight,
                          child: new InkWell(child:new Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                boxShadow: [BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 5.0,
                                ),]
                            ),
                            child: new Icon(Icons.close,color: Colors.white,size: 25,),
                          ),onTap: (){
                            Navigator.of(context).pop();
                          },
                          )
                      )
                    ])]),
        );
      },
    );
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
    var url = await Constants().Clienturl() + Constants.Load_SubjectsandSections+classmap[classname]+"/"+await Constants().Userid();
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
          sectionamp['All Sections'] = "ALL";
          sectionslist.add("All Sections");
          for (Map data in responseJson['result']['section']) {
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
        title: Text("Class Room Recordings"),
        backgroundColor: Color(0xff182C61),

      ),
      drawer:  Constants().drawer(context),
      body: new ListView(
        children: <Widget>[
          new Stack(
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
                  child: new Text("Class Room Recordings",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                ),
              ),
              new Card(
                elevation: 5.0,
                margin: new EdgeInsets.only(left: 40,right: 40,bottom: 20,top: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: _loading ? new Constants().bodyProgress :
                new ListView(
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
                                      Getrecordings();
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
                                            new Icon(Icons.videocam, color: Colors.white,size: 25,),
                                            new Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "Get Recordings",
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
          showreport ? new Container() : new Card(
            elevation: 5.0,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new Container(
                child: new ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: <Widget>[
                    new Padding(
                        padding: EdgeInsets.all(5),
                        child: Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Class Room Recordings List', style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                    ),
                    new Divider(
                        height: 3,
                        color: Theme.of(context).primaryColor),
                    new Container(
                      padding: new EdgeInsets.all(10),
                      child: recordingslist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 10,
                          columns: [
                            DataColumn(
                              label: Text("S No",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                            ),
                            DataColumn(
                              label: Text("Name",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                            ),
                            DataColumn(
                              label: Text("Length",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                            ),
                            DataColumn(
                              label: Text("Users",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                            ),
                            DataColumn(
                              label: Container(margin: EdgeInsets.only(left: 5.0),child:Text("Actions",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                            ),
                          ],
                          rows:recordingslist.map(
                                (user) => DataRow(
                                cells: [
                                  DataCell(
                                    Text((recordingslist.indexOf(user)+1).toString()),
                                  ),
                                  DataCell(
                                    Text(user['name']['\$t']),
                                  ),
                                  DataCell(
                                    Text(user['playback']['format']['length']['\$t'].toString() == "0" ? "<1 Min" :user['playback']['format']['length']['\$t'].toString()+ " Mins"),
                                  ),
                                  DataCell(
                                    Text(user['participants']['\$t']),
                                  ),
                                  DataCell(
                                      new Row(
                                        children: <Widget>[
                                          new InkWell(
                                            child: new Card(
                                              color: Theme.of(context).primaryColor,
                                              elevation: 5.0,
                                              margin: EdgeInsets.all(5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Padding(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text("Play",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                  new Padding(padding: EdgeInsets.only(right: 15,left: 5,top: 5,bottom: 5),
                                                    child: new Container(
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white
                                                      ),
                                                      padding: EdgeInsets.all(3),
                                                      child: new Icon( Icons.play_circle_outline ,color: Theme.of(context).primaryColor  ,size: 15,),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: (){
                                              String meetingurl = user['playback']['format']['url']['\$t'].toString();
                                              const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');
                                              var args = {'url': meetingurl,"endurl": "no"};
                                              _channel.invokeMethod('webview', args);
                                            },
                                          ),
                                          new InkWell(
                                            child: new Card(
                                              color: Colors.red,
                                              elevation: 5.0,
                                              margin: EdgeInsets.all(5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Padding(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text("Delete",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                  new Padding(padding: EdgeInsets.only(right: 15,left: 5,top: 5,bottom: 5),
                                                    child: new Container(
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white
                                                      ),
                                                      padding: EdgeInsets.all(3),
                                                      child: new Icon( Icons.delete ,color: Colors.red ,size: 15,),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: (){
                                              String recordid = user['recordID']['\$t'].toString();
                                              deletedialog(recordid);
                                            },
                                          ),
                                        ],
                                      )
                                  ),
                                ]),
                          ).toList(),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      )
    );
  }

}