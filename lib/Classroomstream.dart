import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xml_parser/xml_parser.dart';
import 'const.dart';
import 'dashboard.dart';

class Classroomstream extends StatefulWidget {
  final String meetingid,name;
  Classroomstream({this.meetingid,this.name});

  @override
  _ClassroomstreamState createState() => new _ClassroomstreamState();
}

class _ClassroomstreamState extends State<Classroomstream> {
  bool _loading = false,sesssion=false;
  String meetingid = "muni-123",name="muni-123",welcome="WELCOME+TO+MUNI+TUITION",fullname="",meetingurl="",classroomurl="",classroomsecret="";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadClassroomurl();
  }
  
  LoadClassroomurl() async{
    Permission microphonepermission = Permission.microphone;
    final status3 = await microphonepermission.request();
    classroomurl = await Constants().Classroomurl();
    classroomsecret = await Constants().Classroomkey();
    fullname = await sp.ReadString("username");
    String pw= "";
    if(Constants.logintype == "teacher")
      pw = "mp";
    else
      pw = "ap";
    String joinparams = "fullName="+fullname+"&meetingID="+widget.meetingid+"&password="+pw+"&redirect=true";
    var joinbytes = utf8.encode("join"+ joinparams +classroomsecret); // data being hashed
    var joindigest = sha1.convert(joinbytes);
    meetingurl = classroomurl+"api/join?"+joinparams+"&checksum="+joindigest.toString();
    print(meetingurl);
    setState(() {
      _loading = false;
    });
    //Createsession(createparams,createdigest);
  }

  Future<Null> Createsession(String params, Digest digest) async {
    var url = classroomurl+"api/create?"+ params+"&checksum="+digest.toString();
    Map<String, String> body = new Map();
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        XmlDocument xmlDocument = XmlDocument.fromString(response.body);
        print("val--"+xmlDocument.getElement("response").getElement("returncode").text);
        if(xmlDocument.getElement("response").getElement("returncode").text == "SUCCESS"){

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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  _loading ? Constants().bodyProgress :  new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.name),
      ),
      body: InAppWebView(
        initialUrl: meetingurl,
        initialOptions: InAppWebViewWidgetOptions(
          inAppWebViewOptions: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
            debuggingEnabled: true,
            javaScriptEnabled: true,
            cacheEnabled: true,
            userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.117 Safari/537.36",
          ),
          androidInAppWebViewOptions: AndroidInAppWebViewOptions(
            supportZoom: true,
            domStorageEnabled: true,
          )
        ),
          onPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
            print(origin);
            print(resources);
            return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
          },
      ),
    );
    //new Container();
  }
}

/*
WebView(
initialUrl: "https://classroom.edecofy.com/bigbluebutton/api/join?fullName=User+4308264&meetingID=muni-123&password=mp&redirect=true&checksum=1405046f7ba44ebebe2c385835adeb5c1f29fbf2",
javascriptMode: JavascriptMode.unrestricted,
userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36",
initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
),*/
