import 'dart:convert';
import 'package:Edecofy/Student/Subject_AnswerDialog.dart';
import 'package:Edecofy/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class StudentViewanswer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StudentViewanswerPageState();
}

class _StudentViewanswerPageState extends State<StudentViewanswer> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _loading = false;
  bool _secondAPI=true;
  TextEditingController controller = new TextEditingController();


  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadonlineviewanswer();
  }

  dynamic resultData = [];
  List questions_list = new List();

  Future<dynamic>getAnswersData(String id1)async{
    Constants().onLoading(context);
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.student_view_result+id;
    Map<String, String> body = new Map();
    body['login_user_id'] = id;
    body['online_exam_id'] = id1;
    print("url is $url"+"body--"+body.toString());
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body).then((response){
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            questions_list = responseJson['result']['exam_result'];
          } catch (e) {}
          setState(() {
            resultData = responseJson['result'];
          });
        }
        else
          resultData = [];
        setState(() {
          _loading = false;
        });
        if (resultData.length > 0)
          answerView();
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  Future<void> _showDialog(BuildContext context, String data) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions', style: TextStyle(
              color: Color(0xff182C61))),
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
  Future<void> answerView() async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                side: BorderSide(style: BorderStyle.none),
                borderRadius: BorderRadius.circular(8)
            ),
            titlePadding: EdgeInsets.all(5),
            title: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  child: Icon(
                    Icons.message,
                    color:Color(0xff182C61),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Text(resultData['page_title'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff182C61))),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Color(0xff182C61),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
            contentPadding: EdgeInsets.all(8),
            content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            color:Color(0xff182C61),
                            child: SizedBox(
                              width: 250,
                              height: 250,
                              child: Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                // alignment: Alignment.l,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        resultData['title'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Text(
                                            'Class:- ' +
                                                resultData['class_name'],
                                            style: TextStyle(
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Section:- ' +
                                                resultData['section_name'],
                                            style: TextStyle(
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Subject:- ' +
                                            resultData['subject_name'],
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'TotalMarks:-  ' +
                                            resultData['total_marks']
                                                .toString(),
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'Time:-  ' +
                                            resultData['duration_time'],
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          'Instruction:-  ' +
                                              resultData['instruction'],
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          _showDialog(
                                              context,
                                              resultData['instruction']);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: CustomPaint(
                              size: Size(30, 20),
                              painter: DrawTriangleShape(fillcolor:Color(0xff182C61)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    new ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: List.generate(resultData['exam_result'].length, (i) =>
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(child: Container(
                                    margin: EdgeInsets.only(
                                        right: 8),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Color(0xff182C61),
                                        shape: BoxShape.circle),
                                    child: Text(
                                      (i + 1).toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),

                                  ), flex: 0,),
                                  new Expanded(child: new Text(
                                    resultData['exam_result'][i]['question_title'] !=
                                        null
                                        ?
                                    resultData['exam_result'][i]['question_title']
                                        : '',
                                    style: new TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight
                                          .bold,
                                        color: Color(0xff182C61)
                                    ),
                                    textAlign: TextAlign.justify,

                                  ), flex: 4,),
                                  Expanded(child: Container(
                                    margin: EdgeInsets.only(
                                        left: 3, right: 2),
                                    padding: EdgeInsets.only(left: 2),
                                    decoration: BoxDecoration(
                                        color: Color(0xff182C61),
                                        shape: BoxShape.rectangle),
                                    child: Text("mark:" +
                                        resultData['exam_result'][i]['question_mark'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  ), flex: 0,),

                                ],
                              ),
                            ),
                            resultData['exam_result'][i]['question_type'] !=
                                null &&
                                resultData['exam_result'][i]['question_type'] ==
                                    'multiple_choice' ?
                            new ListView(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                padding: EdgeInsets.only(
                                    left: 50),
                                children: List.generate(
                                  questions_list[i]['options'].length,
                                      (index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: new Text(
                                        resultData['exam_result'][i]['options'][index],
                                        style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight
                                              .bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    );
                                  },
                                )
                            ) : new Container(),
                            resultData['page_title'] != null &&
                                resultData['page_title'] == 'With Answers' ?
                            Column(
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: new Text(
                                    resultData['exam_result'][i]['submitted_answer'],
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: new Text(
                                    resultData['exam_result'][i]['correct_answer'],
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                              ],
                            ) : Column(
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: new Text(
                                    resultData['exam_result'][i]['correct_answer'],
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        )
                    )
                  ],
                )
            ),
          );
        }
    );
  }

  Future<Null> Loadonlineviewanswer() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.student_view_online_exam;
    Map<String, String> body = new Map();
    body['student_id'] = id;
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
            int i =1;
            for (Map user in responseJson['result']) {
              _Onlineexamdetails.add(Onlineexamdetails.fromJson(user, i));
              i++;
            }
          }catch(e){
            _Onlineexamdetails = new List();
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


  String statusOfExam(String time, String dateOfExam) {
    String endtime = time.trim().split("-")[1];
    if (endtime.length < 5)
      endtime = "0" + endtime;
    DateTime today = new DateTime.now();
    DateTime end = DateTime.parse(dateOfExam.trim() + " " + endtime + ":00");
    if (today.isAfter(end)) {
      return 'view';
    } else
      return 'wait';
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Online Exam"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),
      drawer: Constants().drawer(context),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 50,
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
//                    new Container(
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.orange
//                      ),
//                      child: new SvgPicture.asset("assets/clipboard.svg",color: Colors.white,width: 25,height: 25,),
//                      padding: new EdgeInsets.all(5),
//                      margin: EdgeInsets.all(5),
//                    ),
//                    new Text("Online Exam",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Card(
            margin: new EdgeInsets.only(
                left: 20, right: 20, bottom: 10, top: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search..', border: InputBorder.none),
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
            margin: new EdgeInsets.only(
                left: 10, right: 10, bottom: 10, top: 120),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress :
            new Padding(padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
                    _Onlineexamdetails.length == 0 ? new Container(
                        child: new Center(child: new Text("No Records found",
                            style: new TextStyle(fontSize: 16.0, color: Colors
                                .red))))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: Text("#", style: TextStyle(
                                color: Color(0xff182C61),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("ExamName", style: TextStyle(
                                color: Color(0xff182C61),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Subject", style: TextStyle(
                                color: Color(0xff182C61),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Exam Date/Time", style: TextStyle(
                                color: Color(0xff182C61),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Total Marks", style: TextStyle(
                                color: Color(0xff182C61),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Obtained Marks", style: TextStyle(
                                color: Color(0xff182C61),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Result", style: TextStyle(
                                color: Color(0xff182C61),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("AnswerView", style: TextStyle(
                                color: Color(0xff182C61),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),),
                          ),
                        ],
                        rows: _searchResult.length != 0 ||
                            controller.text.isNotEmpty ?
                        _searchResult.map(
                              (user) =>
                              DataRow(
                                  cells: [
                                    DataCell(
                                      Text(user.sno, style: TextStyle(
                                          color: Color(0xFF646464))),
                                    ),
                                    DataCell(
                                      Text(user.examname, style: TextStyle(
                                          color: Color(0xFF646464))),
                                    ),
                                    DataCell(
                                      Text(user.subname),
                                    ),
                                    DataCell(
                                        new Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            new Padding(
                                                padding: EdgeInsets.all(2),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: "Date: ",
                                                          style: TextStyle(
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColor,
                                                              fontWeight: FontWeight
                                                                  .bold)),
                                                      TextSpan(
                                                          text: user.examdate,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey)),
                                                    ],
                                                  ),
                                                )),
                                            new Padding(
                                                padding: EdgeInsets.only(
                                                    right: 2,
                                                    top: 2,
                                                    bottom: 2),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: "Time: ",
                                                          style: TextStyle(
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColor,
                                                              fontWeight: FontWeight
                                                                  .bold)),
                                                      TextSpan(text: user.time,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey)),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        )
                                    ),
                                    DataCell(
                                      Text(user.totalmarks),
                                    ),
                                    DataCell(
                                      Text(user.obtmarks),
                                    ),
                                    DataCell(
                                      Text(user.result),
                                    ),
                                    DataCell(
                                      new InkWell(
                                        child: new Container(
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: statusOfExam(
                                                  user.time, user.examdate1) ==
                                                  'view' ? Colors.green : Colors
                                                  .grey[600],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))
                                          ),
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              new Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 4,
                                                    top: 5,
                                                    bottom: 5),
                                                child: new Text(statusOfExam(
                                                    user.time,
                                                    user.examdate1) == 'view'
                                                    ? "ViewAnswer"
                                                    : "Please Wait"
                                                  , style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight
                                                          .bold),),),
                                              new Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10,
                                                    left: 4,
                                                    top: 5,
                                                    bottom: 5),
                                                child: new Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                  ),
                                                  padding: EdgeInsets.all(3),
                                                  child: new Icon(statusOfExam(
                                                      user.time,
                                                      user.examdate1) == 'view'
                                                      ? Icons.edit
                                                      : Icons.access_time,
                                                    color: statusOfExam(
                                                        user.time,
                                                        user.examdate1) ==
                                                        'view'
                                                        ? Colors.green
                                                        : Colors.grey[600],
                                                    size: 15,),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (statusOfExam(
                                              user.time, user.examdate1) ==
                                              'view')
                                            getAnswersData(user.onlineexamid);
                                        },
                                      ),
                                    )
                                  ]),
                        ).toList()
                            : _Onlineexamdetails.map(
                              (user) =>
                              DataRow(
                                  cells: [
                                    DataCell(
                                      Text(user.sno),
                                    ),
                                    DataCell(
                                      Text(user.examname),
                                    ),
                                    DataCell(
                                      Text(user.subname),
                                    ),
                                    DataCell(
                                        new Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            new Padding(
                                                padding: EdgeInsets.all(2),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: "Date: ",
                                                          style: TextStyle(
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColor,
                                                              fontWeight: FontWeight
                                                                  .bold)),
                                                      TextSpan(
                                                          text: user.examdate,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey)),
                                                    ],
                                                  ),
                                                )),
                                            new Padding(
                                                padding: EdgeInsets.only(
                                                    right: 2,
                                                    top: 2,
                                                    bottom: 2),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: "Time: ",
                                                          style: TextStyle(
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColor,
                                                              fontWeight: FontWeight
                                                                  .bold)),
                                                      TextSpan(text: user.time,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey)),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        )
                                    ),
                                    DataCell(
                                      Text(user.totalmarks),
                                    ),
                                    DataCell(
                                      Text(user.obtmarks),
                                    ),
                                    DataCell(
                                      Text(user.result),
                                    ),
                                    DataCell(
                                      new InkWell(
                                        child: new Container(
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: statusOfExam(
                                                  user.time, user.examdate1) ==
                                                  'view' ? Colors.green : Colors
                                                  .grey[600],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))
                                          ),
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              new Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 4,
                                                    top: 5,
                                                    bottom: 5),
                                                child: new Text(statusOfExam(
                                                    user.time,
                                                    user.examdate1) == 'view'
                                                    ? "ViewAnswer"
                                                    : "Please Wait"
                                                  , style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight
                                                          .bold),),),
                                              new Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10,
                                                    left: 4,
                                                    top: 5,
                                                    bottom: 5),
                                                child: new Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                  ),
                                                  padding: EdgeInsets.all(3),
                                                  child: new Icon(statusOfExam(
                                                      user.time,
                                                      user.examdate1) == 'view'
                                                      ? Icons.edit
                                                      : Icons.access_time,
                                                    color: statusOfExam(
                                                        user.time,
                                                        user.examdate1) ==
                                                        'view'
                                                        ? Colors.green
                                                        : Colors.grey[600],
                                                    size: 15,),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (statusOfExam(
                                              user.time, user.examdate1) ==
                                              'view')
                                            getAnswersData(user.onlineexamid);
                                        },
                                      ),
                                    )
                                  ]),
                        ).toList(),
                      ),
                    ),
                  ],
                )
            ),
          )
        ],
      ),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: (){
//          statusOfExam("16:55", "1584297000");
//        },
//        child: new Icon(Icons.refresh),
//      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Onlineexamdetails.forEach((vehicleDetail) {
      if (vehicleDetail.examname.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.subname.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.time.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.examdate.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Onlineexamdetails> _searchResult = [];
  List<Onlineexamdetails> _Onlineexamdetails = [];

}

class Onlineexamdetails {
  String examname, id, subname, examdate, time, timeStart, timeEnd, totalmarks,
      obtmarks, result, onlineexamid, examdate1, sno;

  Onlineexamdetails(
      {this.id, this.examname, this.sno, this.subname, this.examdate, this.timeStart, this.timeEnd, this.time, this.totalmarks, this.obtmarks, this.result, this.onlineexamid, this.examdate1});

  factory Onlineexamdetails.fromJson(Map<String, dynamic> json, int no) {
    return new Onlineexamdetails(
        onlineexamid: json['online_exam_id'].toString(),
        examname: json['title'].toString(),
        subname:  json['subject_name'].toString() ,
        examdate: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['exam_date']) * 1000)).toString(),
        examdate1: new DateFormat('yyyy-MM-dd').format(
            new DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(json['exam_date']) * 1000)).toString(),
        time:  "  "+json['time_start'].toString()+"-"+json['time_end'].toString() ,
        timeStart:json['time_start'].toString(),
        timeEnd:json['time_end'].toString() ,
        totalmarks: json['ttl_marks'].toString(),
        obtmarks: json['obtained_marks'].toString(),
        result:json['exam_result_status'].toString(),
        sno: no.toString()
    );
  }
}
