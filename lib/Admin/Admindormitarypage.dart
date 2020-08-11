import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unicorndial/unicorndial.dart';

import '../Studymaterial.dart';
import '../search.dart';
import 'Adminlibrarianinformation.dart';
import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';

class AdminDormitaryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _AdminDormitaryPageState();
}

class _AdminDormitaryPageState extends State<AdminDormitaryPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String file =''; TextEditingController description=new TextEditingController(),dormitoryname=new TextEditingController()
  ,noofrooms=new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadDormitarys();
  }
  
  Future<Null> LoadDormitarys() async {
    _Dormitarydetails.clear();
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.LoadDormitory_Admin;
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
            setState(() {
              for (Map user in responseJson['result']) {
                _Dormitarydetails.add(Dormitarydetails.fromJson(user));
              }  
            });
          }catch(e){
            _Dormitarydetails = new List();
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

  AddApi(String type,Dormitarydetails Dormitarydetails) async{
    Constants().onLoading(context);
    var url="";
    url = await Constants().Clienturl() + Constants.CRUDDormitory_Admin;

    Map<String, String> body = new Map();
    if(type == "new") {
      body['type_page'] = "create";
    }
    else {
      body['type_page'] = "update";
      body['dormitory_id'] = Dormitarydetails.id;
    }
    body['name'] = dormitoryname.text;
    body['number_of_room'] = noofrooms.text;
    body['description'] = description.text;

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
            Constants().ShowSuccessDialog(context, "Dormirory updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Dormirory added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadDormitarys();
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

  Widget _EdittPopup(Dormitarydetails) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 3,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.user,color: Theme.of(context).primaryColor,),),
              new Text("Student"),
            ],
          )
      ),
      PopupMenuItem(
          value: 1,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.edit,color: Theme.of(context).primaryColor,),),
              new Text("Edit"),
            ],
          )
      ),
      PopupMenuItem(
          value: 2,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.trash,color: Colors.red),),
              new Text("Delete"),
            ],
          )
      ),
    ],
    elevation: 5,
    padding: EdgeInsets.symmetric(horizontal: 20),
    onSelected: (value) {
      print(value);
      if(value == 1)
        Adddialog("refresh", "edit", Dormitarydetails);
      else if(value == 2)
        deletedialog(Dormitarydetails);
      else if(value == 3)
        Student(Dormitarydetails);
    },
  );

  deletedialog(Dormitarydetails Dormitarydetails) async {
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
                                      Delete(Dormitarydetails);
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

  Delete(Dormitarydetails Dormitarydetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['type_page'] = "delete";
    body['dormitory_id'] = Dormitarydetails.id;
    var  url = await Constants().Clienturl() + Constants.CRUDDormitory_Admin;

    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          Navigator.of(context).pop();
          Constants().ShowSuccessDialog(context, responseJson['message']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadDormitarys();
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

  Student(Dormitarydetails Dormitarydetails ) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: new Column(
              children: <Widget>[
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
                              Icons.directions_transit,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Student Dormitary",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 10,width: 10,),
                new Container(
                  color: Theme.of(context).primaryColor,
                  child: new Row(
                    children: <Widget>[
                      new Text("Student List",style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
                      new Padding(padding: EdgeInsets.only(left: 5),child: new Icon(Icons.subdirectory_arrow_right,color: Colors.white,),)
                    ],
                    ),
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                ),
                new Container(
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.grey[200]),
                    color: Colors.white,
                  ),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(child: new Container(
                        decoration: new BoxDecoration(
                            border: new Border(right: BorderSide(
                                color: Colors.grey[200],
                                style: BorderStyle.solid))
                        ),
                        child: new Text(
                          "Name",
                          style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        padding: new EdgeInsets.all(2.0),
                      ), flex: 3,),
                      new Expanded(child: new Container(
                        decoration: new BoxDecoration(
                            border: new Border(right: BorderSide(
                                color: Colors.grey[200],
                                style: BorderStyle.solid))
                        ),
                        child: new Text(
                          "Email/Username",
                          style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        padding: new EdgeInsets.all(2.0),
                      ), flex: 3,),
                      new Expanded(child: new Container(
                        decoration: new BoxDecoration(
                            border: new Border(right: BorderSide(
                                color: Colors.grey[200],
                                style: BorderStyle.solid))
                        ),
                        child: new Text(
                          "Phone",
                          style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        padding: new EdgeInsets.all(2.0),
                      ), flex: 3,),
                      new Expanded(child: new Container(
                        decoration: new BoxDecoration(
                            border: new Border(right: BorderSide(
                                color: Colors.grey[200],
                                style: BorderStyle.solid))
                        ),
                        child: new Text(
                          "Class",
                          style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        padding: new EdgeInsets.all(2.0),
                      ), flex: 2,)
                    ],
                  ),
                ),
                new Expanded(
                  child: 5 == 0
                      ? new Container(
                    child: new Center(
                      child: new Text(
                        "No Records found",
                        style: new TextStyle(
                            fontSize: 16.0, color: Colors.red),
                      ),
                    ),
                  )
                      : new ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.grey[200]),
                          color: Colors.white,
                        ),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(child: new Container(
                              decoration: new BoxDecoration(
                                  border: new Border(right: BorderSide(
                                      color: Colors.grey[200],
                                      style: BorderStyle.solid))
                              ),
                              child: new Text(
                                "Muni",
                                style: TextStyle(color: Colors.black87),
                                textAlign: TextAlign.center,
                              maxLines: 1,),
                              padding: new EdgeInsets.all(2.0),
                            ), flex: 3,),
                            new Expanded(child: new Container(
                              decoration: new BoxDecoration(
                                  border: new Border(right: BorderSide(
                                      color: Colors.grey[200],
                                      style: BorderStyle.solid))
                              ),
                              child: new Text(
                                "Muni@hhd.cc",
                                style: TextStyle(color: Colors.black87),
                                textAlign: TextAlign.center,
                                  maxLines: 1),
                              padding: new EdgeInsets.all(2.0),
                            ), flex: 3,),
                            new Expanded(child: new Container(
                              decoration: new BoxDecoration(
                                  border: new Border(right: BorderSide(
                                      color: Colors.grey[200],
                                      style: BorderStyle.solid))
                              ),
                              child: new Text(
                                "235647893625",
                                style: TextStyle(color: Colors.black87),
                                textAlign: TextAlign.center,
                                  maxLines: 1),
                              padding: new EdgeInsets.all(2.0),
                            ), flex: 3,),
                            new Expanded(child: new Container(
                              decoration: new BoxDecoration(
                                  border: new Border(right: BorderSide(
                                      color: Colors.grey[200],
                                      style: BorderStyle.solid))
                              ),
                              child: new Text(
                                "4th class",
                                style: TextStyle(color: Colors.black87),
                                textAlign: TextAlign.center,
                                  maxLines: 1),
                              padding: new EdgeInsets.all(2.0),
                            ), flex: 2,)
                          ],
                        ),
                      );
                    },
                  ),
                ),
                new SizedBox(width: 20,height: 20,),
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
                                      new Icon(Icons.send,color: Colors.white,),
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Send",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
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

  Adddialog(String status,String action, Dormitarydetails Dormitarydetails) async {
    String titlename = "Add Dormitary";
    if(status == "refresh") {
      if(action == "new") {
        description.text = '';
        dormitoryname.text='';
        noofrooms.text='';
        titlename = "Add Dormitary";
      }
      else{
        description.text = Dormitarydetails.description;
        dormitoryname.text = Dormitarydetails.dormitaryname;
        noofrooms.text = Dormitarydetails.noofrooms;
        titlename = "Edit Dormitary";
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
                              action == "new" ? Icons.add : Icons.edit,
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
                new SizedBox(height: 20,width: 20,),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Dormitory Name *",
                      prefixIcon: new Icon(FontAwesomeIcons.book)
                  ),
                  controller:  dormitoryname,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      hintText: "No of Rooms *",
                      prefixIcon: new Icon(FontAwesomeIcons.rupeeSign)
                  ),
                  controller:  noofrooms,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Description ",
                      prefixIcon: new Icon(Icons.message)
                  ),
                  controller: description,
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
                                Adddialog("refresh","new",Dormitarydetails);
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
                                if(dormitoryname.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter dormitory name");
                                  return;
                                }
                                if(noofrooms.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter no of rooms");
                                  return;
                                }
                                AddApi(action,Dormitarydetails);
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
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
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
        title: Text("Manage Dormitary"),
        backgroundColor: Color(0xff182C61),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
                child: Column(
                  children: <Widget>[
                    new SizedBox(width: 20,height: 20,),
                    new Text("Manage Dormitary",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                    new SizedBox(width: 15,height: 15,),
                    new InkWell(child:new Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Icon(Icons.add,color: Colors.white,size: 20,),
                          new Padding(padding: EdgeInsets.only(left: 5),child: Text("Add Dormitary",style: TextStyle(color: Colors.white,fontSize: 14),))
                        ],
                      ),
                    ),
                      onTap: (){
                        Adddialog("refresh","new",null);
                      },
                    )
                  ],
                )
            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 120),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
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
          new Container(
              child : new Stack(
                children: <Widget>[
                  new Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 190),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(0.0),
                        child: new ListView(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                              child : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(child: new Text("Dormitary List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
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
                            _Dormitarydetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                                : new Padding(padding: EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 10,
                                  columns: [
                                    DataColumn(
                                      label: Text("Dormitary Name",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("No of Rooms",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Description",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Actions",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                  ],
                                  rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                                  _searchResult.map(
                                        (user) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(user.dormitaryname),
                                          ),
                                          DataCell(
                                            Text(user.noofrooms),
                                          ),
                                          DataCell(
                                            Text(user.description),
                                          ),
                                          DataCell(
                                            new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                          ),
                                        ]),
                                  ).toList()
                                      : _Dormitarydetails.map(
                                        (user) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(user.dormitaryname),
                                          ),
                                          DataCell(
                                            Text(user.noofrooms),
                                          ),
                                          DataCell(
                                            Text(user.description),
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

    _Dormitarydetails.forEach((vehicleDetail) {
      if (vehicleDetail.dormitaryname.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.noofrooms.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) )
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Dormitarydetails> _searchResult = [];
  List<Dormitarydetails> _Dormitarydetails = [];
}

class Dormitarydetails {
  String dormitaryname, noofrooms, id,description;
  Dormitarydetails({this.dormitaryname,this.noofrooms, this.id,this.description});

  factory Dormitarydetails.fromJson(Map<String, dynamic> json) {
    return new Dormitarydetails(
        noofrooms: json['number_of_room'],
        dormitaryname: json['name'].toString(),
      description: json['description'].toString(),
      id: json['dormitory_id'].toString(),
    );
  }
}