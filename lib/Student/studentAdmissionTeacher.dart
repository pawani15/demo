import 'dart:collection';

import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../const.dart';

class AdminStudentstabsPage extends StatefulWidget {
  final String id;
  AdminStudentstabsPage({this.id});

  @override
  State<StatefulWidget> createState() => new _AdminStudentstabsPageState();
}

class _AdminStudentstabsPageState extends State<AdminStudentstabsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;

  List<Tab> tabs = new List();
  List<Widget> tabsbody = new List();

  List<String> parentslist = new List(),sectionslist = new List();
  Map<String,String> parentmap = new HashMap(),sectionmap = new HashMap();
  String sectionname ="" , parentname="";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    tabs.add(new Tab(text : "All Students"));
    tabsbody.add(new AdminStudentsiformationPage(sectionid:null,classid: widget.id,),);
    Loadparents();
  }

  Future<Null> Loadsectionstabs() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.id;

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
            tabs.add(new Tab(text : "Section - "+data['section_name'].toString()));
            tabsbody.add(new AdminStudentsiformationPage(sectionid:data['section_id'].toString(),classid: widget.id,),);
            sectionslist.add(data['section_name']);
            sectionmap[data['section_name']] = data['section_id'];
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

  Future<Null> Loadparents() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.GetParents_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.id;

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
            parentslist.add(data['parent_name']);
            parentmap[data['parent_name']] = data['parent_id'];
          }
        }
        Loadsectionstabs();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> CreateStudent(String type,String studentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url="";
    if(type == "new")
      url = await Constants().Clienturl() + Constants.Create_Student;
    else
      url = await Constants().Clienturl() + Constants.Create_Student;

    Map<String, String> body = new Map();
    if(type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['student_id'] = studentid;
    }
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
    body['birthday'] = dob == null ? "" : new DateFormat('yyyy-MM-dd').format(dob);
    body['sex'] = gender.text;
    body['doj'] = doj == null ? "" :  new DateFormat('yyyy-MM-dd').format(doj);
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

    body['class_id'] = widget.id;
    body['section_id'] = sectionmap[sectionname];
    body['parent_id'] = parentmap[parentname];

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
          if(type == "edit")
            Constants().ShowSuccessDialog(context, "Student updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Student added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                new AdminStudentstabsPage(id: widget.id,)));
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

  Future<Null> _selectDateofbirth(BuildContext context, String action, Studentdetails studentdetails) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-20),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != dob) {
        print('date selected : ${dob.toString()}');
        setState(() {
          dob = picked;
        });
      }
      Navigator.of(context).pop();
      AddsStudentdialog(action,"norefresh",studentdetails);
    }catch(e){e.toString();}
  }

  Future<Null> _selectDateofjoining(BuildContext context, String action, Studentdetails studentdetails) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != doj) {
        print('date selected : ${doj.toString()}');
        setState(() {
          doj = picked;
        });
      }
      Navigator.of(context).pop();
      AddsStudentdialog(action,"norefresh",studentdetails);
    }catch(e){e.toString();}
  }

  _navigatetogender(BuildContext context, String action, Studentdetails studentdetails) async {
    List<String> Genderlist= new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(context, "Gender", Genderlist);
    setState(() {
      gender.text = result ?? gender.text;
    });
    print("res--"+result.toString());
    Navigator.of(context).pop();
    AddsStudentdialog(action,"norefresh",studentdetails);
  }

  _navigatetosections(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Sections",duplicateitems: sectionslist,)),
    );
    setState(() {
      sectionname = result ?? sectionname;
    });
    print("res--"+result.toString());
  }

  _navigatetoparents(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Parents",duplicateitems: parentslist,)),
    );
    setState(() {
      parentname = result ?? parentname;
    });
    print("res--"+result.toString());
  }

  DateTime dob = null,doj=null;
  TextEditingController name= new TextEditingController(),email = new TextEditingController(),phone = new TextEditingController(),lastname = new TextEditingController(),
      studentcode = new TextEditingController(),address = new TextEditingController(),gender = new TextEditingController(),aadharno = new TextEditingController(),
      password = new TextEditingController(),confirmpassword = new TextEditingController(),parent = new TextEditingController(),dormitory = new TextEditingController(),
      transport = new TextEditingController(),stream = new TextEditingController(),optsub = new TextEditingController(),bloodgroup = new TextEditingController(),nationality = new TextEditingController()
  ,religion = new TextEditingController(),mothertongue = new TextEditingController(),category = new TextEditingController(),minority = new TextEditingController()
  ,accno = new TextEditingController(),bankname = new TextEditingController(),ifsccode = new TextEditingController(),branchname = new TextEditingController(),schoolname = new TextEditingController(),
      result = new TextEditingController(),year = new TextEditingController(),last_class_medium = new TextEditingController(),last_class_rollno = new TextEditingController(),last_class_board = new TextEditingController();

  AddsStudentdialog(String action, String status, Studentdetails studentdetails) async {
    String titlename = "Add Student",save='';
    IconData icon = null;

    if(status == 'refresh') {
      if (action == "new") {
        name.text = '';
        lastname.text ='';
        email.text = '';
        phone.text = '';
        studentcode.text ='';
        gender.text='';
        aadharno.text='';
        transport.text='';
        parent.text='';
        dormitory.text='';
        stream.text='';
        dob=null;
        doj=null;
        optsub.text = '';
        bloodgroup.text = '';
        nationality.text = '';
        result.text = '';
        religion.text = '';
        category.text = '';
        mothertongue.text = '';
        minority.text = '';
        accno.text = '';
        bankname.text = '';
        ifsccode.text = '';
        branchname.text = '';
        schoolname.text = '';
        year.text = '';
        last_class_medium.text = '';
        last_class_rollno.text = '';
        last_class_board.text = '';
        sectionname = '';
        parentname ='';

        titlename = "Add Student";
        icon = Icons.add;
        save = "Add Student";
      }
      else {
        /* var url = await Constants().Clienturl() + Constants.Edit_Teacher_Getdetails+studentdetails.id;
        Map<String, String> body = new Map();
        print("url is $url"+"body--"+body.toString());

        http.post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
            .then((response) {
          if (response.statusCode == 200) {
            print("response --> ${response.body}");
            var responseJson = json.decode(response.body);
            print("response json ${responseJson}");
            if(responseJson['status'].toString() == "true"){
              Map data = responseJson["result"]['edit_data'][0];
              name.text = data['name'];
              email.text = data['email'];
              phone.text = data['phone'];
              address.text = data['address'];
              studentcode.text =data['designation'];
              gender.text=data['sex'];
              aadharno.text=data['show_on_website'];
              transport.text="";
              parent.text="";
              dormitory.text="";
              stream.text="";
              dob= DateTime.parse(data['birthday']+" 00:00:00");
              doj= DateTime.parse(data['birthday']+" 00:00:00");
            }
          }
          else {
            print("erroe--"+response.body);
          }
        });*/
        name.text = studentdetails.name;
        lastname.text =studentdetails.name;
        email.text = studentdetails.email;
        phone.text = studentdetails.phone;
        studentcode.text ='';
        gender.text='';
        aadharno.text='';
        transport.text='';
        parent.text='';
        dormitory.text='';
        stream.text='';
        dob=null;
        doj=null;
        optsub.text = '';
        bloodgroup.text = '';
        nationality.text = '';
        result.text = '';
        religion.text = '';
        category.text = '';
        mothertongue.text = '';
        minority.text = '';
        accno.text = '';
        bankname.text = '';
        ifsccode.text = '';
        branchname.text = '';
        schoolname.text = '';
        year.text = '';
        last_class_medium.text = '';
        last_class_rollno.text = '';
        last_class_board.text = '';
        sectionname = '';
        parentname ='';

        titlename = "Edit Student Info";
        icon = Icons.edit;
        save = "Save";
      }
    }
    else{
      if (action == "new") {
        titlename = "Add Student";
        icon = Icons.add;
        save = "Add Student";
      }
      else {
        titlename = "Edit Student Info";
        icon = Icons.edit;
        save = "Save";
      }
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
                              icon,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text(titlename,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 10,width: 10,),
                /*new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Student code *",
                      prefixIcon: new Icon(FontAwesomeIcons.code)
                  ),
                  controller:  studentcode,
                )),*/
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller:  name,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller:  lastname,
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
                        _navigatetogender(context,action,studentdetails);
                      },
                    )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date Of Birth *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: dob == null ? "" :  new DateFormat('yyyy-MM-dd').format(dob)),
                      ),
                      onTap: (){
                        _selectDateofbirth(context,action,studentdetails);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Phone *",
                    prefixIcon: new Icon(Icons.phone),
                  ),
                  controller:  phone,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  email,
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
                        controller: new TextEditingController(text: sectionname),
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
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Address *",
                      prefixIcon: new Icon(Icons.location_on)
                  ),
                  controller: address,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Password *",
                      prefixIcon: new Icon(FontAwesomeIcons.lockOpen)
                  ),
                  controller:  password,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Aadhar no *",
                      prefixIcon: new Icon(Icons.confirmation_number)
                  ),
                  controller: aadharno,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Dormitory *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: dormitory,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Transport *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: transport,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Dormitory *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: dormitory,
                )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date Of Joining *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: doj == null ? "" :  new DateFormat('yyyy-MM-dd').format(doj)),
                      ),
                      onTap: (){
                        _selectDateofjoining(context,action,studentdetails);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Stream *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: stream,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Optional Subject *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: optsub,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Blood group *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: bloodgroup,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Nationality *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: nationality,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Religion *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: religion,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Mother tounge *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: mothertongue,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Category *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: category,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Minority *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: minority,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Account no *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: accno,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Bank name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: bankname,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Ifsc code *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: ifsccode,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Branch name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: branchname,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Result *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: result,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "School name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: schoolname,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Year *",
                      prefixIcon: new Icon(FontAwesomeIcons.calendar)
                  ),
                  controller: year,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class medium *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_medium,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class roolno *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_rollno,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class board *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_board,
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
                                AddsStudentdialog("new","refresh",studentdetails);
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
                                if(name.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter name");
                                  return;
                                }
                                if(gender.text == ""){
                                  Constants().ShowAlertDialog(context, "Please select gender");
                                  return;
                                }
                                if(dob == ""){
                                  Constants().ShowAlertDialog(context, "Please select date of birth");
                                  return;
                                }
                                if(phone.text == null){
                                  Constants().ShowAlertDialog(context, "Please enter phone no");
                                  return;
                                }
                                if(phone.text != null && phone.text.length !=10){
                                  Constants().ShowAlertDialog(context, "Please enter 10 digit phone no");
                                  return;
                                }
                                if(email.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter email");
                                  return;
                                }
                                if(sectionname == ""){
                                  Constants().ShowAlertDialog(context, "Please select section");
                                  return;
                                }
                                if(parentname == ""){
                                  Constants().ShowAlertDialog(context, "Please select parent");
                                  return;
                                }
                                CreateStudent("new", "");
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
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text(save,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
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
        title: Text("Student Informations"),
        backgroundColor: Color(0xff182C61),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
                child: Column(
                  children: <Widget>[
                    new SizedBox(width: 30,height: 30,),
                    new Text("All Students Information",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ),
          new Container(
              margin: new EdgeInsets.only(left: 15,right: 5,bottom: 10,top: 70),
              child : new Stack(
                children: <Widget>[
                  new Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.only(top: 30,right: 10),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _loading ? new Constants().bodyProgress :
                    new DefaultTabController(
                        length: tabs.length,
                        child: new Scaffold(
                          appBar: TabBar(
                            unselectedLabelColor: Colors.grey,
                            labelColor: Theme.of(context).primaryColor,
                            tabs: tabs,
                            isScrollable: true,
                            controller: _tabController,
                            indicatorColor: Theme.of(context).primaryColor,
                          ),
                          body: TabBarView(
                            children: tabsbody,
                            controller: _tabController,
                          ),
                        )),
                  ),
                  new Align(
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
                        AddsStudentdialog("new","refresh",null);
                      },
                      )
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class AdminStudentsiformationPage extends StatefulWidget {
  final String sectionid,classid;
  AdminStudentsiformationPage({this.sectionid,this.classid});

  @override
  State<StatefulWidget> createState() => new _AdminStudentsiformationPageState();
}

class _AdminStudentsiformationPageState extends State<AdminStudentsiformationPage> with SingleTickerProviderStateMixin{
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  List<String> parentslist = new List(),sectionslist = new List();
  Map<String,String> parentmap = new HashMap(),sectionmap = new HashMap();
  String sectionname ="" , parentname="";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadStudents();
  }

  Future<Null> LoadStudents() async {
    String empid = await sp.ReadString("Userid");
    var url = '';
    _Studentdetails.clear();

    url = await Constants().Clienturl() + Constants.Load_Classwisestudents_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.classid;
    if(widget.sectionid != null)
      body['Section_id'] = widget.sectionid;


    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body:body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            if(widget.sectionid == null) {
              setState(() {
                for (Map user in responseJson['result']) {
                  _Studentdetails.add(Studentdetails.fromJson(user));
                }
              });
            }
            else{
              setState(() {
                for (Map user in responseJson['result']) {
                  _Studentdetails.add(Studentdetails.fromJson(user));
                }
              });
            }
          }catch(e){
            _Studentdetails = new List();
          }
        }
        Loadsectionstabs();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }


  Future<Null> Loadsectionstabs() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Sections_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.classid;

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
            sectionslist.add(data['section_name']);
            sectionmap[data['section_name']] = data['section_id'];
          }
        }
        Loadparents();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> Loadparents() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.GetParents_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.classid;

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
            parentslist.add(data['parent_name']);
            parentmap[data['parent_name']] = data['parent_id'];
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

  Future<Null> CreateStudent(String type,String studentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url="";
    if(type == "new")
      url = await Constants().Clienturl() + Constants.Create_Student;
    else
      url = await Constants().Clienturl() + Constants.Create_Student;

    Map<String, String> body = new Map();
    if(type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "do_update";
      body['student_id'] = studentid;
    }
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
    body['birthday'] = dob == null ? "" : new DateFormat('yyyy-MM-dd').format(dob);
    body['sex'] = gender.text;
    body['doj'] = doj == null ? "" :  new DateFormat('yyyy-MM-dd').format(doj);
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

    body['class_id'] = widget.classid;
    body['section_id'] = sectionmap[sectionname];
    body['parent_id'] = parentmap[parentname];

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
          if(type == "edit")
            Constants().ShowSuccessDialog(context, "Student updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Student added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                new AdminStudentstabsPage(id: widget.classid,)));
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

  Future<Null> _selectDateofbirth(BuildContext context, String action, Studentdetails studentdetails) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-20),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != dob) {
        print('date selected : ${dob.toString()}');
        setState(() {
          dob = picked;
        });
      }
      Navigator.of(context).pop();
      AddsStudentdialog(action,"norefresh",studentdetails);
    }catch(e){e.toString();}
  }

  Future<Null> _selectDateofjoining(BuildContext context, String action, Studentdetails studentdetails) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != doj) {
        print('date selected : ${doj.toString()}');
        setState(() {
          doj = picked;
        });
      }
      Navigator.of(context).pop();
      AddsStudentdialog(action,"norefresh",studentdetails);
    }catch(e){e.toString();}
  }

  _navigatetogender(BuildContext context, String action, Studentdetails studentdetails) async {
    List<String> Genderlist= new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(context, "Gender", Genderlist);
    setState(() {
      gender.text = result ?? gender.text;
    });
    print("res--"+result.toString());
    Navigator.of(context).pop();
    AddsStudentdialog(action,"norefresh",studentdetails);
  }

  _navigatetosections(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Sections",duplicateitems: sectionslist,)),
    );
    setState(() {
      sectionname = result ?? sectionname;
    });
    print("res--"+result.toString());
  }

  _navigatetoparents(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Parents",duplicateitems: parentslist,)),
    );
    setState(() {
      parentname = result ?? parentname;
    });
    print("res--"+result.toString());
  }


  DateTime dob = null,doj=null;
  TextEditingController name= new TextEditingController(),email = new TextEditingController(),phone = new TextEditingController(),lastname = new TextEditingController(),
      studentcode = new TextEditingController(),address = new TextEditingController(),gender = new TextEditingController(),aadharno = new TextEditingController(),
      password = new TextEditingController(),confirmpassword = new TextEditingController(),parent = new TextEditingController(),dormitory = new TextEditingController(),
      transport = new TextEditingController(),stream = new TextEditingController(),optsub = new TextEditingController(),bloodgroup = new TextEditingController(),nationality = new TextEditingController()
  ,religion = new TextEditingController(),mothertongue = new TextEditingController(),category = new TextEditingController(),minority = new TextEditingController()
  ,accno = new TextEditingController(),bankname = new TextEditingController(),ifsccode = new TextEditingController(),branchname = new TextEditingController(),schoolname = new TextEditingController(),
      result = new TextEditingController(),year = new TextEditingController(),last_class_medium = new TextEditingController(),last_class_rollno = new TextEditingController(),last_class_board = new TextEditingController();

  AddsStudentdialog(String action, String status, Studentdetails studentdetails) async {
    String titlename = "Add Student",save='';
    IconData icon = null;

    if(status == 'refresh') {
      if (action == "new") {
        name.text = '';
        lastname.text ='';
        email.text = '';
        phone.text = '';
        studentcode.text ='';
        gender.text='';
        aadharno.text='';
        transport.text='';
        parent.text='';
        dormitory.text='';
        stream.text='';
        dob=null;
        doj=null;
        optsub.text = '';
        bloodgroup.text = '';
        nationality.text = '';
        result.text = '';
        religion.text = '';
        category.text = '';
        mothertongue.text = '';
        minority.text = '';
        accno.text = '';
        bankname.text = '';
        ifsccode.text = '';
        branchname.text = '';
        schoolname.text = '';
        year.text = '';
        last_class_medium.text = '';
        last_class_rollno.text = '';
        last_class_board.text = '';
        sectionname = '';
        parentname ='';

        titlename = "Add Student";
        icon = Icons.add;
        save = "Add Student";
      }
      else {
        /* var url = await Constants().Clienturl() + Constants.Edit_Teacher_Getdetails+studentdetails.id;
        Map<String, String> body = new Map();
        print("url is $url"+"body--"+body.toString());

        http.post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
            .then((response) {
          if (response.statusCode == 200) {
            print("response --> ${response.body}");
            var responseJson = json.decode(response.body);
            print("response json ${responseJson}");
            if(responseJson['status'].toString() == "true"){
              Map data = responseJson["result"]['edit_data'][0];
              name.text = data['name'];
              email.text = data['email'];
              phone.text = data['phone'];
              address.text = data['address'];
              studentcode.text =data['designation'];
              gender.text=data['sex'];
              aadharno.text=data['show_on_website'];
              transport.text="";
              parent.text="";
              dormitory.text="";
              stream.text="";
              dob= DateTime.parse(data['birthday']+" 00:00:00");
              doj= DateTime.parse(data['birthday']+" 00:00:00");
            }
          }
          else {
            print("erroe--"+response.body);
          }
        });*/
        name.text = studentdetails.name;
        lastname.text =studentdetails.name;
        email.text = studentdetails.email;
        phone.text = studentdetails.phone;
        studentcode.text ='';
        gender.text='';
        aadharno.text='';
        transport.text='';
        parent.text='';
        dormitory.text='';
        stream.text='';
        dob=null;
        doj=null;
        optsub.text = '';
        bloodgroup.text = '';
        nationality.text = '';
        result.text = '';
        religion.text = '';
        category.text = '';
        mothertongue.text = '';
        minority.text = '';
        accno.text = '';
        bankname.text = '';
        ifsccode.text = '';
        branchname.text = '';
        schoolname.text = '';
        year.text = '';
        last_class_medium.text = '';
        last_class_rollno.text = '';
        last_class_board.text = '';
        sectionname = '';
        parentname ='';

        titlename = "Edit Student Info";
        icon = Icons.edit;
        save = "Save";
      }
    }
    else{
      if (action == "new") {
        titlename = "Add Student";
        icon = Icons.add;
        save = "Add Student";
      }
      else {
        titlename = "Edit Student Info";
        icon = Icons.edit;
        save = "Save";
      }
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
                              icon,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text(titlename,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 10,width: 10,),
                /*new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Student code *",
                      prefixIcon: new Icon(FontAwesomeIcons.code)
                  ),
                  controller:  studentcode,
                )),*/
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller:  name,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller:  lastname,
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
                        _navigatetogender(context,action,studentdetails);
                      },
                    )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date Of Birth *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: dob == null ? "" :  new DateFormat('yyyy-MM-dd').format(dob)),
                      ),
                      onTap: (){
                        _selectDateofbirth(context,action,studentdetails);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Phone *",
                    prefixIcon: new Icon(Icons.phone),
                  ),
                  controller:  phone,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  email,
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
                        controller: new TextEditingController(text: sectionname),
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
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Address *",
                      prefixIcon: new Icon(Icons.location_on)
                  ),
                  controller: address,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Password *",
                      prefixIcon: new Icon(FontAwesomeIcons.lockOpen)
                  ),
                  controller:  password,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Aadhar no *",
                      prefixIcon: new Icon(Icons.confirmation_number)
                  ),
                  controller: aadharno,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Dormitory *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: dormitory,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Transport *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: transport,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Dormitory *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: dormitory,
                )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date Of Joining *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: doj == null ? "" :  new DateFormat('yyyy-MM-dd').format(doj)),
                      ),
                      onTap: (){
                        _selectDateofjoining(context,action,studentdetails);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Stream *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: stream,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Optional Subject *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: optsub,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Blood group *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: bloodgroup,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Nationality *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: nationality,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Religion *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: religion,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Mother tounge *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: mothertongue,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Category *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: category,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Minority *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: minority,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Account no *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: accno,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Bank name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: bankname,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Ifsc code *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: ifsccode,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Branch name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: branchname,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Result *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: result,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "School name *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: schoolname,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Year *",
                      prefixIcon: new Icon(FontAwesomeIcons.calendar)
                  ),
                  controller: year,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class medium *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_medium,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class roolno *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_rollno,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Last class board *",
                      prefixIcon: new Icon(FontAwesomeIcons.list)
                  ),
                  controller: last_class_board,
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
                                AddsStudentdialog("new","refresh",studentdetails);
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
                                if(name.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter name");
                                  return;
                                }
                                if(gender.text == ""){
                                  Constants().ShowAlertDialog(context, "Please select gender");
                                  return;
                                }
                                if(dob == ""){
                                  Constants().ShowAlertDialog(context, "Please select date of birth");
                                  return;
                                }
                                if(phone.text == null){
                                  Constants().ShowAlertDialog(context, "Please enter phone no");
                                  return;
                                }
                                if(phone.text != null && phone.text.length !=10){
                                  Constants().ShowAlertDialog(context, "Please enter 10 digit phone no");
                                  return;
                                }
                                if(email.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter email");
                                  return;
                                }
                                if(sectionname == ""){
                                  Constants().ShowAlertDialog(context, "Please select section");
                                  return;
                                }
                                if(parentname == ""){
                                  Constants().ShowAlertDialog(context, "Please select parent");
                                  return;
                                }
                                CreateStudent("edit", "");
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
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text(save,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
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

  Future<Null> EditPassword(String studentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Edit_Password_Student+studentid;

    Map<String, String> body = new Map();
    body['password'] = password.text;

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
          Constants().ShowSuccessDialog(context, "Password updated succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Password not updated succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> DeleteParent(String studentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Delete_Student+studentid;

    Map<String, String> body = new Map();
    body['student_id'] = studentid;

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
          Constants().ShowSuccessDialog(context, "Parent deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadStudents();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Parent not deleted succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Editpassword(Studentdetails studentdetails) async {
    password.text = '';
    confirmpassword.text= '';
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
                              Icons.lock_open,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Edit Password",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 10,width: 10,),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Name *",
                      prefixIcon: new Icon(Icons.person_outline)
                  ),
                  controller:  TextEditingController(text: studentdetails.name),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  TextEditingController(text: studentdetails.email),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Phone *",
                      prefixIcon: new Icon(Icons.phone)
                  ),
                  controller:  TextEditingController(text: studentdetails.phone),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password *",
                      prefixIcon: new Icon(Icons.lock_open)
                  ),
                  controller: password,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Confirm Password *",
                      prefixIcon: new Icon(Icons.lock_open)
                  ),
                  controller: confirmpassword,
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
                                Editpassword(studentdetails);
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
                                if(password.text == ""){
                                  Constants().ShowAlertDialog(context, "Please fill new password");
                                  return;
                                }
                                if(confirmpassword.text == ""){
                                  Constants().ShowAlertDialog(context, "Please fill confirm new password");
                                  return;
                                }
                                if(confirmpassword.text != password.text){
                                  Constants().ShowAlertDialog(context, "Please enter password same as new password");
                                  return;
                                }
                                EditPassword(studentdetails.id);
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

  deletedialog(Studentdetails studentdetails) async {
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
                                      DeleteParent(studentdetails.id);
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

  Widget _EdittPopup(Studentdetails user) => PopupMenuButton<int>(
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
                child: new Icon(FontAwesomeIcons.fileInvoice,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Marksheet",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
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
                child: new Icon(FontAwesomeIcons.userEdit,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Profile",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
      PopupMenuItem(
          value: 3,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: new Icon(FontAwesomeIcons.unlockAlt,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Edit Password",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
      PopupMenuItem(
          value: 4,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: new Icon(FontAwesomeIcons.idCard,size: 13,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Generate Id",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
      PopupMenuItem(
          value: 5,
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
      if(value == 2)
        AddsStudentdialog("edit", "refresh", user);
      if(value == 3)
        Editpassword(user);
      if(value == 5)
        deletedialog(user);
    },
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(5.0),
        child: new ListView(
          children: <Widget>[
            new Card(
              margin: new EdgeInsets.all(5),
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
//                trailing: new IconButton(
//                  icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                  onPressed: () {
//                    controller.clear();
//                    onSearchTextChanged('');
//                  },
//                ),
              ),
            ),
            new SizedBox(width: 5,height: 5,),
            _Studentdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 10,
                columns: [
                  DataColumn(
                    label: Text("ID"),
                  ),
                  DataColumn(
                    label: Text("Photo"),
                  ),
                  DataColumn(
                    label: Text("Name"),
                  ),
                  DataColumn(
                    label: Text("Email"),
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
                          Text(user.id),
                        ),
                        DataCell(
                          new Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(user.photo)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.all(10),
                          ),
                        ),
                        DataCell(
                          Text(user.name),
                        ),
                        DataCell(
                          Text(user.email),
                        ),
                        DataCell(
                          new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                        ),
                      ]),
                ).toList()
                    : _Studentdetails.map(
                      (user) => DataRow(
                      cells: [
                        DataCell(
                          Text(user.id),
                        ),
                        DataCell(
                          new Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(user.photo)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.all(10),
                          ),
                        ),
                        DataCell(
                          Text(user.name),
                        ),
                        DataCell(
                          Text(user.email),
                        ),
                        DataCell(
                          new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                        ),
                      ]),
                ).toList(),
              ),
            ),

          ],
        ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Studentdetails.forEach((studentDetail) {
      if (studentDetail.email.toLowerCase().contains(text.toLowerCase())
          || studentDetail.id.toLowerCase().contains(text.toLowerCase()) || studentDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(studentDetail);
    });

    setState(() {});
  }

  List<Studentdetails> _searchResult = [];
  List<Studentdetails> _Studentdetails = [];

}

class Studentdetails {
  String sno, photo, name, phone,email,file,id,admisssionno,studentcode;

  Studentdetails({this.sno, this.photo, this.name, this.phone,this.email,this.file,this.id,this.admisssionno,this.studentcode});

  factory Studentdetails.fromJson(Map<String, dynamic> json) {
    return new Studentdetails(
        photo: "",
        admisssionno: json['admission_no'].toString(),
        studentcode: json['student_code'].toString(),
        name: json['full_name'].toString() ,
        id:  json['student_id'].toString() ,
        email: json['email'].toString()
    );
  }
}