import 'dart:convert';
import 'dart:io';
import 'package:Edecofy/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class StudentLibrary extends StatefulWidget {
  TabController _tabController;
  bool _loading = false;
  String fromdate, todate, book = '', clas = '', subject = '', file = '';
  List<Map<String, dynamic>> books = List();
  TextEditingController controller = new TextEditingController();
  List<String> booklist = new List();
  Map<String, String> bookmamp = new Map();
  TextEditingController description = new TextEditingController(),
      title = new TextEditingController();
  DateTime date = new DateTime.now();
  Map classmap = new Map(), subjectsmap = new Map();
  List<String> filetypelist = new List();
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 1));
  DateTime frmdt;
  DateTime todt;

  String selectedBook;

  @override
  State<StatefulWidget> createState() => new _StudentLibraryPageState();
}

class _StudentLibraryPageState extends State<StudentLibrary>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    setState(() {
      widget._loading = true;
    });
//    filetypelist.add("image");
//    filetypelist.add("doc");
//    filetypelist.add("pdf");
//    filetypelist.add("excel");
//    filetypelist.add("others");

    LoadLibrary();
  }

  _navigatetobooks(BuildContext context) async {
    String result =
    await Constants().Selectiondialog(context, "Books", widget.booklist);
    setState(() {
      widget.book = result ?? widget.book;
    });

    print("res--" + result.toString());
  }

  Future<DateTime> _selectDate(BuildContext context, int index) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now(),
      lastDate: index == 1 ? widget.frmdt : DateTime(2020, 8),);
    if (picked != null)
      setState(() {
        widget.selectedDate = picked;
        if (index == 0) {
          widget.frmdt = widget.selectedDate;
          widget.todate = null;
          widget.fromdate =
          "${widget.selectedDate.day}-${widget.selectedDate.month}-${widget
              .selectedDate.year}";
        } else {
          widget.todt = widget.selectedDate;
          widget.todate =
          "${widget.selectedDate.day}-${widget.selectedDate.month}-${widget
              .selectedDate.year}";
        }
      });
  }

  Future<Null> LoadBookRequest() async {
    if (widget.fromdate != null && widget.todate != null) {
      String id = await sp.ReadString("Userid");
      var url = await Constants().Clienturl() +
          Constants.Student_libraryRequestbook +
          id;
      Map<String, String> body = new Map();
      // body['student_id'] = id;
      body['type_page'] = 'create';
      body['book_id'] = widget.bookmamp[widget.book];
      body['login_user_id'] = id;
      body['issue_start_date'] = widget.fromdate;
      body['issue_end_date'] = widget.todate;
      print("url is $url" + "body--" + body.toString());
      http
          .post(url,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: body)
          .then((response) {
        if (response.statusCode == 200) {
          print("response --> ${response.body}");



          var responseJson = json.decode(response.body);
          //  logger.d(responseJson);
          //   print("$responseJson  4567");
          if (responseJson['recordsTotal'] > 0) {
            print("response json   ${responseJson}");
            try {
              for (Map user in responseJson['data']) {
                _Librarydetails.add(Librarydetails.fromJson(user));
              }
            } catch (e) {
              _Librarydetails = new List();
            }
          }
          setState(() {
            widget._loading = false;
          });
        } else {
          print("erroe--" + response.body);
        }
      });
    } else {
      print("test");
    }
  }

  Future<Null> LoadLibrary() async {
    String id = await sp.ReadString("Userid");
    var url =
        await Constants().Clienturl() + Constants.Load_Students_Library + id;
    Map<String, String> body = new Map();
    body['login_user_id'] = id;
    print("url is $url" + "body--" + body.toString());
    http
        .post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
//        logger.d(response.body);

        var responseJson = json.decode(response.body);
        //  logger.d(responseJson);
        //   print("$responseJson  4567");
        if (responseJson['status'].toString() == "true"){
          print("response json   ${responseJson}");
          try {
            for (Map user in responseJson['result']) {
              _Librarydetails.add(Librarydetails.fromJson(user));
            }
          } catch (e) {
            _Librarydetails = new List();
          }
        }
        setState(() {
          widget._loading = false;
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

//  List<String> classlist= new List(),subjectsslist= new List();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Library"),
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
            new EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              title: new TextField(
                controller: widget.controller,
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
//                  widget.controller.clear();
//                  onSearchTextChanged('');
//                },
//              ),
            ),
          ),
          Container(
            margin:
            new EdgeInsets.only(left: 10, right: 5, bottom: 10, top: 90),
            child: Stack(
              children: <Widget>[
                new Card(
                  elevation: 5.0,
                  margin: new EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 0),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: widget._loading
                      ? new Constants().bodyProgress
                      : new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new ListView(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 2),
                            child: new Text(
                              "Library List",
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
                          _Librarydetails.length == 0
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
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontSize: 15.0),
                                  ),
                                ),
                                DataColumn(
                                  label: Text("Book Title",
                                      style: TextStyle(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          fontSize: 15.0)),
                                ),
                                DataColumn(
                                  label: Text("Author",
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
                                  label: Text("Price",
                                      style: TextStyle(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          fontSize: 15.0)),
                                ),
                                DataColumn(
                                  label: Text("Class",
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
                                  widget
                                      .controller.text.isNotEmpty
                                  ? _searchResult.map(
                                    (user) {
                                  return DataRow(cells: [
                                    DataCell(
                                      Text(user.bookid),
                                    ),
                                    DataCell(
                                      Text(user.booktitle),
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
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                      ),
                                      onTap: () {
                                        if (user.filename ==
                                            "null" || user.filename =="") {
                                          Constants().ShowAlertDialog(
                                              context,
                                              "File not available to download");
                                        }
                                        else{
                                          Download(user.filename);}

                                      },
                                    )),
                                  ]);
                                },
                              ).toList()
                                  : _Librarydetails.map(
                                    (user) =>
                                    DataRow(cells: [
                                      DataCell(
                                        Text(user.bookid),
                                      ),
                                      DataCell(
                                        Text(user.booktitle),
                                      ),
                                      DataCell(
                                        Text(user.author),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50,
                                          child: GestureDetector(
                                            child: Text(
                                              user.description,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
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
                                                padding:
                                                EdgeInsets.only(
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
                                          if (user.filename ==
                                              "null"|| user.filename =="") {
                                            Constants().ShowAlertDialog(
                                                context,
                                                "File not available to download");
                                          }
                                          else{
                                            Download(user.filename);}

                                        },
                                      )),
//                                DataCell(
//                                    new InkWell(child: new Container(child :new Row(
//                                      mainAxisAlignment: MainAxisAlignment.center,
//                                      children: <Widget>[
//                                        new Padding(padding: EdgeInsets.only(right: 5),child: new Text("Download",style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),),),
//                                        new Icon(Icons.cloud_download,color: Colors.white,)
//                                      ],
//                                    ),padding: new EdgeInsets.all(5),
//                                      color: Theme.of(context).primaryColor,
//                                    ),
//                                      onTap: (){
//                                        Download(user);
//                                      },
//                                    )
//                                ),
                                    ]),
                              ).toList(),
                            ),
                          ),
                        ],
                      )),
                ),
//                new Align(
//                    alignment: Alignment.topRight,
//                    child: new InkWell(
//                      child: new Container(
//                        width: 45,
//                        height: 45,
//                        alignment: Alignment.center,
//                        decoration: BoxDecoration(
//                            color: Colors.yellow[800],
//                            shape: BoxShape.circle,
//                            boxShadow: [
//                              BoxShadow(
//                                color: Colors.grey[300],
//                                blurRadius: 5.0,
//                              ),
//                            ]),
//                        child: new Icon(
//                          Icons.add,
//                          color: Colors.white,
//                          size: 20,
//                        ),
//                      ),
//                      onTap: () {
//                        AddBookRequest(null);
//                      },
//                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  AddBookRequest(Librarydetails studymaterialdetails) async {
    showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: BookRequest(onSubmit: (data) async {
              String id = await sp.ReadString("Userid");
              var url =
                  await Constants().Clienturl() + Constants.Student_libraryRequestbook + id;
              http.post(url,
                  headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                  },
                  body: data).then((res) {
                print(res.statusCode);
                print(res.body);
              }).catchError((err) {
                print(err);
              });
            },)
        );
      },
    );
  }

  static const MethodChannel _channel =
  const MethodChannel('com.adrav.edecofy/filepicker');

  Future<Null> Download(String filename) async {
    if(filename == null || filename.isEmpty ) {
      Constants().ShowAlertDialog(context, "No file available to download.");
      return;
    }

    var url = await Constants().Clienturl() +    "api_students/force_download/document/" + filename;
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

    _Librarydetails.forEach((vehicleDetail) {
      if (vehicleDetail.booktitle.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.booktitle.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.classname.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Librarydetails> _searchResult = [];
  List<Librarydetails> _Librarydetails = [];
}

class BookRequest extends StatefulWidget {
  String fromdate, todate, book = '', clas = '', subject = '', file = '',id='';
  List<Map<String, dynamic>> books = List();
  DateTime date = new DateTime.now();
  Map classmap = new Map(), subjectsmap = new Map();
  List<String> filetypelist = new List();
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 1));
  DateTime frmdt;
  DateTime todt;
  ValueChanged<Map<String, String>> onSubmit;
  VoidCallback onCancel, onDismiss;
  String selectedBook;
  BookRequest({this.onSubmit, this.onCancel, this.onDismiss});
  @override
  State<StatefulWidget> createState() {
    return _BookRequestState();
  }
}

class _BookRequestState extends State<BookRequest> {
  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        new Container(
            margin: new EdgeInsets.all(5.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: new Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(2),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: new Container(
                    child: new Text(
                      "Request New Book",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
                  flex: 7,
                ),
                Expanded(
                  child: new InkWell(
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 25,
                      ),
                      onTap: () {
                        if (widget.onDismiss != null) {
                          widget.onDismiss();

                          ///
                        }
                      }),
                  flex: 1,
                )
              ],
            )),
        new SizedBox(
          height: 20,
          width: 20,
        ),
        new Container(
            margin: EdgeInsets.all(5.0),
            child: new InkWell(
              child:
//                      new TextField(
//                        keyboardType: TextInputType.text,
//                        decoration: InputDecoration(
//                            hintText: "Books *",
//                            prefixIcon: new Icon(Icons.library_books),
//                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
//                        ),
//                        controller: TextEditingController(text: widget.book),
//                        enabled: false,
//                      ),
              DropdownButtonFormField(
                items: widget.books.map((book) {
                  return DropdownMenuItem(
                    value: book["book_id"],
                    child: Text(book["book_name"]),
                  );
                }).toList(),
                onChanged: (id) {
                  widget.selectedBook = id;
                  setState(() {});
                },
                value: widget.books.isEmpty ? null : widget.selectedBook,
              ),
              onTap: () {
                // _navigatetobooks(context);
                // _navigatetoclasses(context);
              },
            )),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Issue Starting Date *",
                    prefixIcon: new Icon(Icons.date_range)),
                controller: TextEditingController(text: widget.fromdate),
                enabled: false,
              ),
              onTap: () {
                _selectDate(context, 0);
                // _Fileypedialog(action,studymaterialdetails);
              },
            )),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Issue Ending Date *",
                    prefixIcon: new Icon(Icons.date_range)),
                controller: TextEditingController(text: widget.todate),
                enabled: false,
              ),
              onTap: () {
                _selectDate(context, 1);
                // _Fileypedialog(action,studymaterialdetails);
              },
            )),
        new SizedBox(
          width: 30,
          height: 30,
        ),
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
                          if (widget.onSubmit != null) {
                            Map<String, String> result = {
                              "type_page": "create",
                              "book_id": widget.selectedBook,
                              "login_user_id": widget.id,
                              "issue_start_date": widget.fromdate,
                              "issue_end_date": widget.todate
                            };
                            widget.onSubmit(result);
                            // pass result from here
                          }
                          Navigator.of(context).pop();
                          Constants().ShowSuccessDialog(
                              context, " Book Requested  succesfully");
                          const duration = const Duration(seconds: 2);
                         loadBooks();
                          // Addstudymaterial(action,studymaterialdetails);
                        },
                        child: new Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.green[800],
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15))),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11),
                                  ),
                                )
                              ],
                            )))),
                flex: 1,
              ),
              new Expanded(
                child: new Container(
                    margin: new EdgeInsets.all(0.0),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: new InkWell(
                        onTap: () {
                          if (widget.onCancel != null) widget.onCancel();
                        },
                        child: new Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                )),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "close",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11),
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
    );
  }

  Future<Null> _selectDate(BuildContext context, int index) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: index == 1 ? widget.frmdt : DateTime(2015,8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        widget.selectedDate = picked;
        if (index == 0) {
          widget.frmdt = widget.selectedDate;
          widget.todate = null;
          widget.fromdate = "${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}";
        } else {
          widget.todt = widget.selectedDate;
          widget.todate =
          "${widget.selectedDate.day}-${widget.selectedDate.month}-${widget
              .selectedDate.year}";
        }
      });
    //for date picker//
  }

  loadBooks() async {
    var url =
        await Constants().Clienturl() + Constants.Student_Book_dropdown ;
    Response response = await http
        .get(url);


    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      if (result["status"]) {
        widget.books.clear();
        widget.selectedBook = "";
        if ((result["result"] as List).isNotEmpty) {
          (result["result"] as List).forEach((book) {
            widget.books.add(book);
          });
          widget.selectedBook = widget.books[0]["book_id"];
        }
      }
      setState(() {});
    }
  }

}

class Librarydetails {
  String bookid,
      booktitle,
      author,
      description,
      price,
      classname,
      download,
      filename;

  Librarydetails(
      {this.bookid,
        this.booktitle,
        this.author,
        this.description,
        this.price,
        this.classname,
        this.download,
        this.filename});

  factory Librarydetails.fromJson(Map<String, dynamic> json) {
    return new Librarydetails(
//      id: json[''].toString() ,
      bookid: json['book_id'].toString(),
      booktitle: json['name'].toString(),
      author: json['author'].toString(),
      description: json['description'].toString(),
      price: json['price'].toString(),
      classname: json['class_name'].toString(),
      download: json['download'].toString(),
      filename: json['file_name'].toString(),
    );
  }
}
