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

class ManagegradestabsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _ManagegradestabsPageState();
}

class _ManagegradestabsPageState extends State<ManagegradestabsPage>
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
      tabs.add(new Tab(text: "Grades List",icon: Icon(Icons.list),));
      tabs.add(new Tab(text: "Add Grade",icon: Icon(Icons.add)));
      tabsbody.add(new ManageGradesPage(),);
      tabsbody.add(new AddGradesPage(type: "new",details: null,),);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Manage Exam Grades"),
        backgroundColor: Color(0xff182C61),
       /* leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () =>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(),),
          ),
        ),*/
      ),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 80,
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
                    new SizedBox(width: 15,height: 15,),
                    new Text("Manage Exam Grades",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ),
          new Card(
            elevation: 5.0,
            margin:
            new EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 50),
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

class ManageGradesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ManageGradesPageState();
}

class _ManageGradesPageState extends State<ManageGradesPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  List Gradesdetails = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadGrades();
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
        Edit(user);
      }
      else if(value ==2) {
        deletedialog(user['grade_id'].toString());
      }
    },
  );

  Edit(Map details) async {
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
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Edit Grade",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new AddGradesPage(type : "edit",details: details,),
              ],
            )
        );

      },
    );
  }

  Future<Null> LoadGrades() async {
    String id = await sp.ReadString("Userid");
    Gradesdetails.clear();
    var url = await Constants().Clienturl() + Constants.Load_Grades_Admin;
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
              Gradesdetails = responseJson['result'];
            });
          }catch(e){
            setState(() {
              Gradesdetails = new List();
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

  Future<Null> DeleteApi(String Gradeid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.CRUDManagegraged_Admin;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['grade_id'] = Gradeid;

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
          Constants().ShowSuccessDialog(context, "Grade deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadGrades();
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

  deletedialog(String Gradeid) async {
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
                                      DeleteApi(Gradeid);
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
                    Gradesdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: Text("#"),
                          ),
                          DataColumn(
                            label: Text("Grade"),
                          ),
                          DataColumn(
                            label: Text("Grade Point"),
                          ),
                          DataColumn(
                            label: Text("Mark From"),
                          ),
                          DataColumn(
                            label: Text("Mark Upto"),
                          ),
                          DataColumn(
                            label: Text("Actions"),
                          ),
                        ],
                        rows: Gradesdetails.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text((Gradesdetails.indexOf(user)+1).toString()),
                                ),
                                DataCell(
                                  Text(user['name'].toString()),
                                ),
                                DataCell(
                                  Text(user['grade_point'].toString()),
                                ),
                                DataCell(
                                  Text(user['mark_from'].toString()),
                                ),
                                DataCell(
                                  Text(user['mark_upto'].toString()),
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

class AddGradesPage extends StatefulWidget {
  final Map details;
  final String type;
  AddGradesPage({this.type,this.details});

  @override
  State<StatefulWidget> createState() => new _AddlasssPagePageState();
}

class _AddlasssPagePageState extends State<AddGradesPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
TextEditingController grade = new TextEditingController(),gradepint = new TextEditingController(),markfrom = new TextEditingController(),markupto = new TextEditingController(),comment = new TextEditingController();
  String name = "",date1="";IconData icon = null;

  @override
  void initState() {
    super.initState();
    if(widget.type == "new"){
      name = "Add Grade";
      icon = Icons.add;
    }
    else{
      name = "Edit Grade";
      icon = Icons.edit;
      grade.text = widget.details['name'].toString();
      gradepint.text = widget.details['grade_point'].toString();
      markfrom.text = widget.details['mark_from'].toString();
      markupto.text = widget.details['mark_upto'].toString();
      comment.text = widget.details['comment'].toString();
    }
  }

  Future<Null> CreateGrade() async {
    Constants().onLoading(context);
    var url="";
    if(widget.type == "new")
      url = await Constants().Clienturl() + Constants.CRUDManagegraged_Admin;
    else
      url = await Constants().Clienturl() + Constants.CRUDManagegraged_Admin;

    Map<String, String> body = new Map();
    if(widget.type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['grade_id'] = widget.details['grade_id'];
    }
    body['name'] = grade.text;
    body['grade_point'] = gradepint.text;
    body['mark_from'] = markfrom.text;
    body['mark_upto'] = markupto.text;
    body['comment'] = comment.text;

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
            Constants().ShowSuccessDialog(context, "Grade updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Grade added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            if(widget.type == "edit")
              Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManagegradestabsPage()),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new SizedBox(height: 20,width: 20,),
            new Container(
              padding: EdgeInsets.all(5.0),
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Grade *",
                  prefixIcon: new Icon(FontAwesomeIcons.users),
                ),
                controller: grade,
              ),
            ),
            new Container(
              padding: EdgeInsets.all(5.0),
              child: new TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Grade Point *",
                  prefixIcon: new Icon(Icons.grade),
                ),
                controller: gradepint,
              ),
            ),
            new Container(
              padding: EdgeInsets.all(5.0),
              child: new TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Mark From *",
                  prefixIcon: new Icon(Icons.list),
                ),
                controller: markfrom,
              ),
            ),
            new Container(
              padding: EdgeInsets.all(5.0),
              child: new TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Mark Upto *",
                  prefixIcon: new Icon(Icons.list),
                ),
                controller: markupto,
              ),
            ),
            new Container(
              padding: EdgeInsets.all(5.0),
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Comment *",
                  prefixIcon: new Icon(Icons.comment),
                ),
                controller: comment,
              ),
            ),
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
                              if(grade.text == ""){
                                Constants().ShowAlertDialog(context, "Please enter grade");
                                return;
                              }
                              if(gradepint.text == ""){
                                Constants().ShowAlertDialog(context, "Please enter grade point");
                                return;
                              }
                              if(markfrom.text == ""){
                                Constants().ShowAlertDialog(context, "Please enter mark from");
                                return;
                              }
                              if(markupto.text == ""){
                                Constants().ShowAlertDialog(context, "Please enter mark upto");
                                return;
                              }
                              if(comment.text == ""){
                                Constants().ShowAlertDialog(context, "Please enter comment");
                                return;
                              }
                              CreateGrade();
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
