import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Edecofy/AppUtils.dart';
import 'package:Edecofy/FilePicker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../const.dart';
import '../dashboard.dart';
import '../search.dart';

class Studentmaterial extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StudentmaterialePageState();
}

class _StudentmaterialePageState extends State<Studentmaterial> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String clas = '' , subject = '',file =''; TextEditingController description=new TextEditingController(),title=new TextEditingController();
  DateTime date = new DateTime.now();
  Map classmap= new Map(),subjectsmap = new Map();
  List<String> filetypelist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    filetypelist.add("image");
    filetypelist.add("doc");
    filetypelist.add("pdf");
    filetypelist.add("excel");
    filetypelist.add("others");
    LoadStudymaterials();
  }

  Future<Null> LoadStudymaterials() async {
    _Studymaterialdetails.clear();
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Student_Studymaterial;
    Map<String, String> body = new Map();
    body['student_id'] = id;
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
              for (Map user in responseJson['result']['study_material_info']) {
                _Studymaterialdetails.add(Studymaterialdetails.fromJson(user,i));
                i++;
              }
            });
            //teacherslist = responseJson['data'];
          }catch(e){
            _Studymaterialdetails = new List();
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

  Future<void> _showDialog(BuildContext context, String data) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Description'),
          content: Text(data),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  List<String> classlist= new List(),subjectsslist= new List();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Study Material"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//
//        ),
      ),
      //floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => Addstudymaterialdialog("refresh","new",null),backgroundColor: Theme.of(context).primaryColor,
      //),

      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
//            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 15,height: 15,),
//                    new Text("Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                    new SizedBox(width: 15,height: 15,),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Image(image: AssetImage('assets/refresh_icon.png')),
//                        new Text("Home > Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                      ],
//                    ),
//                  ],
//                )
//            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 30),
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
              margin: new EdgeInsets.only(left: 10,right: 5,bottom: 10,top: 95),
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
//                            new Container(
//                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
//                              child: new Text("Academic Syllabus",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
//                            ),
//                            new Divider(height: 16,color: Theme.of(context).primaryColor,)
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                              child: new Text("Study Material",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                            ),
                            new Divider(height: 16,color: Theme.of(context).primaryColor,),
                       _Studymaterialdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                            :SingleChildScrollView(
                              scrollDirection: Axis.horizontal,

                              child: DataTable(
                                columnSpacing: 10,
                                columns: [
                                  DataColumn(
                                    label: Text("Id No",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Date",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Title",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Description", style:
                                    TextStyle(color: Theme
                                        .of(context)
                                        .primaryColor, fontSize: 15.0),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text("Class",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Subject",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Download",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                                          Text(user.date),
                                        ),
                                        DataCell(
                                          Text(user.name),
                                        ),
                                        DataCell(
                                          Text(user.description),
                                        ),
                                        DataCell(
                                          Text(user.classname),
                                        ),
                                        DataCell(
                                          Text(user.subname),
                                        ),
                                        DataCell(
                                            new InkWell(child: new Container(child :new Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                new Padding(padding: EdgeInsets.only(right: 5),child: new Text("Download",style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),),),
                                                new Icon(Icons.cloud_download,color: Colors.white,)
                                              ],
                                            ),padding: new EdgeInsets.all(5),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                              onTap: (){
                                                if (user.file ==
                                                    "null"|| user.file=="") {
                                                  Constants().ShowAlertDialog(
                                                      context,
                                                      "File not available to download");
                                                }
                                                else {
                                                  Download(user.file);
                                                }
                                              },
                                            )
                                        ),

                                      ]),
                                ).toList()

                                    : _Studymaterialdetails.map(
                                      (user) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(user.sno),
                                        ),
                                        DataCell(
                                          Text(user.date),
                                        ),
                                        DataCell(
                                          Text(user.name),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 50,
                                            child: GestureDetector(child: Text(
                                              user.description,
                                              overflow: TextOverflow.ellipsis,),
                                              onTap: () {
                                                _showDialog(
                                                    context, user.description);
                                              },
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(user.classname),
                                        ),
                                        DataCell(
                                          Text(user.subname),
                                        ),
                                       DataCell(
                                    new InkWell(child: new Container(child :new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Padding(padding: EdgeInsets.only(right: 5),child: new Text("Download",style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),),),
                                        new Icon(Icons.cloud_download,color: Colors.white,)
                                      ],
                                    ),padding: new EdgeInsets.all(5),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                      onTap: (){
                                        if (user.file ==
                                            "null"|| user.file=="") {
                                          Constants().ShowAlertDialog(
                                              context,
                                              "File not available to download");
                                        }
                                        else {
                                          Download(user.file);
                                        }
                                      },
                                    )
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

  static const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');
//  Future<Null> Download(Studymaterialdetails studymatdetails) async {
//    print("downloadurl--"+studymatdetails.filename);
//    if(studymatdetails.filename.split("document")[1] != "/") {
//      Constants().onDownLoading(context);
//      Directory appDocDir = await getExternalStorageDirectory();
//      var path = appDocDir.path;
//      new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
//      String filePath = "$path/Edecofy${studymatdetails.filename.split(
//          "document")[1]}";
//      File file = new File(filePath);
//      if (!await file.exists()) {
//        var httpClient = new HttpClient();
//        var request = await httpClient.getUrl(
//            Uri.parse(studymatdetails.filename));
//        var response = await request.close();
//        var bytes = await consolidateHttpClientResponseBytes(response);
//        file.create();
//        await file.writeAsBytes(bytes);
//      }
//      //OpenFile.open(filePath);
//      var args = {'url': filePath};
//      Navigator.of(context).pop();
//      _channel.invokeMethod('openfile', args);
//    }
//    else{
//      Constants().ShowAlertDialog(context, "File not available to download");
//    }
//  }


  Future<Null> Download(String filename) async {
    if(filename == null || filename.isEmpty ) {
      Constants().ShowAlertDialog(context, "No file available to download.");
      return;
    }

    var url = await Constants().Clienturl() +   "api_students/force_download/document/" + filename;
    print("downloadurl--" + url);

    Constants().onDownLoading(context);
    var appDocDir = await getExternalStorageDirectory();
    var path = appDocDir.path;
    new Directory( "$path/Edecofy").create(recursive: true);
    String filePath = "$path/Edecofy/${filename}";

    File file = new File(filePath);
    if (await file.exists()) {
      file.delete();
    }
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      file.create();
      await file.writeAsBytes(bytes);
      var args = {'url': filePath};
      Navigator.of(context).pop();
      _channel.invokeMethod('openfile', args);
    }else {
      Navigator.of(context).pop();
      Constants().ShowAlertDialog(context, "Failed to download. Please try after sometime");
      return;
    }

  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Studymaterialdetails.forEach((vehicleDetail) {
      if (vehicleDetail.name.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.classname.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Studymaterialdetails> _searchResult = [];
  List<Studymaterialdetails> _Studymaterialdetails = [];

}

class Studymaterialdetails {
  String  description, id, name,classname,subname,date,file,fileurl,sno;
  Studymaterialdetails({this.sno, this.description, this.id, this.name,this.classname,this.date,this.subname,this.file,this.fileurl});
  factory Studymaterialdetails.fromJson(Map<String, dynamic> json,int no) {
    return new Studymaterialdetails(
        id: json['document_id'].toString() ,
        name:  json['title'].toString() ,
        description: json['description'].toString(),
        classname: json['class_name'].toString(),
        subname: json['subject_name'].toString(),
        file: json['file_name'].toString(),
        date:json['date'].toString(),
        sno: no.toString(),
    );
  }
}