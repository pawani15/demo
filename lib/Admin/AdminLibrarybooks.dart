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

class AdminLibrarybooksPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _AdminLibrarybooksPageState();
}

class _AdminLibrarybooksPageState extends State<AdminLibrarybooksPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String clas = '' , file =''; TextEditingController description=new TextEditingController(),title=new TextEditingController(),author=new TextEditingController()
  ,price=new TextEditingController();
  DateTime date = new DateTime.now();
  Map classmap= new Map();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadCLassdetails();
  }

  LoadCLassdetails() async{
    Map body = new Map();

    var url = await Constants().Clienturl() + Constants.Load_Classes;
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
        LoadLibrarybooks();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> LoadLibrarybooks() async {
    _Bookdetails.clear();
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.LoadLibrarybooks_Admin;
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
                _Bookdetails.add(Bookdetails.fromJson(user));
              }  
            });
          }catch(e){
            _Bookdetails = new List();
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

  AddApi(String type,Bookdetails Bookdetails) async{
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url="";
    url = await Constants().Clienturl() + Constants.CRUDLibrarybooks_Admin;

    Map<String,dynamic> body = new Map();
    body['login_user_id'] = empid;
    if(type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "update";
      body['book_id'] = Bookdetails.bookid;
    }

    body['class_id'] = classmap[clas];
    body['name'] = title.text;
    body['author'] = author.text;
    body['price'] = price.text;
    body['description'] = description.text;
    body['file_name'] = _file == null ? "" : new UploadFileInfo(_file, await AppUtil.getFileNameWithExtension(_file));

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
          if(type == "edit")
            Constants().ShowSuccessDialog(context, "Book updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Book added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadLibrarybooks();
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
    //});
  }

  Future<Null> ADDoreditapi(String type,Bookdetails Bookdetails) async {
    Constants().onLoading(context);
    var url="";
    url = await Constants().Clienturl() + Constants.CRUDLibrarybooks_Admin;

    Map<String, String> body = new Map();
    if(type == "new")
      body['type_page'] = "create";
    else {
      body['type_page'] = "update";
      body['book_id'] = Bookdetails.bookid;
    }

    body['class_id'] = classmap[clas];
    body['name'] = title.text;
    body['author'] = author.text;
    body['price'] = price.text;
    body['description'] = description.text;
    body['file_name'] = "";

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
            Constants().ShowSuccessDialog(context, "Book updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Book added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadLibrarybooks();
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

  Widget _EdittPopup(Bookdetails) => PopupMenuButton<int>(
    itemBuilder: (context) => [
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
        Adddialog("refresh", "edit", Bookdetails);
      else if(value == 2)
        deletedialog(Bookdetails);
    },
  );

  List<String> classlist= new List(),subjectsslist= new List();

  _navigatetoclasses(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
    );
    setState(() {
      clas = result ?? clas;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  Dio dio = new Dio();
  File _file = null;
  String fileext= "",filename= "";
  Future _getFile(String action, Bookdetails Bookdetails) async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop();
    Adddialog("norefresh",action,Bookdetails);
  }

  deletedialog(Bookdetails Bookdetails) async {
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
                                      Delete(Bookdetails);
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

  Delete(Bookdetails Bookdetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['book_id'] = Bookdetails.bookid;
    body['type_page'] = "delete";

    var  url = await Constants().Clienturl() + Constants.CRUDLibrarybooks_Admin;

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
            LoadLibrarybooks();
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

  Adddialog(String status,String action, Bookdetails Bookdetails) async {
    String titlename = "Add Book";
    if(status == "refresh") {
      if(action == "new") {
        clas = '';
        description.text = '';
        _file = null;
        title.text='';
        author.text='';
        price.text='';
        titlename = "Add Book";
      }
      else{
        _file = null;
        clas = Bookdetails.classname;
        description.text = Bookdetails.description;
        title.text = Bookdetails.title;
        author.text = Bookdetails.author;
        price.text = Bookdetails.price;
        titlename = "Edit Book";
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
                      hintText: "Book Title *",
                      prefixIcon: new Icon(FontAwesomeIcons.book)
                  ),
                  controller:  title,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Author *",
                      prefixIcon: new Icon(FontAwesomeIcons.userAlt)
                  ),
                  controller:  author,
                )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      hintText: "Price *",
                      prefixIcon: new Icon(FontAwesomeIcons.rupeeSign)
                  ),
                  controller:  price,
                )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Class *",
                            prefixIcon: new Icon(FontAwesomeIcons.chalkboardTeacher),
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
                            hintText: "Upload File *",
                            prefixIcon: new Icon(FontAwesomeIcons.upload),
                            suffixIcon: _file == null ? new Icon(Icons.cloud_upload) : new ClipOval(child: new Image.file(_file,scale: 25,))
                        ),
                        controller: TextEditingController(text:  _file == null ? "" : filename),
                        enabled: false,
                      ),
                      onTap: () {
                        _getFile(action,Bookdetails);
                      },
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
                                Adddialog("refresh","new",Bookdetails);
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
                                  Constants().ShowAlertDialog(context, "please enter book title");
                                  return;
                                }
                                if(author.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter author");
                                  return;
                                }
                                if(price.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter price");
                                  return;
                                }
                                if(clas == ""){
                                  Constants().ShowAlertDialog(context, "please select class");
                                  return;
                                }
                                /*if(_file == null){
                                  Constants().ShowAlertDialog(context, "please select File");
                                  return;
                                }*/
                                AddApi(action,Bookdetails);
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
        title: Text("Manage Library Books"),
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
                    new Text("Manage Library Books",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
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
                          new Padding(padding: EdgeInsets.only(left: 5),child: Text("Add Book",style: TextStyle(color: Colors.white,fontSize: 14),))
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
                                  new Expanded(child: new Padding(child: new Text("Library Books List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
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
                            _Bookdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                                : new Padding(padding: EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 10,
                                  columns: [
                                    DataColumn(
                                      label: Text("Book ID",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Book Title",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Author",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                    ),
                                    DataColumn(
                                      label: Text("Download",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                                            Text(user.bookid),
                                          ),
                                          DataCell(
                                            Text(user.title),
                                          ),
                                          DataCell(
                                            Text(user.author),
                                          ),
                                          DataCell(
                                              new InkWell(child:
                                              new Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    new Padding(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text("Download",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                    new Padding(padding: EdgeInsets.only(right: 15,left: 5,top: 5,bottom: 5),
                                                      child: new Container(
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white
                                                      ),
                                                      padding: EdgeInsets.all(3),
                                                      child: new Icon( Icons.file_download ,color: Colors.green  ,size: 15,),
                                                    ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                                onTap: (){
                                                  Download(user.filename);
                                                },
                                              )
                                          ),
                                          DataCell(
                                            new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                          ),
                                        ]),
                                  ).toList()
                                      : _Bookdetails.map(
                                        (user) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(user.bookid),
                                          ),
                                          DataCell(
                                            Text(user.title),
                                          ),
                                          DataCell(
                                            Text(user.author),
                                          ),
                                          DataCell(
                                              new InkWell(child:
                                              new Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    new Padding(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text("Download",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                    new Padding(padding: EdgeInsets.only(right: 15,left: 5,top: 5,bottom: 5),
                                                      child: new Container(
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white
                                                        ),
                                                        padding: EdgeInsets.all(3),
                                                        child: new Icon( Icons.file_download ,color: Colors.green  ,size: 15,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                                onTap: (){
                                                  Download(user.filename);
                                                },
                                              )
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

  static const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');

  Future<Null> Download(String filename) async {
    if(filename != null) {
      var url = await Constants().Clienturl() +
          "api_admin/force_download/document/" + filename;
      print("downloadurl--" + url);
      Constants().onDownLoading(context);
      var appDocDir = await getExternalStorageDirectory();
      var path = appDocDir.path;
      new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
      String filePath = "$path/Edecofy/${filename}";
      File file = new File(filePath);
      if (!await file.exists()) {
        var httpClient = new HttpClient();
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        file.create();
        await file.writeAsBytes(bytes);
      }
      //OpenFile.open(filePath);
      var args = {'url': filePath};
      Navigator.of(context).pop();
      _channel.invokeMethod('openfile', args);
    }
    else
      Constants().ShowAlertDialog(context, "No file available to download.");
  }


  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Bookdetails.forEach((vehicleDetail) {
      if (vehicleDetail.title.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.author.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.bookid.toLowerCase().contains(text.toLowerCase()) )
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Bookdetails> _searchResult = [];
  List<Bookdetails> _Bookdetails = [];

}

class Bookdetails {
  String title, author, description, bookid,classname,filename,price,subject;

  Bookdetails({this.title, this.author, this.description, this.bookid,this.classname,this.filename,this.price,this.subject});

  factory Bookdetails.fromJson(Map<String, dynamic> json) {
    return new Bookdetails(
        author: json['author'].toString(),
        description: json['description'].toString() ,
        title: json['name'].toString(),
        bookid: json['book_id'].toString(),
        classname: json['class_name'].toString(),
        price: json['price'].toString(),
      subject: json['price'].toString(),
      filename: json['file_name'].toString(),
    );
  }
}