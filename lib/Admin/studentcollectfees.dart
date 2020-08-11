import 'dart:io';
import 'dart:math';

import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';
import '../dashboard.dart';

class StudentColectfeesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StudentColectfeesPageState();
}

class _StudentColectfeesPageState extends State<StudentColectfeesPage> {
  String exam = "",
      clas = '',
      section = '',
      subject = '',examaname='',classname='',sectionanme='',subjectname='';
  bool _loading = false,show=false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadClassdetails();
  }

  Future<Null> Collectfees() async {
    _Studentfeesdetails.clear();
    String id = await sp.ReadString("Userid");
    if(clas == ''){
      Constants().ShowAlertDialog(context, "Please select class");
      return;
    }
    if(section == ''){
      Constants().ShowAlertDialog(context, "Please select section");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Get_Collectfees_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = classmap[clas];
    body['section_id'] = sectionamp[section];
    body['keyword_search'] = search.text;

    print("url is $url" + "body--" + body.toString());

    http
        .post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body)
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          setState(() {
            for (Map user in responseJson['result']) {
              _Studentfeesdetails.add(Studentfeesdetails.fromJson(user));
            }
           show =true ;
          });
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  Map classmap= new Map(),subjectsmap = new Map(),sectionamp= new Map();
  List<String> classlist= new List(),subjectsslist= new List(),sectionslist = new List();

  _navigatetoclasses(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Classes", classlist);

    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    if(result != null)
      LoadSections();
  }

  _navigatetosections(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Sections", sectionslist);
    setState(() {
      section = result ?? section;
    });
    print("res--"+result.toString());
  }

  LoadClassdetails() async{
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
            classlist.add(data['class_name']);
            classmap[data['class_name']] = data['class_id'];
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

  LoadSections() async{
    sectionslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['class_id'] = classmap[clas];

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
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  TextEditingController search = new TextEditingController();

  Widget _EdittPopup(Studentfeesdetails studentfeesdetails) => PopupMenuButton<int>(
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
    },
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Collect Fees"),
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
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
              margin: EdgeInsets.only(top: 20),
              child: new Text("Select Criteria",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 60),
            child: new ListView(
              children: <Widget>[
                new Card(
                  margin: new EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: new ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
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
                                  labelText: "Section *",
                                  prefixIcon: new Icon(FontAwesomeIcons.user),
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
                            child: new TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Search by keywords like Rollno etc",
                                  prefixIcon: new Icon(Icons.list),
                              ),
                              controller: search,
                            ),
                      ),
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
                                        Collectfees();
                                        FocusScope.of(context).requestFocus(FocusNode());
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
                show ? new Card(
                  margin: new EdgeInsets.symmetric(horizontal: 15,vertical: 5),
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
                ) : new Container(),
                show ? new Card(
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
                            new Expanded(child: new Padding(child: new Text("Students List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: Text("Class"),
                              ),
                              DataColumn(
                                label: Text("Section"),
                              ),
                              DataColumn(
                                label: Text("ADMN No"),
                              ),
                              DataColumn(
                                label: Text("Name"),
                              ),
                              DataColumn(
                                label: Text("Actions"),
                              ),
                            ],
                            rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                            _searchResult.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(user.classname),
                                    ),
                                    DataCell(
                                      Text(user.section),
                                    ),
                                    DataCell(
                                      Text(user.admnno),
                                    ),
                                    DataCell(
                                      Text(user.name),
                                    ),
                                    DataCell(
                                      new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                    ),
                                  ]),
                            ).toList()
                                : _Studentfeesdetails.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(user.classname),
                                    ),
                                    DataCell(
                                      Text(user.section),
                                    ),
                                    DataCell(
                                      Text(user.admnno),
                                    ),
                                    DataCell(
                                      Text(user.name),
                                    ),
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
                ) : new Container()
              ],
            ),
          )
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

    _Studentfeesdetails.forEach((vehicleDetail) {
      if (vehicleDetail.admnno.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Studentfeesdetails> _searchResult = [];
  List<Studentfeesdetails> _Studentfeesdetails = [];

}

class Studentfeesdetails {
  String section, name, classname,admnno,id;

  Studentfeesdetails({this.section, this.name, this.classname,this.admnno,this.id});

  factory Studentfeesdetails.fromJson(Map<String, dynamic> json) {
    return new Studentfeesdetails(
        name: json['studentName'].toString() ,
        id:  json['studentId'].toString() ,
        admnno: json['admissionNo'].toString(),
        classname: json['className'].toString(),
        section: json['sectionName'].toString()
    );
  }
}
