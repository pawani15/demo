import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../const.dart';
import '../dashboard.dart';


class AdminclassroutinetabsPage extends StatefulWidget {
  final String id;
  AdminclassroutinetabsPage({this.id});
  @override
  State<StatefulWidget> createState() => new _AdminclassroutinetabsPageState();
}

class _AdminclassroutinetabsPageState extends State<AdminclassroutinetabsPage>
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
    Loadsectionstabs();
  }

  Future<Null> Loadsectionstabs() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.id;

    print("url is $url" + "body--" + body.toString());

    http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },body: body).then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          responseJson['result'].forEach((data) {
            tabs.add(new Tab(
                text: "Section-"+ data['section_name'].toString()),
            );
            tabsbody.add(
              new ClassroutinesAdminPage(
                classid: widget.id,sectionid: data['section_id'],
              ),
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

  Add(Map details) async {
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
                          child: new Container(child: new Text("Add Class Routine",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new AddClassroutinePage(type : "new",details: details,classid: widget.id,),
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
        title: Text("Class Timetable"),
        backgroundColor: Color(0xff182C61),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () =>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(),),
          ),

        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
          child: Column(
            children: <Widget>[
              new SizedBox(width: 10,height: 10,),
              new InkWell(
                child:new Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.add,color: Colors.white,size: 20,),
                      new Padding(padding: EdgeInsets.only(left: 5),child: Text("Add Class Routine",style: TextStyle(color: Colors.white,fontSize: 14),))
                    ],
                  ),
                ),
                onTap: (){
                  Add(null);
                },
              ),
            ],
          )
          ),
          new Card(
            elevation: 5.0,
            margin:
                new EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 80),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading
                ? new Constants().bodyProgress
                : new Column(
                    children: <Widget>[
                      Expanded(
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
                              ))),
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
                                        Constants().ShowAlertDialog(context, "Coming Soon!");
                                      },
                                      child: new Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15))),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Icon(
                                                Icons.print,
                                                color: Colors.white,
                                              ),
                                              new Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  "Print",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
        ],
      ),
    );
  }
}

class ClassroutinesAdminPage extends StatefulWidget {
  final String classid;
  final String sectionid;

  ClassroutinesAdminPage({this.classid,this.sectionid});

  @override
  State<StatefulWidget> createState() => new _ClassroutinesAdminPageState();
}

class _ClassroutinesAdminPageState extends State<ClassroutinesAdminPage>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  List sundaylist = new List();
  List mondaylist = new List();
  List tuesdaylist = new List();
  List wendaylist = new List();
  List thursdaylist = new List();
  List fridaylist = new List();
  List satdaylist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadClassroutine();
  }

  Future<Null> LoadClassroutine() async {
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.LoadClassroutine_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.classid;
    body['section_id'] = widget.sectionid;

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
            sundaylist = responseJson['result']['class_routine']['sunday'];
            mondaylist = responseJson['result']['class_routine']['monday'];
            tuesdaylist = responseJson['result']['class_routine']['tuesday'];
            wendaylist = responseJson['result']['class_routine']['wednesday'];
            thursdaylist = responseJson['result']['class_routine']['thursday'];
            fridaylist = responseJson['result']['class_routine']['friday'];
            satdaylist = responseJson['result']['class_routine']['saturday'];
            print("mondaylen--" + mondaylist.length.toString());
          } catch (e) {
            sundaylist = new List();
            mondaylist = new List();
            tuesdaylist = new List();
            wendaylist = new List();
            thursdaylist = new List();
            fridaylist = new List();
            satdaylist = new List();
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
        deletedialog(user['class_routine_id'].toString());
      }
    },
  );

  Future<Null> DeleteApi(String Gradeid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.CRUDClassroutine_Admin;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['class_routine_id'] = Gradeid;

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
          Constants().ShowSuccessDialog(context, "Class routine deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminclassroutinetabsPage(id: widget.classid,)),
            );
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Class routine not deleted succesfully");
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
                          child: new Container(child: new Text("Edit Class Routine",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new AddClassroutinePage(type : "edit",details: details,classid: widget.classid,),
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
      body: _loading ? new Constants().bodyProgress : new Padding(
          padding: EdgeInsets.all(5.0),
          child: new Column(
            children: <Widget>[
              new Container(
                  height: 50,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5),
                          child: new Text(
                            "Sunday",
                            style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
                          )),
                      sundaylist.length > 0
                          ? new Expanded(
                              child: new ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                  padding: EdgeInsets.all(5),
                                  child: new Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        new Padding(
                                          padding: EdgeInsets.only(
                                              right: 5,
                                                left: 15,
                                              top: 5,
                                              bottom: 5),
                                          child: new Text(
                                            sundaylist[index]['subject_name'] +
                                                " (" +
                                                sundaylist[index]
                                                    ['time_start'] + ":" +sundaylist[index]
                                            ['time_start_min']+
                                                " - " +
                                                sundaylist[index]['time_end'] + ":" +sundaylist[index]
                                            ['time_end_min']+
                                                ")",
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 11),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        new Container(padding: EdgeInsets.all(5),
                                            child:_EdittPopup(satdaylist[index]))
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: sundaylist.length,
                              scrollDirection: Axis.horizontal,
                            ))
                          : new Container(),
                    ],
                  )),
              new Divider(
                height: 1,
                color: Colors.grey,
              ),
              new Container(
                  height: 50,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5),
                          child: new Text(
                            "Monday",
                            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
                          )),
                      mondaylist.length > 0
                          ? new Expanded(
                              child: new ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                    padding: EdgeInsets.all(5),
                                    child: new Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(
                                                right: 5,
                                                left: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: new Text(
                                              mondaylist[index]['subject_name'] +
                                                  " (" +
                                                  mondaylist[index]
                                                  ['time_start'] + ":" +mondaylist[index]
                                              ['time_start_min']+
                                                  " - " +
                                                  mondaylist[index]['time_end'] + ":" +mondaylist[index]
                                              ['time_end_min']+
                                                  ")",
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 11),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          new Container(padding: EdgeInsets.all(5),
                                              child:_EdittPopup(mondaylist[index]))
                                        ],
                                      ),
                                    ),);
                              },
                              itemCount: mondaylist.length,
                              scrollDirection: Axis.horizontal,
                            ))
                          : new Container(),
                    ],
                  )),
              new Divider(
                height: 1,
                color: Colors.grey,
              ),
              new Container(
                  height: 50,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5),
                          child: new Text(
                            "Tuesday",
                            style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
                          )),
                      tuesdaylist.length > 0
                          ? new Expanded(
                              child: new ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                    padding: EdgeInsets.all(5),
                                    child: new Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(
                                                right: 5,
                                                left: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: new Text(
                                              tuesdaylist[index]['subject_name'] +
                                                  " (" +
                                                  tuesdaylist[index]
                                                  ['time_start'] + ":" +tuesdaylist[index]
                                              ['time_start_min']+
                                                  " - " +
                                                  tuesdaylist[index]['time_end'] + ":" +tuesdaylist[index]
                                              ['time_end_min']+
                                                  ")",
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 11),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          new Container(padding: EdgeInsets.all(5),
                                          child:_EdittPopup(tuesdaylist[index]))
                                        ],
                                      ),
                                    ),);
                              },
                              itemCount: tuesdaylist.length,
                              scrollDirection: Axis.horizontal,
                            ))
                          : new Container(),
                    ],
                  )),
              new Divider(
                height: 1,
                color: Colors.grey,
              ),
              new Container(
                  height: 50,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5),
                          child: new Text(
                            "Wednesday",
                            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
                          )),
                      wendaylist.length > 0
                          ? new Expanded(
                              child: new ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                    padding: EdgeInsets.all(5),
                                    child: new Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(
                                                right: 5,
                                                left: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: new Text(
                                              wendaylist[index]['subject_name'] +
                                                  " (" +
                                              wendaylist[index]
                                              ['time_start'] + ":" +wendaylist[index]
                                              ['time_start_min']+
                                                  " - " +
                                                  wendaylist[index]['time_end'] + ":" +wendaylist[index]
                                              ['time_end_min']+
                                                  ")",
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 11),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          new Container(padding: EdgeInsets.all(5),
                                              child:_EdittPopup(wendaylist[index]))
                                        ],
                                      ),
                                    ),);
                              },
                              itemCount: wendaylist.length,
                              scrollDirection: Axis.horizontal,
                            ))
                          : new Container(),
                    ],
                  )),
              new Divider(
                height: 1,
                color: Colors.grey,
              ),
              new Container(
                  height: 50,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5),
                          child: new Text(
                            "Thursday",
                            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
                          )),
                      thursdaylist.length > 0
                          ? new Expanded(
                              child: new ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                    padding: EdgeInsets.all(5),
                                    child: new Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(
                                                right: 5,
                                                left: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: new Text(
                                              thursdaylist[index]['subject_name'] +
                                                  " (" +
                                                  thursdaylist[index]
                                                  ['time_start'] + ":" +thursdaylist[index]
                                              ['time_start_min']+
                                                  " - " +
                                                  thursdaylist[index]['time_end'] + ":" +thursdaylist[index]
                                              ['time_end_min']+
                                                  ")",
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 11),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          new Container(padding: EdgeInsets.all(5),
                                              child:_EdittPopup(thursdaylist[index]))
                                        ],
                                      ),
                                    ),);
                              },
                              itemCount: thursdaylist.length,
                              scrollDirection: Axis.horizontal,
                            ))
                          : new Container(),
                    ],
                  )),
              new Divider(
                height: 1,
                color: Colors.grey,
              ),
              new Container(
                  height: 50,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5),
                          child: new Text(
                            "Friday",
                            style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
                          )),
                      fridaylist.length > 0
                          ? new Expanded(
                              child: new ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                    padding: EdgeInsets.all(5),
                                    child: new Card(
                                      elevation: 5,
                                      margin: EdgeInsets.all(5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(
                                                right: 5,
                                                left: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: new Text(
                                              fridaylist[index]['subject_name'] +
                                                  " (" +
                                                  fridaylist[index]
                                                  ['time_start'] + ":" +fridaylist[index]
                                              ['time_start_min']+
                                                  " - " +
                                                  fridaylist[index]['time_end'] + ":" +fridaylist[index]
                                              ['time_end_min']+
                                                  ")",
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 11),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          new Container(padding: EdgeInsets.all(5),
                                              child:_EdittPopup(fridaylist[index]))
                                        ],
                                      ),
                                    ),);
                              },
                              itemCount: fridaylist.length,
                              scrollDirection: Axis.horizontal,
                            ))
                          : new Container(),
                    ],
                  )),
              new Divider(
                height: 1,
                color: Colors.grey,
              ),
              new Container(
                  height: 50,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5),
                          child: new Text(
                            "Saturday",
                            style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
                          )),
                      satdaylist.length > 0
                          ? new Expanded(
                              child: new ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return new Container(
                                    padding: EdgeInsets.all(5),
                                    child: new Card(
                                      elevation: 5,
                                      margin: EdgeInsets.all(5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(
                                                right: 5,
                                                left: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: new Text(
                                              satdaylist[index]['subject_name'] +
                                                  " (" +
                                                  satdaylist[index]
                                                  ['time_start'] + ":" +satdaylist[index]
                                              ['time_start_min']+
                                                  " - " +
                                                  satdaylist[index]['time_end'] + ":" +satdaylist[index]
                                              ['time_end_min']+
                                                  ")",
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                  fontSize: 11),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          new Container(padding: EdgeInsets.all(5),
                                              child:_EdittPopup(satdaylist[index]))
                                        ],
                                      ),
                                    ),);
                              },
                              itemCount: satdaylist.length,
                              scrollDirection: Axis.horizontal,
                            ))
                          : new Container(),
                    ],
                  )),
              new Divider(
                height: 1,
                color: Colors.grey,
              ),
            ],
          )),
    );
  }
}

class AddClassroutinePage extends StatefulWidget {
  final Map details;
  final String type;
  final String classid;
  AddClassroutinePage({this.type,this.details,this.classid});

  @override
  State<StatefulWidget> createState() => new _AddlasssPagePageState();
}

class _AddlasssPagePageState extends State<AddClassroutinePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  String name = "";IconData icon = null;
  String clas = '',
      section = '',
      subject = '',day='',starttime="",endtime="";
  TimeOfDay start = null,end=null;

  @override
  void initState() {
    super.initState();
    daylist.add("sunday");
    daylist.add("monday");
    daylist.add("tuesday");
    daylist.add("wednesday");
    daylist.add("thursday");
    daylist.add("friday");
    daylist.add("saturday");

    if(widget.type == "new"){
      name = "Add Class Routine";
      icon = Icons.add;
    }
    else{
      name = "Edit Class Routine";
      icon = Icons.edit;
      clas = widget.details['class_name'].toString();
      section = widget.details['section_name'].toString();
      subject = widget.details['subject_name'].toString();
      day = widget.details['day'].toString();
      starttime = (widget.details['time_start'].toString().length >1 ? widget.details['time_start'].toString() : "0"+widget.details['time_start'].toString())+":" + (widget.details['time_start_min'].toString().length > 1 ? widget.details['time_start_min'].toString() : "0"+widget.details['time_start_min'].toString());
      endtime = (widget.details['time_end'].toString().length >1 ? widget.details['time_end'].toString() : "0"+widget.details['time_end'].toString())+":" + (widget.details['time_end_min'].toString().length > 1 ? widget.details['time_end_min'].toString() : "0"+widget.details['time_end_min'].toString());
      final now = new DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, int.tryParse(widget.details['time_start'].toString()), int.tryParse(widget.details['time_start_min'].toString()));
      final dt1 = DateTime(now.year, now.month, now.day, int.tryParse(widget.details['time_end'].toString()), int.tryParse(widget.details['time_end_min'].toString()));
      final format = DateFormat("HH:mm");  //"6:00 AM"
      start = TimeOfDay.fromDateTime(dt);
      end = TimeOfDay.fromDateTime(dt1);
    }
    LoadCLassdetails();
  }

  Future<Null> _selectstarttime(BuildContext context) async {
    try {
      TimeOfDay pickedtime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedtime != null && pickedtime != start) {
        print('time selected : ${start.toString()}');
        setState(() {
          start = pickedtime;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }catch(e){e.toString();}
  }

  Future<Null> _selectensdtime(BuildContext context) async {
    try {
      TimeOfDay pickedtime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedtime != null && pickedtime != end) {
        print('time selected : ${end.toString()}');
        setState(() {
          end = pickedtime;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }catch(e){e.toString();}
  }

  Map classmap= new Map(),subjectsmap = new Map(),sectionamp= new Map();
  List<String> classlist= new List(),subjectsslist= new List(),sectionslist = new List(),daylist = new List();

  _navigatetoclasses(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Classes", classlist);

    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    if(result != null) {
      LoadSubjects(classmap[clas]);
      LoadSections(classmap[clas]);
    }
  }

  _navigatetosubjects(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Subjects", subjectsslist);
    setState(() {
      subject = result ?? subject;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  _navigatetodays(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Day", daylist);
    setState(() {
      day = result ?? day;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      section = result ?? section;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  LoadCLassdetails() async{
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();

    var url = await Constants().Clienturl() + Constants.Load_Classes;
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
          if(widget.type == "edit") {
            LoadSubjects(classmap[clas]);
            LoadSections(classmap[clas]);
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

  Future<Null> Classroutine() async {
    Constants().onLoading(context);
    var url="";
    url = await Constants().Clienturl() + Constants.CRUDClassroutine_Admin;

    Map<String, String> body = new Map();
    if(widget.type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "update";
      body['class_routine_id'] = widget.details['class_routine_id'];
    }

    String starttime1 = start== null ? starttime : formatTimeOfDay(start);
    String endtime1 = end == null ? endtime : formatTimeOfDay(end);

    body['class_id'] = classmap[clas];
    body['section_id'] = sectionamp[section];
    body['subject_id'] = subjectsmap[subject];
    body['day'] = day;
    body['time_start'] = starttime1.substring(0,2);
    body['time_start_min'] = starttime1.substring(3,5);
    body['starting_ampm'] = starttime1.substring(6,8) == "AM" ? "1" :"2";
    body['time_end'] = endtime1.substring(0,2);
    body['time_end_min'] = endtime1.substring(3,5);
    body['ending_ampm'] = endtime1.substring(6,8) == "AM" ? "1" :"2";

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
            Constants().ShowSuccessDialog(context, "Class routine updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Class routine added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminclassroutinetabsPage(id: widget.classid,)),
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

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat("hh:mm a");  //"6:00 AM"
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new SizedBox(height: 20,width: 20,),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Class *",
                    prefixIcon: new Icon(Icons.list),
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
                    hintText: "Section *",
                    prefixIcon: new Icon(Icons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: TextEditingController(text: section),
                enabled: false,
              ),
              onTap: () {
                if(clas == ''){
                  Constants().ShowAlertDialog(context, "Please select class");
                  return;
                }
                _navigatetosections(context);
              },
            )),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Subject *",
                    prefixIcon: new Icon(Icons.subject),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: TextEditingController(text: subject),
                enabled: false,
              ),
              onTap: () {
                if(clas == ''){
                  Constants().ShowAlertDialog(context, "Please select class");
                  return;
                }
                _navigatetosubjects(context);
              },
            )),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Day *",
                    prefixIcon: new Icon(Icons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: TextEditingController(text: day),
                enabled: false,
              ),
              onTap: () {
                _navigatetodays(context);
              },
            )),
        new Container(padding: new EdgeInsets.all(5.0),
            child : new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Starting Time *',
                  prefixIcon: new Icon(Icons.access_time),
                ),
                enabled: false,
                controller: new TextEditingController(text: start == null ? starttime :  formatTimeOfDay(start)),
              ),
              onTap: (){
                _selectstarttime(context);
              },
            )),
        new Container(padding: new EdgeInsets.all(5.0),
            child : new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Ending Time *',
                  prefixIcon: new Icon(Icons.access_time),
                ),
                enabled: false,
                controller: new TextEditingController(text: end == null ? endtime :  formatTimeOfDay(end)),
              ),
              onTap: (){
                _selectensdtime(context);
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
                          if(clas == ''){
                            Constants().ShowAlertDialog(context, "Please select class");
                            return;
                          }
                          if(section == ''){
                            Constants().ShowAlertDialog(context, "Please select section");
                            return;
                          }
                          if(subject == ''){
                            Constants().ShowAlertDialog(context, "Please select subject");
                            return;
                          }
                          if(day == ''){
                            Constants().ShowAlertDialog(context, "Please select day");
                            return;
                          }
                          if(widget.type == "new" && start == null){
                            Constants().ShowAlertDialog(context, "Please select starting time");
                            return;
                          }
                          if(widget.type == "new" && end == ''){
                            Constants().ShowAlertDialog(context, "Please select ending time");
                            return;
                          }
                          Classroutine();
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