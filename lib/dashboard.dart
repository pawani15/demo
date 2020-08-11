import 'package:Edecofy/Teacher/manage_subjectwise_attendance.dart';
import 'package:Edecofy/parent_Subject_wise_attendance.dart';
import 'package:Edecofy/prrivatemessages.dart';
import 'package:Edecofy/teachersinformation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Student/Classrom_Student.dart';
import 'Student/exam_marks_student.dart';
import 'const.dart';
import 'manage-attendenca.dart';
import 'manage-exammarks.dart';
import 'marks.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("res"+ message['data'].toString());
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  String imageurl="",teachers='',students='',attendance,parents='';
  List noticeslist = new List();
  bool _loading = false;
  double present = 0.0;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onBackgroundMessage:
      TargetPlatform.iOS == 'ios' ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      String _homeScreenText;
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
    requestPermission();
    setState(() {
      _loading = true;
    });
    GetDashboardvslues();
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, message["data"]['open-page'],message["data"]['body']),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  Widget _buildDialog(BuildContext context, String open, String msg) {
    return new AlertDialog(
      content: new Text("${msg}"),
      actions: <Widget>[
        new FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        new FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    print("open--"+message["data"]['open-page']);
    // Clear away dialogs
    try {
      Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
      if (message["data"]["open-page"] == "exam_marks") {
        print("open");
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new MarksStudentTabScreen())
        );
      }

     else if (message["data"]["open-page"] == "exam_marks") {
        print("open");
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new MarksTabScreen(id: message["data"]["id"],studentname: message["data"]["name"]))
        );
      }
      else if (message["data"]["open-page"] == "dialy_attendance") {
        print("open");
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new parentStudentAttendance(id: message["data"]["id"],studentname: message["data"]["name"],))
        );
      }
      else if (message["data"]["open-page"] == "subjectwise_attendance") {
        print("open");
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new ParentSubjectWiseAttendance(studentname: message["data"]["id"],id: message["data"]["name"],))
        );
      }
      else if (message["data"]["open-page"] == "class_room_online") {
        print("open");
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new StudentClassroomPage ())
        );
      }
      else if (message["data"]["open-page"] == "message_read" || message["data"]["open-page"] == "group_message_read" ) {
        print("open");
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new PrivatemessagesPage())
        );
      }
    }catch(e){
      print(e);
    }
  }

  Future<Null> GetDashboardvslues() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Dashboard;
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
          teachers = responseJson['result']['teachers'].toString();
          parents = responseJson['result']['parents'].toString();
          students = responseJson['result']['studnets'].toString();
          attendance = responseJson['result']['present_today'].toString();
          present =  students == "0"? 0.0  : double.tryParse(attendance)/double.tryParse(students);
          noticeslist = responseJson['result']['notices'];
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

  var colrs = [
    Colors.purple,
    Colors.cyan,
    Colors.green,
    Colors.pinkAccent,
    Colors.red,
    Colors.indigoAccent,
    Colors.brown,
    Colors.orange,
    Colors.teal,
    Colors.lime,
  ];

  requestPermission() async {
    String url = await Constants().Clienturl();
    setState(() {
      imageurl = "https://demo.edecofy.com/uploads/"+url.split("://")[1]+"logo.png";
    });
    Permission storagepermission = Permission.storage;
    Permission locationpermission = Permission.location;
    Permission camerapermission = Permission.camera;
    Permission microphonepermission = Permission.microphone;

    final status = await storagepermission.request();
    final status1 = await locationpermission.request();
    final status2 = await camerapermission.request();
    final status3 = await microphonepermission.request();

  }

  displaynotice(String noticeid) async{
    Constants().onLoading(context);
    Map body = new Map();
    var  url = await Constants().Clienturl() + Constants.View_Notice+noticeid;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          List list = responseJson['result']['view_data'];
          if(list.length > 0)
            displayNoticedialog(list);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  displayNoticedialog(List notice) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new Row(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: new Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .primaryColor),
                            child: new Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Notice Deatils",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 20,width: 20,),
                new Container(margin: EdgeInsets.all(5.0),
                    child:new Column(
                      children: <Widget>[
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Title:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(notice[0]['notice_title'].toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],),
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Notice:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(notice[0]['notice'].toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],),
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Date:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(notice[0]['create_timestamp']) * 1000)).toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],)
                      ],
                    )),
                new SizedBox(width: 30,height: 30,),
                new Container(
                    margin: new EdgeInsets.all(0.0),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: new InkWell(
                        onTap: () {

                        },
                        child: new Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(15),bottomLeft:Radius.circular(15) )),
                            child: new Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                new Icon(Icons.print,color: Colors.white,),
                                new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Print Notice",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
                              ],
                            ))))
              ],
            )

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Dashboard"),
        backgroundColor: Color(0xff182C61),
      ),
      drawer: Constants().drawer(context),
      body: _loading ? new Constants().bodyProgress :  new ListView(
      children: <Widget>[
        Constants.logintype == "teacher" ? new Row(
          children: <Widget>[
            new Expanded(child: new Container(
              alignment: Alignment.center,
              child: new Card(
                  margin: EdgeInsets.all(10),elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(2)
                            ,child: new SvgPicture.asset("assets/student.svg",width: 35,height: 35,color: Colors.orange,),),
                          new Container(
                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
                          new Expanded(child: new Column(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text(students,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),textAlign: TextAlign.start,)
                              ),
//                              new Container(padding: EdgeInsets.all(2),
//                                  alignment: Alignment.centerLeft,
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent: 0.6,
//                                    progressColor: Colors.orange,
//                                  )
//                              ),
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text("Total Students",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,)
                              ),
                            ],
                          ))
                        ],
                      ))
              ),
            ),flex: 1,),
            new Expanded(child: new InkWell(child: new Container(
              alignment: Alignment.center,
              child: new Card(
                  margin: EdgeInsets.all(10),elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(2)
                            ,child: new SvgPicture.asset("assets/classroom.svg",width: 35,height: 35,color: Colors.green,),),
                          new Container(
                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
                          new Expanded(child:new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text(teachers,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),)
                              ),
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent: 0.8,
//                                    progressColor: Colors.green,
//                                  )
//                              ),
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text("Total Teachers",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)
                              ),
                            ],
                          ))
                        ],
                      ))
              ),
            ),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new TeachersformationPage()));
              },
            ),flex: 1,),
          ],
        ) : new Container(),
        Constants.logintype == "teacher" ? new Row(
          children: <Widget>[
            new Expanded(child: new Container(
              alignment: Alignment.center,
              child: new Card(
                  margin: EdgeInsets.all(10),elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(2)
                            ,child: new SvgPicture.asset("assets/family.svg",width: 35,height: 35,color: Colors.red[400],),),
                          new Container(
                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
                          new Expanded(child:new Column(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text(parents,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),)
                              ),
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent: 0.7,
//                                    progressColor: Colors.red[400],
//                                  )
//                              ),
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text("Total Parents",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)
                              ),
                            ],
                          ))
                        ],
                      ))
              ),
            )),
            new Expanded(child:
            new InkWell(child: new Container(
              alignment: Alignment.center,
              child: new Card(
                  margin: EdgeInsets.all(10),elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(2)
                            ,child: new SvgPicture.asset("assets/attendance.svg",width: 35,height: 35,color: Colors.blue[500],),),
                          new Container(
                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
                          new Expanded(child:new Column(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text(attendance,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),textAlign: TextAlign.start,)
                              ),
//                              new Container(padding: EdgeInsets.all(2),
//                                  alignment: Alignment.centerLeft,
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent:present,
//                                    progressColor: Colors.blue[500],
//                                  )
//                              ),
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text("Attendance",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,)
                              ),
                            ],
                          ))
                        ],
                      ))
              ),
            ),
              onTap: (){

              },
            ),flex: 1,),
//            new Expanded(child: new Container(
//              alignment: Alignment.center,
//              child: new Card(
//                  margin: EdgeInsets.all(10),elevation: 5,
//                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
//                  child: new Container(
//                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
//                      child: new Row(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          new Container(padding: EdgeInsets.all(2)
//                            ,child: new SvgPicture.asset("assets/family.svg",width: 35,height: 35,color: Colors.red[400],),),
//                          new Container(
//                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
//                          new Expanded(child:new Column(
//                            children: <Widget>[
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new Text(parents,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),)
//                              ),
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent: 0.7,
//                                    progressColor: Colors.red[400],
//                                  )
//                              ),
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new Text("Total Parents",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)
//                              ),
//                            ],
//                          ))
//                        ],
//                      ))
//              ),
//            ),flex: 1,),
          ],
        ) : new Container(),
        Constants.logintype == "admin" ? new Row(
          children: <Widget>[
            new Expanded(child: new Container(
              alignment: Alignment.center,
              child: new Card(
                  margin: EdgeInsets.all(10),elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(2)
                            ,child: new SvgPicture.asset("assets/student.svg",width: 35,height: 35,color: Colors.orange,),),
                          new Container(
                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
                          new Expanded(child: new Column(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text(students,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),textAlign: TextAlign.start,)
                              ),
//                              new Container(padding: EdgeInsets.all(2),
//                                  alignment: Alignment.centerLeft,
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent: 0.6,
//                                    progressColor: Colors.orange,
//                                  )
//                              ),
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text("Total Students",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,)
                              ),
                            ],
                          ))
                        ],
                      ))
              ),
            ),flex: 1,),
            new Expanded(child: new InkWell(child: new Container(
              alignment: Alignment.center,
              child: new Card(
                  margin: EdgeInsets.all(10),elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(2)
                            ,child: new SvgPicture.asset("assets/classroom.svg",width: 35,height: 35,color: Colors.green,),),
                          new Container(
                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
                          new Expanded(child:new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text(teachers,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),)
                              ),
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent: 0.8,
//                                    progressColor: Colors.green,
//                                  )
//                              ),
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text("Total Teachers",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)
                              ),
                            ],
                          ))
                        ],
                      ))
              ),
            ),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new TeachersformationPage()));
              },
            ),flex: 1,),
          ],
        ) : new Container(),
        Constants.logintype == "admin" ? new Row(
          children: <Widget>[
            new Expanded(child: new Container(
              alignment: Alignment.center,
              child: new Card(
                  margin: EdgeInsets.all(10),elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(2)
                            ,child: new SvgPicture.asset("assets/family.svg",width: 35,height: 35,color: Colors.red[400],),),
                          new Container(
                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
                          new Expanded(child:new Column(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text(parents,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),)
                              ),
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent: 0.7,
//                                    progressColor: Colors.red[400],
//                                  )
//                              ),
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text("Total Parents",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)
                              ),
                            ],
                          ))
                        ],
                      ))
              ),
            ),flex: 1,),
            new Expanded(child:
            new InkWell(child: new Container(
              alignment: Alignment.center,
              child: new Card(
                  margin: EdgeInsets.all(10),elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(padding: EdgeInsets.all(2)
                            ,child: new SvgPicture.asset("assets/attendance.svg",width: 35,height: 35,color: Colors.blue[500],),),
                          new Container(
                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
                          new Expanded(child:new Column(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text(attendance,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),textAlign: TextAlign.start,)
                              ),
//                              new Container(padding: EdgeInsets.all(2),
//                                  alignment: Alignment.centerLeft,
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent:present,
//                                    progressColor: Colors.blue[500],
//                                  )
//                              ),
                              new Padding(padding: EdgeInsets.all(2),
                                  child: new Text("Attendance",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,)
                              ),
                            ],
                          ))
                        ],
                      ))
              ),
            ),
              onTap: (){

              },
            ),flex: 1,),
//            new Expanded(child: new Container(
//              alignment: Alignment.center,
//              child: new Card(
//                  margin: EdgeInsets.all(10),elevation: 5,
//                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
//                  child: new Container(
//                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
//                      child: new Row(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          new Container(padding: EdgeInsets.all(2)
//                            ,child: new SvgPicture.asset("assets/family.svg",width: 35,height: 35,color: Colors.red[400],),),
//                          new Container(
//                            margin: EdgeInsets.all(5), color: Colors.grey[200], height: 40, width: 1,),
//                          new Expanded(child:new Column(
//                            children: <Widget>[
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new Text(parents,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11),)
//                              ),
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new LinearPercentIndicator(
//                                    width: 80.0,
//                                    lineHeight: 3.0,
//                                    percent: 0.7,
//                                    progressColor: Colors.red[400],
//                                  )
//                              ),
//                              new Padding(padding: EdgeInsets.all(2),
//                                  child: new Text("Total Parents",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)
//                              ),
//                            ],
//                          ))
//                        ],
//                      ))
//              ),
//            ),flex: 1,),
          ],
        ) : new Container(),
        new Card(
          margin: EdgeInsets.all(10),elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: new Container(margin: EdgeInsets.all(10),child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: new Container(
                alignment: Alignment.center,
                decoration:
                BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:  LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 1.0],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.orange[700],
                      Colors.orange[400],
                    ],
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: new SvgPicture.asset("assets/megaphone.svg",width: 30,height: 30,color: Colors.white,),
              ),flex: 2,),
              new Expanded(child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("Announcement",),
                  new Container(
                    margin: EdgeInsets.all(2.0),
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.red[400],
                        shape: BoxShape.rectangle,
                        gradient:  LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.1, 1.0],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.orange[400],
                            Colors.red[400],
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: new Text("Urgent",style: TextStyle(color: Colors.white,fontSize: 10),),
                  ),
                  new Padding(padding: EdgeInsets.all(2), child : new Text("(Coming soon)",style: TextStyle(color: Colors.red,fontSize: 10),)),
                ],
              ),flex: 5,),
              new Expanded(child: new Container(
                margin: EdgeInsets.only(left:5.0,right: 5),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: new Text("0 New",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
              ),flex: 3,)
            ],
          )),
        ),
        new Card(
          margin: EdgeInsets.all(10),elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          child: new Container(margin: EdgeInsets.all(10),child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: new Container(
                alignment: Alignment.center,
                decoration:
                BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:  LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 1.0],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.red[400],
                      Colors.orange[400],
                    ],
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: new SvgPicture.asset("assets/notifications.svg",width: 30,height: 30,color: Colors.white,),
              ),flex: 2,),
              new Expanded(child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("Notifications",),
                  new Padding(padding: EdgeInsets.all(2), child : new Text("(Coming soon)",style: TextStyle(color: Colors.red,fontSize: 10),)),
                ],
              ),flex: 5,),
              new Expanded(child: new Container(
                margin: EdgeInsets.only(left:5.0,right: 5),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: new Text("0 New",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
              ),flex: 3,)
            ],
          )),
        ),
        new SizedBox(
            height: 350,
            child: new Card(
                margin: EdgeInsets.only(left:10,right:10,top:10,bottom:10),elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 0),
                          child: new Text("Noticeboard",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15),textAlign: TextAlign.start,)),
                      Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index) {
                        return Container(padding: EdgeInsets.all(10),child: new Column(
                          children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(flex: 5,child: new Container(),),
                                Expanded(flex: 4,child: Padding(
                                  padding: const EdgeInsets.only(bottom:8.0),
                                  child: new Text(new DateFormat('dd-MM-yyyy   hh:mm aaa').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(noticeslist[index]['create_timestamp']) * 1000)).toString(),style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 11),textAlign: TextAlign.end,),
                                ),),
                                Expanded(flex: 1,child: new /*IconButton(icon: Icon(Icons.delete,color: Colors.red,size: 15,), onPressed: null)*/ Container(),)

                              ],
                            ),
                            new InkWell(child: new Container(height: 65,
                              child: new Stack(children: <Widget>[ new Card( margin: EdgeInsets.only(left: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                elevation: 5,
                                child :new Container(
                                  padding: EdgeInsets.only(left: 55,top: 5,bottom: 5,right: 5),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Row(
                                        children: <Widget>[
                                          new Expanded(child: new Container(child : new Text(new DateFormat('hh:mm aaa').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(noticeslist[index]['create_timestamp']) * 1000)).toString(),style: TextStyle(color: Theme.of(context).primaryColor),),padding: EdgeInsets.all(2),),flex: 3,),
                                          Expanded(child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Container(child : new Text(noticeslist[index]['notice_title'].toString(),style: TextStyle(fontSize: 10,color: Colors.black),maxLines: 1,overflow: TextOverflow.ellipsis),padding: EdgeInsets.all(2),),
                                              new Container(child : new Text(noticeslist[index]['notice'].toString(),style: TextStyle(fontSize: 8),maxLines: 1,overflow: TextOverflow.ellipsis),padding: EdgeInsets.only(left: 2,bottom: 2),)
                                            ],
                                          ),flex: 7,)
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                              new Align(
                                alignment: Alignment.topLeft,
                                child: new Container(
                                  decoration: BoxDecoration(
                                      color: colrs[index%10],
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  child: new Center( child: new Text(new DateFormat('MMM dd').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(noticeslist[index]['create_timestamp']) * 1000)).toString(),style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)),
                                  padding: EdgeInsets.all(10),
                                  width: 50,
                                  height: 65,
                                ),
                              ),
                            ]),
                            ),
                              onTap: (){
                                displaynotice(noticeslist[index]['notice_id'].toString());
                              },
                            )
                          ],
                        ));
                      },itemCount: noticeslist.length,
                      ))])
            ))
      ],
    ),
    );
  }

}
