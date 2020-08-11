import 'dart:io';
import 'dart:math';

import 'package:Edecofy/Admin/AdminMnageonlineexams.dart';
import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';
import 'AdminMnageonlineexams.dart';
import 'AdminMnageonlineexams.dart';

class ManagequestionsPage extends StatefulWidget {
  final Onlineexams details;
  ManagequestionsPage({this.details});

  @override
  State<StatefulWidget> createState() => new _ManagequestionsPageState();
}

class _ManagequestionsPageState extends State<ManagequestionsPage> {
  bool _loading = false,show=false;
  TextEditingController controller = new TextEditingController();
  List qustionslist = new List();
  String marks= "0";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadquestions();
  }

  Future<Null> Loadquestions() async {
    String empid = await sp.ReadString("Userid");
    var url = '';
    url = await Constants().Clienturl() + Constants.LoadQuestions_Admin;
    Map<String, String> body = new Map();
    body['online_exam_id'] = widget.details.id;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            qustionslist = responseJson['result'];
            int mark = 0;
            for(Map question in qustionslist){
              mark = mark + int.tryParse(question['mark']);
            }
            marks = mark.toString();
          }catch(e){
            qustionslist = new List();
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


  Widget _EdittPopup(user) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 2,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: new Icon(FontAwesomeIcons.edit,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Edit",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
      PopupMenuItem(
          value: 3,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: new Icon(FontAwesomeIcons.trashAlt,size: 15,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(5),
              ),
              new Text("Delete",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12),),
            ],
          )
      ),
    ],
    elevation: 5,
    padding: EdgeInsets.symmetric(horizontal: 10),
    onSelected: (value) {
      print(value);
      if(value == 2)
        ADDorEdit("edit",user);
      if(value == 3)
        deletedialog(user);
    },
  );

  deletedialog(Map details) async {
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
                                      Delete(details);
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

  Delete(Map details) async{
    Constants().onLoading(context);
    Map body = new Map();
    body['question_bank_id'] = details['question_bank_id'];
    body['type_page'] = "delete";

    var  url = await Constants().Clienturl() + Constants.CRUDQuestions_Admin;

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
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManagequestionsPage(details: widget.details,)),
            );          }
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

  ADDorEdit(String type,Map details) async {
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
                new SizedBox(height: 10,width: 10,),
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
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text((type == "new" ? "Add" : "Edit") + "Question",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new AddQuestionsPage(type : type,details: details,onlineexams: widget.details,),
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
        title: Text("Manage Questions"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () => Navigator.of(context).pop(),),
      ),

      body: new Stack(
        children: <Widget>[
          new Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
          ),
          _loading ? new Constants().bodyProgress :  new Container(
            margin:  new EdgeInsets.only(left: 15,right: 5,bottom: 10,top: 40),
            child : new ListView(
              children: <Widget>[
            new Stack(
              children: <Widget>[
                new Card(
                  elevation: 5.0,
                  margin: new EdgeInsets.only(top: 25,right: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: new ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 5,right: 5,top: 15,bottom: 5),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(child: new Padding(child: new Text("Question List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                          ],
                        )
                      ),
                      new Container(height: 2,width: double.infinity,color: Theme.of(context).primaryColor,),
                      qustionslist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                          : new Container(
                        padding: new EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: Text("#"),
                              ),
                              DataColumn(
                                label: Text("Type"),
                              ),
                              DataColumn(
                                label: Text("Question"),
                              ),
                              DataColumn(
                                label: Text("Marks"),
                              ),
                              DataColumn(
                                label: Text("Actions"),
                              ),
                            ],
                            rows:qustionslist.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text((qustionslist.indexOf(user)+1).toString()),
                                    ),
                                    DataCell(
                                      Text(user['question_type']),
                                    ),
                                    DataCell(
                                      Container(width: 300,
                                      child: Text(user['question_title'],maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                    ),
                                    DataCell(
                                      Text(user['mark']),
                                    ),
                                    DataCell(
                                      new Padding(padding: EdgeInsets.all(2),child:_EdittPopup(user)),
                                    ),
                                  ]),
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      ADDorEdit("new",null);
                    },
                    )
                )
              ],
            ),
                new Card(
                  elevation: 5.0,
                  margin: new EdgeInsets.only(top: 10,right: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 5,right: 5,top: 15,bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(child: new Padding(child: new Text("Exam Details",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                            ],
                          )
                      ),
                      new Container(height: 2,width: double.infinity,color: Theme.of(context).primaryColor,),
                      new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.grey[200]),
                            color: Colors.white,
                          ),
                          child:new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              "Exam Title",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              widget.details.examanme,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              "Date",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              widget.details.examdate,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,)
                        ],
                      )),
                      new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.grey[200]),
                            color: Colors.white,
                          ),
                          child:
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              "Class",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              widget.details.classname,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              "Time",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              widget.details.examtime+ " - " + widget.details.examto,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,)
                        ],
                      )),
                      new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.grey[200]),
                            color: Colors.white,
                          ),
                          child:
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              "Section",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              widget.details.section,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              "Passing %",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              widget.details.minperc,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,)
                        ],
                      )),
                      new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.grey[200]),
                            color: Colors.white,
                          ),
                          child:
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              "Subject",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              widget.details.subject,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              "Total Marks",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,),
                          new Expanded(child: new Container(
                            decoration: new BoxDecoration(
                                border: new Border(right: BorderSide(
                                    color: Colors.grey[200],
                                    style: BorderStyle.solid))
                            ),
                            child: new Text(
                              marks,
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,),
                            padding: new EdgeInsets.all(5.0),
                          ), flex: 1,)
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            )
    )

    ]
    ));
  }

}

class AddQuestionsPage extends StatefulWidget {
  final Map details;
  final String type;
  final Onlineexams onlineexams;

  AddQuestionsPage({this.type,this.details,this.onlineexams});

  @override
  State<StatefulWidget> createState() => new _AddlasssPagePageState();
}

class _AddlasssPagePageState extends State<AddQuestionsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController suitablewords = new TextEditingController(),marks = new TextEditingController(),questiontitle = new TextEditingController(),optioncont = new TextEditingController();
  String name = "",questiontype="",trueorfalse="true";IconData icon = null;
  int options=0,selectedoption = null;
  List<TextEditingController> optionscontroller = new List();

  @override
  void initState() {
    super.initState();
    questiontypelist.add("Multiple Choice");
    questiontypelist.add("True Or False");
    questiontypelist.add("Fill In The Blanks");

    if(widget.type == "new"){
      name = "Add Question";
      icon = Icons.add;
    }
    else{
      name = "Edit Question";
      icon = Icons.edit;
      if(widget.details['type'] == "fill_in_the_blanks"){
        suitablewords.text = widget.details['correct_answers'];
      }
      if(widget.details['type'] == "multiple_choice"){
        optionscontroller.clear();
        options = int.tryParse(widget.details['number_of_options']);
        optioncont.text = widget.details['number_of_options'];
        List optionslist = json.decode(widget.details['options']);
        List selectedoptionslist = json.decode(widget.details['correct_answers']);
        selectedoption = int.tryParse(selectedoptionslist[0])-1;
        for(int i=0;i<options;i++){
          optionscontroller.add(new TextEditingController(text: optionslist[i].toString()));
        }
      }
      if(widget.details['type'] == "true_false"){
        trueorfalse = widget.details['correct_answers'];
      }
      marks.text = widget.details['mark'].toString();
      if(widget.details['type'] == "true_false")
        questiontype = "True Or False";
      else if(widget.details['type'] == "multiple_choice")
        questiontype = "Multiple Choice";
      else if(widget.details['type'] == "fill_in_the_blanks")
        questiontype = "Fill In The Blanks";
      questiontitle.text = widget.details['question_title'].toString();
    }
  }

  Future<Null> CreateQuestion(String type) async {
    Constants().onLoading(context);
    var url="";
      url = await Constants().Clienturl() + Constants.CRUDQuestions_Admin;

    Map body = new Map();
    if(widget.type == "new")
      body['type_page'] = "add";
    else {
      body['type_page'] = "edit";
      body['question_bank_id'] = widget.details['question_bank_id'];
    }

    body['online_exam_id'] = widget.onlineexams.id;
    body['mark'] = marks.text;
    body['question_title'] = questiontitle.text;
    body['type'] = type;
    if(type == "true_false"){
      body['true_false_answer'] = trueorfalse;
    }
    if(type == "fill_in_the_blanks"){
      body['suitable_words'] = suitablewords.text;
    }
    if(type == "multiple_choice"){
      body['number_of_options'] = options.toString();
      List<String> optionslist = new List();
      for(int i=0;i<optionscontroller.length;i++){
        optionslist.add(optionscontroller[i].text);
      }
      body['options'] = json.encode(optionslist);
      List<String> selectedoption1 = new List();
      selectedoption1.add((selectedoption+1).toString());
      body['correct_answers'] = json.encode(selectedoption1);
    }

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
          if(widget.type == "edit")
            Constants().ShowSuccessDialog(context, "Question updated succesfully");
          else
            Constants().ShowSuccessDialog(context, "Question added succesfully");

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManagequestionsPage(details: widget.onlineexams,)),
            );
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

  List<String> questiontypelist = new List();
  _navigatetoquestiontypes(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Question type", questiontypelist);
    setState(() {
      questiontype = result ?? questiontype;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    print("res--"+result.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: <Widget>[
        new SizedBox(height: 20,width: 20,),
        new Padding(
            padding: EdgeInsets.all(5.0),
            child: new InkWell(
              child: new TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Question Type *",
                    prefixIcon: new Icon(Icons.list),
                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                ),
                controller: TextEditingController(text: questiontype),
                enabled: false,
              ),
              onTap: () {
                _navigatetoquestiontypes(context);
              },
            )),
        new Container(
          padding: EdgeInsets.all(5.0),
          child: new TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Mark *",
              prefixIcon: new Icon(Icons.list),
            ),
            controller: marks,
          ),
        ),
        new Container(
          padding: EdgeInsets.all(5.0),
          child: new TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Question Title *",
              prefixIcon: new Icon(Icons.comment),
            ),
            controller: questiontitle,
            maxLines: 3,
          ),
        ),
        questiontype == "Multiple Choice" ? new Container(
          padding: EdgeInsets.all(5.0),
          child: new TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "No of options *",
              prefixIcon: new Icon(Icons.list),
            ),
            controller: optioncont,
            onChanged: (val){
              if(val.length >0) {
                int len = int.tryParse(val);
                optionscontroller.clear();
                for(int i=0;i<len;i++){
                  optionscontroller.add(new TextEditingController());
                }
                setState(() {
                  options = int.tryParse(val);
                });
              }
              else {
                  setState(() {
                    options = 0;
                  });
                }
            },
          ),
        ) : new Container(),
        questiontype == "Multiple Choice"?
            new Column(
                children : List.generate(
                  options,
                      (index) {
                        return new Row(
                          children: <Widget>[
                            Expanded(
                              child:  new Container(
                                padding: EdgeInsets.all(5.0),
                                child: new TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "Option "+(index+1).toString(),
                                    prefixIcon: new Icon(Icons.list),
                                  ),
                                  controller: optionscontroller[index],
                                ),
                              ),
                            ),
                            Checkbox(
                              value: selectedoption == null ? false : selectedoption==index,
                              onChanged: (val) {
                                setState(() {
                                  selectedoption = index;
                                });
                              },
                            ),
                          ],
                        );
                      },
                )
             ) : new Container(),
        questiontype == "Fill In The Blanks" ? new Container(
          padding: EdgeInsets.all(5.0),
          child: new TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Suitable Words *",
              prefixIcon: new Icon(Icons.list),
            ),
            controller: suitablewords,
          ),
        ) : new Container(),
        questiontype == "True Or False" ? new Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded( child : RadioListTile(
                title: const Text('true'),
                value: 'true',
                groupValue: trueorfalse,
                onChanged: (String value) { setState(() { trueorfalse = value; }); },
              ),flex: 1,),
              Expanded( child :RadioListTile(
                title: const Text('false'),
                value: 'false',
                groupValue: trueorfalse,
                onChanged: (String value) {
                  setState(() { trueorfalse = value;
                  });
                },
              ),flex: 1,),
            ],
          ),
        ) : new Container(),
        new SizedBox(height: 20,width: 20,),
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
                          if(questiontype == ""){
                            Constants().ShowAlertDialog(context, "Please select question type");
                            return;
                          }
                          if(marks.text == ""){
                            Constants().ShowAlertDialog(context, "Please enter mark");
                            return;
                          }
                          if(questiontitle.text == ""){
                            Constants().ShowAlertDialog(context, "Please enter question title");
                            return;
                          }
                          if(questiontype == "Fill In The Blanks" && suitablewords.text == ""){
                            Constants().ShowAlertDialog(context, "Please enter suitable words");
                            return;
                          }
                          if(questiontype == "True Or False" && trueorfalse == ""){
                            Constants().ShowAlertDialog(context, "Please select true or false");
                            return;
                          }
                          for(int i=0;i<optionscontroller.length;i++){
                            if(questiontype == "Multiple Choice" && optionscontroller[i].text == ""){
                              Constants().ShowAlertDialog(context, "Please enter option "+(i+1).toString());
                              return;
                            }
                          }
                          if(questiontype == "Multiple Choice" && selectedoption == null){
                            Constants().ShowAlertDialog(context, "Please select any one of the option");
                            return;
                          }
                          if(questiontype == "Fill In The Blanks")
                            CreateQuestion("fill_in_the_blanks");
                          else if(questiontype == "True Or False")
                            CreateQuestion("true_false");
                          else if(questiontype == "Multiple Choice")
                            CreateQuestion("multiple_choice");
                        },
                        child: new Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(15),bottomLeft: Radius.circular(15))),
                            child: new Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                new Icon(icon,color: Colors.white),
                                new Padding(
                                  padding:
                                  EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
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

}
