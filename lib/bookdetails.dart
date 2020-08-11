import 'dart:io';

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

class Parent_BookdetailsPage1 extends StatefulWidget {
  final String studentname, studentid;

  Parent_BookdetailsPage1({this.studentname, this.studentid});

  @override
  State<StatefulWidget> createState() => new _Parent_BookdetailsPage1State();
}

class _Parent_BookdetailsPage1State extends State<Parent_BookdetailsPage1>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadbooks();
  }

  Future<Null> Loadbooks() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() +
        Constants.Load_Books_Parent +
        widget.studentid;
    Map<String, String> body = new Map();
    body['student_id'] = widget.studentid;
    print("url is $url" + "body--" + body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        //if (responseJson['status'].toString() == "true") {
        print("response json ${responseJson}");
        try {
          int i = 1;
          for (Map user in responseJson['result']) {
            _Bookdetails.add(Bookdetails.fromJson(user, i));
            i++;
          }
        } catch (e) {
          _Bookdetails = new List();
        }
        //}
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Books"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () => Navigator.of(context).pop(),),
      ),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 50,
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
//                    new Container(
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        color: Colors.orange
//                      ),
//                      child: new SvgPicture.asset("assets/book.svg",color: Colors.white,width: 25,height: 25,),
//                      padding: new EdgeInsets.all(5),
//                      margin: EdgeInsets.all(5),
//                    ),
//                    new Text("Books",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Card(
            margin:
            new EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 30),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
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
//                  color: Theme.of(context).primaryColor,
//                ),
//                onPressed: () {
//                  controller.clear();
//                  onSearchTextChanged('');
//                },
//              ),
            ),
          ),
          new Container(
              margin:
              new EdgeInsets.only(left: 10, right: 5, bottom: 10, top: 90),
              child: new Stack(
                children: <Widget>[
                  new Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.only(top: 10, right: 10),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 2),
                              child: new Text(
                                "Books List",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Divider(
                              height: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                            _Bookdetails.length == 0
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
                                      "Book Id",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Book Title",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Author",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Description",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Price",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Class",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Download",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                ],
                                rows: _searchResult.length != 0 ||
                                    controller.text.isNotEmpty
                                    ? _searchResult
                                    .map(
                                      (user) => DataRow(cells: [
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
                                      Text(user.description),
                                    ),
                                    DataCell(
                                      Text(user.price),
                                    ),
                                    DataCell(
                                      Text(user.classname),
                                    ),
                                    DataCell(new InkWell(
                                      child: new Container(
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            new Padding(
                                              padding: EdgeInsets
                                                  .only(
                                                  right:
                                                  5),
                                              child: new Text(
                                                "Download",
                                                style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize:
                                                    8,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            new Icon(
                                              Icons
                                                  .cloud_download,
                                              color: Colors
                                                  .white,
                                            )
                                          ],
                                        ),
                                        padding:
                                        new EdgeInsets
                                            .all(5),
                                        color:
                                        Theme.of(context)
                                            .primaryColor,
                                      ),
                                      onTap: () {
                                        Download(user.filename);
                                      },
                                    )),
                                  ]),
                                )
                                    .toList()
                                    : _Bookdetails.map(
                                      (user) => DataRow(cells: [
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
                                      Container(
                                        width: 50,
                                        child: GestureDetector(
                                          child: Text(
                                              user.description),
                                          onTap: () {
                                            _showDialog(context,
                                                user.description);
                                          },
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(user.price),
                                    ),
                                    DataCell(
                                      Text(user.classname),
                                    ),
                                    DataCell(new InkWell(
                                      child: new Container(
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            new Padding(
                                              padding: EdgeInsets
                                                  .only(
                                                  right: 5),
                                              child: new Text(
                                                "Download",
                                                style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize: 8,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            new Icon(
                                              Icons
                                                  .cloud_download,
                                              color:
                                              Colors.white,
                                            )
                                          ],
                                        ),
                                        padding:
                                        new EdgeInsets.all(
                                            5),
                                        color: Theme.of(context)
                                            .primaryColor,
                                      ),
                                      onTap: () {
                                        if (user.filename ==
                                            "null") {
                                          Constants().ShowAlertDialog(
                                              context,
                                              "File not available to download");
                                        }
                                           else{Download(user.filename);}

                                      },
                                    )),
                                  ]),
                                ).toList(),
                              ),
                            ),
                          ],
                        )),
                  ),
//                  Constants.logintype == "student"
//                      ?
//                  new Align(
//                      alignment: Alignment.topRight,
//                      child: new InkWell(
//                        child: new Container(
//                          width: 45,
//                          height: 45,
//                          alignment: Alignment.center,
//                          decoration: BoxDecoration(
//                              color: Colors.yellow[800],
//                              shape: BoxShape.circle,
//                              boxShadow: [
//                                BoxShadow(
//                                  color: Colors.grey[300],
//                                  blurRadius: 5.0,
//                                ),
//                              ]),
//                          child: new Icon(
//                            FontAwesomeIcons.book,
//                            color: Colors.white,
//                            size: 20,
//                          ),
//                        ),
//                        onTap: () {
//                          requestnewbookdialog("refresh");
//                        },
//                      ))
//                      : new Container()
                ],
              ))
        ],
      ),
    );
  }

//  DateTime startdate = null, enddate = null;
//  String book = "";
//
//  Future<Null> _selectstartDate(BuildContext context) async {
//    try {
//      DateTime picked = await showDatePicker(
//          context: context,
//          initialDate: DateTime.now(),
//          firstDate: DateTime(DateTime.now().minute - 1),
//          lastDate: DateTime(DateTime.now().year + 1));
//
//      if (picked != null && picked != startdate) {
//        print('date selected : ${startdate.toString()}');
//        setState(() {
//          startdate = picked;
//        });
//        Navigator.of(context).pop();
//        requestnewbookdialog("norefresh");
//      }
//    } catch (e) {
//      e.toString();
//    }
//  }
//
//  Future<Null> _selectendDate(BuildContext context) async {
//    try {
//      DateTime picked = await showDatePicker(
//          context: context,
//          initialDate: DateTime.now(),
//          firstDate: DateTime(DateTime.now().minute - 1),
//          lastDate: DateTime(DateTime.now().year + 1));
//
//      if (picked != null && picked != enddate) {
//        print('date selected : ${enddate.toString()}');
//        setState(() {
//          enddate = picked;
//        });
//        Navigator.of(context).pop();
//        requestnewbookdialog("norefresh");
//      }
//    } catch (e) {
//      e.toString();
//    }
//  }
//
//  requestnewbookdialog(
//      String status,
//      ) async {
//    String titlename = "Request New Book";
//    if (status == "refresh") {
//      startdate = null;
//      enddate = null;
//      book = "";
//    }
//    return showDialog<Null>(
//      context: context,
//      barrierDismissible: true, // user must tap button!
//      builder: (BuildContext context) {
//        return new Dialog(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(15))),
//            child: new ListView(
//              shrinkWrap: true,
//              children: <Widget>[
//                new Container(
//                    margin: new EdgeInsets.all(5.0),
//                    child: new Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Expanded(
//                          child: new Container(
//                            decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                color: Theme.of(context).primaryColor),
//                            child: new Icon(
//                              FontAwesomeIcons.book,
//                              color: Colors.white,
//                              size: 20,
//                            ),
//                            padding: EdgeInsets.all(10),
//                            margin: EdgeInsets.all(2),
//                          ),
//                          flex: 2,
//                        ),
//                        Expanded(
//                          child: new Container(
//                            child: new Text(
//                              titlename,
//                              style: TextStyle(
//                                  fontSize: 20,
//                                  color: Theme.of(context).primaryColor,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            margin: EdgeInsets.only(left: 5),
//                          ),
//                          flex: 7,
//                        ),
//                        Expanded(
//                          child: new InkWell(
//                              child: Icon(
//                                Icons.close,
//                                color: Colors.red,
//                                size: 25,
//                              ),
//                              onTap: () => Navigator.of(context).pop()),
//                          flex: 1,
//                        )
//                      ],
//                    )),
//                new SizedBox(
//                  height: 20,
//                  width: 20,
//                ),
//                new Container(
//                    margin: EdgeInsets.all(5.0),
//                    child: new TextField(
//                      keyboardType: TextInputType.text,
//                      decoration: InputDecoration(
//                          hintText: "Book *",
//                          prefixIcon: new Icon(FontAwesomeIcons.book)),
//                      onChanged: (val) {
//                        book = val;
//                      },
//                    )),
//                new Container(
//                    margin: new EdgeInsets.all(5.0),
//                    child: new InkWell(
//                      child: new TextField(
//                        keyboardType: TextInputType.text,
//                        decoration: InputDecoration(
//                          labelText: 'Issue Start Date *',
//                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
//                        ),
//                        enabled: false,
//                        controller: new TextEditingController(
//                            text: startdate == null
//                                ? ""
//                                : new DateFormat('dd-MM-yyyy')
//                                .format(startdate)),
//                      ),
//                      onTap: () {
//                        _selectstartDate(context);
//                      },
//                    )),
//                new Container(
//                    margin: new EdgeInsets.all(5.0),
//                    child: new InkWell(
//                      child: new TextField(
//                        keyboardType: TextInputType.text,
//                        decoration: InputDecoration(
//                          labelText: 'Issue End Date *',
//                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
//                        ),
//                        enabled: false,
//                        controller: new TextEditingController(
//                            text: enddate == null
//                                ? ""
//                                : new DateFormat('dd-MM-yyyy').format(enddate)),
//                      ),
//                      onTap: () {
//                        _selectendDate(context);
//                      },
//                    )),
//                new SizedBox(
//                  width: 30,
//                  height: 30,
//                ),
//                new Container(
//                  child: new Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      new Expanded(
//                        child: new Container(
//                            margin: new EdgeInsets.all(0.0),
//                            alignment: Alignment.center,
//                            width: double.infinity,
//                            child: new InkWell(
//                                onTap: () {
//                                  Navigator.of(context).pop();
//                                  requestnewbookdialog("refresh");
//                                },
//                                child: new Container(
//                                    padding: EdgeInsets.all(10),
//                                    decoration: BoxDecoration(
//                                        color: Colors.yellow[800],
//                                        borderRadius: BorderRadius.only(
//                                            bottomLeft: Radius.circular(15))),
//                                    child: new Row(
//                                      mainAxisAlignment:
//                                      MainAxisAlignment.center,
//                                      children: <Widget>[
//                                        new Icon(
//                                          Icons.autorenew,
//                                          color: Colors.white,
//                                        ),
//                                        new Padding(
//                                          padding: EdgeInsets.only(left: 5.0),
//                                          child: Text(
//                                            "Reset",
//                                            style: TextStyle(
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.bold,
//                                                fontSize: 11),
//                                          ),
//                                        )
//                                      ],
//                                    )))),
//                        flex: 1,
//                      ),
//                      new Expanded(
//                        child: new Container(
//                            margin: new EdgeInsets.all(0.0),
//                            alignment: Alignment.center,
//                            width: double.infinity,
//                            child: new InkWell(
//                                onTap: () {
//                                  if (book == "") {
//                                    Constants().ShowAlertDialog(
//                                        context, "Please enter book");
//                                    return;
//                                  }
//                                  if (startdate == null) {
//                                    Constants().ShowAlertDialog(context,
//                                        "Please select issue start date");
//                                    return;
//                                  }
//                                  if (enddate == null) {
//                                    Constants().ShowAlertDialog(context,
//                                        "Please select issue end date");
//                                    return;
//                                  }
//                                },
//                                child: new Container(
//                                    padding: EdgeInsets.all(10),
//                                    decoration: BoxDecoration(
//                                        color: Colors.green,
//                                        borderRadius: BorderRadius.only(
//                                          bottomRight: Radius.circular(15),
//                                        )),
//                                    child: new Row(
//                                      mainAxisAlignment:
//                                      MainAxisAlignment.center,
//                                      children: <Widget>[
//                                        new Icon(
//                                          Icons.check,
//                                          color: Colors.white,
//                                        ),
//                                        new Padding(
//                                          padding: EdgeInsets.only(left: 5.0),
//                                          child: Text(
//                                            "Submit",
//                                            style: TextStyle(
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.bold,
//                                                fontSize: 11),
//                                          ),
//                                        )
//                                      ],
//                                    )))),
//                        flex: 1,
//                      ),
//                    ],
//                  ),
//                )
//              ],
//            ));
//      },
//    );
//  }

  static const MethodChannel _channel =
  const MethodChannel('com.adrav.edecofy/filepicker');
  Future<Null> Download(String filename) async {
    if(filename == null || filename.isEmpty ) {
      Constants().ShowAlertDialog(context, "No file available to download.");
      return;
    }

    var url = await Constants().Clienturl() + "api_admin/force_download/document/" + filename;
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

//
//  Future<Null> Download(Bookdetails bookdetails) async {
//    print("downloadurl--" + bookdetails.filedownload);
//    if (bookdetails.filedownload != "" &&
//        bookdetails.filedownload.split("document")[1] != "/") {
//      Constants().onDownLoading(context);
//      Directory appDocDir = await getExternalStorageDirectory();
//      var path = appDocDir.path;
//      new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
//      String filePath =
//          "$path/Edecofy${bookdetails.filedownload.split("document")[1]}";
//      File file = new File(filePath);
//      if (!await file.exists()) {
//        var httpClient = new HttpClient();
//        var request =
//        await httpClient.getUrl(Uri.parse(bookdetails.filedownload));
//        var response = await request.close();
//        var bytes = await consolidateHttpClientResponseBytes(response);
//        file.create();
//        await file.writeAsBytes(bytes);
//      }
//      //OpenFile.open(filePath);
//      var args = {'url': filePath};
//      Navigator.of(context).pop();
//      _channel.invokeMethod('openfile', args);
//    } else {
//      Constants().ShowAlertDialog(context, "File not available to download");
//    }
//  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Bookdetails.forEach((vehicleDetail) {
      if (vehicleDetail.author.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.title.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Bookdetails> _searchResult = [];
  List<Bookdetails> _Bookdetails = [];
}

class Bookdetails {
  String title, author, description, price, classname, bookid, filedownload,filename;

  Bookdetails(
      {this.title,
        this.author,
        this.description,
        this.price,
        this.classname,
        this.bookid,
        this.filename,
        this.filedownload});

  factory Bookdetails.fromJson(Map<String, dynamic> json, int no) {
    return new Bookdetails(
        author: json['author'].toString(),
        description:
        json['description'] == null ? "" : json['description'].toString(),
        price: json['price'].toString(),
        title: json['name'].toString(),
        bookid: json['book_id'].toString(),
        filedownload: json['download'].toString(),
        filename:json['file_name'].toString(),
        classname: json['class_name'].toString());

  }
}
