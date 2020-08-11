import 'dart:collection';
import 'dart:io';

import 'package:Edecofy/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../AppUtils.dart';
import '../FilePicker.dart';
import '../search.dart';


class StudentAdmissionPage extends StatefulWidget {
  final String studid;
  StudentAdmissionPage({this.studid});

  @override
  State<StatefulWidget> createState() => new _StudentAdmissionPageState();
}

class _StudentAdmissionPageState extends State<StudentAdmissionPage> {
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  List<String> parentslist = new List(),
      sectionslist = new List();
  Map<String, String> parentmap = new HashMap(),
      sectionmap = new HashMap();
  String sectionname = "",
      parentname = "";
  DateTime dob = null,
      doj = null;
  TextEditingController name = new TextEditingController(),
      email = new TextEditingController(),
      phone = new TextEditingController(),
      lastname = new TextEditingController(),
      studentcode = new TextEditingController(),
      address = new TextEditingController(),
      gender = new TextEditingController(),
      aadharno = new TextEditingController(),
      password = new TextEditingController(),
      confirmpassword = new TextEditingController(),
      parent = new TextEditingController(),
      dormitory = new TextEditingController(),
      transport = new TextEditingController(),
      stream = new TextEditingController(),
      optsub = new TextEditingController(),
      bloodgroup = new TextEditingController(),
      nationality = new TextEditingController()
  ,
      religion = new TextEditingController(),
      mothertongue = new TextEditingController(),
      category = new TextEditingController(),
      minority = new TextEditingController()
  ,
      accno = new TextEditingController(),
      bankname = new TextEditingController(),
      ifsccode = new TextEditingController(),
      branchname = new TextEditingController(),
      schoolname = new TextEditingController(),
      result = new TextEditingController(),
      year = new TextEditingController(),
      last_class_medium = new TextEditingController(),
      last_class_rollno = new TextEditingController(),
      last_class_board = new TextEditingController();


  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    // LoadProfile();
  }


  Future<Null> Loadsectionstabs() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.studid;
    print("url is $url" + "body--" + body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            sectionslist.add(data['section_name']);
            sectionmap[data['section_name']] = data['section_id'];
          }
        }
        setState(() {
          _loading = false;
        });
      }
      else {
        print("erroe--" + response.body);
      }
    });
  }

  Future<Null> Loadparents() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.GetParents_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.studid;

    print("url is $url" + "body--" + body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            parentslist.add(data['parent_name']);
            parentmap[data['parent_name']] = data['parent_id'];
          }
        }
        Loadsectionstabs();
      }
      else {
        print("erroe--" + response.body);
      }
    });
  }

  Future<Null> CreateStudent() async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = "";

    url = await Constants().Clienturl() + Constants.Load_studentAdmission;

    Map<String, String> body = new Map();

    body['name'] = name.text;
    body['student_code'] = "code";
    body['last_name'] = lastname.text;
    body['email'] = email.text;
    body['password'] = password.text;
    body['phone'] = phone.text;
    body['adhar_no'] = aadharno.text;
    body['dormitory_id'] = dormitory.text;
    body['transport_id'] = transport.text;
    body['stream'] = stream.text;
    body['birthday'] =
    dob == null ? "" : new DateFormat('yyyy-MM-dd').format(dob);
    body['sex'] = gender.text;
    body['doj'] = doj == null ? "" : new DateFormat('yyyy-MM-dd').format(doj);
    body['blood_group'] = bloodgroup.text;
    body['opt_sub'] = optsub.text;
    body['nationality'] = nationality.text;
    body['religion'] = religion.text;
    body['mother_tongue'] = mothertongue.text;
    body['catagory'] = category.text;
    body['minority'] = minority.text;
    body['ac_no'] = accno.text;
    body['bank_name'] = bankname.text;
    body['ifsc_code'] = ifsccode.text;
    body['branch_name'] = branchname.text;
    body['school_name'] = schoolname.text;
    body['result'] = result.text;
    body['Year'] = year.text;
    body['last_class_roll_no'] = last_class_rollno.text;
    body['last_class_medium'] = last_class_medium.text;
    body['last_class_board'] = last_class_board.text;
    body['class_id'] = widget.studid;
    body['section_id'] = sectionmap[sectionname];
    body['parent_id'] = parentmap[parentname];

    print("url is $url" + "body--" + body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        print("response json ${responseJson}");
        Navigator.of(context).pop();
        if (responseJson['status'].toString() == "true") {
          Navigator.of(context).pop();

          const duration = const Duration(seconds: 2);
        }
        else {
          Constants().ShowAlertDialog(context, responseJson['message']);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  Future<Null> _selectDateofbirth(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime
              .now()
              .year - 20),
          lastDate: DateTime(DateTime
              .now()
              .year + 1));

      if (picked != null && picked != dob) {
        print('date selected : ${dob.toString()}');
        setState(() {
          dob = picked;
        });
      }
      Navigator.of(context).pop();
      //  AddsStudentdialog(action,"norefresh",studentdetails);
    } catch (e) {
      e.toString();
    }
  }

  Future<Null> _selectDateofjoining(BuildContext contex) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime
              .now()
              .year - 1),
          lastDate: DateTime(DateTime
              .now()
              .year + 1));

      if (picked != null && picked != doj) {
        print('date selected : ${doj.toString()}');
        setState(() {
          doj = picked;
        });
      }
      Navigator.of(context).pop();
      //    AddsStudentdialog(action,"norefresh",studentdetails);
    } catch (e) {
      e.toString();
    }
  }

  _navigatetogender(BuildContext context) async {
    List<String> Genderlist = new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(
        context, "Gender", Genderlist);
    setState(() {
      gender.text = result ?? gender.text;
    });
    print("res--" + result.toString());
    Navigator.of(context).pop();
    //AddsStudentdialog(action,"norefresh",studentdetails);
  }
  _navigatetominority(BuildContext context) async {
    List<String> Genderlist = new List();
    Genderlist.add("Yes");
    Genderlist.add("No");
    String result = await Constants().Selectiondialog(
        context, "Minority", Genderlist);
    setState(() {
      minority.text = result ?? minority.text;
    });
    print("res--" + result.toString());
    Navigator.of(context).pop();
    //AddsStudentdialog(action,"norefresh",studentdetails);
  }

  _navigatetosections(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          Search(
            title: "Sections", duplicateitems: sectionslist,)),
    );
    setState(() {
      sectionname = result ?? sectionname;
    });
    print("res--" + result.toString());
  }

  _navigatetoparents(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          Search(
            title: "Parents", duplicateitems: parentslist,)),
    );
    setState(() {
      parentname = result ?? parentname;
    });
    print("res--" + result.toString());
  }
  _navigatetotransport(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          Search(
            title: "Sections", duplicateitems: sectionslist,)),
    );
    setState(() {
      sectionname = result ?? sectionname;
    });
    print("res--" + result.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Students"),
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
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
              margin: EdgeInsets.only(top: 20),
              child: new Text("Student Admission", style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            ),
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(
                left: 40, right: 40, bottom: 20, top: 90),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child:
            //_loading ? new Constants().bodyProgress :
            new ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top: 5),
                  child: new Text("Student Admission", style: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                ),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Date Of Join",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller: name,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Admission No *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller: lastname,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "First name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller: lastname,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller: lastname,
                )),
                new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "parents *",
                            prefixIcon: new Icon(Icons.list),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
                        controller: TextEditingController(text: parentname),
                        enabled: false,
                      ),
                      onTap: () {
                     //   _navigatetosubjects(context);
                      },
                    )),

                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Gender *",
                          prefixIcon: new Icon(FontAwesomeIcons.list),
                        ),
                        controller: gender,
                        enabled: false,
                      ),
                      onTap: () {
                        _navigatetogender(context);
                      },
                    )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date Of Birth *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(
                            text: dob == null ? "" : new DateFormat(
                                'yyyy-MM-dd').format(dob)),
                      ),
                      onTap: () {
                        _selectDateofbirth(context);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Phone *",
                    prefixIcon: new Icon(Icons.phone),
                  ),
                  controller: phone,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller: email,
                )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Section *",
                          prefixIcon: new Icon(FontAwesomeIcons.list),
                        ),
                        controller: new TextEditingController(
                            text: sectionname),
                        enabled: false,
                      ),
                      onTap: () {
                        _navigatetosections(context);
                      },
                    )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Parent *",
                          prefixIcon: new Icon(FontAwesomeIcons.list),
                        ),
                        controller: new TextEditingController(text: parentname),
                        enabled: false,
                      ),
                      onTap: () {
                        _navigatetoparents(context);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Address *",
                      prefixIcon: new Icon(Icons.location_on)
                  ),
                  controller: address,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Password *",
                      prefixIcon: new Icon(FontAwesomeIcons.lockOpen)
                  ),
                  controller: password,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Aadhar no *",
                      prefixIcon: new Icon(Icons.confirmation_number)
                  ),
                  controller: aadharno,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Dormitory *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: dormitory,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Transport *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: transport,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Dormitory *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: dormitory,
                )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date Of Joining *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(
                            text: doj == null ? "" : new DateFormat(
                                'yyyy-MM-dd').format(doj)),
                      ),
                      onTap: () {
                        _selectDateofjoining(context);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Stream *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: stream,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Optional Subject *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: optsub,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Blood group *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: bloodgroup,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Nationality *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: nationality,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Religion *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: religion,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Mother tounge *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: mothertongue,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Category *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: category,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Minority *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: minority,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Account no *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: accno,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Bank name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: bankname,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Ifsc code *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: ifsccode,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Branch name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: branchname,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Result *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: result,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "School name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: schoolname,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Year *",
                      prefixIcon: new Icon(FontAwesomeIcons.calendar)
                  ),
                  controller: year,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class medium *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_medium,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class roolno *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_rollno,
                )),
                new Container(margin: EdgeInsets.all(5.0), child: new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class board *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_board,
                )),
                new SizedBox(width: 30, height: 30,),
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
                                //  AddsStudentdialog("new","refresh",studentdetails);
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
                                      new Icon(
                                        Icons.autorenew, color: Colors.white,),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text("Reset", style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),),)
                                    ],
                                  )))), flex: 1,),
                      new Expanded(child: new Container(
                          margin: new EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: new InkWell(
                              onTap: () {
                                if (name.text == "") {
                                  Constants().ShowAlertDialog(
                                      context, "Please enter name");
                                  return;
                                }
                                if (gender.text == "") {
                                  Constants().ShowAlertDialog(
                                      context, "Please select gender");
                                  return;
                                }
                                if (dob == "") {
                                  Constants().ShowAlertDialog(
                                      context, "Please select date of birth");
                                  return;
                                }
                                if (phone.text == null) {
                                  Constants().ShowAlertDialog(
                                      context, "Please enter phone no");
                                  return;
                                }
                                if (phone.text != null &&
                                    phone.text.length != 10) {
                                  Constants().ShowAlertDialog(context,
                                      "Please enter 10 digit phone no");
                                  return;
                                }
                                if (email.text == "") {
                                  Constants().ShowAlertDialog(
                                      context, "Please enter email");
                                  return;
                                }
                                if (sectionname == "") {
                                  Constants().ShowAlertDialog(
                                      context, "Please select section");
                                  return;
                                }
                                if (parentname == "") {
                                  Constants().ShowAlertDialog(
                                      context, "Please select parent");
                                  return;
                                }
                                // CreateStudent("edit", "");
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
                                      new Icon(
                                        Icons.check, color: Colors.white,),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text("Save", style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),),)
                                    ],
                                  )))), flex: 1,),
                    ],
                  ),
                )
              ],
            ),),
        ],
      ),
    );
  }
}