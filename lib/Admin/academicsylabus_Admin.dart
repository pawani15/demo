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

import '../FilePicker.dart';
import '../const.dart';
import '../dashboard.dart';


class AdminAcademicsyllabustabsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _AdminAcademicsyllabustabsPageState();
}

class _AdminAcademicsyllabustabsPageState extends State<AdminAcademicsyllabustabsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _loading = false;

  List<Tab> tabs = new List();
  List<Widget> tabsbody = new List();

  String clas = '',subject = '',file='',discription = '';
  Map classmap= new Map(),subjectsmap = new Map();
  List<String> classlist= new List(),subjectsslist= new List();
  TextEditingController title = new TextEditingController();

  _navigatetoclasses(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Classes",duplicateitems: classlist,)),
    );
    setState(() {
      clas = result ?? clas;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
    LoadSubjects(classmap[clas]);
  }

  _navigatetosubjects(BuildContext context) async {
    final result =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(title: "Subjects",duplicateitems: subjectsslist,)),
    );
    setState(() {
      subject = result ?? subject;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  LoadCLassdetails() async{
    Map body = new Map();
    body['admin_id'] = await Constants().Userid();

    var url = await Constants().Clienturl() + Constants.Load_Classes_Admin;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            tabs.add(new Tab(
                text: "Class - "+data['class_name'].toString()));
            tabsbody.add(
              new AdminAcademicsyllabusPage(
                classid: data['class_id'],
              ),
            );
            classlist.add(data['class_name']);
            classmap[data['class_name']] = data['class_id'];
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

  LoadSubjects(classid) async{
    Constants().onLoading(context);
    subjectsslist.clear();
    Map body = new Map();
    body['class_id'] = classid;

    var url = await Constants().Clienturl() + Constants.Load_Subjects_Admin;
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
    Navigator.of(context).pop();
    FocusScope.of(context).requestFocus(FocusNode());
    AddAcademeivsyllabusdialog("norefresh");
  }

  AddSyllabus() async{
    Constants().onLoading(context);
    Map<String,dynamic> body = new Map();
    body['login_user_id'] = await Constants().Userid();
    body['title'] = title.text;
    body['class_id'] = classmap[clas];
    body['subject_id'] = subject == "" ? "" : subjectsmap[subject];
    body['file_name'] = _file == null ? "" : new UploadFileInfo(_file, await AppUtil.getFileNameWithExtension(_file));
    body['description'] = discription;

    var url = await Constants().Clienturl() + Constants.Add_AcademicSyllabus_Admin;
    print("url--"+url+'body is $body');

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
              new AdminAcademicsyllabustabsPage()));
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
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadCLassdetails();
  }

  AddAcademeivsyllabusdialog(String status) async {
    if(status == "refresh") {
      clas = '';
      subject = '';
      title.text = '';
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
                       controller: title,
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
                                  Constants().ShowAlertDialog(context, "please enetr title");
                                  return;
                                }
                                if(clas == ""){
                                  Constants().ShowAlertDialog(context, "please select class");
                                  return;
                                }
                                if(subject == ""){
                                  Constants().ShowAlertDialog(context, "please select subject");
                                  return;
                                }
                                /*if(_file == null){
                                  Constants().ShowAlertDialog(context, "please select File");
                                  return;
                                }*/
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
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Upload Syllabus",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
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
      floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => AddAcademeivsyllabusdialog("refresh"),backgroundColor: Theme.of(context).primaryColor,
      ),
      body:  _loading ? new Constants().bodyProgress : new Stack(
        children: <Widget>[
          new Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
/*            child: new Container(
                child: Column(
                  children: <Widget>[
                    new SizedBox(width: 10,height: 10,),
                    new Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange
                      ),
                      child: new SvgPicture.asset("assets/book.svg",color: Colors.white,width: 25,height: 25,),
                      padding: new EdgeInsets.all(7),
                    ),
                    new SizedBox(width: 10,height: 10,),
                    new Text("Academic Syllabus",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  ],
                )
            ),*/
          ),
          new Card(
            elevation: 5.0,
            margin:
            new EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 30),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child:  new Column(
              children: <Widget>[
                Expanded(
                    child: new DefaultTabController(
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
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminAcademicsyllabusPage extends StatefulWidget {
  final String classid;
  AdminAcademicsyllabusPage({this.classid});

  @override
  State<StatefulWidget> createState() => new _AdminAcademicsyllabusPageState();
}

class _AdminAcademicsyllabusPageState extends State<AdminAcademicsyllabusPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();


  @override
  void initState() {
    super.initState();
    /*setState(() {
      _loading = true;
    });*/
    LoadSylabus();
  }

  Future<Null> LoadSylabus() async {
    String id = await sp.ReadString("Userid");
    _Syllabusdetails.clear();
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Load_AcademicSyllabus_Admin;
    Map<String, String> body = new Map();
    body['class_id'] = widget.classid;

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            setState(() {
              for (Map user in responseJson['result']) {
                _Syllabusdetails.add(Syllabusdetails.fromJson(user));
              }
            });
            print("len"+_Syllabusdetails.length.toString());
          }catch(e){
            print(e.toString());
            _Syllabusdetails = new List();
          }
        }
        /*setState(() {
          _loading = false;
        });*/
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body:  _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
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
                                  Text(user.id),
                                ),
                                DataCell(
                                  Text(user.title),
                                ),
                                DataCell(
                                  Text(user.description),
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
                                  Text(user.filename),
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
                                        Download(user.fileurl,user.filename);
                                      },
                                    )
                                ),
                              ]),
                        ).toList(),
                      ),
                    ),
                  ],
                )),
    );
  }

  static const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');

  Future<Null> Download(String url,String filename) async {
    print("downloadurl--"+url);
    Constants().onDownLoading(context);
    Directory appDocDir = await getExternalStorageDirectory();
    var path =appDocDir.path;
    new Directory(appDocDir.path+'/'+'Edecofy').create(recursive: true);
    String filePath = "$path/Edecofy/${filename}";
    File file = new File(filePath);
    if(!await file.exists()) {
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

  factory Syllabusdetails.fromJson(Map<String, dynamic> json) {
    return new Syllabusdetails(
        title: json['title'].toString(),
        id: json['academic_syllabus_id'].toString() ,
        description: json['description'].toString() ,
        subject: json['subject_name'].toString() ,
        uploader: json['uploader_type'].toString(),
        date: "  "+ new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['timestamp']) * 1000)).toString(),
        filename: json['file_name'].toString(),
        fileurl: json['academic_syllabus_code'].toString(),
    );
  }
}