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

class ExpensesreportPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _ExpensesreportPageState();
}

class _ExpensesreportPageState extends State<ExpensesreportPage> {
  bool _loading = false,show=false;
  TextEditingController controller = new TextEditingController();
  List expenseslist = new List();
  bool showreport = true;

  @override
  void initState() {
    super.initState();
    paymenttypelist.add("Debit");
    paymenttypelist.add("Credit");
    paymenttypemap['Debit'] = "DR";
    paymenttypemap['Credit'] = "CR";
    revmethodmap['1'] = "Cash";
    revmethodmap['2'] = "Check";
    revmethodmap['3'] = "Card";
  }

  Map paymenttypemap= new Map(),revmethodmap= new Map();
  List<String> paymenttypelist = new List();

  _navigatetopatymenttypes(BuildContext context) async {
    String result = await Constants().Selectiondialog(context, "Payment Type", paymenttypelist);
    setState(() {
      paymenttype.text = result ?? paymenttype.text ;
    });
    print("res--"+result.toString());
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<Null> LoadExpensereports() async {
    expenseslist.clear();
    Constants().onLoading(context);
    String empid = await sp.ReadString("Userid");
    var url = '';
    url = await Constants().Clienturl() + Constants.LoadExpenses_Admin;

    Map<String, String> body = new Map();
    body['pay_type'] = paymenttypemap[paymenttype.text];
    body['from_date'] = startdate == null ? "" :  new DateFormat('dd-MM-yyyy').format(startdate);
    body['to_date'] = enddate == null ? "" :  new DateFormat('dd-MM-yyyy').format(enddate);

    print("url is $url"+"body--"+body.toString());

    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            setState(() {
              expenseslist = responseJson['result'];
            });
          }catch(e){
            expenseslist = new List();
          }
          showreport = false;
        }
        else
          Constants().ShowAlertDialog(context, responseJson['message']);
      }
      else {
        print("erroe--"+response.body);
      }
    });
  }

  Future<Null> _selectstartDate(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != startdate) {
        print('date selected : ${startdate.toString()}');
        setState(() {
          startdate = picked;
        });
      }
    }catch(e){e.toString();}
  }

  Future<Null> _selectendDate(BuildContext context) async {
    try {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-1),
          lastDate:  DateTime(DateTime.now().year+1));

      if (picked != null && picked != enddate) {
        print('date selected : ${enddate.toString()}');
        setState(() {
          enddate = picked;
        });
      }
    }catch(e){e.toString();}
  }

  DateTime startdate = null,enddate = null;
  TextEditingController paymenttype = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Expenses Report"),
        backgroundColor: Color(0xff182C61),
        /*leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),),*/
      ),
        drawer: Constants().drawer(context),
        body: new Stack(
        children: <Widget>[
          new Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
//            child: new Container(
//              margin: EdgeInsets.only(top: 20),
//              child: new Text("Expenses Report",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
//            ),
          ),
          new Container(
              margin: new EdgeInsets.only(top: 15),
            child :new ListView(
              children: <Widget>[
                new Card(
                  margin: new EdgeInsets.symmetric(horizontal: 30,vertical: 10),
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
                          child: new InkWell(
                            child: new TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Payment Type *",
                                  prefixIcon: new Icon(FontAwesomeIcons.list),
                                  suffixIcon: new Icon(FontAwesomeIcons.angleDown)
                              ),
                              controller: paymenttype,
                              enabled: false,
                            ),
                            onTap: () {
                              _navigatetopatymenttypes(context);
                            },
                          )),
                      new Container(margin: new EdgeInsets.all(5.0),
                          child : new InkWell(
                            child: new TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Start Date *',
                                prefixIcon: new Icon(FontAwesomeIcons.calendar),
                              ),
                              enabled: false,
                              controller: new TextEditingController(text: startdate == null ? "" :  new DateFormat('dd-MM-yyyy').format(startdate)),
                            ),
                            onTap: (){
                              _selectstartDate(context);
                            },
                          )),
                      new Container(margin: new EdgeInsets.all(5.0),
                          child : new InkWell(
                            child: new TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'End Date *',
                                prefixIcon: new Icon(FontAwesomeIcons.calendar),
                              ),
                              enabled: false,
                              controller: new TextEditingController(text: enddate == null ? "" :  new DateFormat('dd-MM-yyyy').format(enddate)),
                            ),
                            onTap: (){
                              _selectendDate(context);
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
                                        if(paymenttype.text == ''){
                                          Constants().ShowAlertDialog(context, "Please select payment type");
                                          return;
                                        }
                                        if(startdate == null){
                                          Constants().ShowAlertDialog(context, "Please select start date");
                                          return;
                                        }
                                        if(enddate == null){
                                          Constants().ShowAlertDialog(context, "Please select end date");
                                          return;
                                        }
                                        LoadExpensereports();
                                      },
                                      child: new Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
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
                showreport ? new Container() : new Card(
                  elevation: 5.0,
                  margin: new EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(child: new Padding(child: new Text("Expenses Report List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),padding: EdgeInsets.only(left: 10),),flex: 5,),
                             /* new Expanded(child:  new Container(
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
                        child: expenseslist.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                            : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: Text("S No",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Payment ID",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Title",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Category",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Method",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Pay Type",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Amount",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Date",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                              DataColumn(
                                label: Text("Description",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                              ),
                            ],
                            rows:expenseslist.map(
                                  (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text((expenseslist.indexOf(user)+1).toString()),
                                    ),
                                    DataCell(
                                      Text(user['payment_id']),
                                    ),
                                    DataCell(
                                      Text(user['title']),
                                    ),
                                    DataCell(
                                      Text(user['category_name']),
                                    ),
                                    DataCell(
                                      Text(revmethodmap[user['method'].toString()]),
                                    ),
                                    DataCell(
                                      Text(user['pay_type'].toString()),
                                    ),
                                    DataCell(
                                      Text(user['amount'].toString()),
                                    ),
                                    DataCell(
                                      Text(user['timestamp'] == null || user['timestamp'] == "" ? "" : user['timestamp'].toString()),
                                    ),
                                    DataCell(
                                      Text(user['description'].toString()),
                                    ),
                                  ]),
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          )
    ]
    ));
  }

}
