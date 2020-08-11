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

class StudentFeesmanagePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StudentFeesmanagePageState();
}

class _StudentFeesmanagePageState extends State<StudentFeesmanagePage> {
  bool _loading = false,show=false;
  TextEditingController controller = new TextEditingController();
  List feelist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = false;
    });
  }

  Future<Null> Searchfess() async {
    String id = await sp.ReadString("Userid");
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Search_Fees_Management;
    Map<String, String> body = new Map();
    body['payment_id'] = paymentid.text;

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
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          setState(() {
            feelist = responseJson['data'];
            show = true;
          });
        }
      } else {
        Navigator.of(context).pop();
        print("erroe--" + response.body);
      }
    });
  }

  TextEditingController paymentid = new TextEditingController();

  Widget _EdittPopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 1,
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
          value: 2,
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
    },
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Search Fees Management"),
        backgroundColor: Color(0xff182C61),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),
      ),
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
              child: new Text("Search Fees Management",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 90),
            child: new ListView(
              children: <Widget>[
                new Card(
                  margin: new EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: new ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      new SizedBox(height: 10,width: 10,),
                      new Padding(
                          padding: EdgeInsets.all(5.0),
                            child: new TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Payment ID *",
                              ),
                              controller: paymentid,
                            ),
                      ),
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
                                        Searchfess();
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
                                              new Icon(FontAwesomeIcons.search,color: Colors.white),
                                              new Padding(
                                                padding:
                                                EdgeInsets.only(left: 15.0),
                                                child: Text(
                                                  "Search",
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
                show ? new Card(
                  margin: new EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 5,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(child: new Padding(child: new Text("Payment ID Details",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                            new Expanded(child:  new Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                              decoration: BoxDecoration(border: Border(right: BorderSide(width: 2,color: Colors.grey[300]))),
                              child: new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200]),
                                child: new SvgPicture.asset(
                                  "assets/excel.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                padding: EdgeInsets.all(10),
                              ),),flex: 2,),
                            new Expanded(child:  new Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                              decoration: BoxDecoration(border: Border(right: BorderSide(width: 2,color: Colors.grey[300]))),
                              child: new Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                ),
                                child: new SvgPicture.asset(
                                  "assets/pdf.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                padding: EdgeInsets.all(10),
                              ),),flex: 2,),
                            new Expanded(child: new Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200]),
                              child: new SvgPicture.asset(
                                "assets/printer.svg",
                                width: 20,
                                height: 20,
                              ),
                              padding: EdgeInsets.all(10),
                            ),flex: 2,),
                          ],
                        )
                      ),
                      new Container(height: 2,width: double.infinity,color: Theme.of(context).primaryColor,),
                      new Container(
                        padding: new EdgeInsets.all(10),
                        child: feelist.length >0 ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: Text("ID"),
                              ),
                              DataColumn(
                                label: Text("Name"),
                              ),
                              DataColumn(
                                label: Text("Class"),
                              ),
                              DataColumn(
                                label: Text("Date"),
                              ),
                              DataColumn(
                                label: Text("Mode"),
                              ),
                              DataColumn(
                                label: Text("Actions"),
                              ),
                            ],
                            rows:feelist.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(user['paymentid'].toString()),
                                    ),
                                    DataCell(
                                      Text(user['studentName'].toString()),
                                    ),
                                    DataCell(
                                      Text(user['class'].toString()),
                                    ),
                                    DataCell(
                                      Text(user['pymtDt'].toString()),
                                    ),
                                    DataCell(
                                      Text(user['pymtMode'].toString()),
                                    ),
                                    DataCell(
                                      new Padding(padding: EdgeInsets.all(2),child:_EdittPopup()),
                                    ),
                                  ]),
                            ).toList(),
                          ),
                        ) : new Container(alignment: Alignment.center,child: new Text("No records found",style: TextStyle(color: Colors.red,fontSize: 20),),),
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
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                              new Padding(
                                                padding:
                                                EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  "Save",
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
                ) : new Container()
              ],
            ),
          )
        ],
      ),

    );
  }

}
