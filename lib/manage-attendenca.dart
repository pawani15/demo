import 'dart:convert';
import 'package:Edecofy/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class parentStudentAttendance extends StatefulWidget {
  final String studentname,id;
  parentStudentAttendance({this.studentname, this.id});
  int  currentIndex = 0;

  num present,
      absent,
      sickleave,
      casualleave,
      otherleave,
      totalAbsent,
      totalPresent,
      halfLeave,
      totalUndefined,
      undefined,
      event;

  bool notification = false,
      locationtracking = false;
  String fromdate,
      todate,
      currentpassword = '',
      newpassword = '',
      confirmnewpassword = '',
      Classname = '';
  bool _loading = true;
  TextEditingController parentcont = new TextEditingController();
  TextEditingController emailcont = new TextEditingController();
  List<String> monthlist = new List(),
      yearlist = new List();
  Map runningyearmap = null;
  List Attendencelist = new List();
  Map monthmap = new Map();
  bool showreport = true;
  DateTime selectedDate = DateTime.now();
  DateTime frmdt;
  DateTime todt;
  List month2 = new List();
  List varList = new List();

  Map<int,String> selectedMonth= {};

  List<int> sortedMonthDate = [];

  @override
  State<StatefulWidget> createState() => new _ParentstudentAttendancePageState();
}

class _ParentstudentAttendancePageState extends State<parentStudentAttendance> {

  //num halfLeave;

  @override
  void initState() {
    super.initState();

    widget.present = 0;
    widget.absent = 0;
    widget.sickleave= 0 ;
    widget.casualleave = 0 ;
    widget.otherleave= 0 ;
    widget.totalAbsent =0 ;
    widget.totalPresent = 0;
    widget.halfLeave =0 ;
    widget.undefined = 0;
    widget.totalUndefined = 0;
    widget.event  = 0;
    widget._loading = true;
    var monthlist = widget.monthlist;
    monthlist.add("January");
    monthlist.add("February");
    monthlist.add("March");
    monthlist.add("April");
    monthlist.add("May");
    monthlist.add("June");
    monthlist.add("July");
    monthlist.add("August");
    monthlist.add("September");
    monthlist.add("October");
    monthlist.add("November");
    monthlist.add("December");
    var monthmap = widget.monthmap;
    monthmap["January"] = "1";
    monthmap["February"] = "2";
    monthmap["March"] = "3";
    monthmap["April"] = "4";
    monthmap["May"] = "5";
    monthmap["June"] = "6";
    monthmap["July"] = "7";
    monthmap["August"] = "8";
    monthmap["September"] = "9";
    monthmap["October"] = "10";
    monthmap["November"] = "11";
    monthmap["December"] = "12";
    GetRunningyear();
  }

  Future<Null> _selectDate(BuildContext context, int index) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: index == 1 ? widget.frmdt : DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        widget.selectedDate = picked;
        if (index == 0) {
          widget.frmdt = widget.selectedDate;
          widget.todate = null;
          widget.fromdate =
          "${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}";
        } else {
          widget.todt = widget.selectedDate;
          widget.todate =
          "${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}";
        }
      });
  }

  Future<Null> GetRunningyear() async {
    if (widget.fromdate != null && widget.todate != null) {
      String id = await sp.ReadString("Userid");
      var url = await Constants().Clienturl() +
          "api_parents/attendance_report_new/" + widget.id;
      // var url = await Constants().Clienturl() + Constants.Load_StudentsAttendance ;
      Map<String, String> body = new Map();
      body['student_id'] =  widget.id;
      body['from_date'] = widget.fromdate;
      body['to_date'] = widget.todate;

      http
          .post(url,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: body)
          .then((response) {
        print("response . body ${response.body}");
        if (response.statusCode == 200) {
          print("response --> ${response.body}");
          var responseJson = json.decode(response.body);
          if (responseJson['status'].toString() == "true") {
            print("response json ${responseJson}");

            setState(() {
              widget.month2 = responseJson['result']['attendance_data'];
//            print ("dfasd"+  month2.length.toString());
              widget.varList.clear();
              widget.varList.addAll(widget.month2[0]["attendance_list"]);
              widget.currentIndex = 0;
              setFinals(widget.varList);
              print(responseJson['result']['attendance_data'][0]['month']);

              widget.showreport = false;
              widget._loading = false;
            });
          }
        } else {
          setState(() {
            widget._loading = false;
          });
          print("erroe--" + response.body);
        }
      });
    } else {
      print("test");
    }
  }

//_navigatetomonth(BuildContext context) async {
//  final result =  await Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => Search(title: "Month",duplicateitems: monthlist,)),
//  );
//  setState(() {
//    month = result ?? month;
//  });
//  print("res--"+result.toString());
//}
//
//_navigatetoyear(BuildContext context) async {
//  final result =  await Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => Search(title: "Year",duplicateitems: yearlist,)),
//  );
//  setState(() {
//    year = result ?? year;
//  });
//  print("res--"+result.toString());
//}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Student Attendence"),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//
//        ),
        ),
        drawer: Constants().drawer(context),
        body:
        //_loading ? new Constants().bodyProgress :
        new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new Card(
                  margin: new EdgeInsets.only(
                      left: 60, right: 60, bottom: 10, top: 30),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new InkWell(
                            child: new TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: "From Date",
                                  prefixIcon: new Icon(FontAwesomeIcons.user),
                                  suffixIcon:
                                  new Icon(FontAwesomeIcons.angleDown)),
                              controller: TextEditingController(text: widget.fromdate),
                              enabled: false,
                            ),
                            onTap: () {
                              _selectDate(context, 0);
                              // _navigatetomonth(context);
                            },
                          )),
                      new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new InkWell(
                            child: new TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "To Date",
                                  prefixIcon:
                                  new Icon(FontAwesomeIcons.calendar),
                                  suffixIcon:
                                  new Icon(FontAwesomeIcons.angleDown)),
                              onChanged: (String val) {
                                //year = val;
                              },
                              controller: TextEditingController(text: widget.todate),
                              enabled: false,
                            ),
                            onTap: () {
                              if (widget.fromdate == null) {
                                print("invalid date");
                              } else {
                                _selectDate(context, 1);
                              }
                              //  _navigatetoyear(context);
                            },
                          )),
                      new SizedBox(
                        width: 10,
                        height: 10,
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
                                        GetRunningyear();
                                      },
                                      child: new Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                  Radius.circular(15),
                                                  bottomLeft:
                                                  Radius.circular(15))),
                                          child: new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              new IconButton(
                                                  icon: Icon(
                                                    Icons.remove_red_eye,
                                                  ),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    GetRunningyear();
                                                  }),
                                              new Padding(
                                                padding:
                                                EdgeInsets.only(left: 5.0),
                                                child: GestureDetector(
                                                  child: Text(
                                                    "SHOW REPORT",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                  onTap: () {
                                                    GetRunningyear();
                                                  },
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
                  ),
                ),
              ],
            ),
            widget.showreport
                ? new Container()
                : Container(
              height: 50,
              child: Center(
                child: ListView.builder(
                    itemCount: widget.month2.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      print('month:-${widget.month2.length}');
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 9),
                        child: InkWell(
                          child: new Container(
                            decoration: BoxDecoration(
                                color: widget.currentIndex == index
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(color: Colors.grey)),
                            height: 30,
                            width: 80,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              child: Center(
                                  child: Text(widget.month2[index]["month"])),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              widget.currentIndex = index;
                              //  varList.clear();
                              //  print('test:-'+varList.isEmpty.toString());
                              if (widget.currentIndex != 0) {
                                widget.varList.clear();
                                widget.varList.addAll(widget.month2[widget.currentIndex]
                                ["attendance_list"]);

                                setFinals(widget.varList);


                                print('index:-' +
                                    widget.varList.length.toString());
                              } else {
                                widget.varList.clear();
                                widget.varList.addAll(widget.month2[widget.currentIndex]
                                ["attendance_list"]);
                                setFinals(widget.varList);
                                print('index000:-' +
                                    widget.varList.length.toString());
                              }
                            });
                          },
                        ),
                      );
                    }),
              ),
            ),


            widget.showreport
                ? new Container()
                : new Card(
              elevation: 5.0,
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5),
                          child: Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                //your  TextSpan(text: runningyearmap['student_name']+":" , style: TextStyle(color: Colors.green)),
                                TextSpan(
                                    text: ' Attendence Report',
                                    style: TextStyle(
                                        color:
                                        Theme
                                            .of(context)
                                            .primaryColor)),
                              ],
                            ),
                          )),
                      new Divider(
                        height: 3,
                        color: Theme
                            .of(context)
                            .primaryColor,
                      ),

                      Container(
                        padding: EdgeInsets.all(12),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 12,
                          spacing: 15,
                          children: <Widget>[
                            Text(
                              "Present : ${widget.present}",
                              style: TextStyle(color: Colors.green[800]),
                            ),
                            Text(
                              "Absent : ${widget.absent}",
                              style: TextStyle(color: Colors.red[800]),
                            ),
                            Text(
                              "Event : ${widget.event}",
                              style: TextStyle(color: Colors.indigo[800]),
                            ),
                            Text(
                              "Half Leave : ${widget.halfLeave}",
                              style:
                              TextStyle(color: Colors.yellowAccent),
                            ),
                            Text(
                              "Casual Leave : ${widget.casualleave}",
                              style: TextStyle(color: Colors.red[800]),
                            ),
                            Text(
                              "Sick Leave : ${widget.sickleave}",
                              style: TextStyle(color: Colors.red[800]),
                            ),
                            Text(
                              "Other Leave: ${widget.otherleave}",
                              style: TextStyle(color: Colors.red[800]),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(12),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 12,
                          spacing: 15,
                          children: <Widget>[

                            Text(
                              "Total Present : ${widget.totalPresent}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[800]),
                            ),

                            Text("Total Absent : ${widget.totalAbsent}",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[800])),

                            Text("Total Undefined : ${widget.totalUndefined}",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellowAccent[800])),

                          ],
                        ),
                      ),

                      Container(
                        child: new Card(
                          elevation: 5.0,
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, right: 10, left: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: new Column(
                            children: <Widget>[
                              new Padding(
                                  padding: new EdgeInsets.all(5),
                                  child: new Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Text(
                                          "Date",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: new Text(
                                          "Status",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        flex: 1,
                                      ),

                                    ],
                                  )),
                              new Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Container(
                                height: 300,
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[

                                    new Expanded(
                                      //height: 300,
                                        child: Container(
                                          // color: Colors.deepOrange,
                                          child: new ListView.builder(
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemCount: widget.sortedMonthDate.length,
                                            itemBuilder: (BuildContext context,
                                                int ind) {

                                              int index  = widget.sortedMonthDate[ind];
//                                              var len = widget.varList.length - 8;
                                              //  List varList=new List();

                                              String status = "Undefined";
                                              //  IconData icon =
                                              FontAwesomeIcons.checkCircle;
                                              Color color = Colors.grey;

                                              if (widget.selectedMonth[index] == "U") {
                                                status = "Undefined";
                                                // icon = Icons.flag;
                                                color = Colors.black;
                                              }
                                              if (widget.selectedMonth[index] == "P") {
                                                status = "Present";
                                                // icon = Icons.check_circle;
                                                color = Colors.green;
                                              }
                                              if (widget.selectedMonth[index] ==
                                                  "E") {
                                                status = "Event";
                                                //   icon = Icons.flag;
                                                color = Colors.indigo[800];
                                              }
                                              if (widget.selectedMonth[index]=="A") {
                                                status = "Absent";
                                                //  icon =
                                                FontAwesomeIcons.timesCircle;
                                                color = Colors.red[800];
                                              }
                                              if (widget.selectedMonth[index] ==
                                                  "HL") {
                                                status = "Halfday";
                                                //   icon = Icons.flag;
                                                color =
                                                Colors.yellowAccent[800];
                                              }

                                              if (widget.selectedMonth[index] ==
                                                  "CL") {
                                                status = "CasualLeave";
                                                //  icon = Icons.flag;
                                                color = Colors.red[800];
                                              }

                                              if (widget.selectedMonth[index] ==
                                                  "SL") {
                                                status = "SickLeave";
                                                // icon = Icons.flag;
                                                color = Colors.red[800];
                                              }

                                              if (widget.selectedMonth[index] ==
                                                  "OL") {
                                                status = "OtherLeave";
                                                // icon = Icons.flag;
                                                color = Colors.red[800];
                                              }
//

                                              return new Column(
                                                children: <Widget>[
                                                  new Padding(
                                                      padding:
                                                      new EdgeInsets.all(5),
                                                      child: new Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Text(
                                                            ( index)
                                                                .toString(),
                                                          ),
                                                          new Text(
                                                            status,
                                                            style: TextStyle(
                                                                color: color,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          // Icon((icon)),
                                                        ],
                                                      )),
                                                  new Divider(
                                                    height: 1,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
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
                                      onTap: () {},
                                      child: new Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                  Radius.circular(15),
                                                  bottomLeft:
                                                  Radius.circular(15))),
                                          child: new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Icon(
                                                Icons.print,
                                                color: Colors.white,
                                              ),
                                              new Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0),
                                                child: Text(
                                                  "Print Attendence",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold,
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
                  )),
            ),
          ],
        ));
  }

  setFinals(List varList) {
    widget.selectedMonth.clear();
    var len = varList.length;
    for (Map<String,dynamic> obj in varList) {
      if ( obj.containsKey('T/A') ) widget.totalAbsent = obj['T/A'];
      else if (obj.containsKey('T/P') ) widget.totalPresent = obj['T/P'];
      else if (obj.containsKey('T/U'))
        widget.totalUndefined = obj['T/U'];
      else if (obj.containsKey('OL') ) widget.otherleave = obj['OL'];
      else if (obj.containsKey('SL') ) widget.sickleave = obj['SL'];
      else if (obj.containsKey('CL') ) widget.casualleave = obj['CL'];
      else if (obj.containsKey('HL') ) widget.halfLeave = obj['HL'];
      else if (obj.containsKey('A') ) widget.absent = obj['A'];
      else if (obj.containsKey('E') ) widget.event = obj['E'];
      else if (obj.containsKey('P') ) widget.present = obj['P'];
      else if (obj.containsKey('U'))
        widget.undefined = obj['U'];
      else{
        List list = List.from(obj.keys);
        int date = int.tryParse(list[0]);
        if (date != null){
          widget.selectedMonth[date] = obj[list[0]];
        }
      }
    }

    widget.sortedMonthDate = widget.selectedMonth.keys.toList()..sort();
    setState(() {
    });
  }}
