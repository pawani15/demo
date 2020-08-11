import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'const.dart';
import 'dashboard.dart';

class ClassroutinesPage extends StatefulWidget {
  final String studentname,id;
  ClassroutinesPage({this.studentname,this.id});

  @override
  State<StatefulWidget> createState() => new _ClassroutinesPageState();
}

class _ClassroutinesPageState extends State<ClassroutinesPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  Map Classdetails;
  List sundaylist=new List();
  List mondaylist=new List();
  List tuesdaylist=new List();
  List wendaylist=new List();
  List thursdaylist=new List();
  List fridaylist=new List();
  List satdaylist=new List();
  String classname="",sectionname="";

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadclassroutineClass();
  }

  Future<Null> Loadclassroutine() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Classroutine+widget.id;
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
             sundaylist=responseJson['result']['sunday'];
             mondaylist=responseJson['result']['monday'];
             tuesdaylist=responseJson['result']['tuesday'];
             wendaylist=responseJson['result']['wednesday'];
             thursdaylist=responseJson['result']['thursday'];
             fridaylist=responseJson['result']['friday'];
             satdaylist=responseJson['result']['saturday'];
            print("mondaylen--"+mondaylist.length.toString());
          }catch(e){
            sundaylist=new List();
            mondaylist=new List();
            tuesdaylist=new List();
            wendaylist=new List();
            thursdaylist=new List();
            fridaylist=new List();
            satdaylist=new List();
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

  Future<Null> LoadclassroutineClass() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Classroutine_class+widget.id;
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
         classname = responseJson['result']['class_name'];
         sectionname = responseJson['result']['section_name'];
        }
        Loadclassroutine();
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
        title: Text("Class Timetable"),
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
//                        shape: BoxShape.circle,
//                        color: Colors.orange
//                      ),
//                      child: new Icon(Icons.person,color: Colors.white,size: 25,),
//                      padding: new EdgeInsets.all(5),
//                      margin: EdgeInsets.all(5),
//                    ),
//                    new Text(widget.studentname,style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 30),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.all(5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Text("Class-$classname : Section-$sectionname",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),flex: 3,),
//                        new Expanded(child: new InkWell(child: new Container(
//                          decoration: BoxDecoration(
//                            shape: BoxShape.rectangle,
//                            borderRadius: BorderRadius.circular(30),
//                            color: Colors.green,
//                              boxShadow: [new BoxShadow(
//                                color: Colors.grey[300],
//                                blurRadius: 5.0,
//                              ),]
//                          ),
//                          child: new Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              new Padding(padding: EdgeInsets.only(right: 20),child: new Text("Print",style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
//                              new Icon(Icons.print,color: Colors.white,)
//                            ],
//                          ),
//                        ),
//                          onTap: (){
//                            Constants().ShowAlertDialog(context, "Coming Soon!");
//                          },
//                        ),flex: 2,),
                      ],
                    )),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                  new Container( height: 40 ,child : new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(5),child:new Text("Sunday",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                      sundaylist.length > 0 ? new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index)
                      {

                        return new Container(padding: EdgeInsets.all(5),
                            child: new Stack(
                              children: <Widget>[
                                new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).primaryColor,
                                      boxShadow: [new BoxShadow(
                                        color: Colors.grey[300],
                                        blurRadius: 5.0,
                                      ),]
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: new Text(sundaylist[index]
                                  ['name'] +
                                      " (" +
                                      sundaylist[index]
                                      ['time_start'] +
                                      " :" +
                                      sundaylist[index][
                                      'time_start_min'] +
                                      " - " +
                                      sundaylist[index]
                                      ['time_end'] +
                                      " :" +
                                      sundaylist[index]
                                      ['time_end_min'] +
                                      ")",
                                    style: TextStyle(color: Colors.white,fontSize: 11),maxLines: 1,textAlign: TextAlign.center,),
                                  margin: EdgeInsets.only(top: 5),
                                ),
                                new Align(child:new Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange
                                  ),
                                  child: new Icon(Icons.timer,color: Colors.white,size: 10,),
                                  margin: EdgeInsets.only(right: 5),
                                ),alignment: Alignment.topCenter,),
                              ],
                            )) ;
                      },itemCount:sundaylist.length,
                        scrollDirection: Axis.horizontal,
                      )
                      ) : new Container() ,
                    ],
                  )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Container( height: 40 ,child : new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(5),child:new Text("Monday",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                        mondaylist.length > 0 ? new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index)
                        {

                          return new Container(padding: EdgeInsets.all(5),
                          child: new Stack(
                            children: <Widget>[
                              new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: [new BoxShadow(
                                      color: Colors.grey[300],
                                      blurRadius: 5.0,
                                    ),]
                                ),
                                padding: EdgeInsets.all(5),
                                child: new Text(mondaylist[index]
                                ['name'] +
                                    " (" +
                                    mondaylist[index]
                                    ['time_start'] +
                                    " :" +
                                    mondaylist[index][
                                    'time_start_min'] +
                                    " - " +
                                    mondaylist[index]
                                    ['time_end'] +
                                    " :" +
                                    mondaylist[index]
                                    ['time_end_min'] +
                                    ")",
                                    style: TextStyle(color: Colors.white,fontSize: 11),maxLines: 1,textAlign: TextAlign.center,),
                                margin: EdgeInsets.only(top: 5),
                              ),
                              new Align(child:new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange
                                ),
                                child: new Icon(Icons.timer,color: Colors.white,size: 10,),
                                margin: EdgeInsets.only(right: 5),
                              ),alignment: Alignment.topCenter,),
                            ],
                          )) ;
                        },itemCount:mondaylist.length,
                          scrollDirection: Axis.horizontal,
                        )
                        ) : new Container() ,
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Container( height: 40 ,child : new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(5),child:new Text("Tuesday",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                        tuesdaylist.length > 0 ? new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index)
                        {
                          return new Container(padding: EdgeInsets.all(5),
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).primaryColor,
                                        boxShadow: [new BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 5.0,
                                        ),]
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: new Text(tuesdaylist[index]
                                    ['name'] +
                                        " (" +
                                        tuesdaylist[index]
                                        ['time_start'] +
                                        " :" +
                                        tuesdaylist[index][
                                        'time_start_min'] +
                                        " - " +
                                        tuesdaylist[index]
                                        ['time_end'] +
                                        " :" +
                                        tuesdaylist[index]
                                        ['time_end_min'] +
                                        ")"
                                        ,style: TextStyle(color: Colors.white,fontSize: 11),maxLines: 1,textAlign: TextAlign.center,),
                                    margin: EdgeInsets.only(top: 5),
                                  ),
                                  new Align(child:new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange
                                    ),
                                    child: new Icon(Icons.timer,color: Colors.white,size: 10,),
                                    margin: EdgeInsets.only(right: 5),
                                  ),alignment: Alignment.topCenter,),
                                ],

                              )) ;
                        },itemCount:tuesdaylist.length,
                          scrollDirection: Axis.horizontal,
                        )
                        ) : new Container() ,
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Container( height: 40 ,child : new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(5),child:new Text("Wednesday",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                        wendaylist.length > 0 ? new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index)
                        {

                          return new Container(padding: EdgeInsets.all(5),
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).primaryColor,
                                        boxShadow: [new BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 5.0,
                                        ),]
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: new Text(wendaylist[index]
                                                ['name'] +
                                                    " (" +
                                                    wendaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    wendaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    wendaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    wendaylist[index]
                                                    ['time_end_min'] +
                                                    ")",
                                      style: TextStyle(color: Colors.white,fontSize: 11),maxLines: 1,textAlign: TextAlign.center,),
                                    margin: EdgeInsets.only(top: 5),
                                  ),
                                  new Align(child:new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange
                                    ),
                                    child: new Icon(Icons.timer,color: Colors.white,size: 10,),
                                    margin: EdgeInsets.only(right: 5),
                                  ),alignment: Alignment.topCenter,),
                                ],
                              )) ;
                        },itemCount:wendaylist.length,
                          scrollDirection: Axis.horizontal,
                        )
                        ) : new Container() ,
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Container( height: 40 ,child : new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(5),child:new Text("Thursday",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                        thursdaylist.length > 0 ? new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index)
                        {

                          return new Container(padding: EdgeInsets.all(5),
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).primaryColor,
                                        boxShadow: [new BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 5.0,
                                        ),]
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: new Text(thursdaylist[index]
                                    ['name'] +
                                                    " (" +
                                                    thursdaylist[index]
                                                    ['time_start'] +
                                                    " :" +
                                                    thursdaylist[index][
                                                    'time_start_min'] +
                                                    " - " +
                                                    thursdaylist[index]
                                                    ['time_end'] +
                                                    " :" +
                                                    thursdaylist[index]
                                                    ['time_end_min'] +
                                                    ")",

                                      style: TextStyle(color: Colors.white,fontSize: 11),maxLines: 1,textAlign: TextAlign.center,),
                                    margin: EdgeInsets.only(top: 5),
                                  ),
                                  new Align(child:new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange
                                    ),
                                    child: new Icon(Icons.timer,color: Colors.white,size: 10,),
                                    margin: EdgeInsets.only(right: 5),
                                  ),alignment: Alignment.topCenter,),
                                ],
                              )) ;
                        },itemCount:thursdaylist.length,
                          scrollDirection: Axis.horizontal,
                        )
                        ) : new Container() ,
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Container( height: 40 ,child : new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(5),child:new Text("Friday",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                        fridaylist.length > 0 ? new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index)
                        {
                          return new Container(padding: EdgeInsets.all(5),
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).primaryColor,
                                        boxShadow: [new BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 5.0,
                                        ),]
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: new Text(fridaylist[index]
                                      ['name'] +
                                      " (" +
                                      fridaylist[index]
                                      ['time_start'] +
                                      " :" +
                                      fridaylist[index][
                                      'time_start_min'] +
                                      " - " +
                                      fridaylist[index]
                                      ['time_end'] +
                                      " :" +
                                      fridaylist[index]
                                      ['time_end_min'] +
                                      ")",
                                      style: TextStyle(color: Colors.white,fontSize: 11),maxLines: 1,textAlign: TextAlign.center,),
                                    margin: EdgeInsets.only(top: 5),
                                  ),
                                  new Align(child:new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange
                                    ),
                                    child: new Icon(Icons.timer,color: Colors.white,size: 10,),
                                    margin: EdgeInsets.only(right: 5),
                                  ),alignment: Alignment.topCenter,),
                                ],
                              )) ;
                        },itemCount:fridaylist.length,
                          scrollDirection: Axis.horizontal,
                        )
                        ) : new Container() ,
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Container( height: 40 ,child : new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.all(5),child:new Text("Saturday",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                        satdaylist.length > 0 ? new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index)
                        {
                          return new Container(padding: EdgeInsets.all(5),
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).primaryColor,
                                        boxShadow: [new BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 5.0,
                                        ),]
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: new Text(satdaylist[index]
                                    ['name'] +
                                        " (" +
                                        satdaylist[index]
                                        ['time_start'] +
                                        " :" +
                                        satdaylist[index][
                                        'time_start_min'] +
                                        " - " +
                                        satdaylist[index]
                                        ['time_end'] +
                                        " :" +
                                        satdaylist[index]
                                        ['time_end_min'] +
                                        ")",

                                      style: TextStyle(color: Colors.white,fontSize: 11),maxLines: 1,textAlign: TextAlign.center,),
                                    margin: EdgeInsets.only(top: 5),
                                  ),
                                  new Align(child:new Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange
                                    ),
                                    child: new Icon(Icons.timer,color: Colors.white,size: 10,),
                                    margin: EdgeInsets.only(right: 5),
                                  ),alignment: Alignment.topCenter,),
                                ],
                              )) ;
                        },itemCount:satdaylist.length,
                          scrollDirection: Axis.horizontal,
                        )
                        ) : new Container() ,
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
//                    new Container(
//                      child: new Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          new Expanded(
//                            child: new Container(
//                                margin: new EdgeInsets.all(0.0),
//                                alignment: Alignment.center,
//                                width: double.infinity,
//                                child:new InkWell(
//                                    onTap: () {
//                                      Constants().ShowAlertDialog(context, "Coming Soon!");
//                                    },
//                                    child: new Container(
//                                        padding: EdgeInsets.all(10),
//                                        decoration: BoxDecoration(
//                                            color: Colors.green,
//                                            borderRadius: BorderRadius.only(
//                                                bottomRight:
//                                                Radius.circular(15),bottomLeft: Radius.circular(15))),
//                                        child: new Row(
//                                          mainAxisAlignment:
//                                          MainAxisAlignment.center,
//                                          children: <Widget>[
//                                            new Icon(
//                                              Icons.print,
//                                              color: Colors.white,
//                                            ),
//                                            new Padding(
//                                              padding:
//                                              EdgeInsets.only(left: 5.0),
//                                              child: Text(
//                                                "Print ",
//                                                style: TextStyle(
//                                                    color: Colors.white,
//                                                    fontWeight: FontWeight.bold,
//                                                    fontSize: 12),
//                                              ),
//                                            )
//                                          ],
//                                        )))),
//                            flex: 1,
//                          ),
//                        ],
//                      ),
//                    ),
                  ],
                )

            ),
          )
        ],
      ),
    );
  }


}