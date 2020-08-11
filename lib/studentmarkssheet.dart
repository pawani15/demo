import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'const.dart';

class Studentmarkssheet extends StatefulWidget {
  final String examid,studentid,name;
  Studentmarkssheet({this.examid,this.studentid,this.name});

  @override
  State<StatefulWidget> createState() => new _StudentmarkssheetState();
}

class _StudentmarkssheetState extends State<Studentmarkssheet> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;

  List markslist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadmarks();
  }

  Future<Null> Loadmarks() async {
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Marks+widget.studentid+"/"+widget.examid;
    Map<String, String> body = new Map();

    print("url is $url"+"body--"+body.toString());

    http.get(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"})
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true" && responseJson['result'] != null) {
          print("response json ${responseJson}");
          try {
            markslist = responseJson['result'];
          }catch(e){
            markslist = new List();
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
    return  _loading ? new Constants().bodyProgress :
    new Stack(
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
        child: new Text.rich(
          TextSpan(
          children: <TextSpan>[
            TextSpan(text: "Marksheet For: " , style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14)),
            TextSpan(text: "(${widget.name})", style: TextStyle(color: Colors.green,fontSize: 14)),
          ],
        ),
        textAlign: TextAlign.center,)
        //new Text("Search Due Fees",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
      ),
    ),
        new Card(
            margin: new EdgeInsets.only(left: 10, right: 10, bottom: 10,top: 90),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new Column(children: <Widget>[
      new Padding(padding: new EdgeInsets.all(10),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: new Text("Subject",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),flex: 1,),
              new Expanded(child: new Text("Obtained Marks",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
              new Expanded(child: new Text("Highest Marks",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
            ],
          )),
      new Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child:
          new Divider(height: 1,color: Colors.grey,)),
      new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(10),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text("${markslist[index]['sub_name'].toString()}",style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                    new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(markslist[index]['mark_obtained'].toString(),style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                    new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(markslist[index]['mark_total'] == null ? "" : markslist[index]['mark_total'].toString(),style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                  ],
                )),
            new Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child:
                new Divider(height: 1,color: Colors.grey,)),
          ],
        );
      },itemCount: markslist.length,
      )),
      new Container(
          margin: new EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,
          width: double.infinity,
          child:new InkWell(
              onTap: () {
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
                      new Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                      new Padding(
                        padding:
                        EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Print Marksheet",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      )
                    ],
                  ))))
    ]))
    ]);
  }

}
