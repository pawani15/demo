import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'const.dart';
import 'dashboard.dart';

class StudentinvoicesPage extends StatefulWidget {
  final String id;
  StudentinvoicesPage({this.id});

  @override
  State<StatefulWidget> createState() => new _StudentinvoicesPageState();
}

class _StudentinvoicesPageState extends State<StudentinvoicesPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = false;
    });
    //Loadpayments();
    int i=0;
    Map<String,dynamic> data = new Map();
    data['creation_timestamp'] = "1512323232";
    data['title'] = "muni";
    data['amount'] = "233";
    data['amount_paid'] = "1";
    data['status'] = "paid";
    List list = new List();
    list.add(data);
    list.add(data);
    list.add(data);

    for (Map user in list) {
      _Studentinvoicedetails.add(Studentinvoicedetails.fromJson(user,i));
      i++;
    }
  }

  Future<Null> Loadpayments() async {
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Payments+"15";
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
            for (Map user in responseJson['result']['invoices'] ) {
              _Studentinvoicedetails.add(Studentinvoicedetails.fromJson(user,i));
              i++;
            }
          }catch(e){
            _Studentinvoicedetails = new List();
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
            new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(FontAwesomeIcons.paypal,color: Theme.of(context).primaryColor),),
            new Text("Paypal"),
          ],
        )
      ),
      PopupMenuItem(
        value: 2,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(right: 5),child: new Text("U",style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Theme.of(context).primaryColor),),),
            new Text("Pay U Money"),
          ],
        )
      ),
      PopupMenuItem(
        value: 3,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(right: 5),child: new Icon(Icons.payment,color: Theme.of(context).primaryColor),),
            new Text("Stripe"),
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
        title: Text("Invoice List"),
        backgroundColor: Color(0xff182C61),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () =>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(),),
          ),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
              shape: BoxShape.rectangle
            ),
            child: new Container(
                child: Column(
                  children: <Widget>[
                    new SizedBox(width: 10,height: 10,),
                    new Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange
                      ),
                      child: new SvgPicture.asset("assets/creditcard.svg",color: Colors.white,width: 25,height: 25,),
                      padding: new EdgeInsets.all(7),
                    ),
                    new SizedBox(width: 10,height: 10,),
                    new Text("Invoice List",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 90),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search your things..', border: InputBorder.none),
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
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 160),
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
                      child: new Text("Invoice List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                    _Studentinvoicedetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                              label: Text("Student"),
                          ),
                          DataColumn(
                            label: Text("Amount"),
                          ),
                          DataColumn(
                            label: Text("Amount Paid"),
                          ),
                          DataColumn(
                            label: Text("Date"),
                          ),
                          DataColumn(
                            label: Text("Status"),
                          ),
                          DataColumn(
                            label: Text("Action"),
                          ),
                        ],
                        rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                        _searchResult.map(
                              (user)  {
                                Color color =  Colors.green;
                                return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(user.name),
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
                                          new Container(
                                            decoration: BoxDecoration(
                                                color: color,
                                                borderRadius: BorderRadius.all(Radius.circular(15))
                                            ),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                new Padding(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text(user.status,style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                                new Padding(padding: EdgeInsets.only(right: 15,left: 5,top: 5,bottom: 5), child: new Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                  ),
                                                  padding: EdgeInsets.all(3),
                                                  child: new Icon(FontAwesomeIcons.rupeeSign,color: color,size: 15,),
                                                ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      DataCell(
                                        new Padding(padding: EdgeInsets.all(2),child:_PaymentPopup(user.sno)),
                                      ),
                                    ]);
                              },
                        ).toList()
                            :  _Studentinvoicedetails.map(
                              (user) {
                                Color color =  Colors.green;
                                 return DataRow(
                              cells: [
                                DataCell(
                                  Text(user.name),
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
                                    new Container(
                                      decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Padding(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text(user.status,style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),),),
                                          new Padding(padding: EdgeInsets.only(right: 15,left: 5,top: 5,bottom: 5), child: new Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white
                                            ),
                                            padding: EdgeInsets.all(3),
                                            child: new Icon(FontAwesomeIcons.rupeeSign,color: color,size: 15,),
                                          ),
                                          )
                                        ],
                                      ),
                                    )
                                ),
                                DataCell(
                                  new Padding(padding: EdgeInsets.all(2),child:_PaymentPopup(user.sno)),
                                ),
                              ]);
                                  },
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

    _Studentinvoicedetails.forEach((vehicleDetail) {
      if (vehicleDetail.description.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.status.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Studentinvoicedetails> _searchResult = [];
  List<Studentinvoicedetails> _Studentinvoicedetails = [];

}

class Studentinvoicedetails {
  String  amount, name, description,status,amountpaid,date;
  int sno;

  Studentinvoicedetails({this.sno, this.amount, this.name, this.description,this.status,this.amountpaid,this.date});

  factory Studentinvoicedetails.fromJson(Map<String, dynamic> json, int i) {
    return new Studentinvoicedetails(
        sno : i,
        name: json['title'].toString() ,
        //description:  json['description'].toString() ,
        status: json['status'].toString(),
        amount: json['amount'].toString(),
        amountpaid: json['amount_paid'].toString(),
        date: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['creation_timestamp']) * 1000)).toString()
    );
  }
}