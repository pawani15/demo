import 'dart:convert';
import 'dart:io';
import 'package:Edecofy/Student/academic_sylabus_student.dart';
import 'package:Edecofy/const.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../dashboard.dart';

class StudentLibraryRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StudentLibraryRequestPageState();
}

class _StudentLibraryRequestPageState extends State<StudentLibraryRequest> with SingleTickerProviderStateMixin{

  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String clas = '' , subject = '',file =''; TextEditingController description=new TextEditingController(),
      title=new TextEditingController();
  DateTime date = new DateTime.now();
  Map classmap= new Map(),subjectsmap = new Map();
  List<String> filetypelist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });


    LoadBookRequest();
  }

  Future<Null> LoadBookRequest() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Student_libraryRequestbook;
    Map<String, String> body = new Map();
    body['login_user_id'] = id;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
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
              int i =1;
              for (Map user in responseJson['result']['data']) {
                _Homeworkdetails.add(Requestedbookdetails.fromJson(user,i));
                i++;
              }
            });
            //teacherslist = responseJson['data'];
          }catch(e){
            _Homeworkdetails = new List();
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



  List<String> classlist= new List(),subjectsslist= new List();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("My Book Request"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
      //floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => Addstudymaterialdialog("refresh","new",null),backgroundColor: Theme.of(context).primaryColor,
      //),

      drawer: Constants().drawer(context),

      body: new Stack(
        children: <Widget>[
          new Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 15,height: 15,),
//                    new Text("Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                    new SizedBox(width: 15,height: 15,),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//
//                        Image(image: AssetImage('assets/refresh_icon.png')),
//                        new Text("Home > Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                      ],
//                    ),
//
//                  ],
//                )
            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search', border: InputBorder.none),
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
          new Container(
              margin: new EdgeInsets.only(left: 10,right: 5,bottom: 10,top: 75),
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
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:
                              DataTable(
                                columnSpacing: 10,
                                columns: [
                                  DataColumn(
                                    label: Text("S.No",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Requested Book",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Requested By",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Issue Starting Date",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Issue Ending Date",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Request Status",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                                          Text(user.reqbook),
                                        ),
                                        DataCell(
                                          Text(user.reqby),
                                        ),
                                        DataCell(
                                          Text(user.issuesstdt),
                                        ),
                                        DataCell(
                                          Text(user.isuueeddt),
                                        ),
                                        DataCell(
                                          Text(user.reqstatus),
                                        ),


                                      ]),
                                ).toList()
                                    : _Homeworkdetails.map(
                                      (user) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(user.sno),
                                        ),
                                        DataCell(
                                          Text(user.reqbook),
                                        ),
                                        DataCell(
                                          Text(user.reqby),
                                        ),
                                        DataCell(
                                          Text(user.issuesstdt),
                                        ),
                                        DataCell(
                                          Text(user.isuueeddt),
                                        ),

                                        DataCell(
                                          Text(user.reqstatus),
                                        ),

                                      ]),
                                ).toList(),
                              ),
                            ),
                          ],
                        )),
                  ),

                ],
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

    _Homeworkdetails.forEach((vehicleDetail) {
      if (vehicleDetail.reqbook.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.reqby.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.isuueeddt.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });


    setState(() {});
  }
  List<Requestedbookdetails> _searchResult = [];
  List<Requestedbookdetails> _Homeworkdetails = [];

}

class Requestedbookdetails{
  String   id,reqbook ,reqby,issuesstdt,isuueeddt,sno,reqstatus;
  Requestedbookdetails({this.sno, this.reqbook, this.id, this.reqby,this.issuesstdt,this.isuueeddt,this.reqstatus});
  factory Requestedbookdetails.fromJson(Map<String, dynamic> json,int no) {
    return new Requestedbookdetails(
//      id: json[''].toString() ,

      reqby:  json['student_name'].toString() ,
      reqbook: json['book_name'].toString(),
      isuueeddt: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['issue_end_date']) * 1000)).toString(),
      issuesstdt: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['issue_start_date']) * 1000)).toString(),
      reqstatus:json['status'].toString(),
      sno: no.toString(),
    );
  }
}

