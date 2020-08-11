import 'dart:convert';
import 'dart:io';
import 'package:Edecofy/Student/academic_sylabus_student.dart';
import 'package:Edecofy/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../dashboard.dart';

class StudentHomework extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StudentHomeworkPageState();
}

class _StudentHomeworkPageState extends State<StudentHomework> with SingleTickerProviderStateMixin{

  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String clas = '' , subject = '',file =''; TextEditingController description=new TextEditingController(),
      title=new TextEditingController();
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

    LoadHomework();
  }

  Future<Null> LoadHomework() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.LoadHomeWork_students;
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
              for (Map user in responseJson['result']) {
                _Homeworkdetails.add(Homeworkdetails.fromJson(user,i));
                i++;
              }
            });
            //teacherslist = responseJson['data'];
          }catch(e){
            _Homeworkdetails = new List();
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
        title: Text("HomeWork"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
      //floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => Addstudymaterialdialog("refresh","new",null),backgroundColor: Theme.of(context).primaryColor,
      //),

      drawer: Constants().drawer(context),

      body: new Stack(
        children: <Widget>[
          new Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 15,height: 15,),
//                    new Text("Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                    new SizedBox(width: 15,height: 15,),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//
//                        Image(image: AssetImage('assets/refresh_icon.png')),
//                        new Text("Home > Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                      ],
//                    ),
//
//                  ],
//                )
            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 20),
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
              margin: new EdgeInsets.only(left: 10,right: 5,bottom: 10,top: 75),
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
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:
                              DataTable(
                                columnSpacing: 10,
                                columns: [
                                  DataColumn(
                                    label: Text("S.No",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Subject",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("HomeWork",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Assigned Date",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Due Date",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Remark",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Assigned By",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                                          Text(user.subname),
                                        ),
                                        DataCell(
                                          Text(user.hwtitle),
                                        ),
                                        DataCell(
                                          Text(user.assigndt),
                                        ),
                                        DataCell(
                                          Text(user.duedt),
                                        ),
                                        DataCell(
                                          Text(user.description),
                                        ),
                                        DataCell(
                                          Text(user.assignby),
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
                                                if (user.filename ==
                                                    "") {
                                                  Constants().ShowAlertDialog(
                                                      context,
                                                      "File not available to download");
                                                }
                                                else{
                                                  Download(user.filename);}
                                              },
                                            )
                                        ),
                                      ]),
                                ).toList()
                                    : _Homeworkdetails.map(
                                      (user) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(user.sno),
                                        ),
                                        DataCell(
                                          Text(user.subname),
                                        ),
                                        DataCell(
                                          Text(user.hwtitle),
                                        ),
                                        DataCell(
                                          Text(user.assigndt),
                                        ),
                                        DataCell(
                                          Text(user.duedt),
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
                                              },),
                                          ),
                                        ),
                                        DataCell(
                                          Text(user.assignby),
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
    if (user.filename ==
    ""|| user.filename =="null") {
    Constants().ShowAlertDialog(
    context,
    "File not available to download");
    }
    else{
    Download(user.filename);}

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

  Future<Null> Download(String filename) async {
    if(filename == null || filename.isEmpty ) {
      Constants().ShowAlertDialog(context, "No file available to download.");
      return;
    }

    var url = await Constants().Clienturl() +   "api_students/force_download/home_work/" + filename;
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

    _Homeworkdetails.forEach((vehicleDetail) {
      if (vehicleDetail.subname.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.hwtitle.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.assignby.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });


    setState(() {});
  }
  List<Homeworkdetails> _searchResult = [];
  List<Homeworkdetails> _Homeworkdetails = [];

}

class Homeworkdetails {
  String  description, id, hwtitle,assigndt,subname,date,filename,fileurl,sno,duedt,assignby;
  Homeworkdetails({this.sno, this.description, this.id, this.hwtitle,this.assigndt,this.duedt,this.date,this.subname,this.filename,this.fileurl,this.assignby});
  factory Homeworkdetails.fromJson(Map<String, dynamic> json,int no) {
    return new Homeworkdetails(
//      id: json[''].toString() ,
      subname: json['subject_name'].toString(),
      hwtitle:  json['hw_title'].toString() ,
      assigndt: json['assign_dt'].toString(),
      duedt: json['due_dt'].toString(),
      description: json['description'].toString(),
      filename: json['file_name'].toString(),
      date:json['date'].toString(),
      assignby:json['assign_by'].toString(),
      fileurl: json['hw_id'].toString(),
      sno: no.toString(),
    );
  }
}

