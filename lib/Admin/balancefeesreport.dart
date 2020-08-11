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

class BalancefeesreportPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _BalancefeesreportPageState();
}

class _BalancefeesreportPageState extends State<BalancefeesreportPage> {
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

  Future<Null> Showreport() async {
    String id = await sp.ReadString("Userid");
    if(clas == ''){
      Constants().ShowAlertDialog(context, "Please select Class");
      return;
    }
    if(section == ''){
      Constants().ShowAlertDialog(context, "Please select Section");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Load_ExamsMarks+"/"+classmap[clas]+"/"+sectionamp[section];
    Map<String, String> body = new Map();
    body['student_id'] = id;

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
        if (responseJson != null) {
          print("response json ${responseJson}");
          setState(() {
            if(responseJson['result'].containsKey("marks_of_students")){

            }
          });
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  Future<Null> LoadStudents() async {
    String empid = await sp.ReadString("Userid");
    var url = '';
    url = await Constants().Clienturl() + Constants.Load_AllStudents+"11";

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
              for (Map user in responseJson['result']['std_all']) {
                _Balanceeesdetails.add(Balancefeesdetails.fromJson(user));
              }
          }catch(e){
            _Balanceeesdetails = new List();
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

  Map classmap= new Map(),subjectsmap = new Map(),sectionamp= new Map();
  List<String> classlist= new List(),subjectsslist= new List(),sectionslist = new List();

  _navigatetoclasses(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
    );
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
          for (Map data in responseJson['result']['classes']) {
            classlist.add(data['name']);
            classmap[data['name']] = data['class_id'];
          }
        }
        LoadStudents();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadSections() async{
    sectionslist.clear();
    subjectsslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();

    var url = await Constants().Clienturl() + Constants.Load_Sections+classmap[clas]+"/"+await Constants().Userid();
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['sections']) {
            sectionslist.add(data['name']);
            sectionamp[data['name']] = data['section_id'];
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Balance Fees Report"),
        backgroundColor: Color(0xff182C61),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),
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
              margin: EdgeInsets.only(top: 30),
              child: new Text("Balance Fees Report",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 90),
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
                                Constants().ShowAlertDialog(context, "Please select Class");
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
                                  labelText: "Seelct Student *",
                                  prefixIcon: new Icon(FontAwesomeIcons.userGraduate),
                                  suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                              ),
                              controller: TextEditingController(text: section),
                              enabled: false,
                            ),
                            onTap: () {
                              _navigatetosections(context);
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
                new Card(
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
                ),
                new Card(
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
                            new Expanded(child: new Padding(child: new Text("Students Fees Report",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
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
                                label: Text("Student Name"),
                              ),
                              DataColumn(
                                label: Text("ADMN No"),
                              ),
                              DataColumn(
                                label: Text("Roll No"),
                              ),
                              DataColumn(
                                label: Text("Father Name"),
                              ),
                              DataColumn(
                                label: Text("Total Fees"),
                              ),
                              DataColumn(
                                label: Text("Discount"),
                              ),
                              DataColumn(
                                label: Text("Fine"),
                              ),
                              DataColumn(
                                label: Text("Paid Fees"),
                              ),
                              DataColumn(
                                label: Text("Balance"),
                              ),
                            ],
                            rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                            _searchResult.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(user.studentname),
                                    ),
                                    DataCell(
                                      Text(user.admnno),
                                    ),
                                    DataCell(
                                      Text(user.rollno),
                                    ),
                                    DataCell(
                                      Text(user.fathername),
                                    ),
                                    DataCell(
                                      Text(user.totalfees),
                                    ),
                                    DataCell(
                                      Text(user.discount),
                                    ),
                                    DataCell(
                                      Text(user.fine),
                                    ),
                                    DataCell(
                                      Text(user.paidfees),
                                    ),
                                    DataCell(
                                      Text(user.balance),
                                    ),
                                  ]),
                            ).toList()
                                : _Balanceeesdetails.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(user.studentname),
                                    ),
                                    DataCell(
                                      Text(user.admnno),
                                    ),
                                    DataCell(
                                      Text(user.rollno),
                                    ),
                                    DataCell(
                                      Text(user.fathername),
                                    ),
                                    DataCell(
                                      Text(user.totalfees),
                                    ),
                                    DataCell(
                                      Text(user.discount),
                                    ),
                                    DataCell(
                                      Text(user.fine),
                                    ),
                                    DataCell(
                                      Text(user.paidfees),
                                    ),
                                    DataCell(
                                      Text(user.balance),
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
                )
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

    _Balanceeesdetails.forEach((vehicleDetail) {
      if (vehicleDetail.paidfees.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.balance.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Balancefeesdetails> _searchResult = [];
  List<Balancefeesdetails> _Balanceeesdetails = [];

}

class Balancefeesdetails {
  String fine, balance, discount,paidfees,id,studentname,admnno,rollno,fathername,totalfees;

  Balancefeesdetails({this.fine, this.balance, this.discount,this.paidfees,this.id,this.studentname,this.totalfees,this.fathername,this.rollno,this.admnno});

  factory Balancefeesdetails.fromJson(Map<String, dynamic> json) {
    return new Balancefeesdetails(
        balance: json['name'].toString() ,
        id:  json['student_id'].toString() ,
        fathername:  json['name'].toString() ,
        totalfees:  json['student_id'].toString() ,
        rollno:  json['student_id'].toString() ,
        admnno:  json['student_id'].toString() ,
        studentname:  json['name'].toString() ,
        paidfees: json['email'].toString(),
        discount: json['email'].toString(),
        fine: json['email'].toString()
    );
  }
}
