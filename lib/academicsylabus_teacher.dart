import 'dart:io';
import 'package:Edecofy/AppUtils.dart';
import 'package:Edecofy/search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'FilePicker.dart';
import 'const.dart';
import 'dashboard.dart';

class AcademicsyllabustabsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AcademicsyllabustabsPageState();
}

class _AcademicsyllabustabsPageState extends State<AcademicsyllabustabsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _loading = false;
  List<Tab> tabs = new List();
  List<Widget> tabsbody = new List();
  String clas = '',subject = '',title = '',file='',discription = '';
  Map classmap= new Map(),subjectsmap = new Map();
  TextEditingController controller = new TextEditingController();
  List<String> classlist= new List(),subjectsslist= new List();

  _navigatetoclasses(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
    );
    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    LoadSubjects();
  }
  _navigatetosubjects(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Subjects",duplicateitems: subjectsslist,)),
    );
    setState(() {
      subject = result ?? subject;
    });
    print("res1--"+result.toString());
  }

  LoadCLassdetails() async{
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_Classes;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response pawani --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['classes']) {
            classlist.add(data['class_id']);
            classmap[data['class_id']] = data['class_id'];
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

  LoadSubjects() async{
    //subjectsslist.clear();
    Constants().onLoading(context);
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_Subjectsforstudymaterisl+classmap[clas]+"/"+await Constants().Userid();
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            subjectsslist.add(data['name']);
            subjectsmap[data['name']] = data['subject_id'];
        //    print("pawani::$subjectsslist");
          }
        }
        Navigator.of(context).pop();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Dio dio = new Dio();
  File _file = null;
  String fileext= "",filename= "";

  Future _getFile() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
    filename.replaceAll("", "%20");
    Navigator.of(context).pop();
    AddAcademeivsyllabusdialog("norefresh");

  }

  AddSyllabus() async{
    Constants().onLoading(context);
    Map<String,dynamic> body = new Map();
    body['teacher_id'] = await Constants().Userid();
    body['title'] = title;
    body['class_id'] = classmap[clas];
    body['subject_id'] = subject == "" ? "" : subjectsmap[subject];
    body['file_name'] = new UploadFileInfo(_file, await AppUtil.getFileNameWithExtension(_file));
    body['description'] = discription;
    var url = await Constants().Clienturl() + Constants.Upload_ACADSyllabus;
    print("url--"+url+'body is $body');

    /*http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if(responseJson['status'].toString() == "true"){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
              new AcademicsyllabustabsPage()));
        }
        else{
          Constants().ShowAlertDialog(context, "Syllabus not added succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });*/

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
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
              new AcademicsyllabustabsPage()));
        }
        else{
          Constants().ShowAlertDialog(context, "Syllabus not added succesfully");
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.data);
      }
    }catch(e){
      print("imaguploadresponse-->${e}");
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    json.decode(Constants.dynmenulist)['result']['classes'].forEach((data) {
      tabs.add(new Tab(
          text: "Class - "+data['name'].toString()));
      tabsbody.add(
        new AcademicstlabusPage(
          classid: data['class_id'],
        ),
      );
    });
    LoadCLassdetails();
  }

  AddAcademeivsyllabusdialog(String status) async {
    if(status == "refresh") {
      clas = '';
      subject = '';
      title = '';
      _file = null;
      discription = '';
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
                              Icons.cloud_upload,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all( 2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Upload Syllabus",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 20,width: 20,),
                new Container(margin: new EdgeInsets.all(5.0),
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Title *",
                          prefixIcon: new Icon(FontAwesomeIcons.userAlt),
                        ),
                        onChanged: (String val){
                          title = val;
                        },
                      ),
                    ),
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
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Subject *",
                            prefixIcon: new Icon(Icons.subject),
                            suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                        ),
                        controller: TextEditingController(text: subject),
                        enabled: false,
                      ),
                      onTap: () {
                        if(clas == ''){
                          Constants().ShowAlertDialog(context, "Please select Class");
                          return;
                        }
                        _navigatetosubjects(context);
                      },
                    )),
                new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Upload File *",
                            prefixIcon: new Icon(FontAwesomeIcons.fileUpload),
                            suffixIcon: _file == null ? new Icon(Icons.cloud_upload) : fileext == "jpg" || fileext == "png" ? new Image.file(_file,scale: 25,) : new Icon(Icons.cloud_upload)
                        ),
                        controller: TextEditingController(text:  _file == null ? "" : filename),
                        enabled: false,
                      ),
                      onTap: () {
                        _getFile();
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Description *",
                      prefixIcon: new Icon(Icons.message)
                  ),
                  onChanged: (String val){
                    discription = val;
                  },
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
                                AddAcademeivsyllabusdialog("refresh");
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
                                if(title == ""){
                                  Constants().ShowAlertDialog(context, "please enter title");
                                  return;
                                }
                                if(clas == ""){
                                  Constants().ShowAlertDialog(context, "please select class");
                                  return;
                                }
                                if(_file == null){
                                  Constants().ShowAlertDialog(context, "please select File");
                                  return;
                                }
                                AddSyllabus();
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
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Upload Syllabus",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10),),)
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
//
//        ),
      ),
      drawer: Constants().drawer(context),
//      floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => AddAcademeivsyllabusdialog("refresh"),
//        backgroundColor: Theme.of(context).primaryColor,
//      ),
      body:  _loading ? new Constants().bodyProgress : new Stack(
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
//                    new SizedBox(width: 10,height: 10,),
//                    new Container(
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.orange
//                      ),
//                      child: new SvgPicture.asset("assets/book.svg",color: Colors.white,width: 25,height: 25,),
//                      padding: new EdgeInsets.all(7),
//                    ),
//                    new SizedBox(width: 10,height: 10,),
//                    new Text("Academic Syllabus",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),

          Container(
            margin: new EdgeInsets.only(left: 15,right: 5,bottom: 0,top: 40),
            child: Stack(
              children: <Widget>[
                new Card(
                  elevation: 5.0,
                  margin:
                  new EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 30),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child:  new DefaultTabController(
                      length: tabs.length,
                      child: new Scaffold(
                        appBar: TabBar(
                          unselectedLabelColor: Colors.grey,
                          labelColor: Theme.of(context).primaryColor,
                          isScrollable: true,
                          tabs: tabs,
                          controller: _tabController,
                          indicatorColor:
                          Theme.of(context).primaryColor,
                        ),
                        body: TabBarView(
                          children: tabsbody,
                          controller: _tabController,
                        ),
                      )),
                ),
                new Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom:2.0),
                        child: new InkWell(child:new Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.yellow[800],
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 5.0,
                              ),]
                          ),
                          child: new Icon(Icons.add,color: Colors.white,size: 20,),
                        ),onTap: (){
                          AddAcademeivsyllabusdialog("refresh");
                        },
                        ),
                      )
                  )
                ]

            ),
          ),
        ],
      ),
    );
  }
}

class AcademicstlabusPage extends StatefulWidget {
  final String classid;
  AcademicstlabusPage({this.classid});
  @override
  State<StatefulWidget> createState() => new _AcademicstlabusPageState();
}

class _AcademicstlabusPageState extends State<AcademicstlabusPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadSylabus();
  }

  Future<Null> LoadSylabus() async {
    String id = await sp.ReadString("Userid");
    _Syllabusdetails.clear();
    var url = await Constants().Clienturl() + Constants.Load_AcademicSyllabus_Teacher+widget.classid;
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
            int i =1;
            for (Map user in responseJson['result']) {
              _Syllabusdetails.add(Syllabusdetails.fromJson(user,i));
              i++;
            }
          }catch(e){
            _Syllabusdetails = new List();
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
      body:  _loading ? new Constants().bodyProgress :  Stack(
          children: <Widget>[
            Container(
            child: new Padding(padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
                    new Card(
                      margin: new EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 5,
                      child: new ListTile(
                        leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
                        title: new TextField(
                          controller: controller,
                          decoration: new InputDecoration(
                              hintText: 'Search your things..', border: InputBorder.none),
                          onChanged: onSearchTextChanged,
                        ),
//                        trailing: new IconButton(
//                          icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                          onPressed: () {
//                            controller.clear();
//                            onSearchTextChanged('');
//                          },
//                        ),
                      ),
                    ),
                    new SizedBox(width: 5,height: 5,),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                      child: new Text("Academic Syllabus",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 10,color: Theme.of(context).primaryColor,),
                    _Syllabusdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : SingleChildScrollView(
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
                        rows: _Syllabusdetails.map(
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
                                      child: Text(
                                        user.description,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        _showDialog1(context, user.description);
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
                                      child: Text(
                                        user.filename,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        _showDialog1(context, user.filename);
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
                                        if (user.filename ==
                                            "null" || user.filename =="") {
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
          ),]

      ),
    );
  }

  static const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');

//  Future<Null> Download(String filename) async {
//    if(filename != null) {
//      var url = await Constants().Clienturl() +
//          "api_teachers/force_download/syllabus/" + filename;
//      print("downloadurl--" + url);
//      Constants().onDownLoading(context);
//      var appDocDir = await getExternalStorageDirectory();
//      var path = appDocDir.path;
//      new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
//      String filePath = "$path/Edecofy/${filename}";
//      File file = new File(filePath);
//      file.delete();
//      if (!await file.exists()) {
//        var httpClient = new HttpClient();
//        var request = await httpClient.getUrl(Uri.parse(url));
//        print(request);
//        var response = await request.close();
//        if (response.statusCode == 200) {
//          var bytes = await consolidateHttpClientResponseBytes(response);
//          file.create();
//          await file.writeAsBytes(bytes);
//        }
//        else {
//          Navigator.of(context).pop();
//          Constants().ShowAlertDialog(
//              context, "Failed to download. Please try after sometime");
//          return;
//        }
//      }
//      var args = {'url': filePath};
//      Navigator.of(context).pop();
//      _channel.invokeMethod('openfile', args);
//
//    }
//    else
//      Constants().ShowAlertDialog(context, "No file available to download.");
//  }

  Future<Null> Download(String filename) async {
    if(filename == null || filename.isEmpty ) {
      Constants().ShowAlertDialog(context, "No file available to download.");
      return;
    }
    var url = await Constants().Clienturl() + "api_teachers/force_download/syllabus/" + filename;
    print("downloadurl--" + url);
 filename.replaceAll(" ", "%20");
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
  String sno, title, description, subject,uploader,date,filename,id,fileurl;
  Syllabusdetails({this.sno, this.title, this.description, this.subject,this.uploader,this.date,this.filename,this.id,this.fileurl});

  factory Syllabusdetails.fromJson(Map<String, dynamic> json,int no) {
    return new Syllabusdetails(
        title: json['title'].toString(),
        description: json['description'].toString() ,
        subject: json['subject_name'].toString() ,
        uploader: json['uploader_type'].toString(),
        date: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['timestamp']) * 1000)).toString(),
        filename: json['file_name'].toString(),
        fileurl: json['file_download'].toString(),
        sno: no.toString()
    );
  }

}