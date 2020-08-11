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
import 'AppUtils.dart';
import 'FilePicker.dart';
import 'const.dart';
import 'dashboard.dart';
import 'search.dart';

class StudymaterialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StudymaterialPageState();
}

class _StudymaterialPageState extends State<StudymaterialPage> with SingleTickerProviderStateMixin{
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

    LoadCLassdetails();
  }

  LoadCLassdetails() async{
    classlist.clear();
    subjectsslist.clear();
    Map body = new Map();
    body['teacher_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_Classes;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']['classes']) {
            classlist.add(data['class_id']);
            classmap[data['class_id']] = data['class_id'];
          }
        }
        LoadStudymaterials();
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  LoadSubjects() async{
    subjectsslist.clear();
    Map body = new Map();
    Constants().onLoading(context);
    body['teacher_id'] = await Constants().Userid();
    var url = await Constants().Clienturl() + Constants.Load_Subjectsforstudymaterisl+classmap[clas]+"/"+await Constants().Userid();
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          for (Map data in responseJson['result']) {
            subjectsslist.add(data['name']);
            subjectsmap[data['name']] = data['subject_id'];
          }
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> LoadStudymaterials() async {
    _Studymaterialdetails.clear();
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Studymaterial;
    Map<String, String> body = new Map();
    body['teacher_id'] = id;
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
              for (Map user in responseJson['result']['study_material_info']) {
                _Studymaterialdetails.add(Studymaterialdetails.fromJson(user));
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

  Addstudymaterial(String type,Studymaterialdetails studymaterialdetails) async{
    Constants().onLoading(context);
    Map<String,dynamic> body = new Map();
    body['teacher_id'] = await Constants().Userid();
    body['timestamp'] = new DateFormat("dd-MM-yyyy").format(date);
    body['title'] = title.text;
    body['class_id'] = classmap[clas];
    body['subject_id'] = subject == "" ? "" : subjectsmap[subject];
    body['file_name'] = new UploadFileInfo(_file, await AppUtil.getFileNameWithExtension(_file));
    body['file_type'] = file;
    body['description'] = description.text;
    var url = await Constants().Clienturl() + Constants.Create_studymaterial;
    if(type == "edit")
      url = await Constants().Clienturl() + Constants.Update_studymaterial+studymaterialdetails.id;
    print("url--"+url+'body is $body');
    /*http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {*/
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 120000; //5s
    dio.options.receiveTimeout=5000;
    FormData formData = new FormData.from(body);
    // Send FormData
    try {
      Response response = await dio.post("", data: formData);
      if (response.statusCode == 200) {
        print("response --> ${response.data}");
        /*var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");

        }*/
        if(response != null){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          if(type == "edit")
            Constants().ShowSuccessDialog(context, "Study material updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Study material added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadStudymaterials();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, "Study material not added succesfully");
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

  Widget _EdittPopup(Studymaterialdetails studymatdetails) => PopupMenuButton<int>(
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
      PopupMenuItem(
          value: 3,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.download,color: Colors.green),),
              new Text("Download"),
            ],
          )
      ),
    ],
    elevation: 5,
    padding: EdgeInsets.symmetric(horizontal: 20),
    onSelected: (value) {
      print(value);
      if(value == 1)
        Addstudymaterialdialog("refresh", "edit", studymatdetails);
      else if(value == 2)
        deleteStudtmaterialdialog(studymatdetails);
      else if(value == 3)
        Download(studymatdetails.file1);
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
    print("res--"+result.toString());
    if(result !=null)
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
    print("res--"+result.toString());
  }

  Future<Null> _selectDate(BuildContext context, String action, Studymaterialdetails studymaterialdetails) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-50),
          lastDate: DateTime.now());

      if (picked != null && picked != date) {
        print('date selected : ${date.toString()}');
        setState(() {
          date = picked;
        });
        Navigator.of(context).pop();
        Addstudymaterialdialog("norefresh",action,studymaterialdetails);
      }
    }catch(e){e.toString();}
  }

  _Fileypedialog(String action, Studymaterialdetails studymaterialdetails) async{
    String tax = await Constants().Selectiondialog(context, "File type", filetypelist);
    setState(() {
      file = tax ?? file;
    });
    Navigator.of(context).pop();
    Addstudymaterialdialog("norefresh",action,studymaterialdetails);
  }

  Dio dio = new Dio();
  File _file = null;
  String fileext= "",filename= "";
  Future _getFile(String action, Studymaterialdetails studymaterialdetails) async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File file = await FilePicker.getFile(type: FileType.ANY);
    setState(() {
      _file = file;
    });
    fileext = await AppUtil.getFileExtension(_file);
    filename = await AppUtil.getFileNameWithExtension(_file);
    Navigator.of(context).pop();
    Addstudymaterialdialog("norefresh",action,studymaterialdetails);

  }
//  Future _getFile(String action, Studymaterialdetails studymaterialdetails) async {
//    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    File file = await FilePicker.getFile(type: FileType.ANY);
//    setState(() {
//      _file = file;
//    });
//    fileext = await AppUtil.getFileExtension(_file);
//    filename = await AppUtil.getFileNameWithExtension(_file);
//    Navigator.of(context).pop();
//    Addstudymaterialdialog("norefresh",action,studymaterialdetails);
//  }

  deleteStudtmaterialdialog(Studymaterialdetails studymaterialdetails) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new Row(crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new IconButton(icon: new Icon(Icons.close,color: Colors.red,size: 35,), onPressed: () => Navigator.of(context).pop() )
                      ],)),
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
                new SizedBox(width: 20,height: 20,),
                new Container( child: new Text("Are you sure, you want to delete this file?",style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,)),
                new SizedBox(width: 20,height: 20,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new InkWell(
                        onTap: () {
                          Deletematerial(studymaterialdetails);
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
            )

        );
      },
    );
  }

  Deletematerial(Studymaterialdetails studymaterialdetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['document_id'] = studymaterialdetails.id;
    var  url = await Constants().Clienturl() + Constants.Delete_studymaterial+studymaterialdetails.id;
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
          Constants().ShowSuccessDialog(context, responseJson['result']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadStudymaterials();
          }
          new Timer(duration, handleTimeout);
        }
        else{
          Constants().ShowAlertDialog(context, responseJson['result']);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Addstudymaterialdialog(String status,String action, Studymaterialdetails studymaterialdetails) async {
    String titlename = "Add Study Material";
    if(status == "refresh") {
      if(action == "new") {
        date = DateTime.now();
        clas = '';
        subject = '';
        file = '';
        description.text = '';
        _file = null;
        title.text='';
        titlename = "Add Study Material";
      }
      else{
        date = new DateFormat("dd MMM, yyyy").parse(studymaterialdetails.date);
        clas = studymaterialdetails.classname;
        subject = studymaterialdetails.subname;
        file = /*studymaterialdetails.filename*/"";
        _file = null;
        description.text = studymaterialdetails.description;
        title.text = studymaterialdetails.name;
        titlename = "Edit Study Material";
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
                              Icons.add,
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
                new Container(margin: new EdgeInsets.all(5.0),
                    child : new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Date *',
                          prefixIcon: new Icon(FontAwesomeIcons.calendar),
                        ),
                        enabled: false,
                        controller: new TextEditingController(text: date == null ? "" :  new DateFormat('yyyy-MM-dd').format(date)),
                      ),
                      onTap: (){
                        _selectDate(context,action,studymaterialdetails);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Title *",
                      prefixIcon: new Icon(Icons.person_outline)
                  ),
                  controller:  title,
                )),
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Class *",
                            prefixIcon: new Icon(FontAwesomeIcons.chalkboardTeacher,),
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
                        _getFile(action,studymaterialdetails);
                      },
                    )),
                new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new InkWell(
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "File Type *",
                            prefixIcon: new Icon(Icons.folder_open)
                        ),
                        controller: TextEditingController(text: file),
                        enabled: false,
                      ),
                      onTap: () {
                        _Fileypedialog(action,studymaterialdetails);
                      },
                    )),
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Description *",
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
                                Addstudymaterialdialog("refresh","new",studymaterialdetails);
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
                                  ))
                          )
                      ),flex: 1,),
                      new Expanded(child:new Container(
                          margin: new EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: new InkWell(
                              onTap: () {
                                if(clas == ""){
                                  Constants().ShowAlertDialog(context, "please select class");
                                  return;
                                }
                                if(title.text == ""){
                                  Constants().ShowAlertDialog(context, "please enter title");
                                  return;
                                }
                                if(_file == null){
                                  Constants().ShowAlertDialog(context, "please select File");
                                  return;
                                }
                                if(file == ""){
                                  Constants().ShowAlertDialog(context, "please enter file type");
                                  return;
                                }
                                if(!( file == "image" || file == "pdf" || file == "excel" || file == "doc" || file == "others")){
                                  Constants().ShowAlertDialog(context, "please enter file type as image, doc, pdf, excel and others");
                                  return;
                                }
                                Addstudymaterial(action,studymaterialdetails);
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
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Add Material",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
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
        title: Text("Study Material"),
        backgroundColor: Color(0xff182C61),

      ),
      //floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => Addstudymaterialdialog("refresh","new",null),backgroundColor: Theme.of(context).primaryColor,
      //),
      drawer: Constants().drawer(context),
      body: _loading ? new Constants().bodyProgress : new Stack(
        children: <Widget>[
          new Container(
            height: 35,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
                child: Column(
                  children: <Widget>[
                    new SizedBox(width: 10,height: 10,),
//                    new Container(
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.orange
//                      ),
//                      child: new SvgPicture.asset("assets/book.svg",color: Colors.white,width: 25,height: 25,),
//                      padding: new EdgeInsets.all(7),
//                    ),
//                    new Text("Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 25),
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
              margin: new EdgeInsets.only(left: 10,right: 5,bottom: 10,top: 90),
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
                    child:  new Padding(padding: EdgeInsets.all(10.0),
                        child: new ListView(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                              child: new Text("Study Material",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                            ),
                            new Divider(height: 10,color: Theme.of(context).primaryColor,),
                            _Studymaterialdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                                : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 10,
                                columns: [
                                  DataColumn(
                                    label: Text("Id No",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Date",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Name",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Description",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Class",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                                  ),
                                  DataColumn(
                                    label: Text("Subject",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
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
                                          Text(user.id),
                                        ),
                                        DataCell(
                                          Text(user.date),
                                        ),
                                        DataCell(
                                          Text(user.name),
                                        ),
                                        DataCell(
                                          Text(user.description,overflow: TextOverflow.ellipsis,),
                                        ),
                                        DataCell(
                                          Text(user.classname),
                                        ),
                                        DataCell(
                                          Text(user.subname),
                                        ),
                                        DataCell(
                                          new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                        ),
                                      ]),
                                ).toList()
                                    : _Studymaterialdetails.map(
                                      (user) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(user.id),
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
                                          new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                        ),
                                      ]),
                                ).toList(),
                              ),
                            ),
                          ],
                        )),
                  ),
                  new Align(
                      alignment: Alignment.topRight,
                      child: new InkWell(child:new Container(
                        width: 45,
                        height: 45,
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
                        Addstudymaterialdialog("refresh","new",null);
                      },
                      )
                  )
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

    var url = await Constants().Clienturl() + "api_students/force_download/document/" + filename;
    print("downloadurl--" + url);
 //   filename.replaceAll("", "%20");
    Constants().onDownLoading(context);
    var appDocDir = await getExternalStorageDirectory();
    var path = appDocDir.path;
    new Directory( "$path/Edecofy").create(recursive: true);
    String filePath = "$path/Edecofy/${filename}";
    filename.replaceAll(" ", "%20");
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

  Future<Null> Download1(String filename) async {
    if(filename != null) {
      var url = await Constants().Clienturl() +
          "api_teachers/force_download/document/" + filename;
      print("downloadurl--" + url);
      Constants().onDownLoading(context);
      var appDocDir = await getExternalStorageDirectory();
      var path = appDocDir.path;
      new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
      String filePath = "$path/Edecofy/${filename}";
      File file = new File(filePath);
      file.delete();
      if (!await file.exists()) {

        var httpClient = new HttpClient();
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          file.create();
          await file.writeAsBytes(bytes);
        } else {
          Navigator.of(context).pop();
          Constants().ShowAlertDialog(
              context, "Failed to download. Please try after sometime");
          return;
        }
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
  String  description, id, name,classname,subname,date,filename,fileurl,file1;
  Studymaterialdetails({ this.description, this.id, this.name,this.classname,this.date,this.subname,this.filename,this.fileurl,this.file1});
  factory Studymaterialdetails.fromJson(Map<String, dynamic> json) {
    return new Studymaterialdetails(
        id: json['document_id'].toString() ,
        name:  json['title'].toString() ,
        description: json['description'].toString(),
        classname: json['class_name'].toString(),
        subname: json['subject_name'].toString(),
        filename: json['file'].toString(),
        file1:json['file_name'].toString(),
        date:json['date'].toString()
    );
  }
}
