import 'dart:io';

import 'package:Edecofy/prrivatemessages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'AppUtils.dart';
import 'FilePicker.dart';
import 'const.dart';
import 'dashboard.dart';
import 'search.dart';

class Messagesystem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MessagesystemState();
}

class _MessagesystemState extends State<Messagesystem> {
  String recipient= "",message='';
  bool _loading = false;
  TextEditingController messasecont= new TextEditingController();
  List<String> receipentslist = new List();
  Map<String,String> receptmap = new Map();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadReceptents();
  }

  Future<Null> LoadReceptents() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Receipents;
    Map<String, String> body = new Map();
    print("url is $url"+"body--"+body.toString());
    http.get(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"})
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            responseJson['result']['admins'].forEach((admin){
              receipentslist.add(admin['name']+" - Admin");
              receptmap[admin['name']+" - Admin"] = "admin-"+admin['admin_id'];
            });
            responseJson['result']['students'].forEach((admin){
              receipentslist.add(admin['name']);
              receptmap[admin['name']] = "student-"+admin['student_id'];
            });
            responseJson['result']['parents'].forEach((admin){
              receipentslist.add(admin['name']);
              receptmap[admin['name']] = "parent-"+admin['parent_id'];
            });
          }catch(e){
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

  Dio dio = new Dio();
  File _file = null;
  String fileext= "",filename= "";

  Future _getFile() async {
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
  }

  Future<Null> Sendmessage() async {
    String id = await sp.ReadString("Userid");
    if(recipient == ""){
      Constants().ShowAlertDialog(context, "Please Select Receipent");
      return;
    }
    if(messasecont.text == ""){
      Constants().ShowAlertDialog(context, "Please fill message");
      return;
    }

    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Send_Newmessage;
    Map<String, dynamic> body = new Map();
    body['teacher_id'] = id;
    body['message'] = messasecont.text;
    body['attached_file_on_messaging'] = _file == null ? "" : new UploadFileInfo(_file, await AppUtil.getFileNameWithExtension(_file));
    body['reciever'] = receptmap[recipient];
    print("url is $url"+"body--"+body.toString());

    dio.options.baseUrl = url;
    dio.options.connectTimeout = 120000; //5s
    dio.options.receiveTimeout=5000;
    FormData formData = new FormData.from(body);
    // Send FormData
    try {
      Response response = await dio.post("", data: formData);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        print("response --> ${response.data}");
        var responseJson = json.decode(response.data);
        if (responseJson['result']['status'].toString() == "true") {
          print("response json ${responseJson}");
          Constants().ShowSuccessDialog(context, responseJson['result']['message']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                new PrivatemessagesPage()));
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, responseJson['result']['message'].toString());
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.data);
      }
    }catch(e){
      print("imaguploadresponse-->${e}");
    }
  }

  _navigatetoreceipent(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Receipent",duplicateitems: receipentslist,)),
    );
    setState(() {
      recipient = result ?? recipient;
    });
    print("res--"+result.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Message System"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
      drawer: Constants().drawer(context),
      body:  _loading ? new Constants().bodyProgress : new Stack(
        children: <Widget>[
          new Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
              shape: BoxShape.rectangle
            ),
            child: new Center(
              child: new Text("Write New Message",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
            ),
          ),
          new Container(
              margin:
              new EdgeInsets.only(left: 50, right: 30, bottom: 10, top: 30),
          child : new Stack(
            children: <Widget>[
              new Card(
                margin: new EdgeInsets.only(top: 20,right: 20),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    new SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    new Padding(
                        padding: EdgeInsets.all(5.0),
                        child: new InkWell(
                          child: new TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Recipient *",
                                prefixIcon: new Icon(FontAwesomeIcons.userCircle),
                                suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                            ),
                            controller: TextEditingController(text: recipient),
                            enabled: false,
                          ),
                          onTap: () {
                            _navigatetoreceipent(context);
                          },
                        )),
                    new Padding(
                        padding: EdgeInsets.all(5.0),
                        child: new InkWell(
                          child: new TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Upload File *",
                                prefixIcon: new Icon(FontAwesomeIcons.upload),
                                suffixIcon: _file == null ? new Icon(Icons.cloud_upload) : new ClipOval(child: new Image.file(_file,scale: 25,))
                            ),
                            controller: TextEditingController(text:  _file == null ? "" : filename),
                            enabled: false,
                          ),
                          onTap: () {
                            _getFile();
                          },
                        )),
                    new Padding(
                      padding: EdgeInsets.all(5.0),
                      child: new TextField(
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Message *",
                          //prefixIcon: new Icon(Icons.message),
                        ),
                        controller: messasecont,
                        maxLines: 4,
                      ),
                    ),
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
                                      Sendmessage();
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
                                              Icons.send,
                                              color: Colors.white,
                                            ),
                                            new Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "SEND",
                                                style: TextStyle(
                                                    color:Theme.of(context).primaryColor,
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
              new Align(
                alignment: Alignment.topRight,
                child: new Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                  ),
                  child: new Icon(Icons.message,color: Colors.white,size: 30,),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

}