import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'const.dart';
import 'dashboard.dart';

class ManageProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ManageProfilePageState();
}

class _ManageProfilePageState extends State<ManageProfilePage> {
  bool notification = false,locationtracking = false;
  String parent= "",email='';
  bool _loading = false;
  TextEditingController parentcont= new TextEditingController();
  TextEditingController emailcont= new TextEditingController(),currentpassword=new TextEditingController(),newpassword=new TextEditingController(),confirmnewpassword=new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadProfile();
  }

  Future<Null> LoadProfile() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Manage_Profile+id;
    Map<String, String> body = new Map();
    body['parent_id'] = id;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            parentcont.text = responseJson['result'][0]['name'];
            emailcont.text = responseJson['result'][0]['email'];
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

  Future<Null> Updateemail() async {
    String id = await sp.ReadString("Userid");
    if(emailcont.text == ""){
      Constants().ShowAlertDialog(context, "Please fill email");
      return;
    }
    if(currentpassword.text == ""){
      Constants().ShowAlertDialog(context, "Please fill current password");
      return;
    }
    if(newpassword.text == ""){
      Constants().ShowAlertDialog(context, "Please fill new password");
      return;
    }
    if(confirmnewpassword.text == ""){
      Constants().ShowAlertDialog(context, "Please fill confirm new password");
      return;
    }
    if(confirmnewpassword.text != newpassword.text){
      Constants().ShowAlertDialog(context, "Please enter password same as new password");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Update_profile;

    Map<String, String> body = new Map();

    body['parent_id'] = id;
    body['email'] = emailcont.text;
    body['name'] = parentcont.text;
    body['password'] = currentpassword.text;
    body['new_password'] = newpassword.text;
    body['confirm_new_password'] = confirmnewpassword.text;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          Constants().ShowSuccessDialog(context, "Profile has been updated successfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, responseJson['message'].toString());
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
        title: Text("Manage Profile"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
      drawer: Constants().drawer(context),
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
              child: new Text("Manage Profile",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                new Padding(padding: EdgeInsets.all(5.0),child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Parent",
                    prefixIcon: new Icon(FontAwesomeIcons.user),
                  ),
                  onChanged: (String val){
                    parent = val;
                  },
                  controller: parentcont,
                )),
                new Padding(padding: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  onChanged: (String val){
                    email = val;
                  },
                  controller: emailcont,
                )),
              new Padding(padding: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Current Password *",
                      prefixIcon: new Icon(Icons.lock_open)
                  ),
                controller: currentpassword,
              )),
                new Padding(padding: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "New Password *",
                      prefixIcon: new Icon(Icons.lock_open)
                  ),
                  controller: newpassword,
                )),
               new Padding(padding: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Confirm New Password *",
                      prefixIcon: new Icon(Icons.lock_outline)
                  ),
                 controller: confirmnewpassword,
               )),
                new SizedBox(width: 20,height: 20,),
                new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(child: new Container(
                          margin: new EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: new InkWell(
                              onTap: () {
                                setState(() {
                                  currentpassword.text='';newpassword.text='';confirmnewpassword.text='';parentcont.text="";emailcont.text="";
                                });
                              },
                              child: new Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow[800],
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15))),
                                  child: new Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Icon(Icons.autorenew,color: Colors.white,),
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Reset",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
                                    ],
                                  )))),flex: 1,),
                      new Expanded(child:new Container(
                          margin: new EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: new InkWell(
                              onTap: () {
                                Updateemail();
                              },
                              child: new Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(
                                        bottomRight:
                                        Radius.circular(15),)),
                                  child: new Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Icon(Icons.check,color: Colors.white,),
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Update",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
                                    ],
                                  )))),flex: 1,),
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