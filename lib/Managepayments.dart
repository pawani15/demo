import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'const.dart';
import 'dashboard.dart';

class PaymentsPage extends StatefulWidget {
  final String studentname,id;
  PaymentsPage({this.studentname,this.id});

  @override
  State<StatefulWidget> createState() => new _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  List paymentslist;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadpayments();
  }

  Future<Null> Loadpayments() async {
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Payments+widget.id;
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
            int i=0;
            for (Map user in responseJson['result']['invoices']) {
              _Paymentdetails.add(Paymentdetails.fromJson(user,i));
              i++;
            }
            //teacherslist = responseJson['data'];
          }catch(e){
            _Paymentdetails = new List();
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

  Widget _PaymentPopup(position) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text("Paypal"),
            new Padding(padding: EdgeInsets.only(left: 5),child: new Icon(FontAwesomeIcons.paypal),)
          ],
        )
      ),
      PopupMenuItem(
        value: 2,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text("Amazon"),
            new Padding(padding: EdgeInsets.only(left: 5),child: new Icon(FontAwesomeIcons.amazonPay),)
          ],
        )
      ),
      PopupMenuItem(
        value: 3,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text("Stripe"),
            new Padding(padding: EdgeInsets.only(left: 5),child: new Icon(Icons.payment),)
          ],
        )
      ),
    ],
    elevation: 5,
    padding: EdgeInsets.symmetric(horizontal: 20),
    onSelected: (value) {
      print(value);
      setState(() {

      });
    },
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Manage Payment"),
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
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
              shape: BoxShape.rectangle
            ),
//            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 10,height: 10,),
//                    new Container(
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.orange
//                      ),
//                      child: new SvgPicture.asset("assets/creditcard.svg",color: Colors.white,width: 25,height: 25,),
//                      padding: new EdgeInsets.all(7),
//                    ),
//                    new SizedBox(width: 10,height: 10,),
//                    new Text(widget.studentname,style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search ', border: InputBorder.none),
                onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(
                icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
                onPressed: () {
                  controller.clear();
                  onSearchTextChanged('');
                },
              ),
            ),
          ),
          new SizedBox(width: 10,height: 10,),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 90),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                child: new ListView(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(10),
                      child: new Text("Payment List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                    /*new Padding(padding: new EdgeInsets.all(10),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Text("Title",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),flex: 1,),
                        new Expanded(child: new Text("Description",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        //new Expanded(child: new Text("Amount",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        //new Expanded(child: new Text("Amount Paid",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        new Expanded(child: new Text("Date",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        new Expanded(child: new Text("Status",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        new Expanded(child: new Text("Action",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                      ],
                    )),
                    new Divider(height: 1,color: Colors.grey,),
                    new Expanded(child: _searchResult.length != 0 || controller.text.isNotEmpty ?
                    new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(5),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text("#${_searchResult[index].title}",style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].description,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  //new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].amount,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  //new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].amountpaid,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].date,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].status,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:_PaymentPopup(index)),flex: 1,),
                                ],
                              )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount: _searchResult == null ? 0 : _searchResult.length,
                    ) : _Paymentdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(5),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text("${_Paymentdetails[index].title}",style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Paymentdetails[index].description,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  //new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Paymentdetails[index].amount,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  //new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Paymentdetails[index].amountpaid,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Paymentdetails[index].date,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Paymentdetails[index].status,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:_PaymentPopup(index)),flex: 1,),
                                ],
                              )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount:_Paymentdetails == null ? 0 : _Paymentdetails.length,
                    )
                    ),*/
                  _Paymentdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                 : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text("Title",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Description",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Amount",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Amount Paid",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Date",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Status",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                          DataColumn(
                            label: Text("Action",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0)),
                          ),
                        ],
                        rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                        _searchResult.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text(user.title),
                                ),
                                DataCell(
                                  Text(user.description),
                                ),
                                DataCell(
                                  Text(user.amount),
                                ),
                                DataCell(
                                  Text(user.amountpaid),
                                ),
                                DataCell(
                                  Text(user.date),
                                ),
                                DataCell(
                                  Text(user.status),
                                ),
                                DataCell(
                                  new Padding(padding: EdgeInsets.all(2),child:_PaymentPopup(user.sno)),
                                ),
                              ]),
                        ).toList()
                            : _Paymentdetails.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text(user.title),
                                ),
                                DataCell(
                                  Text(user.description),
                                ),
                                DataCell(
                                  Text(user.amount),
                                ),
                                DataCell(
                                  Text(user.amountpaid),
                                ),
                                DataCell(
                                  Text(user.date),
                                ),
                                DataCell(
                                  Text(user.status),
                                ),
                                DataCell(
                                  new Padding(padding: EdgeInsets.all(2),child:_PaymentPopup(user.sno)),
                                ),
                              ]),
                        ).toList(),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Paymentdetails.forEach((vehicleDetail) {
      if (vehicleDetail.description.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.status.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.title.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Paymentdetails> _searchResult = [];
  List<Paymentdetails> _Paymentdetails = [];

}

class Paymentdetails {
  String  amount, title, description,status,amountpaid,date;
  int sno;

  Paymentdetails({this.sno, this.amount, this.title, this.description,this.status,this.amountpaid,this.date});

  factory Paymentdetails.fromJson(Map<String, dynamic> json, int i) {
    return new Paymentdetails(
        sno : i,
        title: json['title'].toString() ,
        description:  json['description'].toString() ,
        status: json['status'].toString(),
        amount: json['amount'].toString(),
        amountpaid: json['amount_paid'].toString(),
        date: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['creation_timestamp']) * 1000)).toString()
    );
  }
}