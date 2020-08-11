import 'dart:collection';
import 'dart:io';
import 'package:Edecofy/search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'AppUtils.dart';
import 'FilePicker.dart';
import 'const.dart';
import 'dashboard.dart';


class StudentstabsPage extends StatefulWidget {
  final String id;
  StudentstabsPage({this.id});

  @override
  State<StatefulWidget> createState() => new _StudentstabsPageState();
}

class _StudentstabsPageState extends State<StudentstabsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  List<Tab> tabs = new List();
  List<Widget> tabsbody = new List();
  List<String> parentslist = new List(),sectionslist = new List();
  Map<String,String> parentmap = new HashMap(),sectionmap = new HashMap();
  String sectionname ="" , parentname="";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    tabs.add(new Tab(text : "All Students"));
    tabsbody.add(new StudentsiformationPage(sectionid:null,classid: widget.id,),);
    Loadsectionstabs();
  }

  Future<Null> Loadsectionstabs() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.id;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            tabs.add(new Tab(text : "Section - "+data['section_name'].toString()));
            tabsbody.add(new StudentsiformationPage(sectionid:data['section_id'].toString(),classid: widget.id,),);
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

  AddsStudentdialog(String action,Studentdetails studentdetails) async {
    String titlename = "Add Student";
    IconData icon = Icons.add;

    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                AddStudentsPage(type: action,studentdetails: studentdetails,id: widget.id,)
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
        title: Text("Student Information"),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),*/
      ),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
//            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 20,height: 20,),
//                    new Text("All Students Information",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Container(
              margin: new EdgeInsets.only(left: 15,right: 5,bottom: 0,top: 0),
              child : new Stack(
                children: <Widget>[
                  new Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.only(top: 30,right: 10),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _loading ? new Constants().bodyProgress :
                    new DefaultTabController(
                        length: tabs.length,
                        child: new Scaffold(
                          appBar: TabBar(
                            unselectedLabelColor: Colors.grey,
                            labelColor: Theme.of(context).primaryColor,
                            tabs: tabs,
                            isScrollable: true,
                            controller: _tabController,
                            indicatorColor: Theme.of(context).primaryColor,
                          ),
                          body: TabBarView(
                            children: tabsbody,
                            controller: _tabController,
                          ),
                        )),
                  ),
//                  new Align(
//                      alignment: Alignment.topRight,
//                      child: new InkWell(child:new Container(
//                        width: 45,
//                        height: 45,
//                        alignment: Alignment.center,
//                        decoration: BoxDecoration(
//                            color: Colors.yellow[800],
//                            shape: BoxShape.circle,
//                            boxShadow: [BoxShadow(
//                              color: Colors.grey[300],
//                              blurRadius: 5.0,
//                            ),]
//                        ),
//                        child: new Icon(Icons.add,color: Colors.white,size: 20,),
//                      ),onTap: (){
//                        AddsStudentdialog("new",null);
//                      },
//                      )
//                  )
                ],
              ))
        ],
      ),
    );
  }
}

class StudentsiformationPage extends StatefulWidget {
  final String sectionid,classid;
  StudentsiformationPage({this.sectionid,this.classid});

  @override
  State<StatefulWidget> createState() => new _StudentsiformationPageState();
}

class _StudentsiformationPageState extends State<StudentsiformationPage> with SingleTickerProviderStateMixin{
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  List<String> parentslist = new List(),sectionslist = new List();
  Map<String,String> parentmap = new HashMap(),sectionmap = new HashMap();
  String sectionname ="" , parentname="";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadStudents();
  }

  Future<Null> LoadStudents() async {
    String empid = await sp.ReadString("Userid");
    var url = '';

    if(widget.sectionid == null)
      url = await Constants().Clienturl() + Constants.Load_AllStudents+widget.classid;
    else
      url = await Constants().Clienturl() + Constants.Load_SectionswiseStudents+widget.classid+"/"+widget.sectionid;

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
            if(widget.sectionid == null) {
              for (Map user in responseJson['result']['std_all']) {
                _Studentdetails.add(Studentdetails.fromJson(user));
              }
            }
            else{
              for (Map user in responseJson['result']['std_section_wise']) {
                _Studentdetails.add(Studentdetails.fromJson(user));
              }
            }
          }catch(e){
            _Studentdetails = new List();
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

  AddsStudentdialog(String action,Studentdetails studentdetails) async {
    String titlename = "Edit Student Info",save='';
    IconData icon = Icons.edit;

    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                AddStudentsPage(type: action,studentdetails: studentdetails,id: widget.classid,)
              ],
            )

        );
      },
    );
  }

  Future<Null> EditPassword(String studentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Edit_Password_Student;

    Map<String, String> body = new Map();
    body['type_page'] = "do_update_pwd";
    body['student_id'] = studentid;
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
          Constants().ShowAlertDialog(context, responseJson['message']);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> DeleteApi(String studentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Delete_Student+studentid;

    Map<String, String> body = new Map();
    body['student_id'] = studentid;

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
          Constants().ShowSuccessDialog(context, "Student deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadStudents();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Student not deleted succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  TextEditingController password = new TextEditingController(),confirmpassword = new TextEditingController();

  Editpassword(Studentdetails studentdetails) async {
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
                  controller:  TextEditingController(text: studentdetails.name),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  TextEditingController(text: studentdetails.email),
                  enabled: false,
                )),
                /*new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Phone *",
                      prefixIcon: new Icon(Icons.phone)
                  ),
                  controller:  TextEditingController(text: studentdetails.phone),
                  enabled: false,
                )),*/
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
                                Editpassword(studentdetails);
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
                                if(password.text == ""){
                                  Constants().ShowAlertDialog(context, "Please fill new password");
                                  return;
                                }
                                if(confirmpassword.text == ""){
                                  Constants().ShowAlertDialog(context, "Please fill confirm new password");
                                  return;
                                }
                                if(confirmpassword.text != password.text){
                                  Constants().ShowAlertDialog(context, "Please enter password same as new password");
                                  return;
                                }
                                EditPassword(studentdetails.id);
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

  deletedialog(Studentdetails studentdetails) async {
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
                                      DeleteApi(studentdetails.id);
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

//  Widget _abc(Studentdetails user)=ExapandableMenu()>;

  Widget _EdittPopup(Studentdetails user) => PopupMenuButton<int>(
    itemBuilder: (context) => [
/*
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
                child: new Icon(FontAwesomeIcons.fileInvoice,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Marksheet",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
*/
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

    ],
    elevation: 5,
    padding: EdgeInsets.symmetric(horizontal: 10),
    onSelected: (value) {
      print(value);
      if(value == 2)
        AddsStudentdialog("edit", user);
//      if(value == 3)
//        Editpassword(user);
//      if(value == 5)
//        deletedialog(user);
    },
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(5.0),
        child: new ListView(
          children: <Widget>[
            new Card(
              margin: new EdgeInsets.all(5),
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
//                trailing: new IconButton(
//                  icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                  onPressed: () {
//                    controller.clear();
//                    onSearchTextChanged('');
//                  },
//                ),
              ),
            ),
            new SizedBox(width: 5,height: 5,),
            _Studentdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 10,
                columns: [
//                  DataColumn(
//                    label: Text("Std Admission",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
//                  ),
                  DataColumn(
                    label: Text("Std ID",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                  ),
                  DataColumn(
                    label: Text("Name",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                  ),
                  DataColumn(
                    label: Text("Photo",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                  ),
                  DataColumn(
                    label: Text("Email",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                  ),
                  DataColumn(
                    label: Text("Actions",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                  ),
                ],
                rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                _searchResult.map(
                      (user) => DataRow(
                      cells: [
//                        DataCell(
//                          Text(user.admisssionno),
//                        ),
                        DataCell(
                          Column(
                            children: <Widget>[
                              Text(user.studentcode),

                            ],
                          ),
                        ),
                        /*DataCell(
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
                        ),*/

                        DataCell(
                          Text(user.name),
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
                          Text(user.email),
                        ),
                        DataCell(
                          new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                        ),
                      ]),
                ).toList()
                    : _Studentdetails.map(
                      (user) => DataRow(
                      cells: [
//                        DataCell(
//                          Text(user.admisssionno),
//                        ),
                        DataCell(
                          Text(user.studentcode),
                        ),
                        /*DataCell(
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
                        ),*/
                        DataCell(
                          Text(user.name),
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
                          Text(user.email),
                        ),
                        DataCell(
                          new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                        ),
                      ]),
                ).toList(),
              ),
            ),

          ],
        ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Studentdetails.forEach((studentDetail) {
      if (studentDetail.email.toLowerCase().contains(text.toLowerCase())
          || studentDetail.id.toLowerCase().contains(text.toLowerCase()) || studentDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(studentDetail);
    });

    setState(() {});
  }

  List<Studentdetails> _searchResult = [];
  List<Studentdetails> _Studentdetails = [];

}

class AddStudentsPage extends StatefulWidget {
  final Studentdetails studentdetails;
  final String type;
  final String id;
  AddStudentsPage({this.type,this.studentdetails,this.id});

  @override
  State<StatefulWidget> createState() => new _AddlasssPagePageState();
}

class _AddlasssPagePageState extends State<AddStudentsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  String date1="",save="";IconData icon = null;
  List<String> parentslist = new List(),sectionslist = new List(),transportlist = new List(),dormitorylist = new List(),classlist = new List() ;
  Map<String,String> parentmap = new HashMap(),sectionmap = new HashMap(),transportmap = new HashMap(),dormitorymap = new HashMap(),classmap = new HashMap(),
      revparentmap = new HashMap(),revsectionmap = new HashMap(),revtransportmap = new HashMap(),revdormitorymap = new HashMap();
  String sectionname ="" , parentname="",dormitoryname ="" , transportname="",classname="";

  Future<Null> Loadstudentdata() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Get_Student_Singledata;
    Map<String, String> body = new Map();
    body['student_id'] = widget.studentdetails.id;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          debugPrint("response json ${responseJson}");
          name.text = responseJson['result']['name'].toString();
          lastname.text = responseJson['result']['last_name'].toString();
          email.text = responseJson['result']['email'].toString();
          phone.text = responseJson['result']['phone'].toString();
          address.text = responseJson['result']['address'].toString();
          studentcode.text =responseJson['result']['code'].toString();
          gender.text=responseJson['result']['sex'].toString();
          aadharno.text=responseJson['result']['adhar_no'].toString();
          stream.text=responseJson['result']['stream'].toString();
          password.text=responseJson['result']['password'].toString();
          dob=null;
          doj=new DateTime.now();
          optsub.text = responseJson['result']['opt_sub'].toString();
          bloodgroup.text = responseJson['result']['blood_group'].toString();
          nationality.text = responseJson['result']['nationality'].toString();
          result.text = responseJson['result']['result'].toString();
          religion.text = responseJson['result']['religion'].toString();
          category.text = responseJson['result']['catagory'].toString();
          mothertongue.text = responseJson['result']['mother_tongue'].toString();
          minority.text = responseJson['result']['minority'].toString();
          accno.text = responseJson['result']['ac_no'].toString();
          bankname.text = responseJson['result']['bank_name'].toString();
          ifsccode.text = responseJson['result']['ifsc_code'].toString();
          branchname.text = responseJson['result']['branch_name'].toString();
          schoolname.text = responseJson['result']['school_name'].toString();
          year.text = responseJson['result']['year'].toString();
          last_class_medium.text = responseJson['result']['last_class_medium'].toString();
          last_class_rollno.text = responseJson['result']['last_class_roll_no'].toString();
          last_class_board.text = responseJson['result']['last_class_board'].toString();
          firstlan.text = responseJson['result']['first_language'].toString();
          seclan.text = responseJson['result']['second_language'].toString();
          district.text = responseJson['result']['district_name'].toString();
          mandal.text = responseJson['result']['mandal_name'].toString();
          rural.text = responseJson['result']['rural'].toString();
          admission.text = widget.studentdetails.admisssionno;
          studentid.text = responseJson['result']['student_code'].toString();
          sectionname = responseJson['result']['section_id'] == null || responseJson['result']['section_id'] == "" ? "" : revsectionmap[responseJson['result']['section_id'].toString()].toString();
          parentname = responseJson['result']['parent_id'] == null || responseJson['result']['parent_id'] == "" ? "" : revparentmap[responseJson['result']['parent_id'].toString()].toString();
          transportname =  responseJson['result']['transport_id'] == null || responseJson['result']['transport_id'] == "" ? "" : revparentmap[responseJson['result']['transport_id'].toString()].toString();
          dormitoryname = responseJson['result']['dormitory_id'] == null || responseJson['result']['dormitory_id'] == "" ? "" : revparentmap[responseJson['result']['dormitory_id'].toString()].toString();
          dob1=responseJson['result']['birthday'].toString();
          doj1=responseJson['result']['doj'].toString();
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

  Future<Null> Loadparents(String repeat) async {
    String id = await sp.ReadString("Userid");
    parentslist.clear();
    var url = await Constants().Clienturl() + Constants.Load_Parents;
    Map<String, String> body = new Map();

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            parentslist.add(data['name']);
            parentmap[data['name']] = data['parent_id'];
            revparentmap[data['parent_id']] = data['name'];
          }
        }
        if(repeat == "repeat")
          Loadtransport();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> Loadtransport() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.LoadTransport_Admin;
    Map<String, String> body = new Map();

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            transportlist.add(data['route_name']);
            transportmap[data['route_name']] = data['transport_id'];
            revtransportmap[data['transport_id']] = data['route_name'];
          }
        }
        Loaddormitary();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> Loaddormitary() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.LoadDormitory_Admin;
    Map<String, String> body = new Map();

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            dormitorylist.add(data['name']);
            dormitorymap[data['name']] = data['dormitory_id'];
            revdormitorymap[data['dormitory_id']] = data['name'];
          }
        }
        if(widget.id == null)
          LoadCLassdetails();
        else
          Loadsectionstabs();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> Loadsectionstabs() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.id;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            sectionslist.add(data['section_name']);
            sectionmap[data['section_name']] = data['section_id'];
            revsectionmap[data['section_id']] = data['section_name'];
          }
        }
        if(widget.type == "new") {
          LoadStudentvalues();
        }
        else
          Loadstudentdata();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> LoadStudentvalues() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + "api_admin/get_student_default_values";
    Map<String, String> body = new Map();

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          admission.text = responseJson['results']['admission_no'];
          studentid.text = responseJson['results']['student_code'];
          email.text = responseJson['results']['email'];
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

  Future<Null> Loadsections(String classid) async {
    String id = await sp.ReadString("Userid");
    sectionslist.clear();
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = classid;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        Navigator.of(context).pop();
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            sectionslist.add(data['section_name']);
            sectionmap[data['section_name']] = data['section_id'];
            revsectionmap[data['section_id']] = data['section_name'];
          }
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }
  LoadCLassdetails() async{
    Map body = new Map();
    var url = await Constants().Clienturl() + Constants.Load_Classes_Admin;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            classlist.add(data['class_name']);
            classmap[data['class_name']] = data['class_id'];
          }
        }
        LoadStudentvalues();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Dio dio = new Dio();

  Future<Null> CreateStudent(String type,Studentdetails studentdetails) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url="";
    if(type == "new")
      url = await Constants().Clienturl() + Constants.Create_Student;
    else
      url = await Constants().Clienturl() + Constants.Create_Student;

    Map<String,dynamic> body = new Map();
    if(type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['student_id'] = studentdetails.id;
    }
    body['name'] = name.text;
    body['student_code'] = "code";
    body['last_name'] = lastname.text;
    body['email'] = email.text;
    body['password'] = password.text;
    body['phone'] = phone.text;
    body['adhar_no'] = aadharno.text;
    body['stream'] = stream.text;
    body['birthday'] = dob == null ? dob1 : new DateFormat('yyyy-MM-dd').format(dob);
    body['sex'] = gender.text;
    body['doj'] = doj == null ? doj1 :  new DateFormat('yyyy-MM-dd').format(doj);
    body['blood_group'] = bloodgroup.text;
    body['opt_sub'] = optsub.text;
    body['nationality'] = nationality.text;
    body['religion'] = religion.text;
    body['mother_tongue'] = mothertongue.text;
    body['catagory'] = category.text;
    body['minority'] = minority.text;
    body['ac_no'] = accno.text;
    body['address']=address.text;
    body['bank_name'] = bankname.text;
    body['ifsc_code'] = ifsccode.text;
    body['branch_name'] = branchname.text;
    body['school_name'] = schoolname.text;
    body['result'] = result.text;
    body['Year'] = year.text;
    body['last_class_roll_no'] = last_class_rollno.text;
    body['last_class_medium'] = last_class_medium.text;
    body['last_class_board'] = last_class_board.text;
    body['first_language'] = firstlan.text;
    body['second_language'] = seclan.text;
    body['district_name'] = district.text;
    body['mandal_name'] = mandal.text;
    body['admission_no'] = "enroll_code";
    body['student_code'] = studentid.text;
    body['rural'] = rural.text;
    body['class_id'] = widget.id == null ? classmap[classname] : widget.id;
    body['section_id'] = sectionmap[sectionname];
    body['parent_id'] = parentmap[parentname];
    body['transport_id'] = transportname == "" ? "" : transportmap[transportname].toString();
    body['dormitory_id'] = dormitoryname == "" ? "" : dormitorymap[dormitoryname].toString();
    body['userfile'] = _file == null ? "" : new UploadFileInfo(_file, await AppUtil.getFileNameWithExtension(_file));

    print("url is $url"+"body--"+body.toString());

    dio.options.baseUrl = url;
    dio.options.connectTimeout = 120000; //5s
    dio.options.receiveTimeout=5000;
    FormData formData = new FormData.from(body);
    // Send FormData
    try {
      Response response = await dio.post("", data: formData);
      if (response.statusCode == 200) {
        print("response --> ${response.data}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.data);
        if(responseJson['status'].toString() == "true"){
          if(type == "edit")
            Constants().ShowSuccessDialog(context, "Student updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Student added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            if(widget.id == null)
              Navigator.of(context).pop();
            else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new StudentstabsPage(id: widget.id,)));
            }
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, responseJson['message']);
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

  File _file = null;
  String fileext= "",filename= "";
  Future _getFile() async {
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<Null> _selectDateofbirth(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-30),
          lastDate:  DateTime.now());

      if (picked != null && picked != dob) {
        print('date selected : ${dob.toString()}');
        setState(() {
          dob = picked;
        });
      }
      FocusScope.of(context).requestFocus(FocusNode());
    }catch(e){e.toString();}
  }

  Future<Null> _selectDateofjoining(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != doj) {
        print('date selected : ${doj.toString()}');
        setState(() {
          doj = picked;
        });
      }
      FocusScope.of(context).requestFocus(FocusNode());
    }catch(e){e.toString();}
  }

  _navigatetogender(BuildContext context) async {
    List<String> Genderlist= new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(context, "Gender", Genderlist);
    setState(() {
      gender.text = result ?? gender.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _navigatetominority(BuildContext context) async {
    List<String> minotitylist= new List();
    minotitylist.add("Yes");
    minotitylist.add("No");
    String result = await Constants().Selectiondialog(context, "Minority", minotitylist);
    setState(() {
      minority.text = result ?? minority.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _navigatetoclass1(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Class",duplicateitems: classlist,)),
    );
    setState(() {
      classname = result ?? classname;
    });
    print("res--"+result.toString());
    if(result !=null)
      Loadsections(classmap[classname]);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _navigatetosections(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Sections",duplicateitems: sectionslist,)),
    );
    setState(() {
      sectionname = result ?? sectionname;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _navigatetoparents(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Parents",duplicateitems: parentslist,)),
    );
    setState(() {
      parentname = result ?? parentname;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _navigatetoonlychild(BuildContext context) async {
    List<String> minotitylist= new List();
    minotitylist.add("Yes");
    minotitylist.add("No");
    String result = await Constants().Selectiondialog(context, "Only Child (Yes/No)", minotitylist);
    setState(() {
      only_child.text = result ?? only_child.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }
  _navigatetogender_parent(BuildContext context) async {
    List<String> Genderlist= new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(context, "Gender", Genderlist);
    setState(() {
      moth_sex.text = result ?? moth_sex.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }
  _navigatetogender1(BuildContext context) async {
    List<String> Genderlist= new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(context, "Gender", Genderlist);
    setState(() {
      p_sex.text = result ?? p_sex.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }
  _navigatetotransport1(BuildContext context) async {
    List<String> minotitylist= new List();
    minotitylist.add("Yes");
    minotitylist.add("No");
    String result = await Constants().Selectiondialog(context, "School Transport", minotitylist);
    setState(() {
      school_tranport.text = result ?? school_tranport.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _navigatetotransport(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Transport",duplicateitems: transportlist,)),
    );
    setState(() {
      transportname = result ?? transportname;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _navigatetodormitory(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Dormitory",duplicateitems: dormitorylist,)),
    );
    setState(() {
      dormitoryname = result ?? dormitoryname;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  TextEditingController p_name= new TextEditingController(),p_email = new TextEditingController(),p_phone = new TextEditingController(),profession = new TextEditingController(),
      status = new TextEditingController(),p_address = new TextEditingController(), p_sex=new TextEditingController(),p_qualification = new TextEditingController(),p_income = new TextEditingController(),
      p_pincode = new TextEditingController(),p_offieceaddress = new TextEditingController(),p_password = new TextEditingController(),
      moth_name= new TextEditingController(),moth_email = new TextEditingController(),moth_phone = new TextEditingController(),moth_profession = new TextEditingController(),
      moth_qualification = new TextEditingController(),moth_income = new TextEditingController(),moth_sex = new TextEditingController(),
      moth_pincode = new TextEditingController(),moth_offieceaddress = new TextEditingController(),   moth_pwd = new TextEditingController(),    moth_status = new TextEditingController(),moth_address = new TextEditingController(),guardian_name= new TextEditingController(),guardian_childname1 = new TextEditingController(),guardian_phone = new TextEditingController(),
      guardian_childclass1 = new TextEditingController(),guardian_childsection1 = new TextEditingController(),guardian_address = new TextEditingController(),only_child = new TextEditingController(),school_tranport = new TextEditingController(),
      guardian_pincode = new TextEditingController(),guardian_area = new TextEditingController(),guardian_childname2 = new TextEditingController(),
      guardian_childclass2 = new TextEditingController(),guardian_childsection2 = new TextEditingController();

  AddsParentdialog() async {
    String titlename = "Add Parent";
    p_name.text = '';
    p_email.text = '';
    p_phone.text = '';
    p_password.text='';
    profession.text = '';
    status.text = '';
    p_sex.text='';
    p_income.text = '';
    p_pincode.text = '';
    p_qualification.text = '';
    p_offieceaddress.text = '';
    p_address.text='';
    moth_name.text = '';
    moth_email.text = '';
    moth_pwd.text='';
    moth_phone.text = '';
    moth_profession.text = '';
    moth_status.text = '';
    moth_address.text='';
    moth_sex.text = '';
    moth_income.text = '';
    moth_pincode.text = '';
    moth_qualification.text = '';
    moth_offieceaddress.text = '';
    guardian_name.text = '';
    only_child.text='';
    guardian_childclass1.text = '';
    guardian_childsection1.text='';
    guardian_childname1.text = '';
    guardian_childclass2.text = '';
    guardian_childsection2.text='';
    guardian_childname2.text = '';
    guardian_area.text = '';
    guardian_phone.text = '';
    guardian_pincode.text = '';
    school_tranport.text = '';
    titlename = "Add Parent";

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
                              Icons.add,
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
                  controller:  p_name,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  p_email,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  // keyboardType: TextInputType.number,
                  // maxLength: 10,
                  decoration: InputDecoration(
                      labelText: "Password *",
                      prefixIcon: new Icon(Icons.remove_red_eye)
                  ),
                  controller:  p_password,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                      labelText: "Phone *",
                      prefixIcon: new Icon(Icons.phone)
                  ),
                  controller:  p_phone,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Profession *",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  profession,
                )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Gender",
                            prefixIcon: new Icon(FontAwesomeIcons.list),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
                        controller: p_sex,
                        enabled: false,
                      ),
                      onTap: () {
                        _navigatetogender1(context);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Qualification ",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  p_qualification,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Annual Income",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  p_income,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Residential Address *",
                      prefixIcon: new Icon(Icons.location_on)
                  ),
                  controller: p_address,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                      labelText: "Pin Code",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  p_pincode,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Office Address",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  //   controller:  offieceaddress,
                )),
                new ExpansionTile(title: new Text("Parent-2 (Optional)",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                  children: <Widget>[
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name *",
                          prefixIcon: new Icon(FontAwesomeIcons.user)
                      ),
                      controller:  moth_name,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Email/Username *",
                          prefixIcon: new Icon(Icons.mail_outline)
                      ),
                      controller:  moth_email,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      // keyboardType: TextInputType.number,
                      // maxLength: 10,
                      decoration: InputDecoration(
                          labelText: "Password *",
                          prefixIcon: new Icon(Icons.remove_red_eye)
                      ),
                      controller:  moth_pwd,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          labelText: "Phone *",
                          prefixIcon: new Icon(Icons.phone)
                      ),
                      controller:  moth_phone,
                    )),
                    new Container(
                        margin: EdgeInsets.all(5.0),
                        child: new InkWell(
                          child: new TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Gender",
                                prefixIcon: new Icon(FontAwesomeIcons.list),
                                suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                            ),
                            controller: moth_sex,
                            enabled: false,
                          ),
                          onTap: () {
                            _navigatetogender_parent(context);
                          },
                        )),

                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Profession *",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_profession,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Qualification ",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_qualification,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Annual Income",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_income,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Address *",
                          prefixIcon: new Icon(Icons.location_on)
                      ),
                      controller: moth_address,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          labelText: "Pin Code",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_pincode,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Office Address",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_offieceaddress,
                    )),
                  ],),
                new ExpansionTile(title: new Text("Guardian - (Optional)",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                  children: <Widget>[
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name *",
                          prefixIcon: new Icon(FontAwesomeIcons.user)
                      ),
                      controller:  guardian_name,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          labelText: "Phone",
                          prefixIcon: new Icon(Icons.phone)
                      ),
                      controller:  guardian_phone,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          labelText: "Pin Code",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_pincode,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Residential Address",
                          prefixIcon: new Icon(Icons.place)
                      ),
                      controller:  guardian_address,
                    )),
                    new Container(
                        margin: EdgeInsets.all(5.0),
                        child: new InkWell(
                          child: new TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Only Child [Yes/No.]",
                                prefixIcon: new Icon(FontAwesomeIcons.list),
                                suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                            ),
                            controller: only_child,
                            enabled: false,
                          ),
                          onTap: () {
                            _navigatetoonlychild(context);
                          },
                        )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Name1",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_childname1,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Class1 ",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller: guardian_childclass1,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Section1",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_childsection1,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Name2",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_childname2,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Class2 ",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller: guardian_childclass2,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Section2",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_childsection2,
                    )),
                    new Container(
                        margin: EdgeInsets.only(top:5.0,left:5.0,bottom:5.0),
                        child: new InkWell(
                          child: new TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "School Transportation",
                                prefixIcon: new Icon(FontAwesomeIcons.list),
                                suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                            ),
                            controller: school_tranport,
                            enabled: false,
                          ),
                          onTap: () {
                            _navigatetotransport1(context);
                          },
                        )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Area",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_area,
                    )),
                  ],),
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
                                AddsParentdialog();
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
                                if(p_name.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter name");
                                  return;
                                }
                                if(p_email.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enetr email");
                                  return;
                                }
                                if(p_phone.text == null){
                                  Constants().ShowAlertDialog(context, "Please enter phone no");
                                  return;
                                }
                                if(p_phone.text != null && p_phone.text.length !=10){
                                  Constants().ShowAlertDialog(context, "Please enter 10 digit phone no");
                                  return;
                                }
                                if(profession.text == null){
                                  Constants().ShowAlertDialog(context, "Please enter profession");
                                  return;
                                }
                                if(p_address.text == null){
                                  Constants().ShowAlertDialog(context, "Please enter address");
                                  return;
                                }
                                CreateParent();
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

  Future<Null> CreateParent() async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url="";
    url = await Constants().Clienturl() + Constants.Create_Parent;

    Map<String, String> body = new Map();
    body['type_page'] = "create";
    body['name'] = p_name.text;
    body['email'] = p_email.text;
    body['password'] = p_password.text;
    body['phone'] = p_phone.text;
    body['profession'] = profession.text;
    body['qualification']=p_qualification.text;
    body['annual_income']=p_income.text;
    body['pin_code']=p_pincode.text;
    body['office_address']=p_offieceaddress.text;
    body['address'] = p_address.text;
    body['moth_name'] = moth_name.text;
    body['moth_email'] = moth_email.text;
    body['moth_password'] = moth_pwd.text;
    body['moth_phone'] = moth_phone.text;
    body['moth_address'] = moth_address.text;
    body['moth_profession'] = moth_profession.text;
    body['moth_qualification'] = moth_qualification.text;
    body['mother_annual_income'] = moth_income.text;
    body['moth_pin_code'] = moth_pincode.text;
    body['moth_office_address'] = moth_offieceaddress.text;
    body['gurdian_name'] = guardian_name.text;
    body['gurdian_phone'] = guardian_phone.text;
    body['gurdian_pin_code'] = guardian_pincode.text;
    body['gurdian_address'] = guardian_address.text;
    body['gurd_child_type'] =  only_child.text;
    body['guardian_child_name1'] = guardian_childname1.text;
    body['guardian_child_class1'] = guardian_childclass1.text;
    body['guardian_child_section1'] = guardian_childsection1.text;
    body['guardian_child_name2'] = guardian_childname2.text;
    body['guardian_child_class2'] = guardian_childclass2.text;
    body['guardian_child_section2'] = guardian_childsection2.text;

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
          Constants().ShowSuccessDialog(context, "Parent added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Loadparents("norepeat");
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context,responseJson['message'] );
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }


  DateTime dob = null,doj=new DateTime.now();
  TextEditingController name= new TextEditingController(),email = new TextEditingController(),phone = new TextEditingController(),lastname = new TextEditingController(),
      studentcode = new TextEditingController(),address = new TextEditingController(),gender = new TextEditingController(),aadharno = new TextEditingController(),
      parent = new TextEditingController(),dormitory = new TextEditingController(),password = new TextEditingController(),
      transport = new TextEditingController(),stream = new TextEditingController(),optsub = new TextEditingController(),bloodgroup = new TextEditingController(),nationality = new TextEditingController()
  ,religion = new TextEditingController(),mothertongue = new TextEditingController(),category = new TextEditingController(),minority = new TextEditingController()
  ,accno = new TextEditingController(),bankname = new TextEditingController(),ifsccode = new TextEditingController(),branchname = new TextEditingController(),schoolname = new TextEditingController(),
      result = new TextEditingController(),year = new TextEditingController(),last_class_medium = new TextEditingController(),last_class_rollno = new TextEditingController(),last_class_board = new TextEditingController()
  ,firstlan = new TextEditingController(),seclan = new TextEditingController(),district = new TextEditingController(),mandal = new TextEditingController(),rural = new TextEditingController(),
      admission = new TextEditingController(),studentid = new TextEditingController();
  String dob1="",doj1="";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });

    if (widget.type == "new") {
      name.text = '';
      lastname.text ='';
      email.text = '';
      phone.text = '';
      studentcode.text ='';
      gender.text='';
      aadharno.text='';
      stream.text='';
      address.text='';
      dob=null;
      admission.text="";
      doj=new DateTime.now();
      optsub.text = '';
      bloodgroup.text = '';
      nationality.text = '';
      result.text = '';
      religion.text = '';
      category.text = '';
      mothertongue.text = '';
      minority.text = '';
      accno.text = '';
      bankname.text = '';
      ifsccode.text = '';
      branchname.text = '';
      schoolname.text = '';
      year.text = '';
      last_class_medium.text = '';
      last_class_rollno.text = '';
      last_class_board.text = '';
      firstlan.text = '';
      seclan.text = '';
      district.text = '';
      mandal.text = '';
      rural.text = '';
      sectionname = '';
      parentname ='';
      transportname =  "";
      password.text =  "";
      dormitoryname = "";
      dob1="";
      doj1="";

      icon = Icons.add;
      save = "Add Student";
    }
    else {
      icon = Icons.edit;
      save = "Save";
    }
    Loadparents("repeat");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  _loading ? new Constants().bodyProgress : new ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: <Widget>[
        new SizedBox(height: 10,width: 10,),
        new Container(margin: new EdgeInsets.all(5.0),
            child : new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Date Of Joining *',
                  prefixIcon: new Icon(FontAwesomeIcons.calendar),
                ),
                enabled: false,
                controller: new TextEditingController(text: doj == null ? doj1 :  new DateFormat('dd-MM-yyyy').format(doj)),
              ),
              onTap: (){
                _selectDateofjoining(context);
              },
            )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Admission No *",
              prefixIcon: new Icon(FontAwesomeIcons.user)
          ),
          controller:  admission,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "First Name *",
              prefixIcon: new Icon(FontAwesomeIcons.user)
          ),
          controller:  name,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Last name *",
              prefixIcon: new Icon(FontAwesomeIcons.user)
          ),
          controller:  lastname,
        )),
        if(save =="Add Student")
        new Container(
            margin: new EdgeInsets.only(
              left: 5.0,
              right: 5.0,
            ),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Container(
                    child: new RaisedButton(
                      onPressed: () {
                        AddsParentdialog();
                      },
                      child: new Text(
                        "Add Parent",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme
                          .of(context)
                          .primaryColor,
                      splashColor: Colors.blueGrey,
                      shape: new RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(10.0)),
                    ),
                  ),
                  new InkWell(
                    child: new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Parent *",
                          prefixIcon: new Icon(FontAwesomeIcons.list),
                          suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                      ),
                      controller: new TextEditingController(text: parentname),
                      enabled: false,
                    ),
                    onTap: () {
                      _navigatetoparents(context);
                    },
                  )
                ])),
//        widget.id == null ?new Container(): new Container(
//            margin: EdgeInsets.all(5.0),
//            child: new InkWell(
//              child: new TextField(
//                keyboardType: TextInputType.text,
//                decoration: InputDecoration(
//                    labelText: "Class *",
//                    prefixIcon: new Icon(FontAwesomeIcons.list),
//                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
//                ),
//                controller: new TextEditingController(text: classname),
//                enabled: false,
//              ),
//              onTap: () {
//                _navigatetoclass1(context);
//              },
//            )),
        new Container(
            margin: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Section *",
                    prefixIcon: new Icon(FontAwesomeIcons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: new TextEditingController(text: sectionname),
                enabled: false,
              ),
              onTap: () {
                _navigatetosections(context);
              },
            )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Id No *",
              prefixIcon: new Icon(FontAwesomeIcons.user)
          ),
          controller:  studentid,
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
                controller: new TextEditingController(text: dob == null ? dob1 :  new DateFormat('dd-MM-yyyy').format(dob)),
              ),
              onTap: (){
                _selectDateofbirth(context);
              },
            )),
        new Container(
            margin: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Gender *",
                    prefixIcon: new Icon(FontAwesomeIcons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: gender,
                enabled: false,
              ),
              onTap: () {
                _navigatetogender(context);
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
          maxLength: 50,
          decoration: InputDecoration(
              labelText: "Email/Username *",
              prefixIcon: new Icon(Icons.mail_outline)
          ),
          controller:  email,
        )),
       if(save == "Add Student" )
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Password *",
              prefixIcon: new Icon(FontAwesomeIcons.lockOpen)
          ),
          controller:  password,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.number,
          maxLength: 16,
          decoration: InputDecoration(
              labelText: "Aadhar no ",
              prefixIcon: new Icon(Icons.confirmation_number)
          ),
          controller: aadharno,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Stream",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: stream,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Optional Subject ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: optsub,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Blood group ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: bloodgroup,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Nationality ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: nationality,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Religion ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: religion,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Mother tounge ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: mothertongue,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Category(SC/ST/OBC/GEN) ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: category,
        )),
        new Container(
            margin: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                maxLength: 30,
                decoration: InputDecoration(
                    labelText: "Minority",
                    prefixIcon: new Icon(FontAwesomeIcons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: minority,
                enabled: false,
              ),
              onTap: () {
                _navigatetominority(context);
              },
            )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: "Account no ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: accno,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Bank Name & Place",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: bankname,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "IFSC Code ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: ifsccode,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Branch Name / Code ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: branchname,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Last Class Name & Last School Name",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: schoolname,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Result ",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: result,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: "Year ",
              prefixIcon: new Icon(FontAwesomeIcons.calendar)
          ),
          controller: year,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Last Class Medium",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: last_class_medium,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Last Class Roll No",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: last_class_rollno,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Last Class Board",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: last_class_board,
        )),
        new Container(
            margin: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Hostel ",
                    prefixIcon: new Icon(FontAwesomeIcons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: new TextEditingController(text: dormitoryname),
                enabled: false,
              ),
              onTap: () {
                _navigatetodormitory(context);
              },
            )),
        new Container(
            margin: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Transport Route ",
                  prefixIcon: new Icon(FontAwesomeIcons.list),
                  suffixIcon: new Icon(FontAwesomeIcons.angleDown),
                ),
                controller: new TextEditingController(text: transportname),
                enabled: false,
              ),
              onTap: () {
                _navigatetotransport(context);
              },
            )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "First Language",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: firstlan,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Second Language",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: seclan,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "District Name",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: district,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Mandal Name",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: mandal,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Rural/Urban",
              prefixIcon: new Icon(FontAwesomeIcons.list)
          ),
          controller: rural,
        )),
        new Container(margin: EdgeInsets.all(5.0),child:new TextField(
          keyboardType: TextInputType.text,
          maxLength: 30,
          decoration: InputDecoration(
              labelText: "Address ",
              prefixIcon: new Icon(Icons.location_on)
          ),
          controller: address,
        )),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Upload Profile Pic",
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
                _getFile();
              },
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
                        setState(() {
                          name.text = '';
                          lastname.text ='';
                          email.text = '';
                          phone.text = '';
                          studentcode.text ='';
                          gender.text='';
                          aadharno.text='';
                          stream.text='';
                          dob=null;
                          doj=null;
                          optsub.text = '';
                          bloodgroup.text = '';
                          nationality.text = '';
                          result.text = '';
                          religion.text = '';
                          category.text = '';
                          mothertongue.text = '';
                          minority.text = '';
                          accno.text = '';
                          bankname.text = '';
                          ifsccode.text = '';
                          branchname.text = '';
                          schoolname.text = '';
                          year.text = '';
                          last_class_medium.text = '';
                          last_class_rollno.text = '';
                          last_class_board.text = '';
                          firstlan.text = '';
                          seclan.text = '';
                          district.text = '';
                          mandal.text = '';
                          rural.text = '';
                          sectionname = '';
                          parentname ='';
                          transportname =  "";
                          dormitoryname = "";
                        });
                      },
                      child: new Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.orange,
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
                        if(admission.text == ""){
                          Constants().ShowAlertDialog(context, "Please enter admission no");
                          return;
                        }
                        if(name.text == ""){
                          Constants().ShowAlertDialog(context, "Please enter first name");
                          return;
                        }
                        if(lastname.text == ""){
                          Constants().ShowAlertDialog(context, "Please enter last name");
                          return;
                        }
                        if(parentname == ""){
                          Constants().ShowAlertDialog(context, "Please select parent");
                          return;
                        }
                        if(widget.id == null &&  classname == ""){
                          Constants().ShowAlertDialog(context, "Please select class");
                          return;
                        }
                        if(sectionname == ""){
                          Constants().ShowAlertDialog(context, "Please select section");
                          return;
                        }
                        if(studentid.text == ""){
                          Constants().ShowAlertDialog(context, "Please enter Id No");
                          return;
                        }
                        if(widget.type == "new" && dob == ""){
                          Constants().ShowAlertDialog(context, "Please select date of birth");
                          return;
                        }
                        if(gender.text == ""){
                          Constants().ShowAlertDialog(context, "Please select gender");
                          return;
                        }
//                        if(phone.text == null){
//                          Constants().ShowAlertDialog(context, "Please enter phone no");
//                          return;
//                        }
//                        if(phone.text != null && phone.text.length !=10){
//                          Constants().ShowAlertDialog(context, "Please enter 10 digit phone no");
//                          return;
//                        }
                        if(email.text == ""){
                          Constants().ShowAlertDialog(context, "Please enter email");
                          return;
                        }
                        CreateStudent(widget.type,widget.studentdetails);
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
    );
  }

}

class Studentdetails {
  String sno, photo, name, phone,email,file,id,admisssionno,studentcode;

  Studentdetails({this.sno, this.photo, this.name, this.phone,this.email,this.file,this.id,this.admisssionno,this.studentcode});

  factory Studentdetails.fromJson(Map<String, dynamic> json) {
    return new Studentdetails(
      // photo: "",
      // admisssionno: json['admission_no'].toString(),
        studentcode: json['student_code'].toString(),
        photo: json['photo'].toString(),
        name: json['name'].toString() ,
        id:  json['student_id'].toString() ,
        email: json['email'].toString()
    );
  }
}
