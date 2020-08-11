import 'dart:convert';
import 'package:Edecofy/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../dashboard.dart';

GlobalKey<ScaffoldState> _drawerKey = GlobalKey();


class StudentClassRoutine extends StatefulWidget {
//  final String studentname,id;
//  StudentClassRoutine({this.studentname,this.id});
  @override
  State<StatefulWidget> createState() => new _StudentClassRoutinePageState();
}

class _StudentClassRoutinePageState extends State<StudentClassRoutine>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  Map Classdetails;
  List sundaylist = new List();
  List mondaylist = new List();
  List tuesdaylist = new List();
  List wendaylist = new List();
  List thursdaylist = new List();
  List fridaylist = new List();
  List satdaylist = new List();
  String classname = "", sectionname = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadclassroutinestudent();
  }

  Future<Null> Loadclassroutinestudent() async {
    String id = await sp.ReadString("Userid");
    var url =
        await Constants().Clienturl() + "api_students/class_routine/" ;
    Map<String, String> body = new Map();
    body['student_id'] = id;
    print("url is $url" + "   body--" + body.toString());
    http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },body: body).then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          debugPrint("response json ${responseJson}");
          try {
            classname = responseJson['result'][0]['class_name'].toString();
            sectionname = responseJson['result'][0]['section_name'].toString();
            sundaylist = responseJson['result'][0]['sunday'];
            mondaylist = responseJson['result'][0]['monday'];
            tuesdaylist = responseJson['result'][0]['tuesday'];
            wendaylist = responseJson['result'][0]['wednesday'];
            thursdaylist = responseJson['result'][0]['thursday'];
            fridaylist = responseJson['result'][0]['friday'];
            satdaylist = responseJson['result'][0]['saturday'];
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
        title: Text("Class Routine"),
        backgroundColor: Color(0xff182C61),
//        leading:  IconButton(
//          icon: new Icon(
//            Icons.menu,
//            color: Colors.white,
//          ),
//          onPressed: () {
//            _drawerKey.currentState.openDrawer();
//          },
//        ),
      ),
      drawer: Constants().drawer(context),

      body: new Stack(
        children: <Widget>[
          new Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 15,height: 15,),
//                    new Container(
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.orange
//                      ),
//                      child: new Icon(Icons.person,color: Colors.white,size: 25,),
//                      padding: new EdgeInsets.all(5),
//                      margin: EdgeInsets.all(5),
//                    ),
//                    new Text('abc',style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//                child: Column(
//                  children: <Widget>[
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//
//                      children: <Widget>[
//                        new SizedBox(width: 15,height: 15,),
//                        new Text("ClassRoutine ",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                        new SizedBox(width: 15,height: 15,),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Image(image: AssetImage('assets/refresh_icon.png')),
//                            new Text("Home > ClassRoutine",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                          ],
//                        ),
//
//                      ],
//                    )
//                  ],
//                )
            ),
          ),
          new Card(
            elevation: 5.0,
            margin:
            new EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading
                ? new Constants().bodyProgress
                : new Padding(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    new SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Center(
                        child: new Container(
                            child: new Text(
                              "Class-$classname :   Section-$sectionname",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ))),

//                            Expanded(child: new InkWell(child: new Container(
//                              decoration: BoxDecoration(
//                                  shape: BoxShape.rectangle,
//                                  borderRadius: BorderRadius.circular(30),
//                                  color: Colors.green,
//                                  boxShadow: [new BoxShadow(
//                                    color: Colors.grey[300],
//                                    blurRadius: 5.0,
//                                  ),]
//                              ),
//                              child: new Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  new Padding(padding: EdgeInsets.only(right: 20),child: new Text("Print",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
//                                  new Icon(Icons.print,color: Colors.white,)
//                                ],
//                              ),
//                            ),
//                              onTap: (){
//                                Constants().ShowAlertDialog(context, "Coming Soon!");
//                              },
//                            ),flex:
                    new Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    new Container(
                        height: 40,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                padding: EdgeInsets.all(5),
                                child: new Text(
                                  "Sunday",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11.0),
                                )),
                            sundaylist.length > 0
                                ? new Expanded(
                                child: ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index)
                                  {

                                    /* sundaylist[index][
                                       'time_start_min']*/
                                    // sundaylist.sort()   ;


                                    return new Container(
                                        padding: EdgeInsets.all(5),
                                        child: new Stack(

                                          children: <Widget>[
                                            new Container(
                                              decoration: BoxDecoration(
                                                  shape:
                                                  BoxShape.rectangle,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(15),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors
                                                          .grey[300],
                                                      blurRadius: 5.0,
                                                    ),
                                                  ]),
                                              padding: EdgeInsets.all(5),
                                              child: new Text(
                                                sundaylist[index]
                                                ['name'] +
                                                    " (" +
                                                    sundaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    sundaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    sundaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    sundaylist[index]
                                                    ['time_end_min'] +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                                maxLines: 1,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                              margin:
                                              EdgeInsets.only(top: 5),
                                            ),
                                            new Align(
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    color: Colors.orange),
                                                child: new Icon(
                                                  Icons.timer,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                margin: EdgeInsets.only(
                                                    right: 5),
                                              ),
                                              alignment:
                                              Alignment.topCenter,
                                            ),
                                          ],
                                        ));
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
                        height: 40,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                padding: EdgeInsets.all(5),
                                child: new Text(
                                  "Monday",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11.0),
                                )),
                            mondaylist.length > 0
                                ? new Expanded(
                                child: new ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // mondaylist.sort()   ;
                                  //  mondaylist.sort((a, b) => a['time_start_min'].compareTo(b['time_start_min']));
                                    return new Container(
                                        padding: EdgeInsets.all(5),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                              decoration: BoxDecoration(
                                                  shape:
                                                  BoxShape.rectangle,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(15),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors
                                                          .grey[300],
                                                      blurRadius: 5.0,
                                                    ),
                                                  ]),
                                              padding: EdgeInsets.all(5),
                                              child: new Text(
                                                mondaylist[index]
                                                ['name'] +
                                                    " (" +
                                                    mondaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    mondaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    mondaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    mondaylist[index]
                                                    ['time_end_min'] +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                                maxLines: 1,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                              margin:
                                              EdgeInsets.only(top: 5),
                                            ),
                                            new Align(
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    color: Colors.orange),
                                                child: new Icon(
                                                  Icons.timer,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                margin: EdgeInsets.only(
                                                    right: 5),
                                              ),
                                              alignment:
                                              Alignment.topCenter,
                                            ),
                                          ],
                                        ));
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
                        height: 40,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                padding: EdgeInsets.all(5),
                                child: new Text(
                                  "Tuesday",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11.0),
                                )),
                            tuesdaylist.length > 0
                                ? new Expanded(
                                child: new ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                   //  tuesdaylist.sort((a, b) => a['time_start_min'].compareTo(b['time_start_min']));
                                   // tuesdaylist.sort((a, b) => a['time_start'].compareTo(b['time_start']));
                                   // tuesdaylist.sort((a, b) => a['time_start_min'].compareTo(b['time_start_min']));
                                    return new Container(
                                        padding: EdgeInsets.all(5),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                              decoration: BoxDecoration(
                                                  shape:
                                                  BoxShape.rectangle,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(15),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors
                                                          .grey[300],
                                                      blurRadius: 5.0,
                                                    ),
                                                  ]),
                                              padding: EdgeInsets.all(5),
                                              child: new Text(
                                                tuesdaylist[index]
                                                ['name'] +
                                                    " (" +
                                                    tuesdaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    tuesdaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    tuesdaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    tuesdaylist[index]
                                                    ['time_end_min'] +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                                maxLines: 1,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                              margin:
                                              EdgeInsets.only(top: 5),
                                            ),
                                            new Align(
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    color: Colors.orange),
                                                child: new Icon(
                                                  Icons.timer,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                margin: EdgeInsets.only(
                                                    right: 5),
                                              ),
                                              alignment:
                                              Alignment.topCenter,
                                            ),
                                          ],
                                        ));
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
                        height: 40,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                padding: EdgeInsets.all(5),
                                child: new Text(
                                  "Wednesday",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11.0),
                                )),
                            wendaylist.length > 0
                                ? new Expanded(
                                child: new ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
//                                        wendaylist.sort((a, b) => a['time_start_min'].compareTo(b['time_start_min']));
//                                    wendaylist.sort((a, b) => a['time_start'].compareTo(b['time_start']));
                                   // wendaylist.sort((a, b) => a['time_end_min'].compareTo(b['time_end_min']));
                                    return new Container(
                                        padding: EdgeInsets.all(5),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                              decoration: BoxDecoration(
                                                  shape:
                                                  BoxShape.rectangle,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(15),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors
                                                          .grey[300],
                                                      blurRadius: 5.0,
                                                    ),
                                                  ]),
                                              padding: EdgeInsets.all(5),
                                              child: new Text(
                                                wendaylist[index]
                                                ['name'] +
                                                    " (" +
                                                    wendaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    wendaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    wendaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    wendaylist[index]
                                                    ['time_end_min'] +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                                maxLines: 1,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                              margin:
                                              EdgeInsets.only(top: 5),
                                            ),
                                            new Align(
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    color: Colors.orange),
                                                child: new Icon(
                                                  Icons.timer,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                margin: EdgeInsets.only(
                                                    right: 5),
                                              ),
                                              alignment:
                                              Alignment.topCenter,
                                            ),
                                          ],
                                        ));
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
                        height: 40,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                padding: EdgeInsets.all(5),
                                child: new Text(
                                  "Thursday",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11.0),
                                )),
                            thursdaylist.length > 0
                                ? new Expanded(
                                child: new ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
//                                        thursdaylist.sort((a, b) => a['time_start_min'].compareTo(b['time_start_min']));
//                                        thursdaylist.sort((a, b) => a['time_start'].compareTo(b['time_start']));
                                   // thursdaylist.sort((a, b) => a['time_end_min'].compareTo(b['time_end_min']));
                                    return new Container(
                                        padding: EdgeInsets.all(5),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                              decoration: BoxDecoration(
                                                  shape:
                                                  BoxShape.rectangle,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(15),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors
                                                          .grey[300],
                                                      blurRadius: 5.0,
                                                    ),
                                                  ]),
                                              padding: EdgeInsets.all(5),
                                              child: new Text(
                                                thursdaylist[index]
                                                ['name'] +
                                                    " (" +
                                                    thursdaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    thursdaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    thursdaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    thursdaylist[index]
                                                    ['time_end_min'] +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                                maxLines: 1,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                              margin:
                                              EdgeInsets.only(top: 5),
                                            ),
                                            new Align(
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    color: Colors.orange),
                                                child: new Icon(
                                                  Icons.timer,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                margin: EdgeInsets.only(
                                                    right: 5),
                                              ),
                                              alignment:
                                              Alignment.topCenter,
                                            ),
                                          ],
                                        ));
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
                        height: 40,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                padding: EdgeInsets.all(5),
                                child: new Text(
                                  "Friday",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11.0),
                                )),
                            fridaylist.length > 0
                                ? new Expanded(
                                child: new ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
//                                        fridaylist.sort((a, b) => a['time_start_min'].compareTo(b['time_start_min']));
//                                        fridaylist.sort((a, b) => a['time_start'].compareTo(b['time_start']));
                                   // fridaylist.sort((a, b) => a['time_end_min'].compareTo(b['time_end_min']));

                                    return new Container(
                                        padding: EdgeInsets.all(5),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                              decoration: BoxDecoration(
                                                  shape:
                                                  BoxShape.rectangle,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(15),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors
                                                          .grey[300],
                                                      blurRadius: 5.0,
                                                    ),
                                                  ]),
                                              padding: EdgeInsets.all(5),
                                              child: new Text(
                                                fridaylist[index]
                                                ['name'] +
                                                    " (" +
                                                    fridaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    fridaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    fridaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    fridaylist[index]
                                                    ['time_end_min'] +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                                maxLines: 1,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                              margin:
                                              EdgeInsets.only(top: 5),
                                            ),
                                            new Align(
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    color: Colors.orange),
                                                child: new Icon(
                                                  Icons.timer,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                margin: EdgeInsets.only(
                                                    right: 5),
                                              ),
                                              alignment:
                                              Alignment.topCenter,
                                            ),
                                          ],
                                        ));
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
                        height: 40,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                                padding: EdgeInsets.all(5),
                                child: new Text(
                                  "Saturday",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 11.0),
                                )),
                            satdaylist.length > 0
                                ? new Expanded(
                                child: new ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
//                                        satdaylist.sort((a, b) => a['time_start_min'].compareTo(b['time_start_min']));
//                                        satdaylist.sort((a, b) => a['time_start'].compareTo(b['time_start']));
                                    //satdaylist.sort((a, b) => a['time_end_min'].compareTo(b['time_end_min']));

                                    return new Container(
                                        padding: EdgeInsets.all(5),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                              decoration: BoxDecoration(
                                                  shape:
                                                  BoxShape.rectangle,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(15),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors
                                                          .grey[300],
                                                      blurRadius: 5.0,
                                                    ),
                                                  ]),
                                              padding: EdgeInsets.all(5),
                                              child: new Text(
                                                satdaylist[index]
                                                ['name'] +
                                                    " (" +
                                                    satdaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    satdaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    satdaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    satdaylist[index]
                                                    ['time_end_min'] +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                                maxLines: 1,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                              margin:
                                              EdgeInsets.only(top: 5),
                                            ),
                                            new Align(
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    color: Colors.orange),
                                                child: new Icon(
                                                  Icons.timer,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                margin: EdgeInsets.only(
                                                    right: 5),
                                              ),
                                              alignment:
                                              Alignment.topCenter,
                                            ),
                                          ],
                                        ));
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
//                    new Container(
//                      child: new Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          new Expanded(
//                            child: new Container(
//                                margin: new EdgeInsets.all(0.0),
//                                alignment: Alignment.center,
//                                width: double.infinity,
//                                child: new InkWell(
//                                    onTap: () {
//                                      Constants().ShowAlertDialog(
//                                          context, "Coming Soon!");
//                                    },
////                                    child: new Container(
////                                        padding: EdgeInsets.all(10),
////                                        decoration: BoxDecoration(
////                                            color: Colors.green,
////                                            borderRadius: BorderRadius.only(
////                                                bottomRight:
////                                                Radius.circular(15),
////                                                bottomLeft:
////                                                Radius.circular(15))),
////                                        child: new Row(
////                                          mainAxisAlignment:
////                                          MainAxisAlignment.center,
////                                          children: <Widget>[
////                                            new Icon(
////                                              Icons.print,
////                                              color: Colors.white,
////                                            ),
////                                            new Padding(
////                                              padding: EdgeInsets.only(
////                                                  left: 5.0),
////                                              child: Text(
////                                                "Print ",
////                                                style: TextStyle(
////                                                    color: Colors.white,
////                                                    fontWeight:
////                                                    FontWeight.bold,
////                                                    fontSize: 12),
////                                              ),
////                                            )
////                                          ],
////                                        ))
//
//                                )),
//                            flex: 1,
//                          ),
//                        ],
//                      ),
//                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}




// To parse this JSON data, do
//
//     final monday = mondayFromJson(jsonString);



