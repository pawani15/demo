import 'dart:io';
import 'dart:math';

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

class ExpensescategoryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _ExpensescategoryPageState();
}

class _ExpensescategoryPageState extends State<ExpensescategoryPage> {
  bool _loading = false,show=false;
  TextEditingController controller = new TextEditingController();
  List expensescategorylist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadExpensescategory();
  }


  Future<Null> CreateExpensescategory(String type, Map details) async {
    Constants().onLoading(context);
    var url="";
    url = await Constants().Clienturl() + Constants.CRUDExpensecat_Admin;

    Map<String, String> body = new Map();
    if(type == "new") {
      body['type_page'] = "create";
    }
    else {
      body['type_page'] = "update";
      body['expense_category_id'] = details['expense_category_id'];
    }
    body['name'] = title.text;

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
          Navigator.of(context).pop();
          Constants().ShowSuccessDialog(context, responseJson['message']);

          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadExpensescategory();
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

  Future<Null> LoadExpensescategory() async {
    String empid = await sp.ReadString("Userid");
    var url = '';
    url = await Constants().Clienturl() + Constants.LoadExpensecat_Admin;

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
            setState(() {
              expensescategorylist = responseJson['result'];
            });
          }catch(e){
            expensescategorylist = new List();
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


  Future<Null> DeleteApi(String expenscatid) async {
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.CRUDExpensecat_Admin;

    Map<String, String> body = new Map();
    body['type_page'] = "delete";
    body['expense_category_id'] = expenscatid;

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
          Navigator.of(context).pop();
          Constants().ShowSuccessDialog(context, responseJson['message']);
          const duration = const Duration(seconds: 2);
          void handleTimeout() {
            // callback function
            Navigator.of(context).pop();
            LoadExpensescategory();
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
                                      DeleteApi(details['expense_category_id']);
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

  TextEditingController title= new TextEditingController();
  AddExpensescategorydialog(String action, String status,Map details) async {
    String titlename = "Add Expenses Category";
    if(status == 'refresh') {
      if (action == "new") {
        title.text = '';
      }
      else {
        titlename = "Edit Expenses Category";
        title.text = details['name'];
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
                              action == "new" ? Icons.add : Icons.edit,
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
                new Container(margin: EdgeInsets.all(5.0),child:new TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Title *",
                      prefixIcon: new Icon(FontAwesomeIcons.user)
                  ),
                  controller: title,
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
                                AddExpensescategorydialog("new",'refresh',details);
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
                                  )))),flex: 1,),
                      new Expanded(child:new Container(
                          margin: new EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: new InkWell(
                              onTap: () {
                                if(title.text == ""){
                                  Constants().ShowAlertDialog(context, "Please enter title");
                                  return;
                                }
                                CreateExpensescategory(action, details);
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
                                      new Padding(padding: EdgeInsets.only(left: 5.0),child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),)
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

  Widget _EdittPopup(user) => PopupMenuButton<int>(
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
      if(value == 1)
        AddExpensescategorydialog("edit","refresh",user);
      else if(value == 2)
        deletedialog(user);
    },
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Expenses Category"),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),*/
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
//              margin: EdgeInsets.only(top: 15),
//              child: new Text("Expenses Category",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
//            ),
          ),
          _loading ? new Constants().bodyProgress :  new Container(
            margin:  new EdgeInsets.only(left: 15,right: 5,bottom: 10,top: 15),
            child : new Stack(
              children: <Widget>[
                new Card(
                  elevation: 5.0,
                  margin: new EdgeInsets.only(top: 25,right: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: new ListView(
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 5,right: 5,top: 15,bottom: 5),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(child: new Padding(child: new Text("Expenses Category",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                            /*new Expanded(child:  new Container(
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
                            ),flex: 2,),*/
                          ],
                        )
                      ),
                      new Container(height: 2,width: double.infinity,color: Theme.of(context).primaryColor,),
                      new Container(
                        padding: new EdgeInsets.all(10),
                        child: expensescategorylist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                            :SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: new Container(width: 80,child: Text("#",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                              ),
                              DataColumn(
                                label: new Container(width: 120,child:Text("Title",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),)),
                              ),
                              DataColumn(
                                label: Text("Actions",style:TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                              ),
                            ],
                            rows:expensescategorylist.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                    new Container(width: 80,child:Text((expensescategorylist.indexOf(user)+1).toString())),
                                    ),
                                    DataCell(
                                      new Container(width: 120,child:Text(user['name'])),
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
                      AddExpensescategorydialog("new","refresh",null);
                    },
                    )
                )
              ],
            ))
    ]
    ));
  }

}
