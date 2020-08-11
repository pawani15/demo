import 'dart:collection';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';
import '../search.dart';
import 'lms_add video.dart';

class AdminCourseListPage extends StatefulWidget {
  final String id;

  AdminCourseListPage({this.id});

  @override
  State<StatefulWidget> createState() => new _AdminCourseListPageState();
}

class _AdminCourseListPageState extends State<AdminCourseListPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _loading = false;
  String clas = '', subject = '', title = '', file = '', discription = '', priority ='',topic='';
  Map classmap = new Map(), subjectsmap = new Map();
  TextEditingController controller = new TextEditingController();
  List<String> classlist = new List(), subjectsslist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadCLassdetails();
  }

  Dio dio = new Dio();
  File _file = null;
  String fileext = "", filename = "";

  Future _getFile() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
    filename.replaceAll(" ", "%20");
    Navigator.of(context).pop();
    AddCoursesdialog("norefresh");
  }

  AddCourse() async {
    Constants().onLoading(context);
    Map<String, dynamic> body = new Map();
    // body['teacher_id'] = await Constants().Userid();
    body['title'] = title;
    body['class_id'] = classmap[clas];
    body['subject_id'] = subject == "" ? "" : subjectsmap[subject];
    body['userfile'] = new UploadFileInfo(
        _file, await AppUtil.getFileNameWithExtension(_file));
    body['description'] = discription;
    body['priority']=priority;
    var url =
        await Constants().Clienturl() + Constants.Admin_Create_Lms_CourseList;
    print("url--" + url + 'body is $body');
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 120000; //5s
    dio.options.receiveTimeout = 5000;
    FormData formData = new FormData.from(body);
    // Send FormData
    try {
      Response response = await dio.post("", data: formData);
      if (response.statusCode == 200) {
        print("response --> ${response.data}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.data);
        if (responseJson['status'].toString() == "true") {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AdminCourseListPage()));
        } else {
          Constants().ShowAlertDialog(context, "Courses not added succesfully");
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.data);
      }
    } catch (e) {
      print("videouploadresponse-->${e}");
    }
  }

  AddTopic(String id,context,String type) async {
    Constants().onLoading(context);
    Map<String, dynamic> body = new Map();
    // body['teacher_id'] = await Constants().Userid();
    body['course_id'] =id;// how to map the course id
    body['title'] = topic;
    body['priority']=priority;
    var url = await Constants().Clienturl() + Constants.Admin_Create_LmsTopicList;
    print("url--" + url + 'body is $body');
    if(type == "edit")
      //body["topic_id"]=;
    url = await Constants().Clienturl() + Constants.Admin_Update_Lms_Topic+widget.id;
    print("url--"+url+'body is $body');
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if(response != null){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          if(type == "edit")
            Constants().ShowSuccessDialog(context, "topic  updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "topic added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadCourseList();
          }
          new Timer(duration, handleTimeout);
        }
//        if (responseJson['status'].toString() == "true") {
//          print("response json ${responseJson}");
//          Navigator.of(context).pop();
//          Constants().ShowSuccessDialog(context, responseJson['result']);
//          const duration = const Duration(seconds: 1);
//          void handleTimeout() {
//            // callback function
//           // Navigator.of(context).pop();
//            LoadCourseList();
//          }
//          new Timer(duration, handleTimeout);
//        }
        else{
          Constants().ShowAlertDialog(context, responseJson['result']);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });

  }

  AddTopicsdialog(String status, String action,String id) async {
    print("status"+status);
    print("id"+id);
    if(status == "refresh") {
      if(action == 'new') {
        topic = '';
        priority ='';

      }
      else{
        topic = '';
        priority ='';
      }
    }
    IconData icon = null;String titlename = '';
    if(action == 'new') {
      icon = Icons.add;
      titlename = "Add Toipc";
    }
    else{
      icon = Icons.edit;
      titlename = "Edit Delete";
    }
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.all(5.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: new Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor),
                            child: new Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),
                          flex:1 ,
                        ),
                        Expanded(
                          child: new Container(
                            child: new Text(
                              "Add Topic",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            margin: EdgeInsets.only(left: 5),
                          ),
                          flex: 17,
                        ),

                        Expanded(
                          child: new InkWell(
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 25,
                              ),
                              onTap: () => Navigator.of(context).pop()),
                          flex: 1,
                        )
                      ],
                    )),
                new SizedBox(
                  height: 20,
                  width: 20,
                ),
                new Container(
                  margin: new EdgeInsets.all(5.0),
                  child: new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Topic *",
                      prefixIcon: new Icon(FontAwesomeIcons.userAlt),
                    ),
                    onChanged: (String val) {
                      topic = val;
                    },
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(5.0),
                  child: new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "priority *",
                      prefixIcon: new Icon(FontAwesomeIcons.userAlt),
                    ),
                    onChanged: (String val) {
                      priority = val;
                    },
                  ),
                ),
                new SizedBox(
                  width: 30,
                  height: 30,
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
                            child: new InkWell(
                                onTap: () {
                                  if (topic == "") {
                                    Constants().ShowAlertDialog(
                                        context, "please enter topic");
                                    return;
                                  }
                                  AddTopic(id,context,action);
                                },
                                child: new Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                        )),
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "Add Course",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
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
            ));
      },
    );
  }

  _navigatetoclasses(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
    );
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Search(
            title: "Subjects",
            duplicateitems: subjectsslist,
          )),
    );
    setState(() {
      subject = result ?? subject;
    });
    print("res1--" + result.toString());
  }

  AddCoursesdialog(String status) async {
    if (status == "refresh") {
      clas = '';
      subject = '';
      title = '';
      _file = null;
      discription = '';
    }
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.all(5.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: new Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor),
                            child: new Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: new Container(
                            child: new Text(
                              "Add Course",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            margin: EdgeInsets.only(left: 5),
                          ),
                          flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 25,
                              ),
                              onTap: () => Navigator.of(context).pop()),
                          flex: 1,
                        )
                      ],
                    )),
                new SizedBox(
                  height: 20,
                  width: 20,
                ),
                new Container(
                  margin: new EdgeInsets.all(5.0),
                  child: new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Title *",
                      prefixIcon: new Icon(FontAwesomeIcons.userAlt),
                    ),
                    onChanged: (String val) {
                      title = val;
                    },
                  ),
                ),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Class *",
                            prefixIcon:
                            new Icon(FontAwesomeIcons.chalkboardTeacher),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)),
                        controller: TextEditingController(text: clas),
                        enabled: false,
                      ),
                      onTap: () {
                        _navigatetoclasses(context);
                      },
                    )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Subject *",
                            prefixIcon: new Icon(Icons.subject),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)),
                        controller: TextEditingController(text: subject),
                        enabled: false,
                      ),
                      onTap: () {
                        if (clas == '') {
                          Constants()
                              .ShowAlertDialog(context, "Please select Class");
                          return;
                        }
                        _navigatetosubjects(context);
                      },
                    )),
                new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Upload File *",
                            prefixIcon: new Icon(FontAwesomeIcons.fileUpload),
                            suffixIcon: _file == null
                                ? new Icon(Icons.cloud_upload)
                                : fileext == "jpg" || fileext == "png"
                                ? new Image.file(
                              _file,
                              scale: 25,
                            )
                                : new Icon(Icons.cloud_upload)),
                        controller: TextEditingController(
                            text: _file == null ? "" : filename),
                        enabled: false,
                      ),
                      onTap: () {
                        _getFile();
                      },
                    )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Description *",
                          prefixIcon: new Icon(Icons.message)),
                      onChanged: (String val) {
                        discription = val;
                      },
                    )),
                new Container(
                  margin: new EdgeInsets.all(5.0),
                  child: new TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "priority ",
                      prefixIcon: new Icon(FontAwesomeIcons.userAlt),
                    ),
                    onChanged: (String val) {
                      priority= val;
                    },
                  ),
                ),
                new SizedBox(
                  width: 30,
                  height: 30,
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
                            child: new InkWell(
                                onTap: () {
                                  if (title == "") {
                                    Constants().ShowAlertDialog(
                                        context, "please enter title");
                                    return;
                                  }
                                  if (clas == "") {
                                    Constants().ShowAlertDialog(
                                        context, "please select class");
                                    return;
                                  }
                                  if (_file == null) {
                                    Constants().ShowAlertDialog(
                                        context, "please select File");
                                    return;
                                  }
                                  AddCourse();
                                },
                                child: new Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                        )),
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "Add Course",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
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
            ));
      },
    );
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
            classlist.add(data['class_id']);
            classmap[data['class_id']] = data['class_id'];
          }
        }
        LoadCourseList();
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
    var url = await Constants().Clienturl() + Constants.Load_Subjects_Admin;
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
            subjectsmap[data['name']] = data['subject_id'];
          }
          Navigator.of(context).pop();
        }
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> LoadCourseList() async {
    _coursedetails.clear();
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Admin_Get_CourseList;
    Map<String, String> body = new Map();
    //   body['teacher_id']=id;
    print("abc:::::" + id);
    print("url is $url" + "body--" + body.toString());
    http.get(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    ).then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            setState(() {
              for (Map user in responseJson['result']) {
                _coursedetails.add(Coursedetails.fromJson(user));
              }
            });
            print("len" + _coursedetails.length.toString());
          } catch (e) {
            print(e.toString());
            _coursedetails = new List();
          }
        }
        setState(() {
          _loading = false;
        });
      } else {
        print("erroe--" + response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
       appBar: new AppBar(
    title: Text("Learning Management System"),
    backgroundColor: Color(0xff182C61),
    ),
    drawer: Constants().drawer(context),
    body:new Stack(
        children: <Widget>[
          new Card(
            margin:
            new EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              title: new TextField(
                // controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search', border: InputBorder.none),
                // onChanged: onSearchTextChanged,
              ),
//              trailing: new IconButton(
//                icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                onPressed: () {
//                  controller.clear();
//                  onSearchTextChanged('');
//                },
//              ),
            ),
          ),
          new Container(
              margin:
              new EdgeInsets.only(left: 10, right: 5, bottom: 10, top: 75),
              child: new Stack(
                children: <Widget>[
                  new Card(
                      elevation: 5.0,
                      margin: new EdgeInsets.only(top: 10, right: 10),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),

                      child: ListView.builder(
                        itemCount: _coursedetails.length,
                        itemBuilder: (context, i) {
                          return    Card(
                            elevation: 5.0,
                            margin: new EdgeInsets.only(top: 10, right: 10),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    AdminCourseList1Page();
                                  },
                                  child: new Container(margin: EdgeInsets.only(top: 10.0),
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: new DecorationImage(
                                        fit: BoxFit.fill,
                                          image: new NetworkImage(_coursedetails[i].image)
                                      ),

                                    ),
                                  ),
                                ),
                                new Container(margin: EdgeInsets.all(5.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(_coursedetails[i].title),
                                      Text(_coursedetails[i].description),
                                    ],
                                  ),
                                ),

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
                                              //  Navigator.of(context).pop();
                                                AddTopicsdialog("refresh","new",_coursedetails[i].courseid);

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
                                                      new Icon(
                                                        Icons.add_circle, color: Colors.white,),
                                                      new Padding(
                                                        padding: EdgeInsets.only(left: 5.0),
                                                        child: Text("Add Topic", style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 11),),)
                                                    ],
                                                  )))), flex: 1,),
                                      new Expanded(child: new Container(
                                          margin: new EdgeInsets.all(0.0),
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          child: new InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                    new AdminCourseList1Page(id:_coursedetails[i].courseid)));

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
                                                      new Icon(Icons.check, color: Colors.white,),
                                                      new Padding(
                                                        padding: EdgeInsets.only(left: 5.0),
                                                        child: Text("View Topics", style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 11),),)
                                                    ],
                                                  )))), flex: 1,),
                                    ],
                                  ),
                                )
                              ],
                            ),

                          );
                        },
                      )),

                ],
              )),
          new Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: new InkWell(
                  child: new Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.yellow[800],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 5.0,
                          ),
                        ]),
                    child: new Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    AddCoursesdialog("refresh");
                  },
                ),
              ))
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

    _coursedetails.forEach((vehicleDetail) {
      if (vehicleDetail.courseid.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.title.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.assignby.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Coursedetails> _searchResult = [];
  List<Coursedetails> _coursedetails = [];
}

class Coursedetails {
  String id,
      title,
      courseid,
      image,
      date,
      description,
      filename,
      fileurl,
      sno,
      duedt,
      assignby;

  Coursedetails(
      {this.sno,
        this.title,
        this.description,
        this.id,
        this.courseid,
        this.image,
        this.duedt,
        this.date,
        this.filename,
        this.fileurl,
        this.assignby});

  factory Coursedetails.fromJson(Map<String, dynamic> json) {
    return new Coursedetails(
//      id: json[''].toString() ,
      courseid: json['course_id'].toString(),
      title: json['title'].toString(),
      //assigndt: json['assign_dt'].toString(),
      //duedt: json['due_dt'].toString(),
      description: json['description'].toString(),
      filename: json['file_name'].toString(),
      //date:json['date'].toString(),
      image: json['image_path'].toString(),
      fileurl: json['hw_id'].toString(),
      //sno: no.toString(),
    );
  }
}
