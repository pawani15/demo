import 'dart:convert';
import 'dart:io';
import 'package:Edecofy/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';

class ParentPayment extends StatefulWidget {
  final String studentname, studentid;

  ParentPayment({this.studentname, this.studentid});

  @override
  State<StatefulWidget> createState() => new _ParentPaymentePageState();
}

//class _StudentPaymentePageState extends State<StudentPayment>
//{
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return new Scaffold(
//      appBar: new AppBar(
//        backgroundColor: Color(0xff182C61),
//        title: Text("Payment"),
//
//      ),
//      drawer: Constants().drawer(context),
//      body:  Container(
//        width: double.infinity,
//        child: new Center(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                new Text("Comming Soon",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                new SizedBox(width: 10,height: 10,),
//              ],
//            )
//        ),
//      ),
//    );;
//  }
//
//}

class _ParentPaymentePageState extends State<ParentPayment> {
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String clas = '', subject = '', file = '';
  TextEditingController description = new TextEditingController(),
      title = new TextEditingController();
  DateTime date = new DateTime.now();
  Map classmap = new Map(), subjectsmap = new Map();
  List<String> filetypelist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    filetypelist.add("image");
    filetypelist.add("doc");
    filetypelist.add("pdf");
    filetypelist.add("excel");
    filetypelist.add("others");

    LoadFee();
  }

  Future<Null> LoadFee() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() +
        Constants.Parent_paymentView +
        widget.studentid;
    Map<String, String> body = new Map();
    body['student_id'] = widget.studentid;
    print("url is $url" + "body--" + body.toString());
    http
        .post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body)
        .then((response) async {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var resJsonOne = json.decode(response.body);
        if (resJsonOne['status'].toString() == "true") {
          print("response json ${resJsonOne}");
          String id1 = resJsonOne['result'][0]['fee_clctn_id'].toString();
          print(id1);
          var url2 = await Constants().Clienturl() +
              Constants.Parent_paymentFeesCollection +
              id1;
          Map<String, String> body2 = new Map();
          body2['fee_clctn_id'] = id1;
          print("url is $url2" + "body--" + body2.toString());
          http
              .post(url2,
                  headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                  },
                  body: body2)
              .then((response) async {
            if (response.statusCode == 200) {
              print("response -->abc12345 ${response.body}");
              var resJsonTwo = json.decode(response.body);
              if (resJsonTwo['status'].toString() == "true") {
                setState(() {
                  int i = 1;
                  for (Map user in resJsonTwo['result']) {
                    _Homeworkdetails.add(Payments.fromJson(user));
                    i++;
                  }
                });
              }
            }
          });

          try {
            setState(() {
              int i = 1;
              for (Map user in resJsonOne['result']) {
                _Homeworkdetails.add(Payments.fromJson(user));
                i++;
              }
            });
            //teacherslist = responseJson['data'];
          } catch (e) {
            _Homeworkdetails = new List();
          }
        }
        setState(() {
          _loading = false;
        });
      } else {
        print("erroe--" + response.body);
      }
    });
  }

  List<String> classlist = new List(), subjectsslist = new List();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("payment"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),
//        ),
      ),

      drawer: Constants().drawer(context),
      //floatingActionButton: FloatingActionButton(child: new Icon(Icons.add),onPressed: () => Addstudymaterialdialog("refresh","new",null),backgroundColor: Theme.of(context).primaryColor,
      //),
      body: new Stack(
        children: <Widget>[
          new Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle),
            child: new Container(
//                child: Column(
//                  children: <Widget>[
//                    new SizedBox(width: 15,height: 15,),
//                    new Text("Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                    new SizedBox(width: 15,height: 15,),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//
//                        Image(image: AssetImage('assets/refresh_icon.png')),
//                        new Text("Home > Study Material",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                      ],
//                    ),
//
//                  ],
//                )
                ),
          ),
          new Card(
            margin:
                new EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search', border: InputBorder.none),
                //onChanged: onSearchTextChanged,
              ),
//              trailing: new IconButton(
//                icon: new Icon(
//                  Icons.cancel,
//                  color: Theme.of(context).primaryColor,
//                ),
//                onPressed: () {
//                  controller.clear();
//                  //onSearchTextChanged('');
//                },
//              ),
            ),
          ),
          new Container(
              margin:
                  new EdgeInsets.only(left: 10, right: 5, bottom: 10, top: 75),
              child: new Stack(
                children: <Widget>[
                  new Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.only(top: 10, right: 10),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _loading
                        ? new Constants().bodyProgress
                        : new Padding(
                            padding: EdgeInsets.all(10.0),
                            child: new ListView(
                              children: <Widget>[
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 10,
                                    columns: [
//                                  DataColumn(
//                                    label: Text("S.No",style:  TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
//                                  ),
                                      DataColumn(
                                        label: Text(
                                          "Group Name",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Fees Name",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Due Date",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Status",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Amount",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Payment ID",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),

                                      DataColumn(
                                        label: Text(
                                          "Mode",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),

                                      DataColumn(
                                        label: Text(
                                          "Date",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Paid",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Discount",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Fine",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Balance",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),

                                      DataColumn(
                                        label: Text(
                                          "Action",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    ],
                                    rows:
//                                _searchResult.length != 0 || controller.text.isNotEmpty ?
//                                _searchResult.map(
//                                      (user) => DataRow(
//                                      cells: [
//                                        DataCell(
//                                          Text(user.grpName),
//                                        ),
//                                        DataCell(
//                                          Text(user.feeName),
//                                        ),
//                                        DataCell(
//                                          Text(user.dueDate.toString()),
//                                        ),
//                                        DataCell(
//                                          Text(user.status),
//                                        ),
//                                        DataCell(
//                                          Text(user.totalAmount),
//                                        ),
//                                        DataCell(
//                                          user.paymentsInfoId=="null"?Text( ' ' ):
//                                          Text(user.paymentsInfoId),
//                                        ),
//                                        DataCell(
//                                          Text(user.paymentMode),
//                                        ),
//                                        DataCell(
//                                          Text(""),
//                                        ),
//                                        DataCell(
//                                          Text(user.totalPaid),
//                                        ),
//                                        DataCell(
//                                          Text(""),
//                                        ),
//                                        DataCell(
//                                          Text(user.fineAmount),
//                                        ),
//                                        DataCell(
//                                          Text(user.dueAmount),
//                                        ),
//                                        DataCell(
//                                            new InkWell(child: new Container(child :new Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              children: <Widget>[
//                                                new Padding(padding: EdgeInsets.only(right: 5),child: new Text("Download",style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),),),
//                                                new Icon(Icons.cloud_download,color: Colors.white,)
//                                              ],
//                                            ),padding: new EdgeInsets.all(5),
//                                              color: Theme.of(context).primaryColor,
//                                            ),
//                                              onTap: (){
//                                                // Download(user);
//                                              },
//                                            )
//                                        ),
//                                      ]),
//                                )
//                                    .toList()
//                                    :

                                        _Homeworkdetails.map(
                                      (user) => DataRow(cells: [
//                                        DataCell(
//                                          Text(user.no.toString()),
//                                        ),
                                        DataCell(
                                          user.grpName == null
                                              ? Text(" ")
                                              : Text(user.grpName),
                                        ),
                                        DataCell(
                                          user.feeName == null
                                              ? Text(" ")
                                              : Text(user.feeName),
                                        ),
                                        DataCell(
                                          user.dueDate == null
                                              ? Text(" ")
                                              : Text(user.dueDate.toString()),
                                        ),
                                        DataCell(
                                          user.status == null
                                              ? Text(" ")
                                              : Text(user.status),
                                        ),
                                        DataCell(
                                          user.totalAmount == null
                                              ? Text(" ")
                                              : Text(user.totalAmount),
                                        ),
                                        DataCell(
                                          user.paymentsInfoId == null
                                              ? Text(" ")
                                              : Text(user.paymentsInfoId),
                                        ),
                                        DataCell(
                                          user.paymentMode == null
                                              ? Text(" ")
                                              : Text(user.paymentMode),
                                        ),
                                        DataCell(
                                          user.paymentDate == null
                                              ? Text(" ")
                                              : Text(user.paymentDate),
                                        ),
                                        DataCell(
                                          user.totalPaid == null
                                              ? Text(" ")
                                              : Text(user.totalPaid),
                                        ),
                                        DataCell(
                                          user.discountAmount == null
                                              ? Text(" ")
                                              : Text(user.discountAmount
                                                  .toString()),
                                        ),
                                        DataCell(
                                          user.fineAmount == null
                                              ? Text(" ")
                                              : Text(user.fineAmount),
                                        ),
                                        DataCell(
                                          user.dueAmount == null
                                              ? Text(" ")
                                              : Text(user.dueAmount),
                                        ),

                                        DataCell(new InkWell(
                                          child: new Container(
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                new Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: new Text(
                                                    "Download",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                new Icon(
                                                  Icons.cloud_download,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            padding: new EdgeInsets.all(5),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          onTap: () {
                                            //  Download(user);
                                          },
                                        )),
                                      ]),
                                    ).toList(),
                                  ),
                                ),
                              ],
                            )),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  static const MethodChannel _channel =
      const MethodChannel('com.adrav.edecofy/filepicker');

//
//  Future<Null> Download(Paymentdetails paymentdetails) async {
//    String fileurl = await Constants().Clienturl()+"api_students/fees_group_info/"+paymentdetails.fileurl;
//    print("downloadurl--"+paymentdetails.fileurl);
//    if(paymentdetails.fileurl != "null") {
//      Constants().onDownLoading(context);
//      Directory appDocDir = await getExternalStorageDirectory();
//      var path = appDocDir.path;
//      new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
//      String filePath = "$path/Edecofy/${paymentdetails.filename}";
//      File file = new File(filePath);
//      if (!await file.exists()) {
//        var httpClient = new HttpClient();
//        var request = await httpClient.getUrl(
//            Uri.parse(fileurl));
//        var response = await request.close();
//        var bytes = await consolidateHttpClientResponseBytes(response);
//        file.create();
//        await file.writeAsBytes(bytes);
//      }
//      //OpenFile.open(filePath);
//      var args = {'url': filePath};
//      Navigator.of(context).pop();
//      _channel.invokeMethod('openfile', args);
//    }
//    else{
//      Constants().ShowAlertDialog(context, "File not available to download");
//    }
//  }

//  Future<Null> Download(String url,String filename) async {
//    print("downloadurl--" + url);
//    Constants().onDownLoading(context);
//    Directory appDocDir = await getExternalStorageDirectory();
//    var path = appDocDir.path;
//    new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
//    String filePath = "$path/Edecofy/${filename}";
//    File file = new File(filePath);
//    if (!await file.exists()) {
//      var httpClient = new HttpClient();
//      var request = await httpClient.getUrl(Uri.parse(url));
//      var response = await request.close();
//      var bytes = await consolidateHttpClientResponseBytes(response);
//      file.create();
//      await file.writeAsBytes(bytes);
//    }
//    else{
//      Constants().ShowAlertDialog(context, "File not available to download");
//    }
//    //OpenFile.open(filePath);
//    var args = {'url': filePath};
//    Navigator.of(context).pop();
//    _channel.invokeMethod('openfile', args);
//
//
//  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Homeworkdetails.forEach((vehicleDetail) {
      if (vehicleDetail.grpName.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.fineAmount.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.dueDate
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase())) _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Payments> _searchResult = [];
  List<Payments> _Homeworkdetails = [];
}

class Paymentdetails {
  String feesgrp,
      status,
      mode,
      discount,
      feestype,
      amt,
      date,
      fine,
      DueDate,
      paymentid,
      paid,
      bal,
      sno;

  Paymentdetails(
      {this.feesgrp,
      this.status,
      this.mode,
      this.discount,
      this.feestype,
      this.amt,
      this.date,
      this.fine,
      this.DueDate,
      this.paymentid,
      this.paid,
      this.bal,
      this.sno});

  factory Paymentdetails.fromJson(Map<String, dynamic> json, int no) {
    return new Paymentdetails(
//      id: json[''].toString() ,
      feesgrp: json['grp_name'].toString(),
      status: json['res_status'].toString(),
      mode: json['payment_mode'].toString(),
      discount: json['discount_amount'].toString(),
      feestype: json['fee_name'].toString(),
      amt: json['total_paid'].toString(),
      date: new DateFormat('dd-MM-yyyy')
                  .format(new DateTime.fromMillisecondsSinceEpoch(
                      int.tryParse(json['date']) * 1000))
                  .toString() ==
              null
          ? null
          : json['date'].toString(),
      fine: json['fine_amount'].toString(),
      DueDate: new DateFormat('dd-MM-yyyy')
          .format(new DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(json['due_date']) * 1000))
          .toString(),
      paymentid: json['payments_info_id'].toString() == null
          ? null
          : json['payments_info_id'].toString(),
      paid: json['total_paid'].toString(),
      bal: json['due_amount'].toString(),
      sno: no.toString(),
    );
  }
}

Payments paymentsFromJson(String str) => Payments.fromJson(
      json.decode(str),
    );

String paymentsToJson(Payments data) => json.encode(
      data.toJson(),
    );

class Payments {
  String grpName;
  String feeName;
  String dueDate;
  int discountAmount;
  String status;
  String totalAmount;
  String detailedInvoiceId;
  String paymentsInfoId;
  String paymentDate;
  String paymentMode;
  String paymentAmount;
  String totalPaid;
  String fineAmount;
  String dueAmount;
  int no;

  Payments({
    this.grpName,
    this.feeName,
    this.dueDate,
    this.discountAmount,
    this.status,
    this.totalAmount,
    this.detailedInvoiceId,
    this.paymentsInfoId,
    this.paymentDate,
    this.paymentMode,
    this.paymentAmount,
    this.totalPaid,
    this.fineAmount,
    this.dueAmount,
    this.no,
  });

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        grpName: json["grp_name"] == null ? null : json["grp_name"],
        feeName: json["fee_name"] == null ? null : json["fee_name"],
        dueDate: json["due_date"] == null ? null : json["due_date"],
        discountAmount:
            json["discount_amount"] == null ? null : json["discount_amount"],
        status: json["res_status"] == null ? null : json["res_status"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        detailedInvoiceId: json["detailed_invoice_id"] == null
            ? null
            : json["detailed_invoice_id"],
        paymentsInfoId:
            json["payments_info_id"] == null ? null : json["payments_info_id"],
        paymentDate: json["payment_date"] == null ? null : json["payment_date"],
        paymentMode: json["payment_mode"] == null ? null : json["payment_mode"],
        paymentAmount:
            json["payment_amount"] == null ? null : json["payment_amount"],
        totalPaid: json["total_paid"] == null ? null : json["total_paid"],
        fineAmount: json["fine_amount"] == null ? null : json["fine_amount"],
        dueAmount: json["due_amount"] == null ? null : json["due_amount"],
      );

  Map<String, dynamic> toJson() => {
        "grp_name": grpName == null ? null : grpName,
        "fee_name": feeName == null ? null : feeName,
        "due_date": dueDate == null ? null : dueDate,
        "status": status == null ? null : status,
        "total_amount": totalAmount == null ? null : totalAmount,
        "detailed_invoice_id":
            detailedInvoiceId == null ? null : detailedInvoiceId,
        "payments_info_id": paymentsInfoId == null ? null : paymentsInfoId,
        "payment_date": paymentDate == null ? null : paymentDate,
        "payment_mode": paymentMode == null ? null : paymentMode,
        "payment_amount": paymentAmount == null ? null : paymentAmount,
        "total_paid": totalPaid == null ? null : totalPaid,
        "fine_amount": fineAmount == null ? null : fineAmount,
        "due_amount": dueAmount == null ? null : dueAmount,
      };
}
