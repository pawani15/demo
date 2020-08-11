import 'dart:collection';
import 'dart:io';

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

import '../const.dart';
import '../dashboard.dart';
import '../questionpaper_teacher.dart';
import '../search.dart';

class Questionpaper_AdminPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _Questionpaper_AdminPageState();
}

class _Questionpaper_AdminPageState extends State<Questionpaper_AdminPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String clas = '' , exam = '' ;
  TextEditingController title = new TextEditingController(), description=new TextEditingController();
  DateTime date = new DateTime.now();
  Map classmap= new Map(),exammap = new Map(),revclassmap= new Map(),revexammap = new Map();
  List<String> filetypelist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadExams();
  }

  LoadCLassdetails() async{
    Map body = new Map();
    body['id'] = await Constants().Userid();

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
            revclassmap[data['class_id']] = data['class_name'];
          }
        }
        Loadteachers();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

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
            revteachersmap[data['teacher_id']] = data['name'];
          }
        }
       LoadQuestionppapers();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadExams() async{
    examslist.clear();
    Map body = new Map();
    var url = await Constants().Clienturl() + Constants.Load_Exams_Admin;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            examslist.add(data['name']);
            exammap[data['name']] = data['exam_id'];
            revexammap[data['exam_id']] = data['name'];
            print("pawani:::::$revclassmap]");
          }
        }
        LoadCLassdetails();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> LoadQuestionppapers() async {
    _Questionpaperdetails.clear();
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Questionpaper_Admin;
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
              int i=1;
              for (Map user in responseJson['result']) {
                _Questionpaperdetails.add(Questionpaperdetails.fromJson(user,i));
                i++;
              }
            });
          }catch(e){
            _Questionpaperdetails = new List();
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

  Addquestionpaper(Questionpaperdetails questionpaperdetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['title'] = title.text;
    body['class_id'] = classmap[clas];
    body['exam_id'] = exam == "" ? "" : exammap[exam];
    body['description'] = description.text;

    var url = await Constants().Clienturl() + Constants.Add_Questionpapers_Teacher+await Constants().Userid();

    if(questionpaperdetails !=null)
      url = await Constants().Clienturl() + Constants.Update_Questionpapers_Teacher+questionpaperdetails.id;

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
          Constants().ShowSuccessDialog(context, responseJson['result']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadQuestionppapers();
          }
          new Timer(duration, handleTimeout);
        }
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

  Deletequestionpaper(Questionpaperdetails questionpaperdetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    var  url = await Constants().Clienturl() + Constants.Delete_Questionpapers_Teacher+questionpaperdetails.id;

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
          Constants().ShowSuccessDialog(context, responseJson['result']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadQuestionppapers();
          }
          new Timer(duration, handleTimeout);
        }
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

  displayquestionpaper(Questionpaperdetails questionpaperdetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    var  url = await Constants().Clienturl() + Constants.Display_Questionpapers_Teacher+questionpaperdetails.id;

    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          List list = responseJson['result']['edit_data'];
          displayQuestionpaperdialog(list);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Widget _EdittPopup(int position, Questionpaperdetails questionpaperdetails) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 1,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right:4),child: new Icon(Icons.file_download,color: Theme.of(context).primaryColor,),),
              Expanded(child: new Text("Download Question Paper")),
            ],
          )
      ),
      /*PopupMenuItem(
        value: 2,
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
        value: 3,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.trash,color:Colors.red),),
            new Text("Delete"),
          ],
        )
      ),*/
    ],
    elevation: 5,
    padding: EdgeInsets.symmetric(horizontal: 20),
    onSelected: (value) {
      print(value);
      if(value == 1)
        Download(questionpaperdetails.questionpaper);
      if(value == 2)
        AddQuestionpaperdialog("refresh", "Edit", questionpaperdetails);
      if(value == 3)
        deleteQuestionpaperdialog(questionpaperdetails);
    },
  );

List<String> classlist= new List(),examslist= new List();
  List<String> teacherslist = new List();
  Map<String,String> teachersmap = new HashMap(),revteachersmap = new HashMap();

  _navigatetoclasses(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
    );
    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    LoadExams();
  }

  _navigatetoexams(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Exams",duplicateitems: examslist,)),
    );
    setState(() {
      exam = result ?? exam;
    });
    print("res--"+result.toString());
  }

  deleteQuestionpaperdialog(Questionpaperdetails questionpaperdetails) async {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new Row(crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                      new IconButton(icon: new Icon(Icons.close,color: Colors.red,size: 35,), onPressed: () => Navigator.of(context).pop() )
                      ],)),
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
                new SizedBox(width: 20,height: 20,),
                new Container(padding: EdgeInsets.all(5), child: new Text("Are you sure, you want to delete this file?",style: TextStyle(fontSize: 16),)),
                new SizedBox(width: 20,height: 20,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new InkWell(
                        onTap: () {
                          Deletequestionpaper(questionpaperdetails);
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
            )

        );
      },
    );
  }

  displayQuestionpaperdialog(List paper) async {
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
                              FontAwesomeIcons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Question Paper Deatils",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 20,width: 20,),
                new Expanded(child: new Container(margin: EdgeInsets.all(5.0),
                    child:new ListView.builder(
                      itemBuilder:
                          (BuildContext context, int index) {
                        return new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text((index+1).toString()+")  "+paper[index]['title'],style: TextStyle(fontSize: 16),),
                            new SizedBox(height: 10,width: 10,),
                            new Text(paper[index]['question_paper'],style: TextStyle(fontSize: 10),),
                            new SizedBox(height: 10,width: 10,),
                          ],
                        );
                      },
                      itemCount: paper.length,
                    ))
                ),
                new SizedBox(width: 30,height: 30,),
                new Container(
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
                                  Radius.circular(15),bottomLeft:Radius.circular(15) )),
                            child: new Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                new Icon(Icons.print,color: Colors.white,),
                                new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Print Question Paper",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
                              ],
                            ))))
              ],
            )

        );
      },
    );
  }

  AddQuestionpaperdialog(String status,String action,Questionpaperdetails details) async {
    if(status == "refresh") {
      if(action == 'new') {
        clas = '';
        exam = '';
        title.text = '';
        description.text = '';
      }
      else{
        clas = details.classname;
        exam = details.exam;
        title.text = details.titile;
        description.text = details.questionpaper;
      }
    }

    IconData icon = null;String titlename = '';
    if(action == 'new') {
      icon = Icons.add;
      titlename = "Add Question Paper";
    }
    else{
      icon = Icons.edit;
      titlename = "Edit Question Paper";
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
                        margin: EdgeInsets.only(left: 2),
                      ),flex: 1,
                    ),
                  Expanded(
                    child: new Container(child: new Text(titlename,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 8,
                  ),
                    Expanded(
                      child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                    )
                ],)),
                new SizedBox(height: 20,width: 20,),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Title *",
                      prefixIcon: new Icon(FontAwesomeIcons.userAlt)
                  ),
                  controller: title,
                )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Class *",
                            prefixIcon: new Icon(FontAwesomeIcons.chalkboardTeacher),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
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
                            hintText: "Exam *",
                            prefixIcon: new Icon(Icons.subject),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
                        controller: TextEditingController(text: exam),
                        enabled: false,
                      ),
                      onTap: () {
                        if(clas == ''){
                          Constants().ShowAlertDialog(context, "Please select Class");
                          return;
                        }
                        _navigatetoexams(context);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Description *",
                      prefixIcon: new Icon(Icons.message)
                  ),
                  controller: description,
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
                                AddQuestionpaperdialog("refresh",'new',details);
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
                                if(title.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter title");
                                  return;
                                }
                                if(clas == ""){
                                  Constants().ShowAlertDialog(context, "please select class");
                                  return;
                                }
                                if(exam == ""){
                                  Constants().ShowAlertDialog(context, "please select exam");
                                  return;
                                }
                                if(description.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter description");
                                  return;
                                }
                                Addquestionpaper(details);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Question Paper"),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () =>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(),),
          ),
        ),*/
      ),
      //floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => AddQuestionpaperdialog("refresh",'new',null),backgroundColor: Theme.of(context).primaryColor,
      //),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
              shape: BoxShape.rectangle
            ),
//            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 10,height: 10,),
//                    new Container(
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.orange
//                      ),
//                      child: new SvgPicture.asset("assets/clipboard.svg",color: Colors.white,width: 25,height: 25,),
//                      padding: new EdgeInsets.all(7),
//                    ),
//                    new SizedBox(width: 10,height: 10,),
//                    new Text("Question Paper",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom:0,top: 30),
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
              margin: new EdgeInsets.only(left: 10,right: 5,bottom: 0,top: 90),
              child : new Stack(
                children: <Widget>[
                  new Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.only(top: 10,right: 10),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
                  _Questionpaperdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red)))) :
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                              label: Text("#",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Title",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Class",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Exam",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Teacher",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Actions",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                        ],
                        rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                        _searchResult.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text(user.sno),
                                ),
                                DataCell(
                                  Text(user.titile),
                                ),
                                DataCell(
                                  Text(revclassmap[user.classname]),
                                ),
                                DataCell(
                                  Text(revexammap[user.exam]),
                                ),
                                DataCell(
                                  Text(revteachersmap[user.teacher]),
                                ),
                                DataCell(
                                  new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(int.tryParse(user.sno),user)),
                                ),
                              ]),
                        ).toList()
                            : _Questionpaperdetails.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text(user.sno),
                                ),
                                DataCell(
                                  Text(user.titile),
                                ),
                                DataCell(
                                  Text(revclassmap[user.classname]),
                                ),
                                DataCell(
                                  Text(revexammap[user.exam].toString()),
                                ),
                                DataCell(
                                  Text(revteachersmap[user.teacher]),
                                ),
                                DataCell(
                                  new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(int.tryParse(user.sno),user)),
                                ),
                              ]),
                        ).toList(),
                      ),
                    ),
                  ],
                )),
          ),
      /*new Align(
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
            AddQuestionpaperdialog("refresh",'new',null);
          },
          )
      )*/
    ],
    ))
        ],
      ),
    );
  }

  static const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');

  Future<Null> Download(String filename) async {
    if(filename == null || filename.isEmpty ) {
      Constants().ShowAlertDialog(context, "No file available to download.");
      return;
    }
    var url = await Constants().Clienturl()+"api_admin/force_download/document/"+filename;
    print("downloadurl--" + url);
    //   filename.replaceAll("", "%20");
    Constants().onDownLoading(context);
    var appDocDir = await getExternalStorageDirectory();
    var path = appDocDir.path;
    new Directory( "$path/Edecofy").create(recursive: true);
    String filePath = "$path/Edecofy/${filename}";
    filename.replaceAll(" ", "%20");
    File file = new File(filePath);
    if (await file.exists()) {
      file.delete();
    }

    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      file.create();
      await file.writeAsBytes(bytes);
      var args = {'url': filePath};
      Navigator.of(context).pop();
      _channel.invokeMethod('openfile', args);
    }else {
      Navigator.of(context).pop();
      Constants().ShowAlertDialog(context, "Failed to download. Please try after sometime");
      return;
    }

  }


  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Questionpaperdetails.forEach((vehicleDetail) {
      if (vehicleDetail.classname.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.teacher.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.exam.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Questionpaperdetails> _searchResult = [];
  List<Questionpaperdetails> _Questionpaperdetails = [];

}

class Questionpaperdetails {
  String  titile, exam, classname,teacher,sno,id,questionpaper;

  Questionpaperdetails({ this.titile, this.exam, this.classname,this.teacher,this.sno,this.id,this.questionpaper});

  factory Questionpaperdetails.fromJson(Map<String, dynamic> json,int i) {
    return new Questionpaperdetails(
        id: json['question_paper_id'].toString() ,
        exam: json['exam_id'].toString() ,
        classname:  json['class_id'].toString() ,
        titile: json['title'].toString(),
        teacher: json['teacher_id'].toString(),
        questionpaper: json['question_paper'].toString(),
        sno: i.toString()
    );
  }

}
