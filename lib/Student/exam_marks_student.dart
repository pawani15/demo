import 'package:Edecofy/const.dart';
import 'package:Edecofy/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarksStudentTabScreen extends StatelessWidget {
  String studentname;
  String id;
//  MarksTabScreen({this.studentname,this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Marks"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
      drawer: Constants().drawer(context),
      body: StudentMarkstabsPage(studentname: studentname, id: id),
    );
  }
}

class StudentMarkstabsPage extends StatefulWidget {
  final String studentname,id;
  TabController _tabController;
  bool _loading = false;
  List markslist;
  List<Tab> tabs = new List();
  List<Widget> tabsbody = new List();
  StudentMarkstabsPage({this.studentname,this.id});
  @override
  State<StatefulWidget> createState() => new _StudentMarkstabsPageState();
}

class _StudentMarkstabsPageState extends State<StudentMarkstabsPage> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
    setState(() {
      widget._loading = true;
    });
    Loadmarkstabs();
  }

  Future<Null> Loadmarkstabs() async {
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Student_Load_Exam;
    Map<String, String> body = new Map();
    body['student_id'] = empid;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          responseJson['result'].forEach((data){
            widget.tabs.add(new Tab(text: data['name'].toString()));
            widget.tabsbody.add(new MarksPage(examid:data['exam_id'].toString(),studentid: empid,),);
          });
        }
        setState(() {
          widget._loading = false;
        });
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildScreen(context);
  }

  buildScreen (BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          height: 40,
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
//                    new SizedBox(width: 10,height: 10,),
//                    new Text(widget.studentname,style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
        ),
        new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 15,right: 15,bottom:0 ,top: 30),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: widget._loading ? new Constants().bodyProgress :
            (widget.tabsbody.isEmpty ? Center(
              child: Card(
                margin: EdgeInsets.all(16),
                child: Container(
                  //  color: Colors.red,
                  child: Text('NO Records Updated', style: TextStyle(color: Colors.red,fontSize: 15), ),
                  //  padding: EdgeInsets.all(16),
                ),
              ),
            ) : new DefaultTabController(
                length: widget.tabs.length,
                child: new Scaffold(
                  appBar: TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Theme.of(context).primaryColor,
                    tabs: widget.tabs,
                    controller: widget._tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                  body: TabBarView(
                    children: widget.tabsbody,
                    controller: widget._tabController,
                  ),
                )))
        ),
      ],
    );
  }

}

class MarksPage extends StatefulWidget {
  final String examid,studentid;
  MarksPage({this.examid,this.studentid});
  @override
  State<StatefulWidget> createState() => new _MarksPageState();
}

class _MarksPageState extends State<MarksPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  List markslist = new List();
  String total = '';
  String gradttl = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadmarks();
  }

  Future<Null> Loadmarks() async {
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Student_Load_Marks;
    Map<String, String> body = new Map();
    body['student_id'] = empid;
    body['exam_id'] = widget.examid;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true" && responseJson['result']!= null) {
          print("response json ${responseJson}");
          try {
            setState(() {
              //gradttl = responseJson['result']['count_grad_ttl'].toString();
              gradttl = responseJson['result']['total_grad_points'].toString();
//            print("gradtotal:::"+gradttl);
              total =responseJson['result']['total_marks'].toString() ;
              //  print(gradttl);
              markslist = responseJson['result']['marks'];
//              for(Map marks in responseJson['result']['marks']){
//                if (marks['mark_total'] != null)
//                  total = total + int.tryParse(marks['mark_total']);
//              }
              //   gradttl=['result']['count_grad_ttl'].toString();
            });
          }catch(e){
            markslist = new List();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  _loading ? new Constants().bodyProgress :
    markslist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
        : new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Padding(padding: new EdgeInsets.all(10),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(child: new Text("Subject",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),flex: 1,),
                  new Expanded(child: new Text("Obtained Marks",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                  new Expanded(child: new Text("Total Marks", style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center), flex: 1,),
                  new Expanded(child: new Text("Grade", style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center), flex: 1,),
                  new Expanded(child: new Text("Comments",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                ],
              )),
          new Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child:
              new Divider(height: 1,color: Colors.grey,)),
          markslist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
              :new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index) {
            return new Column(
              children: <Widget>[
                new Padding(padding: new EdgeInsets.all(10),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text("${markslist[index]['sub_name'].toString()}",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),textAlign: TextAlign.center)),flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(markslist[index]['mark_obtained']== null ? "" : markslist[index]['mark_obtained'].toString(),style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),textAlign: TextAlign.center)),flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.all(
                            2),
                            child: new Text(
                                markslist[index]['mark_total'] == null
                                    ? ""
                                    : markslist[index]['mark_total'].toString(),
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .primaryColor, fontSize: 15.0),
                                textAlign: TextAlign.center)), flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.all(
                            2),
                            child: new Text(
                                markslist[index]['grade_name'] == null
                                    ? ""
                                    : markslist[index]['grade_name'].toString(),
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .primaryColor, fontSize: 15.0),
                                textAlign: TextAlign.center)), flex: 1,),
                        // markslist['exam_result'][i]['question_type'] != null && resultData['exam_result'][i]['question_type'] == 'multiple_choice'?

                        markslist[index]['grade_comment'] == null ?
                        new Container() :
                        markslist[index]['grade_comment'] == 'fail'|| markslist[index]['grade_comment'] == 'Fail' ||  markslist[index]['grade_comment'] == 'FAIL'?
                        new Expanded(child: new Padding(
                            padding: EdgeInsets.all(2),
                            child: new Text(
                                markslist[index]['grade_comment'].toString(),
                                style: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                textAlign: TextAlign.center)), flex: 1,)
                            :
                        new Expanded(child: new Padding(
                            padding: EdgeInsets.all(2),
                            child: new Text(
                                markslist[index]['grade_comment'].toString(),
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .primaryColor, fontSize: 15.0),
                                textAlign: TextAlign.center)), flex: 1,)
                        ,

//                        new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(markslist[index]['comment'] == null
//                            && markslist[index]['comment']=='Fail'? "" : markslist[index]['comment'].toString(),style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),textAlign: TextAlign.center)),flex: 1,),
                      ],
                    )),
                new Padding(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child:
                    new Divider(height: 1,color: Colors.grey,)),
              ],
            );
          },itemCount: markslist.length,
          )),
          new Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text("Total Marks: " + total.toString(),
                    style: TextStyle(color: Theme
                        .of(context)
                        .primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10), textAlign: TextAlign.start,),
                  Flexible(
                    child: new Text(
                      "Average Grade Point :" + gradttl.toString(),
                      style: TextStyle(color: Theme
                          .of(context)
                          .primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),),
                  ),
                ],
              ),
            ),
          ),

//          new Container(
//            child: new Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                new Expanded(
//                  child: new Container(
//                      margin: new EdgeInsets.all(0.0),
//                      alignment: Alignment.center,
//                      width: double.infinity,
//                      child:new InkWell(
//                          onTap: () {
//                            Constants().ShowAlertDialog(context, "Coming Soon!");
//                          },
//                          child: new Container(
//                              padding: EdgeInsets.all(10),
//                              decoration: BoxDecoration(
//                                  color: Colors.green,
//                                  borderRadius: BorderRadius.only(
//                                      bottomRight:
//                                      Radius.circular(15),bottomLeft: Radius.circular(15))),
//                              child: new Row(
//                                mainAxisAlignment:
//                                MainAxisAlignment.center,
//                                children: <Widget>[
//                                  new Icon(
//                                    Icons.print,
//                                    color: Colors.white,
//                                  ),
//                                  new Padding(
//                                    padding:
//                                    EdgeInsets.only(left: 5.0),
//                                    child: Text(
//                                      "Print ",
//                                      style: TextStyle(
//                                          color: Colors.white,
//                                          fontWeight: FontWeight.bold,
//                                          fontSize: 12),
//                                    ),
//                                  )
//                                ],
//                              )))),
//                  flex: 1,
//                ),
//              ],
//            ),
//          ),

        ]
    );
  }

}
