import 'dart:collection';
import 'dart:io';
import 'dart:math';
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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shape_of_view/shape_of_view.dart';
import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';
import '../dashboard.dart';

class Manage_HomeworkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Manage_HomeworkPageState();
}

class _Manage_HomeworkPageState extends State<Manage_HomeworkPage> {
  String exam = "",
      clas = '',
      section = '',classname='',sectionanme='',subjectname='';
  bool _loading = false,show=false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadCLassdetails();
  }

  Future<Null> LoadHomework(String load) async {
    String empid = await sp.ReadString("Userid");
    _Homeworkdetails.clear();
    if(load == "load")
      Constants().onLoading(context);
    var url = '';
    url = await Constants().Clienturl() + Constants.Display_homework_list;
    Map<String, String> body = new Map();
    if(load == "load") {
      body['login_user_id'] = empid;
//      body['subject_id'] = subjectmap[subject.text];
//      body['assign_date'] =
//      date == null ? "" : new DateFormat('dd-MM-yyyy').format(date);
    }

    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        if(load == "load")
          Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            setState(() {
              for (Map user in responseJson['result']) {
                _Homeworkdetails.add(Homeworkdetails.fromJson(user));
              }
            });
          }catch(e){
            setState(() {
              _Homeworkdetails = new List();
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
  Map classmap= new Map(),studentsmap= new Map(),subjectmap =new Map();
  List<String> classlist= new List(),studentslist = new List(),subjectsslist= new List() ;

  _navigatetoclasses(BuildContext context) async {
//    final result =  await Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
//    );
    String result = await Constants().Selectiondialog(context, "Classes", classlist);
    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
    if(result != null) {
      LoadSubjects(classmap[clas]);
    }
  }

  _navigatetosubjects(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Subjects", subjectsslist);
    setState(() {
      subject.text = result ?? subject.text;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  _navigatetostudents(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", studentslist);
    setState(() {
      section = result ?? section;
    });
    print("res--"+result.toString());
  }

  LoadCLassdetails() async{
    Map body = new Map();
    var url = await Constants().Clienturl() + Constants.Load_Classes;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result'] ['classes']) {
            classlist.add(data['name']);
            classmap[data['name']] = data['class_id'];
          }
        }
        LoadHomework("noload");
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadSubjects(String classid) async{
    subjectsslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['class_id'] = classid;
    var url = await Constants().Clienturl() + Constants.Load_Subjects;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['subject']) {
            subjectsslist.add(data['subject_name']);
            subjectmap[data['subject_name']] = data['subject_id'];
          }
          Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadStuents() async{
    studentslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();

    var url = await Constants().Clienturl() + Constants.Load_Sections+classmap[clas]+"/"+await Constants().Userid();
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['sections']) {
            studentslist.add(data['name']);
            studentsmap[data['name']] = data['section_id'];
          }
          Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }
  TextEditingController search = new TextEditingController();

  Widget _EdittPopup(Homeworkdetails homeworkdetails) => PopupMenuButton<int>(
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
                child: new Icon(FontAwesomeIcons.fileDownload,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("File Download",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
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
                child: new Icon(FontAwesomeIcons.user,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Assign To",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
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
          value: 4,
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
      if(value == 3)
        AddsHomeworkdialog("refresh","edit",homeworkdetails);
      else if(value == 4)
        deletedialog(homeworkdetails);
      else if(value == 2)
        AssignStudent(homeworkdetails);
      else if(value == 1)
        Download(homeworkdetails.docwork);
    },
  );

  Dio dio = new Dio();

  Future<Null> CreateHomework(String type,Homeworkdetails homeworkdetails) async {
    String empid = await sp.ReadString("Userid");
    Constants().onLoading(context);
    var url="";
    url = await Constants().Clienturl() + Constants.Manage_homework;

    Map<String,dynamic> body = new Map();
    body['login_user_id'] = empid;
    if(type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "update";
      body['hw_id'] = homeworkdetails.id;
    }

    body['class_id'] = classmap[clas];
    body['subject_id'] = subjectmap[subject.text];
    body['title'] = homeworktitle.text;
    body['assign_date'] = assigndate == null ? asigndate1 :  new DateFormat('dd-MM-yyyy').format(assigndate);
    body['due_date'] = duedate == null ? duedate1 :  new DateFormat('dd-MM-yyyy').format(duedate);
    body['description'] = note.text;
    body['userfile'] =  _file == null ? "" : new UploadFileInfo(_file, await AppUtil.getFileNameWithExtension(_file));

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
          Navigator.of(context).pop();
          if(type == "edit")
            Constants().ShowSuccessDialog(context, "Homework updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Homework added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadHomework("noload");
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

  deletedialog(Homeworkdetails Homeworkdetails) async {
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
                                      Delete(Homeworkdetails);
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

  Delete(Homeworkdetails Homeworkdetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['hw_id'] = Homeworkdetails.id;
    body['type_page'] = "delete";

    var  url = await Constants().Clienturl() + Constants.Manage_homework;

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
            LoadHomework("noload");
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

  DateTime assigndate = null;
  DateTime duedate = null;
  DateTime date = null;

  Future<Null> _selectDate(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != date) {
        print('date selected : ${date.toString()}');
        setState(() {
          date = picked;
        });
      }
    }catch(e){e.toString();}
  }

  Future<Null> _selectAssignDate(BuildContext context,String action,Homeworkdetails details) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != assigndate) {
        print('date selected : ${assigndate.toString()}');
        setState(() {
          assigndate = picked;
        });
      }
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pop();
      AddsHomeworkdialog("norefresh",action,details);
    }catch(e){e.toString();}
  }

  Future<Null> _selectDueDate(BuildContext context,String action,Homeworkdetails details) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != duedate) {
        print('date selected : ${duedate.toString()}');
        setState(() {
          duedate = picked;
        });
      }
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pop();
      AddsHomeworkdialog("norefresh",action,details);
    }catch(e){e.toString();}
  }

  File _file = null;
  String fileext= "",filename= "";
  Future _getFile(String action,Homeworkdetails details) async {
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop();
    AddsHomeworkdialog("norefresh",action,details);
  }

  TextEditingController homeworktitle= new TextEditingController(),subject = new TextEditingController(),note = new TextEditingController();
  String asigndate1="",duedate1="";
  AddsHomeworkdialog(String status,String action,Homeworkdetails details) async {
    String titlename = "Add Home Work";
    IconData icon;
    if(status == "refresh") {
      if(action == 'new') {
        homeworktitle.text = '';
        clas = "";
        subject.text = '';
        note.text = '';
        _file = null;
        assigndate = null;
        duedate = null;
        asigndate1="";
        duedate1="";
        titlename = "Add Home Work";
        icon = Icons.add;
      }
      else{
        homeworktitle.text = details.homework;
        clas = details.classname;
        subject.text = details.subject;
        note.text = details.description;
        _file = null;
        assigndate = null;
        duedate = null;
        asigndate1=details.assigndate;
        duedate1=details.duedate;
        titlename = "Edit Home Work";
        icon = Icons.edit;

        Map body = new Map();
        body['class_id'] = classmap[details.classname];
        var url = await Constants().Clienturl() + Constants.Load_Subjects;
        print("url--"+url+'body is${json.encode(body)} $body');
        http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
            .then((response) {
          if (response.statusCode == 200) {
            print("response --> ${response.body}");
            var responseJson = json.decode(response.body);
            if (responseJson['status'].toString() == "true") {
              print("response json ${responseJson}");
              for (Map data in responseJson['result']) {
                subjectsslist.add(data['name']);
                subjectmap[data['name']] = data['subject_id'];
              }
            }
          }
          else {
            print("erroe--"+response.body);
          }
        });
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
                              action == "new" ? Icons.add : Icons.edit,
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
                      labelText: "Home Work Title *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller:  homeworktitle,
                )),
                new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Class *",
                            prefixIcon: new Icon(FontAwesomeIcons.list),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
                        controller: TextEditingController(text: clas),
                        enabled: false,
                      ),
                      onTap: () {
                        _navigatetoclasses(context);
                      },
                    )),
                new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Subject *",
                            prefixIcon: new Icon(FontAwesomeIcons.list),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
                        controller: subject,
                        enabled: false,
                      ),
                      onTap: () {
                        _navigatetosubjects(context);
                      },
                    )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Assign Date *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: assigndate == null ? asigndate1 :  new DateFormat('dd-MMM-yyyy').format(assigndate)),
                      ),
                      onTap: (){
                        _selectAssignDate(context,action,details);
                      },
                    )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Due Date *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: duedate == null ? duedate1 :  new DateFormat('dd-MMM-yyyy').format(duedate)),
                      ),
                      onTap: (){
                        _selectDueDate(context,action,details);
                      },
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
                        _getFile(action,details);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Note ",
                      prefixIcon: new Icon(Icons.note)
                  ),
                  controller: note,
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
                                AddsHomeworkdialog("refresh",action,details);
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
                                if(homeworktitle.text == ''){
                                  Constants().ShowAlertDialog(context, "Please enter home work title");
                                  return;
                                }
                                if(clas == ''){
                                  Constants().ShowAlertDialog(context, "Please select class");
                                  return;
                                }
                                if(subject.text == ''){
                                  Constants().ShowAlertDialog(context, "Please select subject");
                                  return;
                                }
                                if(action == "new" && assigndate == null){
                                  Constants().ShowAlertDialog(context, "Please select assign date");
                                  return;
                                }
                                if(action == "new" && duedate == null){
                                  Constants().ShowAlertDialog(context, "Please select due time");
                                  return;
                                }
                                CreateHomework(action, details);
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

  bool checkall = false;
  AssignStudent(Homeworkdetails Homeworkdetails ) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Assigntostudents(classlist: classlist,classmap: classmap,details: Homeworkdetails,)
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Home Work List"),
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
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
              margin: EdgeInsets.only(top: 30),
              child: new Text("Home Work List",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
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
                          new SizedBox(height: 10,width: 10,),
                          new Padding(
                              padding: EdgeInsets.all(5.0),
                              child: new InkWell(
                                child: new TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "Class *",
                                      prefixIcon: new Icon(FontAwesomeIcons.user),
                                      suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                  ),
                                  controller: TextEditingController(text: classname),
                                  enabled: false,
                                ),
                                onTap: () {
                                  _navigatetoclasses(context);
                                },
                              )),
                          new Padding(
                              padding: EdgeInsets.all(5.0),
                              child: new InkWell(
                                child: new TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "Subject *",
                                      prefixIcon: new Icon(FontAwesomeIcons.list),
                                      suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                  ),
                                  controller: TextEditingController(text: subjectname),
                                  enabled: false,
                                ),
                                onTap: () {
                                  _navigatetosubjects(context);
                                },
                              )),
                          new Container(margin: new EdgeInsets.all(5.0),
                              child : new InkWell(
                                child: new TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Particular Date *',
                                    prefixIcon: new Icon(FontAwesomeIcons.calendar),
                                  ),
                                  enabled: false,
                                  controller: new TextEditingController(text: date == null ? "" :  new DateFormat('dd-MM-yyyy').format(date)),
                                ),
                                onTap: (){
                                  _selectDate(context);
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
                                            if(classname == ''){
                                              Constants().ShowAlertDialog(context, "Please select class");
                                              return;
                                            }
                                            if(subjectname == ''){
                                              Constants().ShowAlertDialog(context, "Please select subject");
                                              return;
                                            }
                                            if(date == null){
                                              Constants().ShowAlertDialog(context, "Please select particular date");
                                              return;
                                            }
                                            LoadHomework("load");
                                          },
                                          child: new Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor,
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
                          AddsHomeworkdialog("refresh","new",null);
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
                          hintText: 'Search ', border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
//                    trailing: new IconButton(
//                      icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                      onPressed: () {
//                        controller.clear();
//                        onSearchTextChanged('');
//                      },
//                    ),
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
                              new Expanded(child: new Padding(child: new Text("Home Work List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
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
                        child: _Homeworkdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                            : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: Text("S No",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Class",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Subject",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Home Work",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Assigned Date",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Due Date",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Note",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Created By",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Actions",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                            ],
                            rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                            _searchResult.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text((_searchResult.indexOf(user)+1).toString()),
                                    ),
                                    DataCell(
                                      Text(user.classname),
                                    ),
                                    DataCell(
                                      Text(user.subject),
                                    ),
                                    DataCell(
                                      Text(user.homework),
                                    ),
                                    DataCell(
                                      Text(user.assigndate),
                                    ),
                                    DataCell(
                                      Text(user.duedate),
                                    ),
                                    DataCell(
                                      Text(user.description),
                                    ),
                                    DataCell(Text(user.createdby),),
                                    DataCell(
                                      new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                    ),
                                  ]),
                            ).toList()
                                : _Homeworkdetails.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text((_Homeworkdetails.indexOf(user)+1).toString()),
                                    ),
                                    DataCell(
                                      Text(user.classname),
                                    ),
                                    DataCell(
                                      Text(user.subject),
                                    ),
                                    DataCell(
                                      Text(user.homework),
                                    ),
                                    DataCell(
                                      Text(user.assigndate),
                                    ),
                                    DataCell(
                                      Text(user.duedate),
                                    ),
                                    DataCell(
                                      Text(user.description),
                                    ),
                                    DataCell(Text(user.createdby),),
                                    DataCell(
                                      new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                    ),
                                  ]),
                            ).toList(),
                          ),
                        ),
                      ),
                      new Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: new Container(
                                  margin: new EdgeInsets.all(0.0),
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child:new InkWell(
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
                                              new Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                              new Padding(
                                                padding:
                                                EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  "Save",
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
                )
              ],
            ),
          )
        ],
      ),

    );
  }

  static const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');

  Future<Null> Download(String filename) async {
    if(filename != null) {
      var url = await Constants().Clienturl() +
          "api_admin/force_download/home_work/" + filename;
      print("downloadurl--" + url);
      Constants().onDownLoading(context);
      var appDocDir = await getExternalStorageDirectory();
      var path = appDocDir.path;
      new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
      String filePath = "$path/Edecofy/${filename}";
      File file = new File(filePath);
      if (!await file.exists()) {
        var httpClient = new HttpClient();
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        file.create();
        await file.writeAsBytes(bytes);
      }
      //OpenFile.open(filePath);
      var args = {'url': filePath};
      Navigator.of(context).pop();
      _channel.invokeMethod('openfile', args);
    }
    else
      Constants().ShowAlertDialog(context, "No file available to download.");
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Homeworkdetails.forEach((vehicleDetail) {
      if (vehicleDetail.subject.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.homework.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Homeworkdetails> _searchResult = [];
  List<Homeworkdetails> _Homeworkdetails = [];

}

class Assigntostudents extends StatefulWidget {
  final Homeworkdetails details;
  final Map classmap;
  final List classlist;
  Assigntostudents({this.classmap,this.details,this.classlist});

  @override
  State<StatefulWidget> createState() => new _AddlasssPagePageState();
}

class _AddlasssPagePageState extends State<Assigntostudents> with SingleTickerProviderStateMixin{
  bool _loading = false;
  String name = "";IconData icon = null;

  @override
  void initState() {
    super.initState();
  }

  Future<Null> AssignHomework() async {
    Constants().onLoading(context);
    var url="";
    url = await Constants().Clienturl() + Constants.Assign_homework_list;
    String empid = await sp.ReadString("Userid");

    Map body = new Map();
    body['login_user_id'] = empid;
    body['hw_id'] = widget.details.id;
    body['cls_id'] = widget.classmap[classname];
    body['section_id'] = sectionamp[section];
    List studentlist1 = new List();
    for(int i=0;i<studentlist.length;i++){
      if(studentlist[i]['check'] == true)
        studentlist1.add("student_"+studentlist[i]['student_id']);
    }
    body['student_id'] = json.encode(studentlist1);

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
          Constants().ShowSuccessDialog(context, responseJson['message']);

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
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

  List<String> sectionslist = new List();
  Map<String,String> sectionamp = new HashMap();
  String classname="",section="";

  _navigatetoclasses(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Classes", widget.classlist);
    setState(() {
      classname = result ?? classname;
    });
    print("res--"+result.toString());
    if(result != null) {
      LoadSections(widget.classmap[classname]);
    }
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      section = result ?? section;
    });
    print("res--"+result.toString());
    LoadStudents();
  }

  List studentlist = new List();
  Future<Null> LoadStudents() async {
    String empid = await sp.ReadString("Userid");
    var url = '';
    studentlist.clear();
    url = await Constants().Clienturl() + Constants.Load_AllStudents;
    Map<String, String> body = new Map();
    body['class_id'] = widget.classmap[classname];
    body['Section_id'] = sectionamp[section];

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body:body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            List list = responseJson['result'];
            for(int i=0;i<list.length;i++){
              list[i]['check'] = false;
            }
            setState(() {
              studentlist = list;
            });
          }catch(e){
            studentlist = new List();
          }
        }
        LoadAssignedhomework();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> LoadAssignedhomework() async {
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_homework_list;
    Map<String, String> body = new Map();
    body['hw_id'] = widget.details.id;
    body['cls_id'] = widget.classmap[classname];
    body['section_id'] = sectionamp[section];
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body:body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            List assignedlist = json.decode(responseJson['result']['assign_members']);
            for(int i=0;i<assignedlist.length;i++){
              for(int j=0;j<studentlist.length;j++){
                if(assignedlist[i].toString().split("_")[1] == studentlist[i]['student_id'])
                  studentlist[i]['check'] = true;
              }
            }
            setState(() {
              studentlist = studentlist;
            });
          }catch(e){
          }
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadSections(String classid) async{
    sectionslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['class_id'] = classid;
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            sectionslist.add(data['section_name']);
            sectionamp[data['section_name']] = data['section_id'];
          }
          Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }
  bool checkall = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      children: <Widget>[
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
                      FontAwesomeIcons.users,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(2),
                  ),flex: 2,
                ),
                Expanded(
                  child: new Container(child: new Text("Assign to Students",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                ),
                Expanded(
                  child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                )
              ],)),
        new SizedBox(height: 20,width: 20,),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Class *",
                    prefixIcon: new Icon(FontAwesomeIcons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: TextEditingController(text: classname),
                enabled: false,
              ),
              onTap: () {
                _navigatetoclasses(context);
              },
            )),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Section *",
                    prefixIcon: new Icon(FontAwesomeIcons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: TextEditingController(text: section),
                enabled: false,
              ),
              onTap: () {
                if(classname == ""){
                  Constants().ShowAlertDialog(context, "Please select class");
                  return;
                }
                _navigatetosections(context);
              },
            )),
        new SizedBox(height: 20,width: 20,),
        new Container(
          color: Theme.of(context).primaryColor,
          child: new Row(
            children: <Widget>[
              new Text("Student List",style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
              new Padding(padding: EdgeInsets.only(left: 5),child: new Icon(Icons.subdirectory_arrow_right,color: Colors.white,),)
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        ),
        new Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey[200]),
            color: Colors.white,
          ),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: new Container(
                decoration: new BoxDecoration(
                    border: new Border(right: BorderSide(
                        color: Colors.grey[200],
                        style: BorderStyle.solid))
                ),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: checkall,
                      onChanged: (val) {
                        setState(() {
                          checkall = val;
                          for(int i=0;i<studentlist.length;i++){
                            studentlist[i]['check'] = val;
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Check All",
                        style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                padding: new EdgeInsets.all(2.0),
              ), flex: 4,),
              new Expanded(child: new Container(
                decoration: new BoxDecoration(
                    border: new Border(right: BorderSide(
                        color: Colors.grey[200],
                        style: BorderStyle.solid))
                ),
                child: new Text(
                  "Students",
                  style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                padding: new EdgeInsets.all(2.0),
              ), flex: 6,),
            ],
          ),
        ),
        new Expanded(
          child: studentlist.length == 0
              ? new Container(
            child: new Center(
              child: new Text(
                "No Records found",
                style: new TextStyle(
                    fontSize: 16.0, color: Colors.red),
              ),
            ),
          )
              : new ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: studentlist.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.grey[200]),
                  color: Colors.white,
                ),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(child:
                    new Container(
                        decoration: new BoxDecoration(
                            border: new Border(right: BorderSide(
                                color: Colors.grey[200],
                                style: BorderStyle.solid))
                        ),
                        child:  Checkbox(
                          value: studentlist[index]['check'],
                          onChanged: (val) {
                            setState(() {
                              studentlist[index]['check'] = val;
                            });
                          },
                        )), flex: 4,),
                    new Expanded(child: new Container(
                      child: new Text(
                        studentlist[index]['full_name'],
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                        maxLines: 1,),
                      padding: new EdgeInsets.all(2.0),
                    ), flex: 6,),
                  ],
                ),
              );
            },
          ),
        ),
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
                        bool check = true;
                        for(int i=0;i<studentlist.length;i++){
                          if(studentlist[i]['check'] == true)
                            check = false;
                        }
                        if(check){
                          Constants().ShowAlertDialog(context, "Please select atleast one student.");
                          return;
                        }
                        AssignHomework();
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
                              new Icon(Icons.send,color: Colors.white,),
                              new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Send",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
                            ],
                          )))),flex: 1,),
            ],
          ),
        )
      ],
    );
  }

}

class Homeworkdetails {
  String description, homework, classname,subject,id,assigndate,duedate,docwork,createdby;

  Homeworkdetails({this.description, this.homework, this.classname,this.subject,this.id,this.assigndate,this.duedate,this.docwork,this.createdby});

  factory Homeworkdetails.fromJson(Map<String, dynamic> json) {
    return new Homeworkdetails(
      homework: json['title'].toString() ,
      id:  json['hw_id'].toString() ,
      subject: json['subject_name'].toString(),
      classname: json['class_name'].toString(),
      assigndate: json['assign_date'].toString(),
      duedate: json['due_date'].toString(),
      description: json['description'].toString(),
      docwork: json['doc_work'].toString(),
      createdby: json['created_by_name'].toString(),

    );
  }
}
