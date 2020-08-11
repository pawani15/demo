import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:Edecofy/FilePicker.dart';
import 'package:Edecofy/Teacher/sample.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../AppUtils.dart';
import '../const.dart';

class AdminCourseList1Page extends StatefulWidget {
  final String id;
  AdminCourseList1Page({this.id});
  @override
  State<StatefulWidget> createState() => new _AdminCourseList1PageState();
}

class _AdminCourseList1PageState extends State<AdminCourseList1Page>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  String clas = '', subject = '', file = '', discription = '', topic = '';
  Map classmap = new Map(), subjectsmap = new Map();
  TextEditingController controller = new TextEditingController();
  TextEditingController title = new TextEditingController(),
      priority = new TextEditingController();

  List<String> classlist = new List(), subjectsslist = new List();
  Dio dio = new Dio();
  File _file = null;
  String fileext = "", filename = "", clienturl = '';

  Future _getFile(String action, Topic details) async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);

    Navigator.of(context).pop();
    AddLmsVideodialog("norefresh", action, details);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadCourseList();
  }

  AddLmsVideo(topicDetails, String type) async {
    Constants().onLoading(context);
    Map<String, dynamic> body = new Map();
    body['topic_id'] = topicDetails.topicid;
    body['course_id'] = widget.id;
    body['title'] = title.text;
    body['priority'] = priority.text;
    body['userfile'] = new UploadFileInfo(
        _file, await AppUtil.getFileNameWithExtension(_file));
    print("body" + body.toString());
    var url =
        await Constants().Clienturl() + Constants.Admin_Add_Video + widget.id;
    print("pawani" + url);
    if (type == "edit")
      // body["video_id"];
      url = await Constants().Clienturl() +
          Constants.Admin_Update_Video_list +
          widget.id;
    print("url--" + url + 'body is $body');
    /*http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {*/
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 120000; //5s
    dio.options.receiveTimeout = 5000;
    FormData formData = new FormData.from(body);
    // Send FormData
    try {
      Response response = await dio.post("", data: formData);
      if (response.statusCode == 200) {
        print("response --> ${response.data}");
        if (response != null) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          if (type == "edit")
            Constants()
                .ShowSuccessDialog(context, "Courses  updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Courses added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadCourseList();
          }

          new Timer(duration, handleTimeout);
        } else {
          Constants().ShowAlertDialog(context, "Courses not added succesfully");
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.data);
      }
    } catch (e) {
      print("imaguploadresponse-->${e}");
    }
    //});
  }

  DeleteLmsVideo(Topic details) async {
    Constants().onLoading(context);
    Map body = new Map();
    body["course_id"] = details.courseid;
    body['topic_id'] = details.topicid;
    var url = await Constants().Clienturl() +
        Constants.Admin_Delete_Lms_topic +
        details.courseid;
    print("url--" + url + 'body is${json.encode(body)} $body');
    http
        .post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          Navigator.of(context).pop();
          Constants().ShowSuccessDialog(context, responseJson['result']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadCourseList();
          }

          new Timer(duration, handleTimeout);
        } else {
          Constants().ShowAlertDialog(context, responseJson['result']);
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  AddLmsVideodialog(String status, String action, details) async {
    print("pawani" + details.toString());
    if (status == "refresh") {
      if (action == 'new') {
        title.text = '';
        priority.text = '';
        file = '';
        _file = null;
      } else {
        title.text = details.title;
        priority.text = details.priority;
        file = "";
        _file = null;
      }
    }

    IconData icon = null;
    String titlename = '';
    if (action == 'new') {
      icon = Icons.add;
      titlename = "Add  Video";
    } else {
      icon = Icons.edit;
      titlename = "Edit Video";
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
                              icon,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 2),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: new Container(
                            child: new Text(
                              titlename,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            margin: EdgeInsets.only(left: 5),
                          ),
                          flex: 8,
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
                    margin: EdgeInsets.all(5.0),
                    child: new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Title *",
                          prefixIcon: new Icon(FontAwesomeIcons.userAlt)),
                      controller: title,
                    )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Priority *",
                          prefixIcon: new Icon(FontAwesomeIcons.userAlt)),
                      controller: priority,
                    )),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: new InkWell(
                    child: new TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Upload video *",
                          prefixIcon: new Icon(FontAwesomeIcons.upload),
                          suffixIcon: _file == null
                              ? new Icon(Icons.cloud_upload)
                              : new ClipOval(
                                  child: new Image.file(
                                  _file,
                                  scale: 25,
                                ))),
                      controller: TextEditingController(
                          text: _file == null ? "" : filename),
                      enabled: false,
                    ),
                    onTap: () {
                      _getFile(action, details);
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
                                  if (title.text == "") {
                                    Constants().ShowAlertDialog(
                                        context, "please enter title");
                                    return;
                                  }
                                  if (_file == null) {
                                    Constants().ShowAlertDialog(
                                        context, "please select File");
                                    return;
                                  }
                                  AddLmsVideo(details, action);
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
                                            "Update",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11),
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

  delete_lms_videoDialogdialog(details) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
          backgroundColor: Colors.transparent,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Stack(children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 5.0,
                          ),
                        ]),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new SizedBox(
                          width: 20,
                          height: 20,
                        ),
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
                        new SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        new Container(
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Center(
                                child: new Text(
                              "Are you sure, you want to delete this file?",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ))),
                        new SizedBox(
                          width: 20,
                          height: 20,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new InkWell(
                                onTap: () {
                                  DeleteLmsVideo(details);
                                },
                                child: new Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        )
                                      ],
                                    )))
                          ],
                        ),
                        new SizedBox(
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  new Align(
                      alignment: Alignment.topRight,
                      child: new InkWell(
                        child: new Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 5.0,
                                ),
                              ]),
                          child: new Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ))
                ])
              ]),
        );
      },
    );
  }

  Future<Null> LoadCourseList() async {
    _course_topic_details.clear();
    //String id = await sp.ReadString("Userid");
    var url =
        await Constants().Clienturl() + Constants.Admin_Get_CourseTopic_List;
    Map<String, String> body = new Map();
    body['course_id'] = widget.id;
    print("url is $url" + "body--" + body.toString());
    http
        .post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            setState(() {
              for (Map user in responseJson['result']['image_topic']) {
                _course_topic_details.add(CourseTopicdetails.fromJson(user));
              }
              for (Map user in responseJson['result']['topics']) {
                topic_details.add(Topic.fromJson(user));
              }
            });
          } catch (e) {
            print("err---" + e.toString());
            _course_topic_details = new List();
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

  Future<Null> LoadVideoList(Topic details) async {
    _video_details.clear();
    //String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Admin_get_videoList;
    Map<String, String> body = new Map();
    body['course_id'] = details.courseid;
    body['topic_id'] = details.topicid;
    print("url is $url" + "body--" + body.toString());
    http
        .post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            setState(() {
              for (Map user in responseJson['result']) {
                _video_details.add(Videos.fromJson(user));
              }
              print('length in api got::'+_video_details.length.toString());
            });
          } catch (e) {
            print("err---" + e.toString());
            _video_details = new List();
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

//      if (response.statusCode == 200) {
//        print("response --> ${response.body}");
//        var responseJson = json.decode(response.body);
//        if (responseJson['status'].toString() == "true") {
//          print("response json ${responseJson}");
//          try {
//            setState(() {
//              for (Map user in responseJson['result']['topics']) {
//                _course_topic_details.add(CourseTopicdetails.fromJson(user));
//              }
//            });
//            for(int i=0;i<_course_topic_details.length;i++){
//              var url1 = clienturl + Constants.Admin_Get_Course_VideoList+widget.id+"/"+_course_topic_details[i].topicid;
//              http.get(
//                url1,
//                headers: {"Content-Type": "application/x-www-form-urlencoded"},
//              ).then((response) {
//                if (response.statusCode == 200) {
//                  print("response --> ${response.body}");
//                  var responseJson = json.decode(response.body);
//                  if (responseJson['status'].toString() == "true") {
//                    setState(() {
//                      _course_topic_details[i].vedios = responseJson['result'];
//                    });
//                  }
//                  else{
//                    setState(() {
//                      _course_topic_details[i].vedios = new List();
//                    });
//                  }
//
//                } else {
//                  print("erroe--" + response.body);
//                }
//              });
//            }
//          } catch (e) {
//            print("err---"+e.toString());
//            _course_topic_details = new List();
//          }
//        }
//        setState(() {
//          _loading = false;
//        });
//      } else {
//        print("erroe--" + response.body);
//      }

  List<Widget> GetVedioslist(Topic details) {
    LoadVideoList(details);
    print('length got is ::::::: '+_video_details.length.toString());
    return _video_details.length == 0
        ? List.generate(
            1,
            (j) => new Text(
                  "No records found",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                  textAlign: TextAlign.center,
                ))
        : List.generate(
            _video_details.length,
            (index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.play_circle_filled,
                      color: Colors.indigo[800],
                      size: 20,
                    ),
                    Text(
                      _video_details[index].title.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.indigo[800],
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      _video_details[index].size.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigo[800],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.delete,
                      color: Colors.indigo[800],
                      size: 18,
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.rate_review,
                      color: Colors.indigo[800],
                      size: 18,
                    ),
                  ],
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text("Learning Management System"),
        backgroundColor: Color(0xff182C61),
      ),
      drawer: Constants().drawer(context),
      body: _loading
          ? Constants().bodyProgress
          : Stack(children: <Widget>[
              new Card(
                margin: new EdgeInsets.only(
                    left: 20, right: 20, bottom: 10, top: 20),
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
              Container(
                margin: new EdgeInsets.only(
                    left: 10, right: 5, bottom: 10, top: 85),
                child: Stack(children: <Widget>[
                  new Card(
                      elevation: 5.0,
                      margin: new EdgeInsets.only(top: 10, right: 10),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey,
                              image: DecorationImage(
                                image: new NetworkImage(
                                    _course_topic_details[0].image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _course_topic_details[0].title,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: Colors.indigo[800]),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            _course_topic_details[0].description,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.grey),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.indigo[800],
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              Text(
                                "PHP Learning videos",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.indigo[800]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Card(
                              elevation: 5.0,
                              margin: new EdgeInsets.only(top: 5, right: 10),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return new ExpansionTile(
                                    title: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.green[600],
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            topic_details[index].title,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              print("topic");
                                              AddLmsVideodialog("refresh",
                                                  'new', topic_details[index]);
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              delete_lms_videoDialogdialog(
                                                  topic_details[index]);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              print("topic");
//                                            Navigator.of(context).pop();
//                                            Navigator.of(context).push(new MaterialPageRoute(
//                                                builder: (BuildContext context) =>
//                                                new VideoPlayerScreen()
//                                            ));
                                              AddLmsVideodialog("refresh",
                                                  'edit', topic_details[index]);
                                              VideoPlayerScreen();
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(height: 1, width: 1),
                                      children:GetVedioslist(topic_details[index])
                                  );
                                },
                                itemCount: topic_details.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                              ),
                            ),
                          ),
                        ],
                      )),
                ]),
              ),
            ]),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _course_topic_details.forEach((vehicleDetail) {
      if (vehicleDetail.courseid.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.topicid.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.image.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<CourseTopicdetails> _searchResult = [];
  List<CourseTopicdetails> _course_topic_details = [];
  List<Videos> _video_details = [];
  List<Topic> topic_details = [];
}

class CourseTopicdetails {
  String topicid,
      courseid,
      image,
      filename,
      priority,
      description,
      title,
      fileurl;

  List<Topic> topics;
  List vedios;

  CourseTopicdetails(
      {this.topics,
      this.topicid,
      this.courseid,
      this.image,
      this.description,
      this.priority,
      this.title,
      this.vedios});

  factory CourseTopicdetails.fromJson(Map<String, dynamic> json) {
    return new CourseTopicdetails(
        topicid: json['topic_id'].toString(),
        courseid: json['course_id'].toString(),
        priority: json['priority'].toString(),
        description: json['description'].toString(),
        image: json['image_path'].toString(),
        title: json['title'].toString(),
        vedios: new List());
  }
}

class Topic {
  String topicid, courseid, priority, title, videos_count;

  Topic(
      {this.topicid,
      this.courseid,
      this.priority,
      this.title,
      this.videos_count});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return new Topic(
      topicid: json['topic_id'].toString(),
      courseid: json['course_id'].toString(),
      priority: json['priority'].toString(),
      title: json['topic_title'].toString(),
      videos_count: json['videos_count'].toString(),
    );
  }
}

class Videos {
  String videoid,
      topicid,
      courseid,
      priority,
      title,
      video,
      size,
      video_id,
      video_path,
      videos_count;

  Videos(
      {this.topicid,
      this.courseid,
      this.priority,
      this.title,
      this.video,
      this.video_id,
      this.video_path,
      this.size,
      this.videos_count});

  factory Videos.fromJson(Map<String, dynamic> json) {
    return new Videos(
      video_id: json['video_id'].toString(),
      courseid: json['course_id'].toString(),
      priority: json['priority'].toString(),
      topicid: json['video_id'].toString(),
      title: json['topic_title'].toString(),
      video_path: json['video_path'].toString(),
      size: json['size'].toString(),
      videos_count: json['videos_count'].toString(),
    );
  }
}
