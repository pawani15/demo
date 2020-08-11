import 'dart:async';
import 'dart:convert';

import 'package:Edecofy/const.dart';
import 'package:countdown/countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import 'online_exam_student.dart';

class QuestionScreen extends StatefulWidget {
  int currentSelection = 1;
  String examcode, examid, examdate;

  QuestionScreen({this.examcode, this.examid, this.examdate});

  createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {

  CountDown cd ;
  String time = "",Subjec="",marks="",examdate="",instructions="";
  bool _loading = false;
  List questions_list = new List();
  var sub;
  int i =0;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _loading = true;
    });
    Loadonlineexamquestions();
  }

  @override
  void dispose() {
    if(questions_list.length>0)
      sub.cancel();
    super.dispose();
  }

  Future<Null> Loadonlineexamquestions() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Student_Onlineexamwuestions_list;
    Map<String, String> body = new Map();
    body['login_user_id'] = id;
    body['online_exam_code'] = widget.examcode;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body:body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            questions_list = responseJson['result']['questions'];
            Subjec = responseJson['result']['subject_name'].toString();
            marks = responseJson['result']['total_marks'].toString();
            examdate = responseJson['result']['exam_date'].toString();
            instructions = responseJson['result']['instruction'].toString();

            DateTime today = new DateTime.now();
            DateTime end = DateTime.parse(widget.examdate + " " +
                responseJson['result']['time_end'].toString() + ":00");
            int duration = end
                .difference(today)
                .inMinutes;
            print("dur--"+duration.toString());
            cd = CountDown(Duration(minutes: duration));
            sub = cd.stream.listen(null);
            sub.onData((Duration d) {
              setState(() {
                time = _printDuration(d);
              });
            });

            // when it finish the onDone cb is called
            sub.onDone(() {
              print("done");
              Submitexam();
            });
            for(int i=0;i<questions_list.length;i++){
              questions_list[i]['answer'] = "";
            }
          }catch(e){
            questions_list = new List();
          }
        }
        else{
          questions_list = new List();
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

  Future<Null> LoadSubmit() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Submit Permission', style: TextStyle(color: Color(0xff182C61)),),
          content: Text('Are you sure want to Submit the exam???',
            style: TextStyle(fontSize: 10,
                color: Color(0xff182C61),
                fontWeight: FontWeight.bold),),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes', style: TextStyle(fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),),
              onPressed: () {
                Submitexam();
              },
            ),
            FlatButton(
              child: Text('No', style: TextStyle(fontSize: 10,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> Submitexam() async {
    Constants().onLoading(context);
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Student_Submitexam;
    Map<String, String> body = new Map();
    body['login_user_id'] = id;
    body['online_exam_id'] = widget.examid;

    Map ansdata = new Map();
    try {
      for(int i=0;i<questions_list.length;i++){
        List list = new List();
        list.add(questions_list[i]['answer']);
        ansdata[questions_list[i]['question_bank_id']] = list ;
      }
    }catch(e){
    }
    body['submit_ans_data'] = json.encode(ansdata);

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body:body)
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          Constants().ShowSuccessDialog(context, responseJson['msg_status'].toString());
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                new OnlineExamsPage()));

          }
          new Timer(duration, handleTimeout);
        }
        else
          Constants().ShowAlertDialog(context, "We have encountered an error, we are working on it.");
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _showDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 30, bottom: 50),
          title: Center(child: Text('Information', style: TextStyle(
              fontSize: 12,
              color: Color(0xff182C61),
              fontWeight: FontWeight.bold),)),
          content: Container(
            height: 200,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      constraints:
                      BoxConstraints.tight(Size.fromRadius(10)),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('exam has to be submitted:',
                          style: TextStyle(fontSize: 12, color: Color(
                              0xff182C61), fontWeight: FontWeight.bold),),
                        Text(
                          examdate, style: TextStyle(fontSize: 12, color: Color(
                            0xFF646464)),)
                      ],
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      constraints:
                      BoxConstraints.tight(Size.fromRadius(10)),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                          'i',
                          style: TextStyle(color: Colors.white,)

                      ),
                    ),
                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Instructions:- ', style: TextStyle(fontSize: 12,
                              color: Color(0xff182C61),
                              fontWeight: FontWeight.bold),),
                          Text(instructions, style: TextStyle(
                              fontSize: 12, color: Color(0xFF646464))
                            ,
                            maxLines: 5,),
                        ],
                      ),
                    )

                  ],
                )

              ],
            ),
          ),
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
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Online Exam Test'),
          backgroundColor: Color(0xff182C61),
        ),
        drawer: Constants().drawer(context),
        body: _loading ? new Constants().bodyProgress :
        questions_list.length == 0 ? new Container(
          alignment: Alignment.center,
          child: new Text("No questions found.",style: TextStyle(color: Colors.red,fontSize: 20),),
        ): Container(
            child: Column(
              children: <Widget>[
                new Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                      shape: BoxShape.rectangle
                  ),

                  child: new Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                new SizedBox(width: 10,height: 10,),
                                new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange
                                  ),
                                  child: new SvgPicture.asset("assets/book.svg",color: Colors.white,width: 20,height: 20,),
                                  padding: new EdgeInsets.all(7),
                                ),
                                new SizedBox(width:2 ,height: 2,),
                                new Text("Subject: " + Subjec, style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),),
                              ],
                            ),

                            Row(

                              children: <Widget>[
                                new SizedBox(width: 10,height: 10,),
                                new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange
                                  ),
                                  child: new SvgPicture.asset("assets/attendance.svg",color: Colors.white,width: 20,height: 20,),
                                  padding: new EdgeInsets.all(7),
                                ),
                                new SizedBox(width:2 ,height: 2,),
                                new Text("Total: "+marks+" Marks",style: TextStyle(color: Colors.white,fontSize: 10.0,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                        ),
                      )

                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(5),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.yellow, Colors.orange])),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.access_alarms),
                          Padding(child:Text(
                            time,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),padding: EdgeInsets.only(left: 5),),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(8),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(questions_list.length, (index) {
                        return InkWell(child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: index == i
                                  ? Color(0xff19B85C)
                                  : Colors.grey[400],
                              shape: BoxShape.circle),
                          constraints: index == i
                              ? BoxConstraints.tight(Size.fromRadius(25))
                              : BoxConstraints.tight(Size.fromRadius(20)),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              (index + 1).toString(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                          onTap: (){
                            index1= null;
                            index2= null;
                            controller.text =
                                questions_list[index]['answer'].toString();
                            setState(() {
                              i = index;
                            });
                          },
                        );
                      }),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 5),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),

                    child: Container(
                      padding: EdgeInsets.only(left:5,right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
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
                                                    right: 12),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Color(0xff182C61),
                                                    shape: BoxShape.circle),
                                                child: Text(
                                                  (i + 1).toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),

                                              ), flex: 0,),
                                              Expanded(child: Text(
                                                  questions_list[i]['question_title']
                                                      .toString(),
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(fontSize: 12,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color: Color(
                                                          0xff182C61))),
                                                flex: 4,),
                                              //marks
                                              Expanded(child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 4, right: 3),
                                                padding: EdgeInsets.only(
                                                    left: 4, right: 2),
                                                decoration: BoxDecoration(
                                                    color: Color(0xff182C61),
                                                    shape: BoxShape.rectangle),
                                                child: Text("Marks:-" +
                                                    questions_list[i]['mark']
                                                        .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ), flex: 0,),
                                              //end
                                            ]),
                                      ),
                                      questions_list[i]['type'].toString() ==
                                          "fill_in_the_blanks" ? getInputOption(
                                          context, i) :
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children:
                                        questions_list[i]['type'].toString() ==
                                            "true_false" ? gettrueorfalse(
                                            context, i) : getCheckboxOptions(
                                            context, i),
                                      ),
                                    ],)
                              )
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[

                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    if(i==0)
                                      return;
                                    index1= null;
                                    index2= null;
                                    setState(() {
                                      i--;
                                    });
                                    controller.text =
                                        questions_list[i]['answer'].toString();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    if(i == questions_list.length-1)
                                      return;
                                    index1= null;
                                    index2= null;
                                    setState(() {
                                      i++;
                                    });
                                    controller.text =
                                        questions_list[i]['answer'].toString();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            thickness: 2,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    // alignment: Alignment.p;,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // i == questions_list.length-1 ?
                                        new Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          child: new RaisedButton(
                                            onPressed: () {
                                              LoadSubmit();
                                              //  Submitexam();
                                            },
                                            textColor: Colors.white,
                                            color: Colors.green,
                                            child: Text("Submit"),
                                          ),
                                        )
                                        //: new Container() ,
//                                        IconButton(
//                                          icon: Icon(
//                                            Icons.arrow_back_ios,
//                                            size: 16,
//                                          ),
//                                          onPressed: () {
//                                            if(i==0)
//                                              return;
//                                            index1= null;
//                                            index2= null;
//                                            setState(() {
//                                              i--;
//                                            });
//                                            controller.text =
//                                                questions_list[i]['answer'].toString();
//                                          },
//                                        ),
//                                        IconButton(
//                                          icon: Icon(
//                                            Icons.arrow_forward_ios,
//                                            size: 16,
//                                          ),
//                                          onPressed: () {
//                                            if(i == questions_list.length-1)
//                                              return;
//                                            index1= null;
//                                            index2= null;
//                                            setState(() {
//                                              i++;
//                                            });
//                                            controller.text =
//                                                questions_list[i]['answer'].toString();
//                                          },
//                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          constraints:
                                          BoxConstraints.tight(
                                              Size.fromRadius(10)),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: GestureDetector(
                                            child: Text(
                                              'i',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),

                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                Text('Informtion:',
                                                  style: TextStyle(fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight
                                                          .bold),),

                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      _showDialog();
                                    },
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  TextEditingController controller = new TextEditingController();

  Widget getInputOption(BuildContext ctx, int j) {
    /* return List.generate(
          1,
              (index) {*/
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        color: Colors.grey[200],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: new TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type your Answer'),
            onChanged: (String val){
              questions_list[j]['answer']= val;
            },
            maxLines: 5,
            controller: controller,
          ),
        ),
      ),
    );
  }

  int index1= null;
  int index2= null;

  List<Widget> getCheckboxOptions(BuildContext ctx,int j) {
    int len = int.tryParse(questions_list[j]['number_of_options']);
    print("opt--"+questions_list[j]['options'].toString());
    List questionlist = json.decode(questions_list[j]['options']);

    for(String option in questionlist){
      if(option == questions_list[j]['answer'])
        index1 = questionlist.indexOf(option);
    }
    //index1 = questions_list[j]['answer'] == null ? null : int.tryParse(questions_list[j]['answer']);

    return List.generate(
      len,
          (index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: index1 == null ? false : index1==index,
                    onChanged: (val) {
                      setState(() {
                        index1 = index;
                      });
                      questions_list[j]['answer']= questionlist[index1];
                      //questions_list[j]['answer']= index1.toString();
                    },
                  ),
                  Expanded(
                    child: Text(
                      questionlist[index],
                      style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> gettrueorfalse(BuildContext ctx,int j) {
    List questionlist = new List();
    questionlist.add("true");
    questionlist.add("false");

    for(String option in questionlist){
      if(option == questions_list[j]['answer'])
        index2 = questionlist.indexOf(option);
    }

    return List.generate(
      2,
          (index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: index2 == null ? false : index2==index,
                    onChanged: (val) {
                      setState(() {
                        index2 = index;
                      });
                      questions_list[j]['answer']= questionlist[index2];
                    },
                  ),
                  Expanded(
                    child: Text(
                      questionlist[index],
                      style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
