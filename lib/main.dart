import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'const.dart';
import 'profile.dart';
import 'login.dart';
import 'uploadprofilepicture.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;

Widget _defaultHome;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _defaultHome = new LoginPage();
  String _result = await sp.ReadString("Userid");
  if (_result != "") {
    _defaultHome = new DashboardPage();
    Constants.email = await sp.ReadString("email");
    Constants.username = await sp.ReadString("username");
    Constants.logintype = await sp.ReadString("logintype");
    Constants.dynmenulist = await sp.ReadString("children");
    if(Constants.logintype == "teacher")
      LoadCLassdetails();
    else if(Constants.logintype == "student")
      LoadStudentDetails();
    else if(Constants.logintype  == "admin")
      LoadAdminCLassdetails();
    else if(Constants.logintype == "parent")
      LoadChildrendetails();
    else
      runApp(MyApp());
  }
  runApp(MyApp());
}


LoadStudentDetails() async{
  Map body = new Map();
  body['student_id'] = await Constants().Userid();
  var url = await Constants().Clienturl() + Constants.Load_Childrens;
  print("url--"+url+'body is${json.encode(body)} $body');
  http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
      .then((response) {
    if (response.statusCode == 200) {
      print("response --> ${response.body}");
      var responseJson = json.decode(response.body);
      if (responseJson['status'].toString() == "true") {
        print("response json ${responseJson}");
        try {
          sp.Remove("children");
          sp.WriteString("children",response.body);
          Constants.dynmenulist = response.body;
        }catch(e){
        }
      }
      runApp(MyApp());
    }
    else {
      print("erroe--"+response.body);
    }
  });
}

LoadChildrendetails() async{
  Map body = new Map();
  body['parent_id'] = await Constants().Userid();

  var url = await Constants().Clienturl() + Constants.Load_Childrens;
  print("url--"+url+'body is${json.encode(body)} $body');
  http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
      .then((response) {
    if (response.statusCode == 200) {
      print("response --> ${response.body}");
      var responseJson = json.decode(response.body);
      if (responseJson['status'].toString() == "true") {
        print("response json ${responseJson}");
        try {
          sp.Remove("children");
          sp.WriteString("children",response.body);
          Constants.dynmenulist = response.body;
        }catch(e){
        }
      }
      runApp(MyApp());
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
        try {
          sp.Remove("children");
          sp.WriteString("children",response.body);
          Constants.dynmenulist = response.body;
        }catch(e){
        }
      }
      runApp(MyApp());
    }
    else {
      print("erroe--"+response.body);
    }
  });
}

LoadAdminCLassdetails() async{
  Map body = new Map();

  var url = await Constants().Clienturl() +  Constants.Load_Classes_Admin;
  print("url--"+url+'body is${json.encode(body)} $body');
  http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
      .then((response) {
    if (response.statusCode == 200) {
      print("response --> ${response.body}");
      var responseJson = json.decode(response.body);
      if (responseJson['status'].toString() == "true") {
        print("response json ${responseJson}");
        try {
          sp.Remove("children");
          sp.WriteString("children",response.body);
          Constants.dynmenulist = response.body;
        }catch(e){
        }
      }
      runApp(MyApp());
    }
    else {
      print("erroe--"+response.body);
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  Color primarycolor = Color(0xff182C61);
  Color primarycoloraccent = Color(0xFF534bae);
  Color tableTextColor = Color(0xFF646464);
  MaterialColor colorCustom = MaterialColor(0xFF1a237e, color);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edecofy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
          primarySwatch: colorCustom,
          primaryColor: colorCustom,
          accentColor: Colors.blue,
          fontFamily: 'Poppins'
      ),
      home: _defaultHome,
      debugShowCheckedModeBanner: false,
    );
  }
}
