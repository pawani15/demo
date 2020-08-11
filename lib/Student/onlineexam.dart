import 'dart:io';

import 'package:Edecofy/Student/student_view_answer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../const.dart';
import '../dashboard.dart';
import 'Student_QuestionScreen.dart';
import 'Subject_AnswerDialog.dart';

class OnlineexamsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _OnlineexamsPageState();
}

class _OnlineexamsPageState extends State<OnlineexamsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadonlineexams();
  }

  Future<Null> Loadonlineexams() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Student_Onlineexams_list;
    Map<String, String> body = new Map();
    body['student_id'] = id;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body:body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            int i =1;
            for (Map user in responseJson['result']) {
              _Onlineexamdetails.add(Onlineexamdetails.fromJson(user,i));
              i++;
            }
          }catch(e){
            _Onlineexamdetails = new List();
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
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Online Exam"),
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
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
              shape: BoxShape.rectangle
            ),
            child: new Container(
                child: Column(
                  children: <Widget>[
                    new SizedBox(width: 15,height: 15,),
                    new Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange
                      ),
                      child: new SvgPicture.asset("assets/clipboard.svg",color: Colors.white,width: 25,height: 25,),
                      padding: new EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                    ),
                    new Text("Online Exam",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 90),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search..', border: InputBorder.none),
                onChanged: onSearchTextChanged,
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
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 160),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                      child: new Text("Online Exam",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Text("Exam name",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 2,),
                        new Expanded(child: new Text("Subject",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 2,),
                        new Expanded(child: new Text("Exam Date/Time",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 4,),
                        new Expanded(child: new Text("Action",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 4,),
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Expanded(child: _searchResult.length != 0 || controller.text.isNotEmpty ?
                    new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                              child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text("${_searchResult[index].title}",style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 2,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].subject,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 2,),
                                  new Expanded(child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Padding(padding: EdgeInsets.all(2),child: Text.rich(
                                        TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: "Date: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                            TextSpan(text: _searchResult[index].date, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                          ],
                                        ),
                                      )),
                                      new Padding(padding: EdgeInsets.all(2),child:Text.rich(
                                        TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: "Time: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                            TextSpan(text: _searchResult[index].time, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),flex: 4,),
                                  new Expanded(
                                    child: new InkWell(
                                      child: new Container(
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: _Onlineexamdetails[index].status != "submitted" ? Colors.green : Colors.grey[600],
                                            borderRadius: BorderRadius.all(Radius.circular(15))
                                        ),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            new Padding(padding: EdgeInsets.only(left: 10,right: 2,top: 5,bottom: 5),child: new Text(_searchResult[index].status != "submitted" ? "Take Exam": "Submitted",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                            new Padding(padding: EdgeInsets.only(right: 5,left: 2,top: 5,bottom: 5), child: new Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white
                                              ),
                                              padding: EdgeInsets.all(3),
                                              child: new Icon(_searchResult[index].status != "submitted" ? Icons.edit : Icons.access_time ,color: _searchResult[index].status != "submitted" ? Colors.green : Colors.grey[600] ,size: 15,),
                                            ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        DateTime today = new DateTime.now();
                                        DateTime start =  DateTime.parse(_searchResult[index].date1.trim()+" "+_searchResult[index].time.trim().split("-")[0]+":00");
                                        DateTime end =  DateTime.parse(_searchResult[index].date1.trim()+" "+_searchResult[index].time.trim().split("-")[1]+":00");
                                        if(_searchResult[index].status != "submitted") {
                                          if (today.isAfter(start) &&
                                              today.isBefore(end)) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuestionScreen(examcode: _searchResult[index].code,examid: _searchResult[index].id,examdate:_searchResult[index].date1 ,),
                                                ));
                                          }
                                          else {
                                            Constants().ShowAlertDialog(context, "you can only take the exam during the scheduled time");
                                          }
                                        }
                                        else
                                          Constants().ShowAlertDialog(context, "This exam already submitted.");
                                      },
                                    ),
                                    flex: 4,
                                  ),
                                ],
                          )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount: _searchResult == null ? 0 : _searchResult.length,
                    ) : _Onlineexamdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text("${_Onlineexamdetails[index].title}",style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 2,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Onlineexamdetails[index].subject,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 2,),
                                  new Expanded(child:
                                  new Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Padding(padding: EdgeInsets.all(2),child: Text.rich(
                                        TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: "Date: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                            TextSpan(text: _Onlineexamdetails[index].date, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                          ],
                                        ),
                                      )),
                                      new Padding(padding: EdgeInsets.all(2),child:Text.rich(
                                        TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: "Time: " , style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11)),
                                            TextSpan(text: _Onlineexamdetails[index].time, style: TextStyle(color: Colors.grey,fontSize: 11)),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),flex: 4,),
                                  new Expanded(
                                    child: new InkWell(
                                      child: new Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: _Onlineexamdetails[index].status != "submitted" ? Colors.green : Colors.grey[600],
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(padding: EdgeInsets.only(left: 10,right: 2,top: 5,bottom: 5),child: new Text(_Onlineexamdetails[index].status != "submitted" ? "Take Exam": "Submitted",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                          new Padding(padding: EdgeInsets.only(right: 5,left: 2,top: 5,bottom: 5), child: new Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white
                                              ),
                                            padding: EdgeInsets.all(3),
                                            child: new Icon(_Onlineexamdetails[index].status != "submitted" ? Icons.edit : Icons.access_time ,color: _Onlineexamdetails[index].status != "submitted" ? Colors.green : Colors.grey[600] ,size: 15,),
                                          ),
                                          )
                                        ],
                                      ),
                                    ),
                                      onTap: (){
                                        DateTime today = new DateTime.now();
                                        DateTime start =  new DateFormat("yyyy-MM-dd hh:mm:ss").parse(_Onlineexamdetails[index].date1.trim()+" "+_Onlineexamdetails[index].time.trim().split("-")[0]+":00");
                                        DateTime end =  new DateFormat("yyyy-MM-dd hh:mm:ss").parse(_Onlineexamdetails[index].date1.trim()+" " +_Onlineexamdetails[index].time.trim().split("-")[1]+":00");
                                        if(_Onlineexamdetails[index].status != "submitted") {
                                          if ((today.isAfter(start) &&
                                              today.isBefore(end))) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuestionScreen(examcode: _Onlineexamdetails[index].code,examid: _Onlineexamdetails[index].id,examdate:_Onlineexamdetails[index].date1 ,),
                                                ));
                                          }
                                          else {
                                            Constants().ShowAlertDialog(context, "you can only take the exam during the scheduled time");
                                          }
                                        }
                                        else
                                          Constants().ShowAlertDialog(context, "This exam already submitted.");
                                      },
                                    ),
                                    flex: 4,
                                  ),
                                ],
                              )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount:_Onlineexamdetails == null ? 0 : _Onlineexamdetails.length,
                    )
                    )
                  ],
                )),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              /*Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: IconButton(
                    icon: Icon(Icons.add,color: Colors.white,),
                    tooltip: "Take Test",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionScreen(),
                          ));
                    },

                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
              ),*/

              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: IconButton(
                    icon: Icon(Icons.remove_red_eye,color: Colors.white,),
                    tooltip:"View Result",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StudentViewanswer()
                          ));
                      },

                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
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

    _Onlineexamdetails.forEach((vehicleDetail) {
      if (vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.time.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.subject.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.date.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Onlineexamdetails> _searchResult = [];
  List<Onlineexamdetails> _Onlineexamdetails = [];

}

class Onlineexamdetails {
  String sno, subject,date,time,id,code,status,date1,title;
  Onlineexamdetails({this.sno, this.subject,this.date,this.time,this.id,this.code,this.status,this.date1,this.title});

  factory Onlineexamdetails.fromJson(Map<String, dynamic> json,int no) {
    return new Onlineexamdetails(
        subject:  json['subject_name'].toString() ,
        time:  "  "+json['time_start'].toString()+"-"+json['time_end'].toString() ,
        date: "  "+ new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['exam_date']) * 1000)).toString(),
        date1: new DateFormat('yyyy-MM-dd').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['exam_date']) * 1000)).toString(),
        id:  json['online_exam_id'].toString() ,
        title:  json['title'].toString() ,
        code:  json['code'].toString() ,
        status:  json['status_name'].toString() ,
        sno: no.toString()
    );
  }
}