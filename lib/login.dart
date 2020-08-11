import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'OnBoardingScreens/OnBoardingScreens.dart';
import 'const.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldky = new GlobalKey<ScaffoldState>();
  var username = '';
  String password = '';
  String _homeScreenText='',fcmid;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  submit() async{
    // First validate form.
    if(username == "" || username == null){
      Constants().ShowAlertDialog(context, "Please enter Username");
      return;
    }

    if(password == ""){
      Constants().ShowAlertDialog(context, "Please enter Password");
      return;
    }
    Constants().onLoading(context);
    var url =  Constants.BASE_URL+ Constants.Login_Api;
    Map<String, String> body = new Map();
    body[isNumeric(username) ? 'email' :'email' ] = username;
    body['password'] = password;
    print("url is $url -- par-${body.toString()}");
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        Navigator.of(context).pop();
        if (responseJson['status'].toString() == "true" && responseJson['result']['user_type'] == 'parent') {
          sp.Remove("Userid");
          sp.Remove("clienturl");
          sp.Remove("email");
          sp.Remove("mobile");
          sp.Remove("username");
          sp.Remove("logintype");
          sp.WriteString("logintype", responseJson['result']['user_type']);
          sp.WriteString("Userid", responseJson['result']['parent_id']);
          sp.WriteString("clienturl", responseJson['result']['access_url']);
          sp.WriteString("email", responseJson['result']['email']);
          sp.WriteString("username", responseJson['result']['name']);
          sp.WriteString("mobile", responseJson['result']['phone']);
          Constants.email = responseJson['result']['email'];
          Constants.schooltype = responseJson['result']['system_title'];
          Constants.username = responseJson['result']['name'];
          sp.Remove("classroomurl");
          sp.Remove("classroomkey");
          sp.WriteString("classroomurl", responseJson['result']['classroomBaseURL']);
          sp.WriteString("classroomkey", responseJson['result']['classroomSecret']);

          Constants.logintype = responseJson['result']['user_type'];
          Updatefcm(responseJson['result']['user_type'],responseJson['result']['parent_id'],responseJson['result']['access_url']);
        }

        else if (responseJson['status'].toString() == "true" && responseJson['result']['user_type'] == 'teacher') {
          sp.Remove("Userid");
          sp.Remove("clienturl");
          sp.Remove("email");
          sp.Remove("mobile");
          sp.Remove("username");
          sp.Remove("logintype");
          sp.WriteString("logintype", responseJson['result']['user_type']);
          sp.WriteString("Userid", responseJson['result']['teacher_id']);
          sp.WriteString("clienturl", responseJson['result']['access_url']);
          sp.WriteString("email", responseJson['result']['email']);
          sp.WriteString("username", responseJson['result']['name']);
          sp.WriteString("mobile", responseJson['result']['phone']);
          Constants.email = responseJson['result']['email'];
          Constants.username = responseJson['result']['name'];
          Constants.logintype = responseJson['result']['user_type'];
          Constants.schooltype = responseJson['result']['system_title'];

          sp.Remove("classroomurl");
          sp.Remove("classroomkey");
          sp.WriteString("classroomurl", responseJson['result']['classroomBaseURL']);
          sp.WriteString("classroomkey", responseJson['result']['classroomSecret']);

          Updatefcm(responseJson['result']['user_type'],responseJson['result']['teacher_id'],responseJson['result']['access_url']);
        }

        else if (responseJson['status'].toString() == "true" && responseJson['result']['user_type'] == 'student') {
          sp.Remove("Userid");
          sp.Remove("clienturl");
          sp.Remove("email");
          sp.Remove("mobile");
          sp.Remove("username");
          sp.Remove("logintype");
          sp.WriteString("logintype", responseJson['result']['user_type']);
          sp.WriteString("Userid", responseJson['result']['student_id']);
          sp.WriteString("clienturl", responseJson['result']['access_url']);
          sp.WriteString("email", responseJson['result']['email']);
          sp.WriteString("username", responseJson['result']['name']);
          sp.WriteString("mobile", responseJson['result']['phone']);
          Constants.email = responseJson['result']['email'];
          Constants.username = responseJson['result']['name'];
          Constants.logintype = responseJson['result']['user_type'];
          Constants.schooltype = responseJson['result']['system_title'];
          Updatefcm(responseJson['result']['user_type'],responseJson['result']['student_id'],responseJson['result']['access_url']);
          sp.Remove("classroomurl");
          sp.Remove("classroomkey");
          sp.WriteString("classroomurl", responseJson['result']['classroomBaseURL']);
          sp.WriteString("classroomkey", responseJson['result']['classroomSecret']);
          Updatefcm(responseJson['result']['user_type'],responseJson['result']['student_id'],responseJson['result']['access_url']);
        }
        else if (responseJson['status'].toString() == "true" && responseJson['result']['user_type'] == 'admin') {
          sp.Remove("Userid");
          sp.Remove("clienturl");
          sp.Remove("email");
          sp.Remove("mobile");
          sp.Remove("username");
          sp.Remove("logintype");
          sp.WriteString("logintype", responseJson['result']['user_type']);
          sp.WriteString("Userid", responseJson['result']['admin_id']);
          sp.WriteString("clienturl", responseJson['result']['access_url']);
          sp.WriteString("email", responseJson['result']['email']);
          sp.WriteString("username", responseJson['result']['name']);
          sp.WriteString("mobile", responseJson['result']['phone']);
          Constants.email = responseJson['result']['email'];
          Constants.username = responseJson['result']['name'];
          Constants.logintype = responseJson['result']['user_type'];
          Constants.schooltype = responseJson['result']['system_title'];
          sp.Remove("classroomurl");
          sp.Remove("classroomkey");
          sp.WriteString("classroomurl", responseJson['result']['classroomBaseURL']);
          sp.WriteString("classroomkey", responseJson['result']['classroomSecret']);
          Updatefcm(responseJson['result']['user_type'],responseJson['result']['admin_id'],responseJson['result']['access_url']);

        }
        else{
          Constants().ShowAlertDialog(context, "Username/Password is incorrect");
        }
      }
      else {
        print("error"+response.body);
        Navigator.of(context).pop();
      }
    });
  }

  Updatefcm(String usertype,String userid,String clienturl) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['user_type'] = usertype;
    body['user_id'] = userid;
    body['fcm_id'] = fcmid;
    var url = clienturl+"/api_parents/user_fcm_update_api/"+usertype+"/"+userid+"/"+fcmid;
    print("url--"+url+'body is $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        debugPrint("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        Navigator.of(context).pop();
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          if(usertype == "parent")
            LoadChildrendetails();
          else if(usertype == "teacher")
            LoadCLassdetails();
          else if(usertype == "admin")
            LoadAdminCLassdetails();
          else if(usertype == "student")
            LoadStudentdetails();
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
        if(usertype == "admin"){
          LoadAdminCLassdetails();
        }
      }
    });
  }

  LoadChildrendetails() async{
    Constants().onLoading(context);
    Map body = new Map();
    body['parent_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_Childrens;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        Navigator.of(context).pop();
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            sp.Remove("children");
            sp.WriteString("children",response.body);
            Constants.dynmenulist = response.body;
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(builder: (context) => new OnboardingPage()),
            );
          }catch(e){
          }
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  LoadCLassdetails() async{
    Constants().onLoading(context);
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_Classes;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        Navigator.of(context).pop();
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            sp.Remove("children");
            sp.WriteString("children",response.body);
            Constants.dynmenulist = response.body;
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(builder: (context) => new OnboardingPage()),
            );
          }catch(e){
          }
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  LoadAdminCLassdetails() async{
    Constants().onLoading(context);
    Map body = new Map();
    var url = await Constants().Clienturl() + Constants.Load_Classes_Admin;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        Navigator.of(context).pop();
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            sp.Remove("children");
            sp.WriteString("children",response.body);
            Constants.dynmenulist = response.body;
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(builder: (context) => new OnboardingPage()),
            );
          }catch(e){
          }
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  LoadStudentdetails() async{
    Constants().onLoading(context);
    Map body = new Map();
    body['student_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_Classes;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        Navigator.of(context).pop();
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            sp.Remove("children");
            sp.WriteString("children",response.body);
            Constants.dynmenulist = response.body;
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(builder: (context) => new OnboardingPage()),
            );
          }catch(e){
          }
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
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
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
        fcmid = token;
      });
      print(_homeScreenText);
    });
  }

  void fcmtokenupdate(String userid) async{
    Map body = new Map();
    Map data = new Map();
    body['data'] = data;
    data['id'] = userid;
    data['description'] = fcmid;
    print('body is${json.encode(body)}');
    var url = "ADUser";
    http
        .post(url,
        headers: {"Accept": "application/json"},
        body: json.encode(body))
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      var res = json.decode(response.body)['response'];
      if (res['status'] == 0) {
        Navigator.of(context).pop();
        showInSnackBar("logged in succesfully with username : $username");
        const duration = const Duration(seconds:2);
        void handleTimeout() {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) => null),
          );// callback function
        }
        new Timer(duration, handleTimeout);

      } else if (res['status'] == -1) {
        Navigator.of(context).pop();
        showInSnackBar("${res['error'].toString()}");
      } else {
        Navigator.of(context).pop();
        showInSnackBar("${res['errors'].toString()}");
      }
    });
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Authenticating..."),
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String message) {
    scaffoldky.currentState
        .showSnackBar(new SnackBar(content: new Text(message,style: new TextStyle(color: Colors.yellow),),backgroundColor: Colors.black,duration:const Duration(milliseconds: 4000),));
  }
  bool _isHidden = true;
  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only( top:50.0,right: 30.0, left: 30.0),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            new Container(
              width: 150.0,
              height: 150.0,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logo1.png',
                width: 150.0,
                height: 150.0,
                fit: BoxFit.cover,
              ),

//                new Image.network('https://demo.edecofy.com/uploads/demo.edecofy.com/logo.png')

            ),
            SizedBox(height: 40.0,),
            buildTextField("Email/Phone/Username"),
            SizedBox(height: 20.0,),
            buildTextField("Password"),
            SizedBox(height: 50.0,),
            new InkWell(child: buildButtonContainer(),
              onTap: (){
                submit();
              },),

            SizedBox(height: 50.0),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.lock,
                    size: 20.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20.0,),
//            Container(
//              child: Center(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text("Don't have an account?"),
//                    SizedBox(width: 10.0,),
//
//                    Text("Sign up", style: TextStyle(color: Theme.of(context).primaryColor,))
//                  ],
//                ),
//              ),
//            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText){
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right:8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(
            fontSize: 16.0,
          ),

          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:Color(0xff27AE60)),),
//        border: OutlineInputBorder(
//          borderRadius: BorderRadius.circular(20.0),
//        ),
//          prefixIcon: hintText == "Email/Phone" ? Icon(Icons.email) : Icon(Icons.lock),
          suffixIcon: hintText == "Password" ? IconButton(
            onPressed: _toggleVisibility,
            icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
          ) : null,
        ),
        onChanged: (String val){
          hintText == "Email/Phone/Username" ? username = val : password = val;

        },
        obscureText: hintText == "Password" ? _isHidden : false,
      ),
    );
  }

  Widget buildButtonContainer(){
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xff182C61),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:15.0),
            child: Icon(
              Icons.exit_to_app,
              size: 20.0,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:100.0),
            child: Text(
              " Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,

              ),
            ),
          ),
        ],
      ),
    );

  }

}
