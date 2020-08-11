import 'dart:io';
import 'dart:math';

import 'package:Edecofy/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../AppUtils.dart';
import '../FilePicker.dart';
import '../const.dart';
import '../dashboard.dart';

class StudentPromotionPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StudentPromotionPageState();
}

class _StudentPromotionPageState extends State<StudentPromotionPage> {
  String ruunungyear = "", nextyear='',
      fromclass = '', toclass='';
  bool _loading = false;
  bool showreport = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadClassdetails();
  }

  Future<Null> Managepromotion() async {
    String id = await sp.ReadString("Userid");
    if(fromclass == ''){
      Constants().ShowAlertDialog(context, "Please select Promotion from Class");
      return;
    }
    if(toclass == ''){
      Constants().ShowAlertDialog(context, "Please select Promotion to Class");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Student_Managepromotion;
    Map<String, String> body = new Map();
    body['type_page'] = "promote";
    body['Running_year'] = ruunungyear;
    body['Promotion_from_class_id'] = classmap[fromclass];
    print("url is $url" + "body--" + body.toString());

    http
        .post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body)
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == 'true') {
          print("response json ${responseJson}");
          Constants().ShowSuccessDialog(context, responseJson['message']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
          new Timer(duration, handleTimeout);
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  Map classmap= new Map();
  List<String> classlist= new List();

  _navigatetoclasses(BuildContext context,String type) async {
    final result =  await Constants().Selectiondialog(context, "Classes", classlist);
    setState(() {
      if (type == "from")
        fromclass = result ?? fromclass;
      else
        toclass = result ?? toclass;
    });
  }

  LoadClassdetails() async{
    Map body = new Map();
    body['type_page'] = "get";

    var url = await Constants().Clienturl() + Constants.Student_getpromotion;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          ruunungyear = responseJson['result']['running_year'];
          nextyear = responseJson['result']['next_year'];

          for (Map data in responseJson['result']['class_list']) {
            classlist.add(data['name']);
            classmap[data['name']] = data['class_id'];
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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Students"),
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
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Container(
              margin: EdgeInsets.only(top: 30),
              child: new Text("Student Promotion",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
          ),
          new Card(
                    margin:
                    new EdgeInsets.only(left: 40, right: 40, bottom: 10, top: 90),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: new ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: "Current Session *",
                                    prefixIcon: new Icon(FontAwesomeIcons.user),
                                ),
                                controller: TextEditingController(text: ruunungyear),
                                enabled: false,
                              ),
                            )),
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: "Promote To Session *",
                                    prefixIcon: new Icon(FontAwesomeIcons.user),
                                ),
                                controller: TextEditingController(text: nextyear),
                                enabled: false,
                              ),
                            )),
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: "Promotion From Class *",
                                    prefixIcon: new Icon(FontAwesomeIcons.user),
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                ),
                                controller: TextEditingController(text: fromclass),
                                enabled: false,
                              ),
                              onTap: () {
                                _navigatetoclasses(context,"from");
                              },
                            )),
                        new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new InkWell(
                              child: new TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: "Promotion To Class *",
                                    prefixIcon: new Icon(FontAwesomeIcons.user),
                                    suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                                ),
                                controller: TextEditingController(text: toclass),
                                enabled: false,
                              ),
                              onTap: () {
                                _navigatetoclasses(context,"to");
                              },
                            )),
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
                                          Managepromotion();
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
                                            new SvgPicture.asset("assets/promotion.svg",color: Colors.white,width: 25,height: 25,),
                                            new Padding(
                                              padding:
                                              EdgeInsets.only(left: 15.0),
                                              child: Text(
                                                "Manage Promotion",
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
                    ),
                  ),
        ],
      ),

    );
  }
}
