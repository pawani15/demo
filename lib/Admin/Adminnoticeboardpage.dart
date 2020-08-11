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

class AdminNoticeboardPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _AdminNoticeboardPageState();
}

class _AdminNoticeboardPageState extends State<AdminNoticeboardPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String file =''; TextEditingController notice=new TextEditingController(),title=new TextEditingController(),vehnummber=new TextEditingController()
  ,routefare=new TextEditingController();
  String running  = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    showlist.add("Yes");
    showlist.add("No");
    showmap['Yes'] = "1";
    showmap['No'] = "0";
    running  = "running";
    LoadNoticeboards(running,"noload");
  }
  
  Future<Null> LoadNoticeboards(String type,String load) async {
    _Noticeboarddetails.clear();
    String empid = await sp.ReadString("Userid");
    if(load == "load")
      Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.LoadNoticeboard_Admin;
    Map<String, String> body = new Map();
    body['status'] = type == "running" ? "1" : "0";

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body:body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        if(load == "load")
          Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            setState(() {
              for (Map user in responseJson['result']) {
                _Noticeboarddetails.add(Noticeboarddetails.fromJson(user));
              }  
            });
          }catch(e){
            _Noticeboarddetails = new List();
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

  Dio dio = new Dio();
  AddApi(String type,Noticeboarddetails Noticeboarddetails) async{
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url="";
    url = await Constants().Clienturl() + Constants.CRUDNoticeboard_Admin;

    Map<String, dynamic> body = new Map();
    body['login_user_id'] = empid;
    if(type == "new") {
      body['type_page'] = "create";
    }
    else {
      body['type_page'] = "update";
      body['notice_id'] = Noticeboarddetails.id;
    }
    body['notice_title'] = title.text;
    body['notice'] = notice.text;
    body['create_timestamp'] = date == null ? date1 :  new DateFormat('dd-MM-yyyy').format(date);
    body['check_sms'] = showmap[sendsms];
    body['show_on_website'] = showmap[showonwebsite];
    body['image'] = _file == null ? "" : new UploadFileInfo(_file, await AppUtil.getFileNameWithExtension(_file));

    print("url is $url"+"body--"+body.toString());

    dio.options.baseUrl = url;
    dio.options.connectTimeout = 120000; //5s
    dio.options.receiveTimeout=5000;
    FormData formData = new FormData.from(body);
    // Send FormData
    try {
      Response response = await dio.post("", data: formData);
      if (response.statusCode == 200) {
        print("response --> ${response.data}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.data);
        if(responseJson['status'].toString() == "true"){
          Navigator.of(context).pop();
          Constants().ShowSuccessDialog(context, responseJson['message']);

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadNoticeboards(running,"load");
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, responseJson['message']);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.data);
      }
    }catch(e){
      print("imaguploadresponse-->${e}");
    }
   /* http.post(url,
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
            Constants().ShowSuccessDialog(context, "Noticeboard updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Noticeboard added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadNoticeboards(running,"load");
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
    });*/
  }

  Widget _EdittPopup(Noticeboarddetails noticeboarddetails) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 3,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.print,color: Theme.of(context).primaryColor,),),
              new Text("View Notice"),
            ],
          )
      ),
      PopupMenuItem(
          value: 4,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(Icons.cancel,color: Colors.orange),),
              new Text(noticeboarddetails.status == "1" ? "Mark Archive" : "Remove from Archive"),
            ],
          )
      ),
      PopupMenuItem(
          value: 1,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.edit,color: Colors.green),),
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
        Adddialog("refresh", "edit", noticeboarddetails);
      else if(value == 2)
        deletedialog(noticeboarddetails);
      else if(value == 3)
        displaynotice(noticeboarddetails);
      else if(value == 4)
        Archive(noticeboarddetails);
    },
  );

  displaynotice(Noticeboarddetails noticeboarddetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    var  url = await Constants().Clienturl() + Constants.View_Notice+noticeboarddetails.id;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          List list = responseJson['result']['view_data'];
          if(list.length > 0)
            displayNoticedialog(list);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  displayNoticedialog(List notice) async {
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
                              Icons.warning,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Notice Deatils",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 20,width: 20,),
                new Container(margin: EdgeInsets.all(5.0),
                    child:new Column(
                      children: <Widget>[
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Title:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(notice[0]['notice_title'].toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],),
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Notice:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(notice[0]['notice'].toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],),
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Date:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(notice[0]['create_timestamp']) * 1000)).toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],)
                      ],
                    )),
                new SizedBox(width: 30,height: 30,),
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
                                  Constants().ShowAlertDialog(context, "Coming Soon!");
                                },
                                child: new Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(15),
                                            bottomLeft:
                                            Radius.circular(15))),
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Icon(
                                          Icons.print,
                                          color: Colors.white,
                                        ),
                                        new Padding(
                                          padding:
                                          EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "Print",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold,
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

  deletedialog(Noticeboarddetails Noticeboarddetails) async {
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
                                      Delete(Noticeboarddetails);
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

  Delete(Noticeboarddetails Noticeboarddetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['type_page'] = "delete";
    body['notice_id'] = Noticeboarddetails.id;
    var  url = await Constants().Clienturl() + Constants.CRUDNoticeboard_Admin;

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
            LoadNoticeboards(running,"load");
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

  Archive(Noticeboarddetails Noticeboarddetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['type_page'] = Noticeboarddetails.status == "0" ? "remove_from_archived" : "mark_as_archive";
    body['notice_id'] = Noticeboarddetails.id;
    var  url = await Constants().Clienturl() + Constants.CRUDNoticeboard_Admin;

    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          Constants().ShowSuccessDialog(context, responseJson['message']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadNoticeboards(running,"load");
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

  DateTime date = null;
  String date1 ="";

  Future<Null> _selectDate(BuildContext context,String action,Noticeboarddetails details) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != date) {
        print('date selected : ${date.toString()}');
        setState(() {
          date = picked;
        });
      }
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pop();
      Adddialog("norefresh",action,details);
    }catch(e){e.toString();}
  }

  File _file = null;
  String fileext= "",filename= "";
  Future _getFile(String action,Noticeboarddetails details) async {
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop();
    Adddialog("norefresh",action,details);
  }

  List<String> showlist= new List();
  Map showmap= new Map();
  String showonwebsite="",sendsms="";
  _navigatetowebsite(BuildContext context,String action,Noticeboarddetails details) async {
    String result = await Constants().Selectiondialog(context, "Show on Website", showlist);
    setState(() {
      showonwebsite = result ?? showonwebsite;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop();
    Adddialog("norefresh",action,details);
    print("res--"+result.toString());
  }

  _navigatetosms(BuildContext context,String action,Noticeboarddetails details) async {
    String result = await Constants().Selectiondialog(context, "Send SMS To All", showlist);
    setState(() {
      sendsms = result ?? sendsms;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop();
    Adddialog("norefresh",action,details);
    print("res--"+result.toString());
  }

  Adddialog(String status,String action, Noticeboarddetails Noticeboarddetails) async {
    String titlename = "Add Noticeboard";
    if(status == "refresh") {
      if(action == "new") {
        notice.text = '';
        title.text='';
        date = null;
        date1= "";
        _file = null;
        showonwebsite = "";
        sendsms = "";
        titlename = "Add Noticeboard";
      }
      else{
        notice.text = Noticeboarddetails.notice;
        title.text = Noticeboarddetails.title;
        date = null;
        date1= Noticeboarddetails.createtime;
        _file = null;
        showonwebsite = Noticeboarddetails.showonwebsite == "0" ? "No" : "Yes";
        sendsms =  "Yes";
        titlename = "Edit Noticeboard";
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
                      hintText: "Title *",
                      prefixIcon: new Icon(FontAwesomeIcons.book)
                  ),
                  controller:  title,
                )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: date == null ? date1 :  new DateFormat('dd-MMM-yyyy').format(date)),
                      ),
                      onTap: (){
                        _selectDate(context,action,Noticeboarddetails);
                      },
                    )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Show On Website *',
                          prefixIcon: new Icon(Icons.list),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: showonwebsite),
                      ),
                      onTap: (){
                        _navigatetowebsite(context,action,Noticeboarddetails);
                      },
                    )),
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Send SMS To All *',
                          prefixIcon: new Icon(Icons.list),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: sendsms),
                      ),
                      onTap: (){
                        _navigatetosms(context,action,Noticeboarddetails);
                      },
                    )),
                new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Upload File *",
                          prefixIcon: new Icon(Icons.file_upload),
                          suffixIcon: _file == null ? new Icon(Icons.cloud_upload) : new Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new FileImage(_file)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        controller: TextEditingController(text:  _file == null ? "" : filename),
                        enabled: false,
                      ),
                      onTap: () {
                        _getFile(action,Noticeboarddetails);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Notice ",
                      prefixIcon: new Icon(Icons.message)
                  ),
                  controller: notice,
                  maxLines: 4,
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
                                Adddialog("refresh","new",Noticeboarddetails);
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
                                if(title.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter tile");
                                  return;
                                }
                               /* if(_file == ""){
                                  Constants().ShowAlertDialog(context, "please select upload file");
                                  return;
                                }*/
                                if(showonwebsite == ""){
                                  Constants().ShowAlertDialog(context, "please select show on website");
                                  return;
                                }
                                if(sendsms == ""){
                                  Constants().ShowAlertDialog(context, "please select send sms to all");
                                  return;
                                }
                                if(notice.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter notice");
                                  return;
                                }
                                AddApi(action,Noticeboarddetails);
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
        title: Text("Manage Noticeboard"),
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
                    new Text("Manage Noticeboard",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
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
                          new Padding(padding: EdgeInsets.only(left: 5),child: Text("Add Noticeboard",style: TextStyle(color: Colors.white,fontSize: 14),))
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
                                margin: new EdgeInsets.all(5),
                                child : new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Expanded(child:
                                    new InkWell(child:
                                    new Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.green),
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(padding: EdgeInsets.only(right: 5,left: 20,top: 10,bottom: 10),
                                              child: new Icon( Icons.settings ,color: Colors.green,size: 20,)
                                          ),
                                          new Padding(padding: EdgeInsets.only(left: 5,right: 20,top: 10,bottom: 10),child: new Text("Running",style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),),),
                                        ],
                                      ),
                                    ),
                                      onTap: (){
                                        running  = "running";
                                        LoadNoticeboards(running,"load");
                                      },
                                    ),
                                      flex: 1,),
                                    new Expanded(child:
                                    new InkWell(child:
                                    new Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.red),
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(padding: EdgeInsets.only(left: 20,right: 5,top: 10,bottom: 10),
                                              child: new Icon( Icons.access_time ,color: Colors.red,size: 20,)
                                          ),
                                          new Padding(padding: EdgeInsets.only(left: 5,right: 20,top: 10,bottom: 10),child: new Text("Archived",style: TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.bold),),),
                                        ],
                                      ),
                                    ),
                                      onTap: (){
                                        running  = "archived";
                                        LoadNoticeboards(running,"load");
                                      },
                                    ),
                                      flex: 1,),
                                  ],
                                )
                            ),
                            new Container(
                              padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                              child : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(child: new Text("Noticeboard List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
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
                            _Noticeboarddetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                                : new Padding(padding: EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 10,
                                  columns: [
                                    DataColumn(
                                      label: Text("#",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Title",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Show on Website",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Date",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                                            Text((_searchResult.indexOf(user)+1).toString()),
                                          ),
                                          DataCell(
                                            Text(user.title),
                                          ),
                                          DataCell(
                                              new InkWell(child:
                                              new Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: user.showonwebsite == "0"?  Colors.red: Colors.green,
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    new Padding(padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 5),child: new Text(user.showonwebsite == "0"? "Inactive" :"Active  ",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                    new Padding(padding: EdgeInsets.only(right: 5,left: 10,top: 5,bottom: 5),
                                                      child: new Container(
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white
                                                        ),
                                                        padding: EdgeInsets.all(5),
                                                        child: new Icon(user.showonwebsite == "0"?  Icons.cancel : Icons.check ,color: user.showonwebsite == "0"?  Colors.red: Colors.green,size: 15,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                                onTap: (){
                                                },
                                              )
                                          ),
                                          DataCell(
                                            Text(user.createtime),
                                          ),
                                          DataCell(
                                            new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                          ),
                                        ]),
                                  ).toList()
                                      : _Noticeboarddetails.map(
                                        (user) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text((_Noticeboarddetails.indexOf(user)+1).toString()),
                                          ),
                                          DataCell(
                                            Text(user.title),
                                          ),
                                          DataCell(
                                              new InkWell(child:
                                              new Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: user.showonwebsite == "0"?  Colors.red: Colors.green,
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    new Padding(padding: EdgeInsets.only(left: 15,right: 10,top: 5,bottom: 5),child: new Text(user.showonwebsite == "0"? "Inactive" :"Active  ",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                    new Padding(padding: EdgeInsets.only(right: 5,left: 10,top: 5,bottom: 5),
                                                      child: new Container(
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white
                                                        ),
                                                        padding: EdgeInsets.all(5),
                                                        child: new Icon(user.showonwebsite == "0"?  Icons.cancel : Icons.check ,color: user.showonwebsite == "0"?  Colors.red: Colors.green,size: 15,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                                onTap: (){
                                                },
                                              )
                                          ),
                                          DataCell(
                                            Text(user.createtime),
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

    _Noticeboarddetails.forEach((vehicleDetail) {
      if (vehicleDetail.title.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.notice.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) )
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Noticeboarddetails> _searchResult = [];
  List<Noticeboarddetails> _Noticeboarddetails = [];
}

class Noticeboarddetails {
  String title, notice, showonwebsite, id,status,createtime,filename;
  Noticeboarddetails({this.title, this.notice, this.showonwebsite, this.id,this.status,this.createtime,this.filename});

  factory Noticeboarddetails.fromJson(Map<String, dynamic> json) {
    return new Noticeboarddetails(
        showonwebsite: json['show_on_website'],
        title: json['notice_title'].toString(),
      filename: json['image'].toString(),
      id: json['notice_id'].toString(),
        status: json['status'].toString(),
      createtime: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['create_timestamp']) * 1000)).toString(),
    );
  }
}