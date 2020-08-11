import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'const.dart';
import 'dashboard.dart';

class SectionstimetabletabsPage extends StatefulWidget {
  final String id,name;
  SectionstimetabletabsPage({this.id,this.name});
  @override
  State<StatefulWidget> createState() => new _SectionstimetabletabsPageState();
}

class _SectionstimetabletabsPageState extends State<SectionstimetabletabsPage>
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
    var url = await Constants().Clienturl() +
        Constants.Load_Sectionwisetimetable +
        widget.id;
    Map<String, String> body = new Map();

    print("url is $url" + "body--" + body.toString());

    http.get(/*"http://demo.edecofy.com/api_teachers/class_routine/10"*/url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }).then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          responseJson['result'].forEach((data) {
            tabs.add(new Tab(
                text: "Class-"+data['class_name'].toString() + " : Section-"+ data['section_name'].toString()),
            );
            tabsbody.add(
              new ClassroutinesTeachersPage(
                data: data,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Class Routine"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//
//        ),
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
//              children: <Widget>[
//                new SizedBox(
//                  width: 10,
//                  height: 10,
//                ),
//                new SizedBox(
//                  width: 10,
//                  height: 10,
//                ),
//                new Text(
//                  "Class "+widget.name,
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 16.0,
//                      fontWeight: FontWeight.bold),
//                ),
//              ],
//            )),
          ),
          new Card(
            elevation: 5.0,
            margin:
                new EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 40),
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
//                      new Container(
//                        child: new Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            new Expanded(
//                              child: new Container(
//                                  margin: new EdgeInsets.all(0.0),
//                                  alignment: Alignment.center,
//                                  width: double.infinity,
//                                  child: new InkWell(
//                                      onTap: () {
//                                        Constants().ShowAlertDialog(context, "Coming Soon!");
//                                      },
//                                      child: new Container(
//                                          padding: EdgeInsets.all(10),
//                                          decoration: BoxDecoration(
//                                              color: Colors.green,
//                                              borderRadius: BorderRadius.only(
//                                                  bottomRight:
//                                                      Radius.circular(15),
//                                                  bottomLeft:
//                                                      Radius.circular(15))),
//                                          child: new Row(
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.center,
//                                            children: <Widget>[
//                                              new Icon(
//                                                Icons.print,
//                                                color: Colors.white,
//                                              ),
//                                              new Padding(
//                                                padding:
//                                                    EdgeInsets.only(left: 5.0),
//                                                child: Text(
//                                                  "Print",
//                                                  style: TextStyle(
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold,
//                                                      fontSize: 12),
//                                                ),
//                                              )
//                                            ],
//                                          ))
//                                  )),
//                              flex: 1,
//                            ),
//                          ],
//                        ),
//                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class ClassroutinesTeachersPage extends StatefulWidget {
  final Map data;

  ClassroutinesTeachersPage({this.data});

  @override
  State<StatefulWidget> createState() => new _ClassroutinesTeachersPageState();
}

class _ClassroutinesTeachersPageState extends State<ClassroutinesTeachersPage>
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
    try {
      sundaylist = widget.data['sunday'];
      mondaylist = widget.data['monday'];
      tuesdaylist = widget.data['tuesday'];
      wendaylist = widget.data['wednesday'];
      thursdaylist = widget.data['thursday'];
      fridaylist = widget.data['friday'];
      satdaylist = widget.data['saturday'];
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Padding(
          padding: EdgeInsets.all(5.0),
          child: new Column(
            children: <Widget>[
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                fontSize: 11.0),
                          )),
                      sundaylist.length > 0
                          ? new Expanded(
                          child: ListView.builder(
                            itemBuilder:
                                (BuildContext context, int index) {

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
                                            color: Theme
                                                .of(context)
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
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
                                            color: Theme
                                                .of(context)
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
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
                                            color: Theme
                                                .of(context)
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
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
                                            color: Theme
                                                .of(context)
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
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
                                            color: Theme
                                                .of(context)
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
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
                                            color: Theme
                                                .of(context)
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
                                color: Theme
                                    .of(context)
                                    .primaryColor,
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
                                            color: Theme
                                                .of(context)
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


            ],
          )),
    );
  }
}
