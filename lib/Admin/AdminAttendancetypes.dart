import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unicorndial/unicorndial.dart';

import 'Adminlibrarianinformation.dart';
import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';

class AdminAttendancetypePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _AdminAttendancetypePageState();
}

class _AdminAttendancetypePageState extends State<AdminAttendancetypePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadAttendancetypes();
  }

  Future<Null> LoadAttendancetypes() async {
    Attendancetypedetails.clear();
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Attendancetypes_Admin;
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
                Attendancetypedetails.add(Attendancetypesdetails.fromJson(user));
              }  
            });
          }catch(e){
            Attendancetypedetails = new List();
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

  Future<Null> CreateAccountatnt(String type, Attendancetypesdetails attendancetpedetails) async {
    Constants().onLoading(context);
    var url="";
    url = await Constants().Clienturl() + Constants.CRUDAttendancetypes_Admin;

    Map<String, String> body = new Map();
    if(type == "new") {
      body['type_page'] = "create";
    }
    else {
      body['type_page'] = "update";
      body['attendance_type_id'] = attendancetpedetails.id;
    }
    body['device_name'] = devicename.text;
    body['device_ip'] = deviceip.text;

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
            Constants().ShowSuccessDialog(context, "Attendance type updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Attendance type added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadAttendancetypes();
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
  
  Future<Null> DeleteApi(String accountantid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.CRUDAttendancetypes_Admin;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['attendance_type_id'] = accountantid;

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
          Constants().ShowSuccessDialog(context, "Attendance type deleted succesfully");
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadAttendancetypes();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Attendance type not deleted succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Widget _EdittPopup(Attendancetypesdetails attendancetpedetails) => PopupMenuButton<int>(
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
      if(value == 1)
        Addattendancetypedialog("edit", attendancetpedetails);
      if(value == 2)
        deletedialog(attendancetpedetails);
    },
  );

  TextEditingController devicename= new TextEditingController(),deviceip = new TextEditingController();
  Addattendancetypedialog(String action, Attendancetypesdetails attendancetpedetails) async {
    String titlename = "Add Attendance Type",save='';
    IconData icon = null;
      if(action == "new") {
        devicename.text = '';
        deviceip.text = '';
        titlename = "Add Attendance Type";
        icon = Icons.add;
        save = "Save";
      }
      else{
        devicename.text = attendancetpedetails.devicename;
        deviceip.text = attendancetpedetails.deviceip;
        titlename = "Edit Attendance Type";
        icon = Icons.edit;
        save = "Save";
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
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Device Name *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller:  devicename,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Device IP *",
                      prefixIcon: new Icon(FontAwesomeIcons.ethernet)
                  ),
                  controller:  deviceip,
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
                                Addattendancetypedialog("new",attendancetpedetails);
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
                                if(devicename.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter device name");
                                  return;
                                }
                                if(deviceip.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enetr device IP");
                                  return;
                                }
                                CreateAccountatnt(action, attendancetpedetails);
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
  
  deletedialog(Attendancetypesdetails attendancetpedetails) async {
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
                                      DeleteApi(attendancetpedetails.id);
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
    return new Scaffold(
      appBar: new AppBar(
        title: Text("All Attendance Types"),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),*/
      ),
      drawer: Constants().drawer(context),
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
                    new Text("All Attendance Types",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
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
                          new Padding(padding: EdgeInsets.only(left: 5),child: Text("Add New Attendance Types",style: TextStyle(color: Colors.white,fontSize: 14),))
                        ],
                      ),
                    ),
                      onTap: (){
                      Addattendancetypedialog("new", null);
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
                                  new Expanded(child: new Padding(child: new Text("All Attendance Types",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                                /*  new Expanded(child:  new Container(
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
                            Attendancetypedetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                                : new Padding(padding: EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 10,
                                columns: [
                                  DataColumn(
                                    label: Text("Attendance Type ID",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Device Name",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Device IP",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Creted On",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                                          Text(user.devicename),
                                        ),
                                        DataCell(
                                          Text(user.deviceip),
                                        ),
                                        DataCell(
                                          Text(user.createdon),
                                        ),
                                        DataCell(
                                          new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                        ),
                                      ]),
                                ).toList()
                                    : Attendancetypedetails.map(
                                      (user) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text("#"+user.id),
                                        ),
                                        DataCell(
                                          Text(user.devicename),
                                        ),
                                        DataCell(
                                          Text(user.deviceip),
                                        ),
                                        DataCell(
                                          Text(user.createdon),
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

    Attendancetypedetails.forEach((vehicleDetail) {
      if (vehicleDetail.deviceip.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.createdon.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.devicename.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Attendancetypesdetails> _searchResult = [];
  List<Attendancetypesdetails> Attendancetypedetails = [];

}


class Attendancetypesdetails {
  String sno, devicename, deviceip,createdon,id;

  Attendancetypesdetails({this.sno,this.devicename, this.deviceip,this.createdon,this.id});

  factory Attendancetypesdetails.fromJson(Map<String, dynamic> json) {
    return new Attendancetypesdetails(
        devicename: json['device_name'].toString() ,
        id:  json['attendance_type_id'].toString() ,
        deviceip:  json['device_ip'].toString() ,
        createdon: json['created_on'].toString()
    );
  }
}