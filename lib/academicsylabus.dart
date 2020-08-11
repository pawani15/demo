import 'dart:io';
import 'package:Edecofy/dashboard.dart';
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
import 'const.dart';

class AcademicsyllabusPage extends StatefulWidget {
  final String studentname,studentid;
  AcademicsyllabusPage({this.studentname,this.studentid});
  @override
  State<StatefulWidget> createState() => new _AcademicstlabusPageState();
}

class _AcademicstlabusPageState extends State<AcademicsyllabusPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  List teacherslist;
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
    LoadSylabus();
  }

  Future<Null> LoadSylabus() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_AcademicSyllabus+widget.studentid;
    Map<String, String> body = new Map();
    body['student_id'] = widget.studentid;
    print(id);
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
            int i =1;
            for (Map user in responseJson['result']['syllabus']) {
              _Syllabusdetails.add(Syllabusdetails.fromJson(user,i));
              i++;
            }
          }catch(e){
            _Syllabusdetails = new List();
          }
        }
        else
          _Syllabusdetails = new List();

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

  Future<void> _showDialog1(BuildContext context, String data) {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Academic Syllabus"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//
//        ),
      ),
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

            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search ', border: InputBorder.none),
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
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 100),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                      child: new Text("Academic Syllabus",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                    _Syllabusdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        :
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: Text("Id No",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Title",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Description",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Subject",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Uploader",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Date",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("File",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Download",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                                  Text(user.title),
                                ),
                                DataCell(
                                  Text(user.description,
                                    overflow: TextOverflow.ellipsis,),
                                ),
                                DataCell(
                                  Text(user.subject),
                                ),
                                DataCell(
                                  Text(user.uploader),
                                ),
                                DataCell(
                                  Text(user.date),
                                ),
                                DataCell(
                                  Text(user.file),
                                ),
                                DataCell(
                                    new InkWell(
                                      child: new Container(child: new Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: new Text("Download",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight
                                                      .bold),),),
                                          new Icon(Icons.cloud_download,
                                            color: Colors.white,)
                                        ],
                                      ), padding: new EdgeInsets.all(5),
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                      ),
                                      onTap: () {
                                        if (user.file ==
                                            "null" || user.file =="") {
                                          Constants().ShowAlertDialog(
                                              context,
                                              "File not available to download");
                                        }
                                        else{
                                          Download(user.file);}
                                      },
                                    )
                                ),
                              ]),
                        ).toList()
                            : _Syllabusdetails.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text(user.sno),
                                ),
                                DataCell(
                                  Text(user.title),
                                ),
                                DataCell(
                                  Container(
                                    width: 50,
                                    child: GestureDetector(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        strutStyle: StrutStyle(fontSize: 12.0),
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.black),
                                            text: user.description),
                                      ),
                                      onTap: () {
                                        _showDialog(context, user.description);
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(user.subject),
                                ),
                                DataCell(
                                  Text(user.uploader),
                                ),
                                DataCell(
                                  Text(user.date),
                                ),
                                DataCell(
                                  Container(
                                    width: 50,
                                    child: GestureDetector(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        strutStyle: StrutStyle(fontSize: 12.0),
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.black),
                                            text: user.file),
                                      ),
                                      onTap: () {
                                        _showDialog1(context, user.file);
                                      },
                                    ),
                                  ),
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
                                            "null") {
                                          Constants().ShowAlertDialog(
                                              context,
                                              "File not available to download");
                                        }
                                        else{
                                          Download(user.file);}
                                      },)
                                ),
                              ]),
                        ).toList(),
                      ),
                    ),
                  ],
                )),
          )
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
    var url = await Constants().Clienturl() +  "api_parents/force_download/syllabus/" + filename;
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

    _Syllabusdetails.forEach((vehicleDetail) {
      if (vehicleDetail.subject.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.title.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.uploader.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.date.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Syllabusdetails> _searchResult = [];
  List<Syllabusdetails> _Syllabusdetails = [];

}

class Syllabusdetails {
  String sno, title, description, subject,uploader,date,file,id,fileurl;
  Syllabusdetails({this.sno, this.title, this.description, this.subject,this.uploader,this.date,this.file,this.id,this.fileurl});

  factory Syllabusdetails.fromJson(Map<String, dynamic> json,int no) {
    return new Syllabusdetails(
        title: json['title'].toString(),
        description: json['description'].toString() ,
        subject: json['subject_name'].toString() ,
        uploader: json['uploader_type'].toString(),
        date: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['timestamp']) * 1000)).toString(),
        file: json['file_name'].toString(),
        id:  json['academic_syllabus_id'].toString() ,
        fileurl: json['academic_syllabus_code'].toString(),
        sno: no.toString()
    );
  }
}