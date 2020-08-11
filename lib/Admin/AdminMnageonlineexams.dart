import 'dart:io';

import 'package:Edecofy/Student/Subject_AnswerDialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:unicorndial/unicorndial.dart';

import '../Studymaterial.dart';
import '../search.dart';
import 'Adminlibrarianinformation.dart';
import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';
import 'Createonlineexam.dart';
import 'Managequestionpaper.dart';

class AdminManageonlineexamsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _AdminManageonlineexamsPageState();
}

class _AdminManageonlineexamsPageState extends State<AdminManageonlineexamsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String clas = '' , file =''; TextEditingController description=new TextEditingController(),title=new TextEditingController(),author=new TextEditingController()
  ,price=new TextEditingController();
  DateTime date = new DateTime.now();
  Map classmap= new Map();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadOnlineexams("active","noload");
  }
  
  Future<Null> LoadOnlineexams(String examtype,String type) async {
    _Onlineexams.clear();
    if(type == "load")
      Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.LoadOnlineexam_Admin;
    Map<String, String> body = new Map();
    if(examtype == "expired")
      body['type_page'] = examtype;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        if(type == "load")
          Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            setState(() {
              for (Map user in responseJson['result']) {
                _Onlineexams.add(Onlineexams.fromJson(user));
              }  
            });
          }catch(e){
            _Onlineexams = new List();
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

  dynamic resultData = [];
  List result_list = new List();
  Future<dynamic>getAnswersData(String examid)async{
    Constants().onLoading(context);
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Viewresult_Admin;

    Map<String, String> body = new Map();
    body['online_exam_id'] = examid;
    print("url is $url"+"body--"+body.toString());
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body).then((response){
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            result_list = responseJson['result']['online_exam_results'];
          } catch (e) {}
          setState(() {
            resultData = responseJson['result'];
          });
        }
        else {
          resultData = [];
          Constants().ShowAlertDialog(context, responseJson['message']);
        }
        if (resultData.length > 0)
          answerView();
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<void> answerView() async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                side: BorderSide(style: BorderStyle.none),
                borderRadius: BorderRadius.circular(8)
            ),
            titlePadding: EdgeInsets.all(5),
            title: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  child: Icon(
                    Icons.message,
                    color:Color(0xff182C61),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Text("View Exam Result",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff182C61))),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Color(0xff182C61),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
            contentPadding: EdgeInsets.all(8),
            content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          /*Container(
                            color:Color(0xff182C61),
                            child: SizedBox(
                              width: 250,
                              height: 250,
                              child: Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                // alignment: Alignment.l,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        resultData['online_exam_data']['title'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Text(
                                            'Class:- ' +
                                                resultData['online_exam_data']['class_name'],
                                            style: TextStyle(
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Section:- ' +
                                                resultData['online_exam_data']['section_name'],
                                            style: TextStyle(
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Subject:- ' +
                                            resultData['online_exam_data']['subject_name'],
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'TotalMarks:-  ' +
                                            resultData['online_exam_data']['total_marks']
                                                .toString(),
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'Minimun Percentage:  ' +
                                            resultData['online_exam_data']['minimum_percentage']
                                                .toString(),
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: CustomPaint(
                              size: Size(30, 20),
                              painter: DrawTriangleShape(fillcolor:Color(0xff182C61)),
                            ),
                          ),*/
                          new Container(
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: ShapeOfView(
                              shape: BubbleShape(
                                  position: BubblePosition.Bottom,
                                  arrowPositionPercent: 0.5,
                                  borderRadius: 20,
                                  arrowHeight: 15,
                                  arrowWidth: 15
                              ),
                              child: new Container(
                                color: Theme.of(context).primaryColor,
                                padding: new EdgeInsets.only(top: 10,bottom: 30,right: 40,left: 40),
                                child: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      width: 25,
                                      height: 25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[700],
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.yellow,width: 3)
                                      ),
                                    ),
                                    new SizedBox(width: 5,height: 5,),
                                    new Text(resultData['online_exam_data']['title'],style: TextStyle(color: Colors.white),),
                                    new SizedBox(width: 5,height: 5,),
                                    new Text("Class- ${resultData['online_exam_data']['class_name']} : Section- ${resultData['online_exam_data']['section_name']}",style: TextStyle(color: Colors.white),),
                                    new SizedBox(width: 5,height: 5,),
                                    new Text("Subject: ${resultData['online_exam_data']['subject_name']}",style: TextStyle(color: Colors.white),),
                                    new SizedBox(width: 5,height: 5,),
                                   /* new Text("Total Marks: ${resultData['online_exam_data']['total_marks']}",style: TextStyle(color: Colors.white),),
                                    new SizedBox(width: 5,height: 5,),*/
                                    new Text("Minimun Percentage: ${resultData['online_exam_data']['minimum_percentage']}",style: TextStyle(color: Colors.white),),
                                    new SizedBox(width: 5,height: 5,),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    resultData['online_exam_results'].length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: Text("Student Name",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Obtained Marks",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Result",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),

                        ],
                        rows:result_list.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text(user['student_first_name'] + " " +user['student_last_name']),
                                ),
                                DataCell(
                                  Text(user['obtained_mark']),
                                ),
                                DataCell(
                                  Text(user['result'] == null || user['result'] == "" ? "Fail(Absent)" : user['result']),
                                ),
                              ]),
                        ).toList(),
                      ),
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

  Future<void> _showDialog(BuildContext context, String data) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions', style: TextStyle(
              color: Color(0xff182C61))),
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

  Widget _EdittPopup(Onlineexams Onlineexams) => PopupMenuButton<int>(
    icon: Icon(Icons.settings,color: Colors.grey,size: 20,),
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 3,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(Icons.apps,color: Colors.yellow[700]),),
              new Text("Manage Question"),
            ],
          )
      ),
      PopupMenuItem(
          value: 1,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.edit,color: Theme.of(context).primaryColor,),),
              new Text("Edit"),
            ],
          )
      ),
      PopupMenuItem(
          value: 2,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.trash,color: Colors.red),),
              new Text("Delete"),
            ],
          )
      ),
    ],
    elevation: 5,
    padding: EdgeInsets.symmetric(horizontal: 20),
    onSelected: (value) {
      print(value);
      if(value == 1){
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext
                context) =>
                new CreateonlineexamPage(type: "edit",details: Onlineexams,)));
      }
      else if(value ==2) {
        deletedialog(Onlineexams);
      }
      else if(value == 3){
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext
                context) =>
                new ManagequestionsPage(details: Onlineexams,)));
      }
    },
  );
  
  deletedialog(Onlineexams Onlineexams) async {
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
                                      Delete(Onlineexams);
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

  Delete(Onlineexams Onlineexams) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['online_exam_id'] = Onlineexams.id;
    body['type_page'] = "delete";

    var  url = await Constants().Clienturl() + Constants.CRUDOnlineexam_Admin;

    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          Navigator.of(context).pop();
          Constants().ShowSuccessDialog(context, responseJson['message']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminManageonlineexamsPage()),
            );          }
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

  Changeexamstatus(Onlineexams Onlineexams,String status){
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return new Dialog(
          child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new SizedBox(width: 20,height: 20,),
            new Container(padding: EdgeInsets.all(10), child: new Text("Are You Sure You Want To Update This Information ?",style: TextStyle(fontSize: 16),)),
            new SizedBox(width: 20,height: 20,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: new Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all( Radius.circular(15) )),
                        child: new Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.cancel,color: Colors.white,),
                            new Padding(padding: EdgeInsets.only(left: 10.0),child: Text("No",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),)
                          ],
                        ))),
                new InkWell(
                    onTap: () {
                      ChangeexamstatusApi(Onlineexams, status);
                    },
                    child: new Container(
                      margin: EdgeInsets.all(5),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all( Radius.circular(15) )),
                        child: new Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.check,color: Colors.white,),
                            new Padding(padding: EdgeInsets.only(left: 10.0),child: Text("Yes",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),)
                          ],
                        )))
              ],
            ),
            new SizedBox(width: 20,height: 20,),
          ],
        ),
        );
      },
    );
  }

  ChangeexamstatusApi(Onlineexams Onlineexams,String status) async{
       var  url = await Constants().Clienturl() + Constants.Status_Onlineexam_Admin;
       Navigator.of(context).pop();

                Constants().onLoading(context);
                Map body = new Map();
                body['online_exam_id'] = Onlineexams.id;
                body['status'] = status;

                print("url--"+url+'body is${json.encode(body)} $body');
                http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
                    .then((response) {
                  if (response.statusCode == 200) {
                    print("response --> ${response.body}");
                    Navigator.of(context).pop();

                    var responseJson = json.decode(response.body);
                    if (responseJson['status'].toString() == "true") {
                      print("response json ${responseJson}");
                      Constants().ShowSuccessDialog(context, responseJson['message']);
                      const duration = const Duration(seconds: 2);
                      void handleTimeout() {
                        // callback function
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminManageonlineexamsPage()),
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
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Manage Online Exam"),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),*/
      ),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 50),
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
          new Container(
              margin: new EdgeInsets.only(top: 105),
              child : new ListView(
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.all(5),
                    child : new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(child:
                        new InkWell(child:
                        new Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: new Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.only(right: 5,left: 20,top: 10,bottom: 10),
                                  child: new Icon( Icons.signal_cellular_4_bar ,color: Colors.green,size: 20,)
                              ),
                            new Expanded(child:new Padding(padding: EdgeInsets.only(left: 5,right: 20,top: 10,bottom: 10),child: new Text("Active Exams",style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),),)),
                            ],
                          ),
                        ),
                          onTap: (){
                            LoadOnlineexams("active","load");
                          },
                        ),
                         flex: 1,),
                        new Expanded(child:
                        new InkWell(child:
                        new Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: new Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.only(left: 20,right: 5,top: 10,bottom: 10),
                                  child: new Icon( Icons.access_time ,color: Colors.orange,size: 20,)
                              ),
                               new Expanded(child:new Padding(padding: EdgeInsets.only(left: 5,right: 20,top: 10,bottom: 10),child: new Text("Expied Exams",style: TextStyle(color: Colors.orange,fontSize: 14,fontWeight: FontWeight.bold),),),)
                            ],
                          ),
                        ),
                          onTap: (){
                            LoadOnlineexams("expired","load");
                          },
                        ),
                        flex: 1,),
                      ],
                    )
                  ),
                  new Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.all(10),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10),
                        child: new ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                              child : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(child: new Text("Online Exams List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                                  /*new Expanded(child:  new Container(
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
                                  ),flex: 2,),*/
                                ],
                              )
                            ),
                            new Container(height: 2,width: double.infinity,color: Theme.of(context).primaryColor,),
                            _Onlineexams.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                                : new Padding(padding: EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 10,
                                  columns: [
                                    DataColumn(
                                      label: Text("Exam Name",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Class & Sec",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Subject",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Exam Date & Time",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Status",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Options",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                  ],
                                  rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                                  _searchResult.map(
                                        (user) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(user.examanme),
                                          ),
                                          DataCell(
                                              new Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Padding(padding: EdgeInsets.all(2),child: Text.rich(
                                                    TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "Class: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                                        TextSpan(text: user.classname, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                                      ],
                                                    ),
                                                  )),
                                                  new Padding(padding: EdgeInsets.all(2),child:Text.rich(
                                                    TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "Section: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                                        TextSpan(text: user.section, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                              )),
                                          DataCell(
                                            Text(user.subject),
                                          ),
                                          DataCell(
                                              new Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Padding(padding: EdgeInsets.all(2),child: Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: "Date: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                                    TextSpan(text: user.examdate, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                                  ],
                                                ),
                                              )),
                                              new Padding(padding: EdgeInsets.all(2),child:Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: "Time: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                                    TextSpan(text: user.examtime+" - "+user.examto, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                                  ],
                                                ),
                                              )),
                                            ],
                                          )),
                                          DataCell(
                                              new InkWell(child:
                                              new Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: user.status == "published"?  Theme.of(context).primaryColor : Colors.yellow[700],
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    new Padding(padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 5),child: new Text(user.status == "published"? "Published" : user.status == "expired"? "Expired":"Pending  ",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                    new Padding(padding: EdgeInsets.only(right: 5,left: 10,top: 5,bottom: 5),
                                                      child: new Container(
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white
                                                        ),
                                                        padding: EdgeInsets.all(5),
                                                        child: new Icon( user.status == "published"?  Icons.check : Icons.refresh ,color: user.status == "published"?  Theme.of(context).primaryColor : Colors.yellow[700],size: 15,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                                onTap: (){
                                                },
                                              )
                                          ),
                                          DataCell(
                                            new Row(
                                              children: <Widget>[
                                                new Container(
                                                  margin: EdgeInsets.only(right: 5),
                                                  child:  new InkWell(child:
                                                  new Container(
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.all(Radius.circular(17))
                                                    ),
                                                    child: new Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: <Widget>[
                                                        new Padding(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text("Actions",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                        new Padding(padding: EdgeInsets.only(right: 0,left: 5,top: 5,bottom: 5),
                                                          child: new Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.white
                                                            ),
                                                            padding: EdgeInsets.all(5),
                                                            child: _EdittPopup(user),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                    onTap: (){
                                                    },
                                                  ) ,
                                                ),
                                                new Container(
                                                  margin: EdgeInsets.only(right: 5),
                                                  child:  new InkWell(child:
                                                  new Container(
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: user.status == "published"? Colors.red : user.status == "expired"? Colors.yellow[700] : Theme.of(context).primaryColor,
                                                        borderRadius: BorderRadius.all(Radius.circular(15))
                                                    ),
                                                    child: new Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: <Widget>[
                                                        new Padding(padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 5),child: new Text(user.status == "published"? "Cancel      ": user.status == "expired"? "Expired": "Publish Now",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                        new Padding(padding: EdgeInsets.only(right: 5,left: user.status == "published" ? 20 : 10,top: 5,bottom: 5),
                                                          child: new Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.white
                                                            ),
                                                            padding: EdgeInsets.all(5),
                                                            child: new Icon(user.status == "published"? Icons.cancel : user.status == "expired"? Icons.refresh : Icons.send ,color: user.status == "published"? Colors.red : user.status == "expired"? Colors.yellow : Theme.of(context).primaryColor,size: 15,),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                    onTap: (){
                                                      if(user.status != "expired")
                                                        Changeexamstatus(user,user.status == "published"?"expired": "published");
                                                    },
                                                  ) ,
                                                ),
                                                new Container(
                                                  margin: EdgeInsets.only(right: 5),
                                                  child:  new InkWell(child:
                                                  new Container(
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.all(Radius.circular(15))
                                                    ),
                                                    child: new Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: <Widget>[
                                                        new Padding(padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 5),child: new Text("View Result",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                        new Padding(padding: EdgeInsets.only(right: 5,left: 10,top: 5,bottom: 5),
                                                          child: new Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.white
                                                            ),
                                                            padding: EdgeInsets.all(5),
                                                            child: new Icon(Icons.remove_red_eye ,color: Colors.green,size: 15,),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                    onTap: (){
                                                        getAnswersData(user.id);
                                                    },
                                                  ) ,
                                                ),
                                              ],
                                            )
                                          ),
                                        ]),
                                  ).toList()
                                      : _Onlineexams.map(
                                        (user) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(user.examanme),
                                          ),
                                          DataCell(
                                              new Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Padding(padding: EdgeInsets.all(2),child: Text.rich(
                                                    TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "Class: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                                        TextSpan(text: user.classname, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                                      ],
                                                    ),
                                                  )),
                                                  new Padding(padding: EdgeInsets.all(2),child:Text.rich(
                                                    TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "Section: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                                        TextSpan(text: user.section, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                              )),
                                          DataCell(
                                            Text(user.subject),
                                          ),
                                          DataCell(
                                              new Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Padding(padding: EdgeInsets.all(2),child: Text.rich(
                                                    TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "Date: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                                        TextSpan(text: user.examdate, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                                      ],
                                                    ),
                                                  )),
                                                  new Padding(padding: EdgeInsets.all(2),child:Text.rich(
                                                    TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "Time: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                                        TextSpan(text: user.examtime +" - "+user.examto, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                              )),
                                          DataCell(
                                              new InkWell(child:
                                              new Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: user.status == "published"?  Theme.of(context).primaryColor : Colors.yellow[700],
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    new Padding(padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 5),child: new Text(user.status == "published"? "Published" :user.status == "expired"? "Expired": "Pending  ",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                    new Padding(padding: EdgeInsets.only(right: 5,left: 10,top: 5,bottom: 5),
                                                      child: new Container(
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white
                                                        ),
                                                        padding: EdgeInsets.all(5),
                                                        child: new Icon( user.status == "published"?  Icons.check : Icons.refresh ,color: user.status == "published"?  Theme.of(context).primaryColor : Colors.yellow[700],size: 15,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                                onTap: (){
                                                },
                                              )
                                          ),
                                          DataCell(
                                              new Row(
                                                children: <Widget>[
                                                  new Container(
                                                    margin: EdgeInsets.only(right: 5),
                                                    child:  new InkWell(child:
                                                    new Container(
                                                      margin: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.all(Radius.circular(17))
                                                      ),
                                                      child: new Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: <Widget>[
                                                          new Padding(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text("Actions",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                          new Padding(padding: EdgeInsets.only(right: 0,left: 5,top: 5,bottom: 5),
                                                            child: new Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.white
                                                              ),
                                                              padding: EdgeInsets.all(5),
                                                              child: _EdittPopup(user),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                      onTap: (){
                                                      },
                                                    ) ,
                                                  ),
                                                  new Container(
                                                    margin: EdgeInsets.only(right: 5),
                                                    child:  new InkWell(child:
                                                    new Container(
                                                      margin: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: user.status == "published"? Colors.red : user.status == "expired"? Colors.yellow[700] : Theme.of(context).primaryColor,
                                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                                      ),
                                                      child: new Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: <Widget>[
                                                          new Padding(padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 5),child: new Text(user.status == "published"? "Cancel      ": user.status == "expired"? "Expired": "Publish Now",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                          new Padding(padding: EdgeInsets.only(right: 5,left: user.status == "published" ? 20 : 10,top: 5,bottom: 5),
                                                            child: new Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.white
                                                              ),
                                                              padding: EdgeInsets.all(5),
                                                              child: new Icon(user.status == "published"? Icons.cancel : user.status == "expired"? Icons.refresh : Icons.send ,color: user.status == "published"? Colors.red : user.status == "expired"? Colors.yellow : Theme.of(context).primaryColor,size: 15,),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                      onTap: (){
                                                      if(user.status != "expired")
                                                        Changeexamstatus(user,user.status == "published"?"expired": "published");
                                                      },
                                                    ) ,
                                                  ),
                                                  new Container(
                                                    margin: EdgeInsets.only(right: 5),
                                                    child:  new InkWell(child:
                                                    new Container(
                                                      margin: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                                      ),
                                                      child: new Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: <Widget>[
                                                          new Padding(padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 5),child: new Text("View Result",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                          new Padding(padding: EdgeInsets.only(right: 5,left: 10,top: 5,bottom: 5),
                                                            child: new Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.white
                                                              ),
                                                              padding: EdgeInsets.all(5),
                                                              child: new Icon(Icons.remove_red_eye ,color: Colors.green,size: 15,),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                      onTap: (){
                                                          getAnswersData(user.id);
                                                      },
                                                    ) ,
                                                  ),
                                                ],
                                              )
                                          ),
                                        ]),
                                  ).toList(),
                                ),
                              )),
                          ],
                        )),
                  ),
                ],
              ))
        ],
      ),
    );

  }

  String statusOfExam(String time, String dateOfExam) {
    String endtime = time.trim();
    if (endtime.length < 5)
      endtime = "0" + endtime;
    DateTime today = new DateTime.now();
    DateTime end = DateTime.parse(dateOfExam.trim() + " " + endtime + ":00");
    if (today.isAfter(end)) {
      return 'view';
    } else
      return 'wait';
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Onlineexams.forEach((vehicleDetail) {
      if (vehicleDetail.examanme.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.classname.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) )
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Onlineexams> _searchResult = [];
  List<Onlineexams> _Onlineexams = [];

}

class Onlineexams {
  String examanme, classname, subject, id,examdate,examtime,section,code,examto,minperc,instruction,status,totalamrks;

  Onlineexams({this.examanme, this.classname, this.subject, this.id,this.examdate,this.examtime,this.section,this.totalamrks,this.code,this.examto,this.minperc,this.instruction,this.status});

  factory Onlineexams.fromJson(Map<String, dynamic> json) {
    return new Onlineexams(
        classname: json['class_name'].toString(),
        subject: json['subject_name'].toString() ,
      section: json['section_name'].toString() ,
      examanme: json['title'].toString(),
        id: json['online_exam_id'].toString(),
        examdate: new DateFormat('dd-MM-yyyy').format(
            new DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(json['exam_date']) * 1000)).toString(),
        examtime: json['time_start'].toString(),
      code: json['code'].toString(),
      examto: json['time_end'].toString(),
      minperc: json['minimum_percentage'].toString(),
      instruction: json['instruction'].toString(),
      status: json['status'].toString(),

    );
  }
}