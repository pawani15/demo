import 'dart:io';
import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unicorndial/unicorndial.dart';

import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';

class AdminParentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AdminParentsPageState();
}

class _AdminParentsPageState extends State<AdminParentsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadparents();
  }

  Future<Null> Loadparents() async {
    _Parentdetails.clear();
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Parents;
    Map<String, String> body = new Map();
    body['class_id'] = "";
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
            setState(() {
              for (Map user in responseJson['result']) {
                _Parentdetails.add(Parentdetails.fromJson(user));
              }
            });
          }catch(e){
            _Parentdetails = new List();
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

  List<String> classlist= new List(),studentsslist= new List();
  String clas = '' , subject = '';
  Map classmap= new Map(),studentsmap = new Map();

  _navigatetoclasses(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
    );
    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
  }

  Future<Null> CreateParent(String type,String parentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url="";
    if(type == "new")
      url = await Constants().Clienturl() + Constants.Create_Parent;
    else
      url = await Constants().Clienturl() + Constants.Edit_Parent;

    Map<String, String> body = new Map();
    if(type == "new")
      body['type_page'] ="create";
    else {
      body['type_page'] ="edit";
      body['parent_id'] = parentid;
    }
    body['name'] = name.text;
    body['email'] = email.text;
    body['password'] =password.text;
    body['phone'] = phone.text;
    body['sex']=sex.text;
    body['profession'] = profession.text;
    body['qualification']=qualification.text;
    body['annual_income']=income.text;
    body['pin_code']=pincode.text;
    body['office_address']=offieceaddress.text;
    body['address'] = address.text;
    body['moth_name'] =moth_name.text;
    body['moth_email'] = moth_email.text;
    body['sex1']=moth_sex.text;
    body['moth_password'] = moth_pwd.text;
    body['moth_phone'] = moth_phone.text;
    body['moth_address'] = moth_address.text;
    body['moth_profession'] = moth_profession.text;
    body['moth_qualification'] = moth_qualification.text;
    body['mother_annual_income'] = moth_income.text;
    body['moth_pin_code'] = moth_pincode.text;
    body['moth_office_address'] = moth_offieceaddress.text;
    body['gurdian_name'] = guardian_name.text;
    body['gurdian_phone'] = guardian_phone.text;
    body['gurdian_pin_code'] = guardian_pincode.text;
    body['gurdian_address'] = guardian_address.text;
    body['gurd_child_type'] =  only_child.text;
    body['guardian_area']=guardian_area.text;
    body['guardian_child_name1'] = guardian_childname1.text;
    body['guardian_child_class1'] = guardian_childclass1.text;
    body['guardian_child_section1'] = guardian_childsection1.text;
    body['guardian_child_name2'] = guardian_childname2.text;
    body['guardian_child_class2'] = guardian_childclass2.text;
    body['guardian_child_section2'] = guardian_childsection2.text;
 body['school_transportation']=school_tranport.text;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        print("response json  ${responseJson}");
        Navigator.of(context).pop();
        if(responseJson['status']){
          Navigator.of(context).pop();
          if(type == "edit")
           Constants().ShowSuccessDialog(context, "Parent updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Parent added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Loadparents();
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

  Future<Null> EditParentPassword(String parentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Edit_Password_Parent;

    Map<String, String> body = new Map();
    body['password'] = password.text;
    body['type_page'] = "edit_pwd";
    body['parent_id'] = parentid;
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

  Future<Null> DeleteParent(String parentid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Delete_Parent;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['parent_id'] = parentid;

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
            Loadparents();
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

  Widget _EdittPopup(Parentdetails parentdetails) => PopupMenuButton<int>(
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
                child: new Icon(Icons.lock_open,size: 15,
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
          value: 3,
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
      if(value == 1)
        AddsParentdialog("edit", parentdetails);
      if(value == 2)
        Editpassword(parentdetails);
      if(value == 3)
        deleteparentdialog(parentdetails);
    },
  );

  _navigatetogender(BuildContext context) async {
    List<String> Genderlist= new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(context, "Gender", Genderlist);
    setState(() {
      moth_sex.text = result ?? moth_sex.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }
  _navigatetogender1(BuildContext context) async {
    List<String> Genderlist= new List();
    Genderlist.add("Male");
    Genderlist.add("Female");
    String result = await Constants().Selectiondialog(context, "Gender", Genderlist);
    setState(() {
      sex.text = result ?? sex.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }
  _navigatetoonlychild(BuildContext context) async {
    List<String> minotitylist= new List();
    minotitylist.add("Yes");
    minotitylist.add("No");
    String result = await Constants().Selectiondialog(context, "Only Child (Yes/No)", minotitylist);
    setState(() {
      only_child.text = result ?? only_child.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _navigatetotransport(BuildContext context) async {
    List<String> minotitylist= new List();
    minotitylist.add("Yes");
    minotitylist.add("No");
    String result = await Constants().Selectiondialog(context, "School Transport", minotitylist);
    setState(() {
      school_tranport.text = result ?? school_tranport.text;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  TextEditingController name= new TextEditingController(),email = new TextEditingController(),phone = new TextEditingController(),profession = new TextEditingController(),
      status = new TextEditingController(),address = new TextEditingController(),password = new TextEditingController(),confirmpassword = new TextEditingController(),
      sex=new TextEditingController(),qualification = new TextEditingController(),income = new TextEditingController(),
      pincode = new TextEditingController(),offieceaddress = new TextEditingController()  ,    moth_pwd = new TextEditingController(),   moth_name= new TextEditingController(),moth_email = new TextEditingController(),moth_phone = new TextEditingController(),moth_profession = new TextEditingController(),
      moth_status = new TextEditingController(),moth_address = new TextEditingController(),moth_sex = new TextEditingController(),moth_qualification = new TextEditingController(),moth_income = new TextEditingController(),
      moth_pincode = new TextEditingController(),moth_offieceaddress = new TextEditingController(),guardian_name= new TextEditingController(),guardian_childname1 = new TextEditingController(),guardian_phone = new TextEditingController(),
      guardian_childclass1 = new TextEditingController(),guardian_childsection1 = new TextEditingController(),guardian_address = new TextEditingController(),only_child = new TextEditingController(),school_tranport = new TextEditingController(),
      guardian_pincode = new TextEditingController(),guardian_area = new TextEditingController(),guardian_childname2 = new TextEditingController(),
      guardian_childclass2 = new TextEditingController(),guardian_childsection2 = new TextEditingController();

  AddsParentdialog(String action, Parentdetails parentdetails) async {
    String titlename = "Add Parent";
    if(action == "new") {
      name.text = '';
      email.text = '';
      password.text='';
      phone.text = '';
      profession.text = '';
      status.text = '';
      address.text='';
      sex.text='';
      income.text = '';
      pincode.text = '';
      qualification.text = '';
      offieceaddress.text = '';
      moth_name.text = '';
      moth_email.text = '';
      moth_phone.text = '';
      moth_profession.text = '';
      moth_status.text = '';
      moth_address.text='';
      moth_sex.text = '';
      moth_income.text = '';
      moth_pincode.text = '';
      moth_qualification.text = '';
      moth_offieceaddress.text = '';
      guardian_name.text = '';
      only_child.text='';
      guardian_childclass1.text = '';
      guardian_childsection1.text='';
      guardian_childname1.text = '';
      guardian_childclass2.text = '';
      guardian_childsection2.text='';
      guardian_childname2.text = '';
      guardian_area.text = '';
      guardian_phone.text = '';
      guardian_pincode.text = '';
      school_tranport.text = '';
      titlename = "Add Parent";
    }
    else{
      name.text =parentdetails.name;
      email.text =parentdetails.email;
      phone.text =parentdetails.phone;
      profession.text =parentdetails.profession;
      status.text = "";
      address.text=parentdetails.address;
      password.text=parentdetails.pwd;
      sex.text =parentdetails.gender;
      income.text =parentdetails.annincome;
      pincode.text =parentdetails.pincode;
      offieceaddress.text =parentdetails.ofcadd;
      moth_qualification.text =parentdetails.m_qualification;
      moth_pwd.text=parentdetails.m_mpwd;
      address.text=parentdetails.address;
      moth_name.text =parentdetails.moth_name;
      moth_email.text =parentdetails.moth_email;
      moth_phone.text =parentdetails.moth_phone;
      moth_profession.text =parentdetails.moth_profession;
      moth_status.text = '';
      moth_address.text=parentdetails.moth_address;
      moth_sex.text =parentdetails.m_gender;
      moth_income.text =parentdetails.m_annincome;
      moth_pincode.text =parentdetails.m_pincode;
      moth_offieceaddress.text =parentdetails.m_ofcadd;
      moth_qualification.text =parentdetails.m_qualification;
      guardian_name.text =parentdetails.g_name;
      only_child.text=parentdetails.g_onlychild;
      guardian_childclass1.text =parentdetails.g_childNmame1;
      guardian_childsection1.text=parentdetails.g_child_Sec1;
      guardian_childname1.text =parentdetails.g_chileClass1;
      guardian_childclass2.text =parentdetails.g_chileClass2;
      guardian_childsection2.text=parentdetails.g_child_Sec2;
      guardian_childname2.text =parentdetails.g_childNmame2;
      guardian_area.text =parentdetails.g_area;
      guardian_phone.text =parentdetails.g_phone;
      guardian_pincode.text =parentdetails.g_pincode;
      school_tranport.text =parentdetails.g_schoolTrans;
      titlename = "Edit Parent Info";
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
                              Icons.settings,
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
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                      labelText: "Name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller:  name,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  email,
                )),
                if( titlename == "Add Parent")
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  //keyboardType: TextInputType.number,
                  //  maxLength: 10,
                  decoration: InputDecoration(
                      labelText: "Password *",
                      prefixIcon: new Icon(Icons.remove_red_eye)
                  ),
                  controller:  password,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                      labelText: "Phone *",
                      prefixIcon: new Icon(Icons.phone)
                  ),
                  controller:  phone,
                )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Gender",
                            prefixIcon: new Icon(FontAwesomeIcons.list),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
                        controller: sex,
                        enabled: false,
                      ),
                      onTap: () {
                       // _navigatetogender1(context);
                        _navigatetogender1(context);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  maxLength: 30,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Profession *",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  profession,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  maxLength: 30,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Qualification ",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  qualification,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Annual Income",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  income,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  decoration: InputDecoration(
                      labelText: "Address *",
                      prefixIcon: new Icon(Icons.location_on),

                  ),
                  controller: address,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                      labelText: "Pin Code",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  pincode,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                      labelText: "Office Address",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  offieceaddress,
                )),
                new ExpansionTile(title: new Text("Parent-2 (Optional)",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                  children: <Widget>[
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name *",
                          prefixIcon: new Icon(FontAwesomeIcons.user)
                      ),
                      controller:  moth_name,
                    )),
                    new Container(
                        margin: EdgeInsets.all(5.0),
                        child: new InkWell(
                          child: new TextField(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Gender",
                                prefixIcon: new Icon(FontAwesomeIcons.list),
                                suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                            ),
                            controller: moth_sex,
                            enabled: false,
                          ),
                          onTap: () {
                            _navigatetogender(context);
                          },
                        )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      decoration: InputDecoration(
                          labelText: "Email/Username ",
                          prefixIcon: new Icon(Icons.mail_outline)
                      ),
                      controller:  moth_email,
                    )),
                    if( titlename == "Add Parent")
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      //keyboardType: TextInputType.number,
                      //  maxLength: 10,
                      decoration: InputDecoration(
                          labelText: "Password *",
                          prefixIcon: new Icon(Icons.remove_red_eye)
                      ),
                      controller:  moth_pwd,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          labelText: "Phone ",
                          prefixIcon: new Icon(Icons.phone)
                      ),
                      controller:  moth_phone,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      maxLength: 30,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Profession ",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_profession,
                    )),

                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      decoration: InputDecoration(
                          labelText: "Qualification ",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_qualification,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Annual Income",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_income,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      decoration: InputDecoration(
                          labelText: "Address ",
                          prefixIcon: new Icon(Icons.location_on)
                      ),
                      controller: moth_address,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          labelText: "Pin Code",
                          prefixIcon: new Icon(Icons.list)

                      ),
                      controller:  moth_pincode,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      decoration: InputDecoration(
                          labelText: "Office Address",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  moth_offieceaddress,
                    )),
                  ],),
                new ExpansionTile(title: new Text("Guardian - (Optional)",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                  children: <Widget>[
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name *",
                          prefixIcon: new Icon(FontAwesomeIcons.user)
                      ),
                      controller:  guardian_name,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          labelText: "Phone",
                          prefixIcon: new Icon(Icons.phone)
                      ),
                      controller:  guardian_phone,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          labelText: "Pin Code",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_pincode,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      decoration: InputDecoration(
                          labelText: "Residential Address",
                          prefixIcon: new Icon(Icons.place)
                      ),
                      controller:  guardian_address,
                    )),
                    new Container(
                        margin: EdgeInsets.all(5.0),
                        child: new InkWell(
                          child: new TextField(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Only Child [Yes/No.]",
                                prefixIcon: new Icon(FontAwesomeIcons.list),
                                suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                            ),
                            controller: only_child,
                            enabled: false,
                          ),
                          onTap: () {
                            _navigatetoonlychild(context);
                          },
                        )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Name1",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_childname1,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Class1 ",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller: guardian_childclass1,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Section1",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_childsection1,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Name2",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_childname2,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Class2 ",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller: guardian_childclass2,
                    )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Guardian Child Section2",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_childsection2,
                    )),
                    new Container(
                        margin: EdgeInsets.all(5.0),
                        child: new InkWell(
                          child: new TextField(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "School Transportation",
                                prefixIcon: new Icon(FontAwesomeIcons.list),
                                suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                            ),
                            controller: school_tranport,
                            enabled: false,
                          ),
                          onTap: () {
                            _navigatetotransport(context);
                          },
                        )),
                    new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      decoration: InputDecoration(
                          labelText: "Area",
                          prefixIcon: new Icon(Icons.list)
                      ),
                      controller:  guardian_area,
                    )),
                  ],),
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
                                AddsParentdialog("new",parentdetails);
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
                                if(email.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enetr email");
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
                                if(profession.text == null){
                                  Constants().ShowAlertDialog(context, "Please enter profession");
                                  return;
                                }
                                if(address.text == null){
                                  Constants().ShowAlertDialog(context, "Please enter address");
                                  return;
                                }
                                if(action=="new")
                                  CreateParent(action,"");
                                else
                                  CreateParent(action,parentdetails.id);
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

  Editpassword(Parentdetails parentdetails) async {
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
                  controller:  TextEditingController(text: parentdetails.name),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Email/Username *",
                      prefixIcon: new Icon(Icons.mail_outline)
                  ),
                  controller:  TextEditingController(text: parentdetails.email),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Phone *",
                      prefixIcon: new Icon(Icons.phone)
                  ),
                  controller:  TextEditingController(text: parentdetails.phone),
                  enabled: false,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Profession *",
                      prefixIcon: new Icon(Icons.list)
                  ),
                  controller:  TextEditingController(text: parentdetails.profession),
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
                                Editpassword(parentdetails);
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
                                EditParentPassword(parentdetails.id);
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

  File _file = null;
  String fileext= "",filename= "";
  Future _getFile() async {
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
  }

  GenerateCsv() async {
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
                          child: new Container(child: new Text("Generate CSV File",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 10,width: 10,),
                new Container(
                    margin: EdgeInsets.all(10.0),
                    color: Theme.of(context).primaryColor,
                    child: new InkWell(
                      child: new ListTile(
                          title: new Text("Sample Format Download",style: TextStyle(color:  Colors.white,fontSize: 11),),
                          leading: new Icon(FontAwesomeIcons.fileCsv,color:  Colors.white),
                          trailing: new Icon(FontAwesomeIcons.download,color:  Colors.white)
                      ),
                      onTap: () {

                      },
                    )
                ),
                new Container(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.grey[200],
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Select CSV File",
                            prefixIcon: new Icon(FontAwesomeIcons.fileCsv),
                            suffixIcon: new Icon(FontAwesomeIcons.fileUpload)
                        ),
                        controller: TextEditingController(text:  _file == null ? "" : filename),
                        enabled: false,
                      ),
                      onTap: () {
                        _getFile();
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
                                        new Icon(FontAwesomeIcons.cloudUploadAlt,color: Colors.white),
                                        //new SvgPicture.asset("assets/clipboard.svg",color: Colors.white,width: 25,height: 25,),
                                        new Padding(
                                          padding:
                                          EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "Upload",
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
            )
        );
      },
    );
  }

  deleteparentdialog(Parentdetails parentdetails) async {
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
                                      DeleteParent(parentdetails.id);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var childButtons = List<UnicornButton>();

//    childButtons.add(UnicornButton(
//        currentButton: FloatingActionButton(
//          heroTag: "csv",
//          backgroundColor: Colors.yellow[800],
//          mini: true,
//          child: Icon(FontAwesomeIcons.fileCsv,color: Colors.white,),
//          onPressed: () {
//            GenerateCsv();
//          },
//        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
          heroTag: "add",
          backgroundColor: Colors.yellow[800],
          mini: true,
          child: Icon(Icons.add,color: Colors.white,),
          onPressed: (){
            AddsParentdialog("new", null);
          },
        )));


    return new Scaffold(
      appBar: new AppBar(
        title: Text("All Parents"),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),*/
      ),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
//            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 20,height: 20,),
//                    new Text("All Parents Information",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Container(
              margin: new EdgeInsets.only(left: 15,right: 5,bottom: 10,top: 40),
              child : new Stack(
                children: <Widget>[
                  new Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.only(top: 25,right: 10),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(0.0),
                        child: new ListView(
                          children: <Widget>[
//                            new Card(
//                              margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 30),
//                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
//                              elevation: 10,
//                              child: new ListTile(
//                                leading: new Icon(Icons.filter_list,color: Theme.of(context).primaryColor,),
//                                title: new Text("Filter By Class",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 16)),
//                                trailing: new Container(
//                                  decoration: BoxDecoration(border: Border(left: BorderSide(width: 2,color: Colors.grey[300]))),
//                                  child: new Icon(FontAwesomeIcons.angleDown,color: Theme.of(context).primaryColor,),
//                                ),
//                              ),
//                            ),
//                            new Card(
//                              margin: new EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 10),
//                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
//                              elevation: 10,
//                              child: new ListTile(
//                                leading: new Icon(Icons.filter_list,color: Theme.of(context).primaryColor,),
//                                title: new Text("Filter By Student",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 16)),
//                                trailing: new Container(
//                                  decoration: BoxDecoration(border: Border(left: BorderSide(width: 2,color: Colors.grey[300]))),
//                                  child: new Icon(FontAwesomeIcons.angleDown,color: Theme.of(context).primaryColor,),
//                                ),
//                              ),
//                            ),
                            new Container(
                                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[300],width: 2.0),right: BorderSide(color: Colors.grey[300],width: 2.0),
                                    left: BorderSide(color: Colors.grey[300],width: 2.0),bottom: BorderSide(color: Colors.grey[300],width: 2.0)),borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
                                padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                                child : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(child: new Padding(child: new Text("All Parents",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                                    /* new Expanded(child:  new Container(
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
                                    ),flex: 2,),*/
                                  ],
                                )
                            ),
                            new Container(height: 2,width: double.infinity,color: Theme.of(context).primaryColor,),
                            _Parentdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                                : new Padding(padding: EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 10,
                                    columns: [
                                      DataColumn(
                                        label: Text("ID No",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                      ),
                                      DataColumn(
                                        label: Text("Name",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                      ),
                                      DataColumn(
                                        label: Text("Email/User",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                      ),
                                      DataColumn(
                                        label: Text("Phone No",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                      ),
                                      DataColumn(
                                        label: Text("Actions",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                      ),
                                    ],
                                    rows: _searchResult.length != 0 ?
                                    _searchResult.map(
                                          (user) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text("#"+user.id),
                                            ),
                                            DataCell(
                                              Text(user.name),
                                            ),
                                            DataCell(
                                              Text(user.email),
                                            ),
                                            DataCell(
                                              Text(user.phone),
                                            ),
                                            DataCell(
                                              new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                            ),
                                          ]),
                                    ).toList()
                                        : _Parentdetails.map(
                                           (user) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text("#"+user.id),
                                            ),
                                            DataCell(
                                              Text(user.name),
                                            ),
                                            DataCell(
                                              Text(user.email),
                                            ),
                                            DataCell(
                                              Text(user.phone),
                                            ),
                                            DataCell(
                                              new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                            ),
                                          ]),
                                    ).toList(),
                                  ),
                                )),
                          ],
                        )),
                  ),
                  /*new Align(
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
                        child: new Icon(Icons.menu,color: Colors.white,size: 20,),
                      ),onTap: (){

                      },
                      )
                  )*/
                ],
              ))
        ],
      ),
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.yellow[800],
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.menu),
          childButtons: childButtons),
    );


  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Parentdetails.forEach((vehicleDetail) {
      if (vehicleDetail.phone.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.email.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Parentdetails> _searchResult = [];
  List<Parentdetails> _Parentdetails = [];

}

class Parentdetails {
  String sno, name,pwd, phone,email,id,gender,profession,qualification,pincode,annincome,resdd,ofcadd,address,
     moth_name,m_mpwd,m_qualification,m_gender ,moth_phone,moth_email,moth_profession,moth_address, m_pincode,m_annincome,
      m_resadd,m_ofcadd,
    g_name,g_phone,g_onlychild,g_childNmame1,g_pincode,g_chileClass1,g_child_Sec1,g_schoolTrans,g_area,
      g_childNmame2,g_chileClass2,g_child_Sec2,g_resadd;

  Parentdetails({this.sno,this.id,this.name, this.pwd,this.email,this.gender,this.profession,this.qualification,this.pincode,this.phone,this.annincome,this.resdd,
    this.ofcadd,this.address,
    this.moth_name,this.m_mpwd,this.m_qualification,this.m_gender,this.moth_phone,this.moth_email,this.moth_profession,this.moth_address,this.m_pincode,
    this.m_annincome,this.m_resadd,this.m_ofcadd,
     this.g_name,this.g_phone,this.g_onlychild,this.g_pincode,this.g_area,this.g_resadd,this.g_schoolTrans,this.g_childNmame1,this.g_child_Sec1,this.g_chileClass1,
    this.g_chileClass2,this.g_childNmame2,this.g_child_Sec2});

  factory Parentdetails.fromJson(Map<String, dynamic> json) {
    return new Parentdetails(
        id:  json['parent_id'].toString() ,
        name: json['name'].toString() ,
        pwd:json['password'].toString(),
        email: json['email'].toString(),
        phone:  json['phone'].toString() ,
        gender: json['sex'].toString() ,
        profession:  json['profession'].toString() ,
       qualification: json['qualification'].toString(),
       pincode: json['pin_code'].toString(),
       annincome: json['annual_income'].toString(),
       ofcadd: json['office_address'].toString(),
       address:  json['address'].toString() ,
       m_mpwd:json['moth_password'].toString(),
        moth_name: json['moth_name'].toString() ,
        moth_email:  json['moth_email'].toString() ,
        moth_phone:  json['moth_phone'].toString() ,
        moth_profession:  json['moth_profession'].toString() ,
       m_gender: json['sex1'].toString(),
        m_qualification: json['moth_qualification'].toString(),
        m_annincome: json['mother_annual_income'].toString(),
        m_ofcadd: json['moth_office_address'].toString(),
        m_pincode: json['moth_pin_code'].toString(),
      //  m_resadd: json[''].toString(),
        moth_address:  json['moth_address'].toString() ,
      g_name: json['gurdian_name'].toString(),
      g_pincode: json['gurdian_pin_code'].toString(),
      g_phone: json['gurdian_phone'].toString(),
      g_resadd: json['gurdian_address'].toString(),
      g_area: json['guardian_area'].toString(),
      g_schoolTrans: json['school_transportation'].toString(),
      g_childNmame1: json['guardian_child_name1'].toString(),
      g_child_Sec1: json['guardian_child_section1'].toString(),
      g_chileClass1: json['guardian_child_class1'].toString(),
      g_childNmame2: json['guardian_child_name2'].toString(),
      g_chileClass2: json['guardian_child_class2'].toString(),
      g_child_Sec2: json['guardian_child_section2'].toString(),
      g_onlychild: json['gurd_child_type'].toString(),

    );
  }
}

