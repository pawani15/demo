import 'dart:collection';

import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../const.dart';
import '../dashboard.dart';

class ManageSectionstabsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ManageSectionstabsPageState();
}

class _ManageSectionstabsPageState extends State<ManageSectionstabsPage>
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
    Loadclassstabs();
  }

  Future<Null> Loadclassstabs() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() +
        Constants.Load_Classes;
    Map<String, String> body = new Map();

    print("url is $url" + "body--" + body.toString());

    http.get(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }).then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");

          responseJson['result'].forEach((data) {
            tabs.add(new Tab(
                text: "Class-"+data['class_name'].toString()));
            tabsbody.add(
              new ManagesectionsPage(id: data['class_id'],),
            );
          });
        }
        setState(() {
          _loading = false;
        });
      } else {
        print("erroe--" + response.body);
      }
    });
  }

  Addclass() async {
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
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Add Section",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new AddsectionssPage(type : "new",details: null,),
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
        title: Text("Manage Sections"),
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
                new SizedBox(
                  width: 30,
                  height: 30,
                ),
                new Text(
                  "Manage Sections ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
      new Container(
          margin: new EdgeInsets.only(left: 15, right: 5, bottom: 10, top: 70),
       child: new Stack(
        children: <Widget>[
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(right: 10, top: 25),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading
                ? new Constants().bodyProgress
                :  new Container(
                    margin: EdgeInsets.only(top: 10),
                          child: new DefaultTabController(
                              length: tabs.length,
                              child: new Scaffold(
                                appBar: TabBar(
                                  unselectedLabelColor: Colors.grey,
                                  labelColor: Theme.of(context).primaryColor,
                                  tabs: tabs,
                                  controller: _tabController,
                                  isScrollable: true,
                                  indicatorColor:
                                      Theme.of(context).primaryColor,
                                ),
                                body: TabBarView(
                                  children: tabsbody,
                                  controller: _tabController,
                                ),
                              ))),
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
                Addclass();
              },
              )
          )
        ],
      )),
        ],
      ),
    );
  }
}

class ManagesectionsPage extends StatefulWidget {
  final String id;
  ManagesectionsPage({this.id});

  @override
  State<StatefulWidget> createState() => new _ManagesectionsPageState();
}

class _ManagesectionsPageState extends State<ManagesectionsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  List Sectionslist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadSections();
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
      else if(value ==2) {
        deletedialog(user['section_id'].toString());
      }
    },
  );

  Editclass(Map details) async {
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
                          child: new Container(child: new Text("Edit Class",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new AddsectionssPage(type : "edit",details: details,),
              ],
            )
        );

      },
    );
  }

  Future<Null> DeleteApi(String sectionid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.CRUDManagecsections_Admin;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['section_id'] = sectionid;

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
          Constants().ShowSuccessDialog(context, "Section deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadSections();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Section not deleted succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  deletedialog(String sectionid) async {
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
                                      DeleteApi(sectionid);
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

  Future<Null> LoadSections() async {
    String id = await sp.ReadString("Userid");
    Sectionslist.clear();
    var url = await Constants().Clienturl() + Constants.Load_ManageSections_Admin;
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
          try {
            setState(() {
              Sectionslist = responseJson['result'];
            });
          }catch(e){
            setState(() {
              Sectionslist = new List();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body:  _loading ? Constants().bodyProgress : new Padding(padding: EdgeInsets.all(10.0),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Sectionslist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 10,
                  columns: [
                    DataColumn(
                      label: Text("#"),
                    ),
                    DataColumn(
                      label: Text("Section Name"),
                    ),
                    DataColumn(
                      label: Text("Nick Name"),
                    ),
                    DataColumn(
                      label: Text("Teacher"),
                    ),
                    DataColumn(
                      label: Text("Actions"),
                    ),
                  ],
                  rows: Sectionslist.map(
                        (user) => DataRow(
                        cells: [
                          DataCell(
                            Text(user['section_id'].toString()),
                          ),
                          DataCell(
                            Text(user['section_name'].toString()),
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


class AddsectionssPage extends StatefulWidget {
  final String type;
  final Map details;
  AddsectionssPage({this.type,this.details});

  @override
  State<StatefulWidget> createState() => new _AddlasssPagePageState();
}

class _AddlasssPagePageState extends State<AddsectionssPage> with SingleTickerProviderStateMixin{
  bool _loading = false;
  TextEditingController sectionname = new TextEditingController(),numericname = new TextEditingController(),teacher = new TextEditingController(),classname = new TextEditingController();
  String name = "";IconData icon = null;

  @override
  void initState() {
    super.initState();
    if(widget.type == "new"){
      name = "Add Section";
      icon = Icons.add;
    }
    else{
      name = "Edit Section";
      icon = Icons.edit;
      sectionname.text = widget.details['section_name'].toString();
      numericname.text = widget.details['name_numeric'].toString();
      teacher.text = widget.details['teacher_name'].toString();
      classname.text = widget.details['name'].toString();
    }
    setState(() {
      _loading = true;
    });
    Loadteachers();
  }

  Future<Null> CreateSection() async {
    Constants().onLoading(context);
    var url="";
    if(widget.type == "new")
      url = await Constants().Clienturl() + Constants.CRUDManagecsections_Admin;
    else
      url = await Constants().Clienturl() + Constants.CRUDManagecsections_Admin;

    Map<String, String> body = new Map();
    if(widget.type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['section_id'] = widget.details['section_id'];
    }
    body['class_id'] = classsmap[classname.text];
    body['name'] = sectionname.text;
    body['nick_name'] = numericname.text;
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
            Constants().ShowSuccessDialog(context, "Section updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Section added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageSectionstabsPage()),
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

  List<String> teacherslist = new List(),classlist= new List();
  Map<String,String> teachersmap = new HashMap(),classsmap = new HashMap();

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
        Loadclasses();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> Loadclasses() async {
    var url = await Constants().Clienturl() + Constants.Load_Classes;
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
            classlist.add(data['class_name'].toString());
            classsmap[data['class_name'].toString()] = data['class_id'];
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

  _navigatetoclass(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Class",duplicateitems: classlist,)),
    );
    setState(() {
      classname.text = result ?? classname.text;
    });
    print("res--"+result.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading ? Constants().bodyProgress : 
      new ListView(
        shrinkWrap: true,
        children: <Widget>[
          new SizedBox(height: 20,width: 20,),
          new Container(
            padding: EdgeInsets.all(5.0),
            child: new TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Section Name *",
                prefixIcon: new Icon(FontAwesomeIcons.users),
              ),
              controller: sectionname,
            ),
          ),
          new Container(
            padding: EdgeInsets.all(5.0),
            child: new TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Nick Name",
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
                      labelText: "Class *",
                      prefixIcon: new Icon(FontAwesomeIcons.chalkboardTeacher),
                      suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                  ),
                  controller: classname,
                  enabled: false,
                ),
                onTap: () {
                  _navigatetoclass(context);
                },
              )),
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
                            if(sectionname.text == ""){
                              Constants().ShowAlertDialog(context, "Please enter section name");
                              return;
                            }
                            if(classname.text == ""){
                              Constants().ShowAlertDialog(context, "Please select class");
                              return;
                            }
                            if(teacher.text == ""){
                              Constants().ShowAlertDialog(context, "Please select teacher");
                              return;
                            }
                            CreateSection();
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