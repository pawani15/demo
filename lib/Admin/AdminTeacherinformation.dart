import 'dart:io';
import 'dart:math';

import 'package:Edecofy/search.dart';
import 'package:Edecofy/teachersinformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';

class AdminteacherPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _AdminteacherPageState();
}

class _AdminteacherPageState extends State<AdminteacherPage> {
  bool _loading = false,show=false;
  TextEditingController controller = new TextEditingController();
  bool credentials = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadteachers();
  }

  Future<Null> Loadteachers() async {
    _Teacherdetails.clear();
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Teachers_Admin;
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
            setState(() {
              for (Map user in responseJson['result']) {
                _Teacherdetails.add(Teacherdetails.fromJson(user));
              }
            });
          }catch(e){
            _Teacherdetails = new List();
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

  Future<Null> CreateTeacher(String type,String teacherid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url="";
    if(type == "new")
      url = await Constants().Clienturl() + Constants.Create_Teacher;
    else
      url = await Constants().Clienturl() + Constants.Create_Teacher;

    Map<String, String> body = new Map();

    if(type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['teacher_id'] = teacherid;
    }

    body['name'] = name.text;
    body['email'] = email.text;
    body['password'] = "";
    body['phone'] = phone.text;
    body['designation'] = specalization.text;
    body['address'] = address.text;
    body['birthday'] = new DateFormat('yyyy-MM-dd').format(dob);
    body['sex'] = gender.text;
    body['show_on_website'] = showonwebsite.text;
    body['facebook'] = facebookurl.text;
    body['twitter'] = twitterurl.text;
    body['linkedin'] = linkdinurl.text;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        print("response json ${responseJson}");
        Navigator.of(context).pop();
        if(responseJson['status'].toString() == "true"){
          Navigator.of(context).pop();
          if(type == "edit")
            Constants().ShowSuccessDialog(context, "Teacher updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Teacher added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Loadteachers();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Teacher not added succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> EditTeacherPassword(String teacherid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Edit_Password_Teacher;

    Map<String, String> body = new Map();
    body['type_page'] = "edit_pwd";
    body['teacher_id'] = teacherid;
    body['password'] = password.text;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        print("response json ${responseJson}");
        Navigator.of(context).pop();
        if(responseJson['status'].toString() == "true"){
          Navigator.of(context).pop();
          Constants().ShowSuccessDialog(context, "Password updated succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Password not updated succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> Delete(String teacherid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Delete_Teacher;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['teacher_id'] = teacherid;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        print("response json ${responseJson}");
        Navigator.of(context).pop();
        if(responseJson['status'].toString() == "true"){
          Navigator.of(context).pop();
          Constants().ShowSuccessDialog(context, "Teacher deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Loadteachers();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Teacher not deleted succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  TextEditingController search = new TextEditingController();

  Widget _EdittPopup(Teacherdetails teacherdetails) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 1,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: new Icon(FontAwesomeIcons.edit,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Edit",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
      PopupMenuItem(
          value: 2,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: new Icon(Icons.lock_open,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Edit Password",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
      PopupMenuItem(
          value: 3,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: new Icon(FontAwesomeIcons.trashAlt,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Delete",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
    ],
    elevation: 5,
    padding: EdgeInsets.symmetric(horizontal: 10),
    onSelected: (value) {
      print(value);
      if(value == 1)
        AddsTeacherdialog("edit", "refresh",teacherdetails);
      if(value == 2)
        Editpassword(teacherdetails);
      if(value == 3)
        deletedialog(teacherdetails);
    },
  );

  Future<Null> _selectDateofbirth(BuildContext context, String action, Teacherdetails teacherdetails) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != dob) {
        print('date selected : ${dob.toString()}');
        setState(() {
          dob = picked;
        });
      }
      Navigator.of(context).pop();
      AddsTeacherdialog(action,"norefresh",teacherdetails);
    }catch(e){e.toString();}
  }

  _navigatetogender(BuildContext context, String action, Teacherdetails teacherdetails) async {
    List<String> Genderlist= new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(context, "Gender", Genderlist);
    setState(() {
      gender.text = result ?? gender.text;
    });
    print("res--"+result.toString());
    Navigator.of(context).pop();
    AddsTeacherdialog(action,"norefresh",teacherdetails);
  }

  File _file = null;
  String fileext= "",filename= "";
  Future _getFile(String action, Teacherdetails teacherdetails) async {
    File file = await FilePicker.getFile(type: FileType.IMAGE);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
    Navigator.of(context).pop();
    AddsTeacherdialog(action,"norefresh",teacherdetails);
  }

  DateTime dob = null;
  TextEditingController name= new TextEditingController(),email = new TextEditingController(),phone = new TextEditingController(),profession = new TextEditingController(),
      specalization = new TextEditingController(),address = new TextEditingController(),gender = new TextEditingController(),showonwebsite = new TextEditingController(),
      password = new TextEditingController(),confirmpassword = new TextEditingController(),statuscon = new TextEditingController(),facebookurl = new TextEditingController(),
      twitterurl = new TextEditingController(),linkdinurl = new TextEditingController();

  AddsTeacherdialog(String action, String status, Teacherdetails teacherdetails) async {
    String titlename = "Add Teacher",save='';
    IconData icon = null;
    String dateofbirth ="";

    if(status == 'refresh') {
      if (action == "new") {
        name.text = '';
        email.text = '';
        phone.text = '';
        specalization.text ='';
        gender.text='';
        showonwebsite.text='';
        twitterurl.text='';
        statuscon.text='';
        facebookurl.text='';
        linkdinurl.text='';
        _file = null;
        fileext= "";
        filename= "";
        dob=null;
        address.text = '';
        credentials = false;
        titlename = "Add Teacher";
        icon = Icons.add;
        save = "Add Teacher";
      }
      else {
        var url = await Constants().Clienturl() + Constants.Edit_Teacher_Getdetails;
        Map<String, String> body = new Map();
        body['teacher_id'] = teacherdetails.id;
        print("url is $url"+"body--"+body.toString());

        http.post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
            .then((response) {
          if (response.statusCode == 200) {
            print("response --> ${response.body}");
            var responseJson = json.decode(response.body);
            print("response json ${responseJson}");
            if(responseJson['status'].toString() == "true"){
              Map data = responseJson["result"];
              Map sociallink = json.decode(responseJson["result"]['social_links'])[0];

              name.text = data['name'].toString();
              email.text = data['email'].toString();
              phone.text = data['phone'].toString();
              address.text = data['address'].toString();
              credentials = false;
              specalization.text =data['designation'].toString();
              gender.text=data['sex'];
              showonwebsite.text=data['show_on_website'].toString();
              twitterurl.text= sociallink['twitter'].toString();
              statuscon.text="";
              facebookurl.text=sociallink['facebook'].toString();
              linkdinurl.text=sociallink['linkedin'].toString();
              _file = null;
              fileext= "";
              filename= "";
              dob = null;
              dateofbirth = data['birthday'].toString();
            }
          }
          else {
            print("erroe--"+response.body);
          }
        });
        titlename = "Edit Teacher Info";
        icon = Icons.edit;
        save = "Save";
      }
    }
    else{
      if (action == "new") {
        titlename = "Add Teacher";
        icon = Icons.add;
        save = "Add Teacher";
      }
      else {
        titlename = "Edit Teacher Info";
        icon = Icons.edit;
        save = "Save";
      }
    }
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
                new SizedBox(height: 10,width: 10,),
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
                              icon,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text(titlename,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 10,width: 10,),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller:  name,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Specalization *",
                      prefixIcon: new Icon(FontAwesomeIcons.users)
                  ),
                  controller:  specalization,
                )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Gender *",
                          prefixIcon: new Icon(FontAwesomeIcons.list),
                        ),
                        controller: gender,
                        enabled: false,
                      ),
                      onTap: () {
                        _navigatetogender(context,action,teacherdetails);
                      },
                    )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date Of Birth *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: dob == null ? dateofbirth :  new DateFormat('yyyy-MM-dd').format(dob)),
                      ),
                      onTap: (){
                        _selectDateofbirth(context,action,teacherdetails);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Phone *",
                    prefixIcon: new Icon(Icons.phone),
                  ),
                  controller:  phone,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  email,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Address *",
                      prefixIcon: new Icon(Icons.location_on)
                  ),
                  controller: address,
                )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Show On Website *",
                          prefixIcon: new Icon(FontAwesomeIcons.list),
                        ),
                        controller: showonwebsite,
                        enabled: false,
                      ),
                      onTap: () {

                      },
                    )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Status *",
                          prefixIcon: new Icon(FontAwesomeIcons.list),
                        ),
                        controller: statuscon,
                        enabled: false,
                      ),
                      onTap: () {

                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Facebook URL *",
                      prefixIcon: new Icon(FontAwesomeIcons.facebook)
                  ),
                  controller: facebookurl,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Linkedin URL *",
                      prefixIcon: new Icon(FontAwesomeIcons.linkedin)
                  ),
                  controller: linkdinurl,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Twitter URL *",
                      prefixIcon: new Icon(FontAwesomeIcons.twitter)
                  ),
                  controller: twitterurl,
                )),
                new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Upload File *",
                          prefixIcon: new Icon(Icons.file_upload),
                          suffixIcon: _file == null ? new Icon(Icons.cloud_upload) : new Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new FileImage(_file)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        controller: TextEditingController(text:  _file == null ? "" : filename),
                        enabled: false,
                      ),
                      onTap: () {
                        _getFile(action,teacherdetails);
                      },
                    )),
                new Container(
                    child: ListTile(
                      leading: new Checkbox(value: credentials, onChanged: (val){
                        setState(() {
                          credentials = val;
                        });
                        AddsTeacherdialog(action,"norefresh",teacherdetails);
                      },activeColor: Colors.green,),
                      title: new Text("Send Credentials via SMS",style: TextStyle(fontSize: 11),),
                      trailing: new Icon(FontAwesomeIcons.questionCircle),
                    )
                ),
                new SizedBox(width: 30,height: 30,),
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
                                Navigator.of(context).pop();
                                AddsTeacherdialog("new","refresh",teacherdetails);
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
                                if(name.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter name");
                                  return;
                                }
                                if(specalization.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter specalization");
                                  return;
                                }
                                if(gender.text == ""){
                                  Constants().ShowAlertDialog(context, "Please select gender");
                                  return;
                                }
                                if(dob == ""){
                                  Constants().ShowAlertDialog(context, "Please select date of birth");
                                  return;
                                }
                                if(phone.text == null){
                                  Constants().ShowAlertDialog(context, "Please enter phone no");
                                  return;
                                }
                                if(phone.text != null && phone.text.length !=10){
                                  Constants().ShowAlertDialog(context, "Please enter 10 digit phone no");
                                  return;
                                }
                                if(email.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter email");
                                  return;
                                }

                                if(action=="new")
                                  CreateTeacher(action, "");
                                else
                                  CreateTeacher(action, teacherdetails.id);
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
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text(save,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
                                    ],
                                  )))),flex: 1,),
                    ],
                  ),
                )
              ],
            )

        );
      },
    );
  }

  Editpassword(Teacherdetails teacherdetails) async {
    password.text = '';
    confirmpassword.text= '';
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
                new SizedBox(height: 10,width: 10,),
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
                              Icons.lock_open,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Edit Password",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 10,width: 10,),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Name *",
                      prefixIcon: new Icon(Icons.person_outline)
                  ),
                  controller:  TextEditingController(text: teacherdetails.name),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Email *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  TextEditingController(text: teacherdetails.email),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Phine *",
                      prefixIcon: new Icon(Icons.phone)
                  ),
                  controller:  TextEditingController(text: teacherdetails.phone),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password *",
                      prefixIcon: new Icon(Icons.lock_open)
                  ),
                  controller: password,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Confirm Password *",
                      prefixIcon: new Icon(Icons.lock_open)
                  ),
                  controller: confirmpassword,
                )),
                new SizedBox(width: 30,height: 30,),
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
                                Navigator.of(context).pop();
                                Editpassword(teacherdetails);
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
                                EditTeacherPassword(teacherdetails.id);
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
            )
        );
      },
    );
  }

  deletedialog(Teacherdetails teacherdetails) async {
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
                                      Delete(teacherdetails.id);
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

  File _csvfile = null;
  String csvfileext= "",csvfilename= "";
  Future _getcsvFile() async {
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _csvfile = file;
    });
    csvfileext = await AppUtil.getFileExtension(_csvfile);
    csvfilename = await AppUtil.getFileNameWithExtension(_csvfile);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Manage Teacher"),
        backgroundColor: Color(0xff182C61),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
              margin: EdgeInsets.only(top: 30),
              child: new Text("Manage Teacher",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 80,right: 5,left: 5),
            child: new ListView(
              children: <Widget>[
                new Stack(
                  children: <Widget>[
                    new Card(
                      margin: new EdgeInsets.only(left: 10, right: 10, bottom: 10,top: 25),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: new ListView(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          new SizedBox(height: 30,width: 30,),
                          new Container(
                              margin: EdgeInsets.symmetric(vertical:10.0,horizontal: 20),
                              color: Theme.of(context).primaryColor,
                              child: new InkWell(
                                child: new ListTile(
                                    title: new Text("Sample Format Download",style: TextStyle(color:  Colors.white,fontSize: 11),),
                                    leading: new Icon(FontAwesomeIcons.fileCsv,color:  Colors.white),
                                    trailing: new Icon(FontAwesomeIcons.download,color:  Colors.white)
                                ),
                                onTap: () {

                                },
                              )
                          ),
                          new Container(
                              margin: EdgeInsets.symmetric(vertical:10.0,horizontal: 20),
                              color: Colors.grey[200],
                              child: new InkWell(
                                child: new TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "Select CSV File",
                                      prefixIcon: new Icon(FontAwesomeIcons.fileCsv),
                                      suffixIcon: new Icon(FontAwesomeIcons.fileUpload)
                                  ),
                                  controller: TextEditingController(text:  _file == null ? "" : filename),
                                  enabled: false,
                                ),
                                onTap: () {
                                  _getcsvFile();
                                },
                              )),
                          new SizedBox(height: 20,width: 20,),
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
                                                  new Icon(FontAwesomeIcons.search,color: Colors.white),
                                                  new Padding(
                                                    padding:
                                                    EdgeInsets.only(left: 15.0),
                                                    child: Text(
                                                      "Search",
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
                    new Align(
                        alignment: Alignment.topRight,
                        child: new InkWell(child:new Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.yellow[800],
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 5.0,
                              ),]
                          ),
                          child: new Icon(Icons.add,color: Colors.white,size: 20,),
                        ),onTap: (){
                          AddsTeacherdialog("new", "refresh", null);
                        },
                        )
                    )
                  ],
                ),
                new Card(
                  margin: new EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 5,
                  child: new ListTile(
                    leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
                    title: new TextField(
                      controller: controller,
                      decoration: new InputDecoration(
                          hintText: 'Search your things..', border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
                      onPressed: () {
                        controller.clear();
                        onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
                new Card(
                  margin: new EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 5,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(child: new Padding(child: new Text("Manage Teacher",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                              new Expanded(child:  new Container(
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 2,color: Colors.grey[300]))),
                                child: new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200]),
                                  child: new SvgPicture.asset(
                                    "assets/excel.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),),flex: 2,),
                              new Expanded(child:  new Container(
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 2,color: Colors.grey[300]))),
                                child: new Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                  ),
                                  child: new SvgPicture.asset(
                                    "assets/pdf.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),),flex: 2,),
                              new Expanded(child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200]),
                                child: new SvgPicture.asset(
                                  "assets/printer.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                padding: EdgeInsets.all(10),
                              ),flex: 2,),
                            ],
                          )
                      ),
                      new Container(height: 2,width: double.infinity,color: Theme.of(context).primaryColor,),
                      new Container(
                        padding: new EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: Text("Teacher ID"),
                              ),
                              DataColumn(
                                label: Text("Photo"),
                              ),
                              DataColumn(
                                label: Text("Name"),
                              ),
                              DataColumn(
                                label: Text("Email/User"),
                              ),
                              DataColumn(
                                label: Text("Actions"),
                              ),
                            ],
                            rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                            _searchResult.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text("#"+user.id),
                                    ),
                                    DataCell(
                                      new Container(
                                        width: 35.0,
                                        height: 35.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(user.photo)
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[300],
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(10),
                                      ),
                                    ),
                                    DataCell(
                                      Text(user.name),
                                    ),
                                    DataCell(
                                      Text(user.email),
                                    ),
                                    DataCell(
                                      new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                    ),
                                  ]),
                            ).toList()
                                : _Teacherdetails.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text("#"+user.id),
                                    ),
                                    DataCell(
                                      new Container(
                                        width: 35.0,
                                        height: 35.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(user.photo)
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[300],
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.all(10),
                                      ),
                                    ),
                                    DataCell(
                                      Text(user.name),
                                    ),
                                    DataCell(
                                      Text(user.email),
                                    ),
                                    DataCell(
                                      new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                    ),
                                  ]),
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),

    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Teacherdetails.forEach((vehicleDetail) {
      if (vehicleDetail.phone.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.email.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Teacherdetails> _searchResult = [];
  List<Teacherdetails> _Teacherdetails = [];

}
