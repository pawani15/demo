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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../FilePicker.dart';
import '../const.dart';
import '../dashboard.dart';

class ManageexamstabsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _ManageexamstabsPageState();
}

class _ManageexamstabsPageState extends State<ManageexamstabsPage>
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
      tabs.add(new Tab(text: "Exams List",icon: Icon(Icons.list),));
      tabs.add(new Tab(text: "Add Exams",icon: Icon(Icons.add)));
      tabsbody.add(new ManageExamsPage(),);
      tabsbody.add(new AddExamsPage(type: "new",details: null,),);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Manage Exams"),
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
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
//            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 10,height: 10,),
//                    new Container(
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.orange
//                      ),
//                      child: new SvgPicture.asset("assets/exam.svg",color: Colors.white,width: 25,height: 25,),
//                      padding: new EdgeInsets.all(7),
//                    ),
//                    new SizedBox(width: 10,height: 10,),
//                    new Text("Manage Exams",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Card(
            elevation: 5.0,
            margin:
            new EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 20),
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

class ManageExamsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ManageExamsPageState();
}

class _ManageExamsPageState extends State<ManageExamsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  List Examdetails = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadExams();
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
        deletedialog(user['exam_id'].toString());
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
                          child: new Container(child: new Text("Edit Exam",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new AddExamsPage(type : "edit",details: details,),
              ],
            )
        );

      },
    );
  }

  Future<Null> LoadExams() async {
    String id = await sp.ReadString("Userid");
    Examdetails.clear();
    var url = await Constants().Clienturl() + Constants.Load_Exams_Admin;
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
              Examdetails = responseJson['result'];
            });
          }catch(e){
            setState(() {
              Examdetails = new List();
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

  Future<Null> DeleteApi(String examid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.CRUDManageExams_Admin;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['exam_id'] = examid;

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
          Constants().ShowSuccessDialog(context, "Exam deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadExams();
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
  Future<void> _showDialog(BuildContext context, String data) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Description'),
          content: Text(data),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  deletedialog(String examid) async {
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
                                      DeleteApi(examid);
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
                    Examdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: Text("S No"),
                          ),
                          DataColumn(
                            label: Text("Exam Name"),
                          ),
                          DataColumn(
                            label: Text("Date"),
                          ),
                          DataColumn(

                            label: Text("Comments"),
                          ),
                          DataColumn(
                            label: Text("Actions"),
                          ),
                        ],
                        rows: Examdetails.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text((Examdetails.indexOf(user)+1).toString()),
                                ),
                                DataCell(
                                  Text(user['name'].toString()),
                                ),
                                DataCell(
                                  Text(user['date'].toString()),
                                ),
                                DataCell(
                                  Container(
                                    width: 100,
                                    child: GestureDetector(child: Text(
                                      user['comment'].toString(),
                                      overflow: TextOverflow.ellipsis,
                                    maxLines: 1,),
                                      onTap: () {
                                        _showDialog(
                                            context, user['comment']);
                                      },
                                    ),
                                  ),

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

class AddExamsPage extends StatefulWidget {
  final String type;
  final Map details;
  AddExamsPage({this.type,this.details});

  @override
  State<StatefulWidget> createState() => new _AddlasssPagePageState();
}

class _AddlasssPagePageState extends State<AddExamsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
TextEditingController comment = new TextEditingController(),examane = new TextEditingController();
  DateTime date = null;
  String name = "",date1="";IconData icon = null;

  @override
  void initState() {
    super.initState();
    if(widget.type == "new"){
      name = "Add Exam";
      icon = Icons.add;
      date1 ="";
    }
    else{
      name = "Edit Exam";
      icon = Icons.edit;
      examane.text = widget.details['name'].toString();
      comment.text = widget.details['comment'].toString();
      date1 = widget.details['date'].toString();
    }
    setState(() {
      _loading = true;
    });
    Loadclasses();
  }

  List<String> classlist= new List();
  Map<String,String> classsmap = new HashMap();

  Future<Null> Loadclasses() async {
    var url = await Constants().Clienturl() + Constants.Load_Classes_Admin;
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
            classlist.add(data['class_id'].toString());
            classsmap[data['class_id'].toString()] = data['class_id'];
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

  Future<Null> CreateExam() async {
    Constants().onLoading(context);
    var url="";
    if(widget.type == "new")
      url = await Constants().Clienturl() + Constants.CRUDManageExams_Admin;
    else
      url = await Constants().Clienturl() + Constants.CRUDManageExams_Admin;

    Map<String, String> body = new Map();
    if(widget.type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['exam_id'] = widget.details['exam_id'];
    }
    body['date'] = date == null ? date1 : new DateFormat("dd-MM-yyyy").format(date);
    body['name'] = examane.text;
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
            Constants().ShowSuccessDialog(context, "Exam updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Exam added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            if(widget.type == "edit")
              Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageexamstabsPage()),
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

  Future<Null> _selectDate(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate: DateTime(DateTime.now().year+1));

      if (picked != null && picked != date) {
        print('date selected : ${date.toString()}');
        setState(() {
          date = picked;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }catch(e){e.toString();}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new SizedBox(height: 20,width: 20,),
            new Container(
              padding: EdgeInsets.all(5.0),
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Exam Name *",
                  prefixIcon: new Icon(FontAwesomeIcons.list),
                ),
                controller: examane,
              ),
            ),
            new Container(margin: new EdgeInsets.all(5.0),
                child : new InkWell(
                  child: new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Date *',
                      prefixIcon: new Icon(FontAwesomeIcons.calendar),
                    ),
                    enabled: false,
                    controller: new TextEditingController(text: date == null ? date1 :  new DateFormat('dd-MMM-yyyy').format(date)),
                  ),
                  onTap: (){
                    _selectDate(context);
                  },
                )),
            new Container(
              padding: EdgeInsets.all(5.0),
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Comment *",
                  prefixIcon: new Icon(FontAwesomeIcons.comment),
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
                              if(examane.text == ""){
                                Constants().ShowAlertDialog(context, "Please enter exam name");
                                return;
                              }
                              if(widget.type == "new" && date == null){
                                Constants().ShowAlertDialog(context, "Please select date");
                                return;
                              }
                              if(comment.text == ""){
                                Constants().ShowAlertDialog(context, "Please enter comment");
                                return;
                              }
                              CreateExam();
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
