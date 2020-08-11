import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'const.dart';
import 'dashboard.dart';

class TransportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TransportPageState();
}

class _TransportPageState extends State<TransportPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadtransports();
  }

  Future<Null> Loadtransports() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Transport;
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
            int i =1;
            for (Map user in responseJson['result']) {
              _Transportdetails.add(Transportdetails.fromJson(user,i));
              i++;
            }
          }catch(e){
            _Transportdetails = new List();
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


  Future<void> _showDialog(BuildContext context, int index) {
    //you have to pass index value here ok
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Description'),
          content: Text(_Transportdetails[index].description),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Transport"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () =>  Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => DashboardPage(),),
//          ),ge
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
//                    new SizedBox(width: 15,height: 15,),
//                    new Container(
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        color: Colors.orange
//                      ),
//                      child: new Icon(Icons.directions,color: Colors.white,size: 25,),
//                      padding: new EdgeInsets.all(5),
//                      margin: EdgeInsets.all(5),
//                    ),
//                    new Text("Transport",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                  ],
//                )
//            ),
          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search...', border: InputBorder.none),
                onChanged: onSearchTextChanged,
              ),
//              trailing: new IconButton(
//                icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                onPressed: () {
//                  controller.clear();
//                  onSearchTextChanged('');
//                },
//              ),
            ),
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 90),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                      child: new Text("Transport Details",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                    new Padding(padding: new EdgeInsets.all(5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("Route Name",style:  TextStyle(color: Theme.of(context).primaryColor,fontSize: 15.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("Vehicle No",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("Description",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("Route Fare",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_searchResult[index].routename,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_searchResult[index].vehno,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_searchResult[index].description,style: TextStyle(color: Colors.grey,fontSize: 11),maxLines: 2,textAlign: TextAlign.center),),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_searchResult[index].fare,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                ],
                          )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount: _searchResult == null ? 0 : _searchResult.length,
                    ) : _Transportdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(5),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_Transportdetails[index].routename,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_Transportdetails[index].vehno,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 6),
                                    child: GestureDetector(child: new Text(
                                        _Transportdetails[index].description,
                                        overflow: TextOverflow.ellipsis
                                        ,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11),
                                        maxLines: 2,
                                        textAlign: TextAlign.center),
                                      onTap: () {
                                        setState(() {
                                          _showDialog(context, index);
                                        });
                                      },
                                    )
                                    ,), flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_Transportdetails[index].fare,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                ],
                              )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount:_Transportdetails == null ? 0 : _Transportdetails.length,
                    )
                    )
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

    _Transportdetails.forEach((vehicleDetail) {
      if (vehicleDetail.vehno.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.routename.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Transportdetails> _searchResult = [];
  List<Transportdetails> _Transportdetails = [];

}

class Transportdetails {
  String routename, vehno, description, fare;
  Transportdetails({this.routename, this.vehno, this.description, this.fare});
  factory Transportdetails.fromJson(Map<String, dynamic> json,int no) {
    return new Transportdetails(
        vehno: json['number_of_vehicle'].toString(),
        description: json['description'].toString() ,
        fare : json['route_fare'].toString(),
        routename: json['route_name'].toString()
    );
  }
}