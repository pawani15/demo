import 'dart:io';
import 'package:Edecofy/const.dart';
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

import '../dashboard.dart';

class StudentAcademicSyllabus extends StatefulWidget {
//  final String studentname,studentid;
  // StudentAcademicSyllabus({this.studentname,this.studentid});
  @override
  State<StatefulWidget> createState() =>
      new _StudentAcademicSyllabusPageState();
}

class _StudentAcademicSyllabusPageState extends State<StudentAcademicSyllabus>
    with SingleTickerProviderStateMixin {
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
    var url = await Constants().Clienturl() +
        Constants.LoadStudentsAcademicSyllabus +
        id;
    Map<String, String> body = new Map();
    body['student_id'] = id;
    print("url is $url" + "body--" + body.toString());

    http
        .post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            int i = 1;
            for (Map user in responseJson['result']['syllabus']) {
              _Syllabusdetails.add(Syllabusdetails.fromJson(user, i));
              i++;
            }
          } catch (e) {
            _Syllabusdetails = new List();
          }
        } else
          _Syllabusdetails = new List();

        setState(() {
          _loading = false;
        });
      } else {
        print("erroe--" + response.body);
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
//          onPressed: () => Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
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
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
//            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 15,height: 15,),
//                    new Text("Academic Syllabus",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                    new SizedBox(width: 15,height: 15,),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Image(image: AssetImage('assets/refresh_icon.png')),
//                        new Text("Home > Academic Syllabus",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                      ],
//                    ),
//                  ],
//                )
//            ),
          ),
          new Card(
            margin:
            new EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 25),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(
                Icons.search,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search ', border: InputBorder.none),
                onChanged: onSearchTextChanged,
              ),
//              trailing: new IconButton(
//                icon: new Icon(
//                  Icons.cancel,
//                  color: Theme
//                      .of(context)
//                      .primaryColor,
//                ),
//                onPressed: () {
//                  controller.clear();
//                  onSearchTextChanged('');
//                },
//              ),
            ),
          ),
          new Card(
            elevation: 5.0,
            margin:
            new EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 100),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading
                ? new Constants().bodyProgress
                : new Padding(
                padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
                    new Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      child: new Text(
                        "Academic Syllabus",
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    new Divider(
                      height: 16,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                    _Syllabusdetails.length == 0
                        ? new Container(
                        child: new Center(
                            child: new Text("No Records found",
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.red))))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Id No",
                              style: TextStyle(
                                  color:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  fontSize: 15.0),
                            ),
                          ),
                          DataColumn(
                            label: Text("Title",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Description",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Subject",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Uploader",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Date",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("File",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Download",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 15.0)),
                          ),
                        ],
                        rows: _searchResult.length != 0 ||
                            controller.text.isNotEmpty
                            ? _searchResult
                            .map(
                              (user) =>
                              DataRow(cells: [
                                DataCell(
                                  Text(user.sno),
                                ),
                                DataCell(
                                  Text(user.title),
                                ),
                                DataCell(
                                  Text(
                                    user.description,
                                    overflow:
                                    TextOverflow.ellipsis,
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
                                  Text(user.file),
                                ),
                                DataCell(new InkWell(
                                  child: new Container(
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        new Padding(
                                          padding:
                                          EdgeInsets.only(
                                              right: 5),
                                          child: new Text(
                                            "Download",
                                            style: TextStyle(
                                                color:
                                                Colors.white,
                                                fontSize: 8,
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                        ),
                                        new Icon(
                                          Icons.cloud_download,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                    padding:
                                    new EdgeInsets.all(5),
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
                                )),
                              ]),
                        )
                            .toList()
                            : _Syllabusdetails.map(
                              (user) =>
                              DataRow(cells: [
                                DataCell(
                                  Text(user.sno),
                                ),
                                DataCell(
                                  Text(user.title),
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
                                    child: GestureDetector(child: Text(
                                      user.file,
                                      overflow: TextOverflow.ellipsis,),
                                      onTap: () {
                                        _showDialog1(
                                            context, user.file);
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(new InkWell(
                                  child: new Container(
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Padding(
                                          padding: EdgeInsets.only(
                                              right: 5),
                                          child: new Text(
                                            "Download",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                        ),
                                        new Icon(
                                          Icons.cloud_download,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                    padding: new EdgeInsets.all(5),
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                  ),
                                  onTap: () {
                                    if (user.file ==
                                        "null") {
                                      Constants().ShowAlertDialog(
                                          context,
                                          "File not available to download");
                                    }
                                    else{
                                      Download(user.file);}
                                  },
                                )),
                              ]),
                        ).toList(),
                      ),
                    ),

                  ],
                )

            ),

          ),
//          Divider(
//            color: Colors.grey[400],
//            thickness: 2,
//          ),
//          Container(
//            margin: EdgeInsets.only(right: 40),
//            padding: EdgeInsets.symmetric(vertical: 8),
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                  child: Container(
//                    alignment: Alignment.center,
//                    child: Text('showing pages'),
//                  ),
//                ),
//                Expanded(
//                  child: Container(
//                    alignment: Alignment.center,
//                    child: Text('1-10'),
//                  ),
//                ),
//                Expanded(
//                  child: Container(
//                    child: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(
//                            Icons.arrow_back_ios,
//                            size: 16,
//                          ),
//                          onPressed: () {},
//                        ),
//                        IconButton(
//                          icon: Icon(
//                            Icons.arrow_forward_ios,
//                            size: 16,
//                          ),
//                          onPressed: () {},
//                        ),
//                      ],
//                    ),
//                  ),
//                )
//              ],
//            ),
//          )
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

    var url = await Constants().Clienturl() +  "api_students/force_download/syllabus/" + filename;
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

//  Future<Null> download(Syllabusdetails syllabusdetails,BuildContext context) async {
//    String url = await Constants().Clienturl() +
//        "api_students/download_academic_syllabus/";
//    String body = "academic_syllabus_code=" +
//        Uri.encodeComponent(syllabusdetails.fileurl);
////      String body = Uri.encodeComponent("academic_syllabus_code");
//    var bodyBytes = utf8.encode(body);
////      print("Body $body");
////    var http = HttpClient();
////    var request = await http.postUrl(Uri.parse(url)); /// what this api respond, any input param ?
////
//    String root = (await getExternalStorageDirectory()).path;
//
//    String filePath = "$root/Edecofy/${syllabusdetails.file}";
//
//  DownloadUtil.download(url, filePath, body: {"academic_syllabus_code" : syllabusdetails.fileurl}, context: context);
//    File file = new File(filePath);
//
//    if(file.existsSync()){
//      // DO when success
//    }
//
//  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Syllabusdetails.forEach((vehicleDetail) {
      if (vehicleDetail.subject.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.title.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.uploader.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.date.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Syllabusdetails> _searchResult = [];
  List<Syllabusdetails> _Syllabusdetails = [];
}

class Syllabusdetails {
  String sno,
      title,
      description,
      subject,
      uploader,
      date,
      file,
      id,
      fileurl,
      filename;

  Syllabusdetails({this.sno,
    this.title,
    this.description,
    this.subject,
    this.uploader,
    this.date,
    this.file,
    this.id,
    this.fileurl,
    this.filename});

  factory Syllabusdetails.fromJson(Map<String, dynamic> json, int no) {
    return new Syllabusdetails(
      title: json['title'].toString(),
      description: json['description'].toString(),
      subject: json['subject_name'].toString(),
      uploader: json['uploader_type'].toString(),
      date: new DateFormat('dd-MM-yyyy')
          .format(new DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json['timestamp']) * 1000))
          .toString(),
      file: json['file_name'].toString(),
      id: json['academic_syllabus_id'].toString(),
      fileurl: json['academic_syllabus_code'].toString(),
      sno: no.toString(),
      filename: json['file'].toString(),
    );
  }
}

class DownloadUtil {
  static final PDF_FILE = "application/pdf";
  static final JPG_FILE = "image/jpg";
  static final PNG_FILE = "image/png";

  /**
   * Get Extension of string after '.'
   */
  static String getFileExtension(String str) {
    if (str == null) {
      str = "";
    }

    int extensionIndex = str.lastIndexOf('.');

    if (extensionIndex != -1) {
      return str.substring(extensionIndex + 1);
    }

    return null;
  }

  static String getContentType(String fileExtension) {
    if (fileExtension == null) {
      fileExtension = "";
    }

    fileExtension = fileExtension.toLowerCase();

    String contentType = null;
    if (fileExtension == "jpg")
      contentType = DownloadUtil.JPG_FILE;
    else if (fileExtension == "png")
      contentType = DownloadUtil.PNG_FILE;
    else if (fileExtension == "pdf") contentType = DownloadUtil.PDF_FILE;

    return contentType;
  }

  static download(String url, String filePath,
      {Map<String, String> body,
        String method = "POST",
        bool pop = true,
        BuildContext context}) async {
    String bodyData;
    const MethodChannel _channel =
    const MethodChannel('com.adrav.edecofy/filepicker');
    if (method == "POST") {
      bodyData = "";
      if (body != null && body.length > 0) {
        body.forEach((key, value) {
          bodyData += "$key=" + Uri.encodeComponent(value);
        });
      }
    }

    var bodyBytes;
    if (bodyData != null) {
      bodyBytes = utf8.encode(bodyData);
    }

    var http = HttpClient();
    var request;

    if (method == "POST") {
      request = await http.postUrl(Uri.parse(url));
      request.headers.add("Content-Type", "application/x-www-form-urlencoded");
      request.headers.add("Content-Length", bodyBytes.length.toString());
      request.add(bodyBytes);
    } else if (method == "GET") {
      request = await http.getUrl(Uri.parse(url));
    }

    HttpClientResponse response = await request.close();
    List<int> data = List<int>();
    data = await consolidateHttpClientResponseBytes(response);


    File file = File(filePath);
    file.writeAsBytes(data);

    print(file.path+" <===== Path");
    var args = {'url': file.path};
    if (pop) {
      Navigator.of(context).pop();
    }
    _channel.invokeMethod('openfile', args);
  }
}
