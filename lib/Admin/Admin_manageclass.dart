import 'dart:collection';
import 'dart:io';

import 'package:Edecofy/AppUtils.dart';
import 'package:Edecofy/search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../FilePicker.dart';
import '../const.dart';
import '../dashboard.dart';

class ManageclasstabsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _ManageclasstabsPageState();
}

class _ManageclasstabsPageState extends State<ManageclasstabsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _loading = false;

  List<Tab> tabs = new List();
  List<Widget> tabsbody = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    tabs.add(new Tab(text: "Class List",icon: Icon(Icons.list),));
    tabs.add(new Tab(text: "Add Class",icon: Icon(Icons.add)));
    tabsbody.add(new ManageclasssPage(),);
    tabsbody.add( new AddlasssPage(type : "new",details: null,),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Manage Class"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () => Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
            child: new Container(
                child: Column(
                  children: <Widget>[
                    new SizedBox(width: 10,height: 10,),
                    new Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange
                      ),
                      child: new SvgPicture.asset("assets/classroom.svg",color: Colors.white,width: 25,height: 25,),
                      padding: new EdgeInsets.all(7),
                    ),
                    new SizedBox(width: 10,height: 10,),
                    new Text("Manage Class",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ),
          new Card(
            elevation: 5.0,
            margin:
            new EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 90),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new DefaultTabController(
                length: tabs.length,
                child: new Scaffold(
                  appBar: TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Theme.of(context).primaryColor,
                    tabs: tabs,
                    controller: _tabController,
                    indicatorColor:
                    Theme.of(context).primaryColor,
                  ),
                  body: TabBarView(
                    children: tabsbody,
                    controller: _tabController,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class ManageclasssPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ManageclasssPageState();
}

class _ManageclasssPageState extends State<ManageclasssPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  List Classdetails = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadClasses();
  }

  Widget _EdittPopup(user) => PopupMenuButton<int>(
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
      if(value == 1){
        Editclass(user);
      }
      else if(value ==2){
        deletedialog(user['class_id'].toString());
      }
    },
  );

  Editclass(Map classdetails) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
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
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Edit class",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new AddlasssPage(type : "edit",details: classdetails,),
              ],
            )
        );

      },
    );
  }

  Future<Null> LoadClasses() async {
    String id = await sp.ReadString("Userid");
    Classdetails.clear();
    var url = await Constants().Clienturl() + Constants.LoadManageclasses_Admin;
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
              Classdetails = responseJson['result'];
            });
          }catch(e){
            setState(() {
              Classdetails = new List();
            });
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

  Future<Null> DeleteParent(String classid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.CRUDManageclasses_Admin;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['class_id'] = classid;

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
          Constants().ShowSuccessDialog(context, "Class deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadClasses();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Class not deleted succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  deletedialog(String classid) async {
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
                                      DeleteParent(classid);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body:  _loading ? Constants().bodyProgress : new Padding(padding: EdgeInsets.all(10.0),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Classdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 10,
                  columns: [
                    DataColumn(
                      label: Text("Class Id",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                    ),
                    DataColumn(
                      label: Text("Class Name",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                    ),
                    DataColumn(
                      label: Text("Numeric Name",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                    ),
                    DataColumn(
                      label: Text("Teacher",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                    ),
                    DataColumn(
                      label: Text("Actions",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                    ),
                  ],
                  rows: Classdetails.map(
                        (user) => DataRow(
                        cells: [
                          DataCell(
                            Text(user['class_id'].toString()),
                          ),
                          DataCell(
                            Text(user['name'].toString()),
                          ),
                          DataCell(
                            Text(user['name_numeric'].toString()),
                          ),
                          DataCell(
                            Text(user['teacher_name'].toString()),
                          ),
                          DataCell(
                            _EdittPopup(user),
                          )
                        ]),
                  ).toList(),
                ),
              ),
            ],
          )),
    );
  }

}

class AddlasssPage extends StatefulWidget {
  final String type;
  final Map details;
  AddlasssPage({this.type,this.details});

  @override
  State<StatefulWidget> createState() => new _AddlasssPagePageState();
}

class _AddlasssPagePageState extends State<AddlasssPage> with SingleTickerProviderStateMixin{
  bool _loading = false;
  TextEditingController classname = new TextEditingController(),numericname = new TextEditingController(),teacher = new TextEditingController();
  String name = "";IconData icon = null;

  @override
  void initState() {
    super.initState();
    if(widget.type == "new"){
      name = "Add Class";
      icon = Icons.add;
    }
    else{
      name = "Edit Class";
      icon = Icons.edit;
      teacher.text = widget.details['teacher_name'].toString();
      numericname.text = widget.details['name'].toString();
    }
    setState(() {
      _loading = true;
    });
    Loadteachers();
  }

  Future<Null> CreateClass() async {
    Constants().onLoading(context);
    var url="";
    if(widget.type == "new")
      url = await Constants().Clienturl() + Constants.CRUDManageclasses_Admin;
    else
      url = await Constants().Clienturl() + Constants.CRUDManageclasses_Admin;

    Map<String, String> body = new Map();
    if(widget.type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['class_id'] = widget.details['class_id'];
    }
    body['name'] = numericname.text;
    body['teacher_id'] = teachersmap[teacher.text];

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
          if(widget.type == "edit")
            Constants().ShowSuccessDialog(context, "Class updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Class added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            if(widget.type == "edit")
              Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageclasstabsPage()),
            );
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

  List<String> teacherslist = new List();
  Map<String,String> teachersmap = new HashMap();
  String teachername = "";

  Future<Null> Loadteachers() async {
    var url = await Constants().Clienturl() + Constants.Load_Teachers_Admin;
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
            teacherslist.add(data['name']);
            teachersmap[data['name']] = data['teacher_id'];
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

  _navigatetoteachers(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Teacher",duplicateitems: teacherslist,)),
    );
    setState(() {
      teacher.text = result ?? teacher.text;
    });
    print("res--"+result.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading ? Constants().bodyProgress : new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new SizedBox(height: 20,width: 20,),
        new Container(
          padding: EdgeInsets.all(5.0),
          child: new TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Class Name *",
              prefixIcon: new Icon(FontAwesomeIcons.users),
            ),
            controller: numericname,
          ),
        ),
        new Container(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Teacher *",
                    prefixIcon: new Icon(FontAwesomeIcons.chalkboardTeacher),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: teacher,
                enabled: false,
              ),
              onTap: () {
                _navigatetoteachers(context);
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
                          if(numericname.text == ""){
                            Constants().ShowAlertDialog(context, "Please enter class name");
                            return;
                          }
                          if(teacher.text == ""){
                            Constants().ShowAlertDialog(context, "Please select teacher");
                            return;
                          }
                          CreateClass();
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
                                new Icon(icon,color: Colors.white),
                                new Padding(
                                  padding:
                                  EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    name,
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
    );
  }

}
