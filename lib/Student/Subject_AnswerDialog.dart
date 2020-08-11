import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';


//class StudentAnswerView extends StatefulWidget {
// // final String studentname,studentid;
//  //ParentOnlineView({this.studentname,this.studentid});
//  @override
//  State<StatefulWidget> createState() => new _StudentAnswerViewPageState();
//}
//
//class _StudentAnswerViewPageState extends State<StudentAnswerView> with SingleTickerProviderStateMixin {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return new Scaffold(
//      appBar: new AppBar(
//        title: Text("Online ExamMarks"),
//        backgroundColor: Color(0xff182C61),
//      ),
//      //floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => Addstudymaterialdialog("refresh","new",null),backgroundColor: Theme.of(context).primaryColor,
//      //),
//
//      drawer: Constants().drawer(context),
//      body: new Stack(
//          children: <Widget>[
//            new Container(
//              height: 60,
//              width: double.infinity,
//              decoration: BoxDecoration(
//                  color: Theme
//                      .of(context)
//                      .primaryColor,
//                  borderRadius: BorderRadius.only(
//                      bottomLeft: Radius.circular(35),
//                      bottomRight: Radius.circular(35)),
//                  shape: BoxShape.rectangle),
//              padding: new EdgeInsets.only(top: 10),
//              /*new Text(
//              "Manage Student Attendence",
//              textAlign: TextAlign.center,
//              style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 16.0,
//                  fontWeight: FontWeight.bold),
//            ),*/
////            Column(
////              crossAxisAlignment: CrossAxisAlignment.center,
////              children: <Widget>[
////                new Container(
////                  decoration: BoxDecoration(
////                      shape: BoxShape.circle,
////                      color: Colors.orange
////                  ),
////                  child: new SvgPicture.asset("assets/student.svg",width: 25,height: 25,color: Colors.white,),
////                  padding: new EdgeInsets.all(5),
////                  margin: EdgeInsets.all(5),
////                ),
////                new Text("Attendence Report of Student",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),),
////                new Container(padding: EdgeInsets.all(5),
////                  child:new Row(
////                  mainAxisAlignment: MainAxisAlignment.center,
////                    children: <Widget>[
////                      new Container(
////                        decoration: BoxDecoration(
////                            shape: BoxShape.circle,
////                            color: Colors.orange
////                        ),
////                        child: new Icon(Icons.history,size:15,color: Colors.white,),
////                        padding: new EdgeInsets.all(5),
////                        margin: EdgeInsets.only(right: 5),
////                      ),
////                      new Text("Session: ${new DateFormat('dd-MM-yyyy:hh:mm aaa').format(new DateTime.now())}",style: TextStyle(color: Colors.white,fontSize: 12.0,fontWeight: FontWeight.bold),),
////                    ],
////                ))
////              ],
////            )
//            ),
//
//
//          ]
//      ),
//    );
//  }
//
//}





//
class AnswerDialog {
  static Widget show(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 4, right: 4),
        child: AlertDialog(
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
                child: Text('With Answers',
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
                            width: 200,
                            height: 200,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'daily exam',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Class 1  Section:-A',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Subject',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'TotalMarks',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Time',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Instruction',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
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
                      children: List.generate(100, (i) =>
                      new Padding(
                        padding: EdgeInsets.only(top:10.0,bottom: 10.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.all(2.0),
                              child: new Text('${i+1}. What is your name?',
                                style: new TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                            ),

                            new Padding(
                              padding: EdgeInsets.all(2.0),
                              child: new Text('abc',
                                style: new TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(2.0),
                              child: new Text('teddy',
                                style: new TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(2.0),
                              child: new Text('XYZ',
                                style: new TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(2.0),
                              child: new Text('Pawani',
                                style: new TextStyle(
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(2.0),
                              child: new Text('[Submitted Answer - teddy]',
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic
                                ),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(2.0),
                              child: new Text('[Correct Answer - teddy]',
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      )
                  )
                ],
              )
          ),
        )
    );
  }

  static getOptionList(BuildContext context) {
    return List.generate(4, (index) {
      return Container(
        margin: EdgeInsets.all(4),
        child: Text(
          '${index + 1}',
          style: TextStyle(color: Colors.grey[700], fontSize: 18),
        ),
      );
    });
  }

  static getCheckboxOption(BuildContext context) {
    return List.generate(2, (index) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
        child: Container(
          child: Column(
            children: <Widget>[
              Text(
                'This is my Text',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Color(0xff182C61)),
              ),
              new Text('abc'),
              new Text('abc'),
              new Text('abc'),
              new Text('abc'),
            ],
          ),

        ),
      );
    });
  }

  static getVerticalCheckboxOption(BuildContext context) {
    return List.generate(2, (index) {
      return Card(
        child: Container(
          child: Row(
            children: <Widget>[
              Checkbox(
                value: true,
                onChanged: (val) {},
              ),
              Expanded(
                child: Text(
                  'This is my Text',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Color(0xff182C61)),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class DrawTriangleShape extends CustomPainter {
  Paint painter;
  var path = Path();

  DrawTriangleShape({Color fillcolor: Colors.blue}) {
    painter = Paint()
      ..color = fillcolor
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    path.reset();
    path.moveTo(0, 0);
    path.relativeLineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
