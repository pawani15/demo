import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'const.dart';
import 'dashboard.dart';

class TeachersformationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TeachersformationPageState();
}

class _TeachersformationPageState extends State<TeachersformationPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  List teacherslist;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Loadteachers();
  }

  Future<Null> Loadteachers() async {
    String empid = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Teachers;
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
            for (Map user in responseJson['data']) {
              _Teacherdetails.add(Teacherdetails.fromJson(user));
            }
            //teacherslist = responseJson['data'];
          }catch(e){
            _Teacherdetails = new List();
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
        title: Text("Teachers"),
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
//                height: 110,
//                width: double.infinity,
//                decoration: BoxDecoration(
//                    color: Color(0xff182C61),
//                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
//                    shape: BoxShape.rectangle
//                ),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    new Text("Teacher Information ",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                    SizedBox(height: 5 ,width: 10,),
//                    Padding(
//                      padding: const EdgeInsets.only(left:120.0),
//                      child: Row(
//                        children: <Widget>[
//                          Image.asset('assets/refresh_icon.png',),
//                          SizedBox( width: 10,),
//                          new Text("Home > Teachers",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                        ],
//                      ),
//                    ),
//
//                  ],
//                ),
//              )

          ),
          new Card(
            margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 5,
            child: new ListTile(
              leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
              title: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                    hintText: 'Search ..', border: InputBorder.none),
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
                child: new ListView(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                      child: new Text("Teachers List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                    /*new Padding(padding: new EdgeInsets.all(5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Text("Teacher ID",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        new Expanded(child: new Text("Photo",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        new Expanded(child: new Text("Name",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        new Expanded(child: new Text("Email",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
                        new Expanded(child: new Text("Phone",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),flex: 1,),
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
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text("#${_searchResult[index].id}",style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: ClipOval(
                                    child: new Image.network(_searchResult[index].photo,fit: BoxFit.fill,),
                                  ),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].name,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].email,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_searchResult[index].phone,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                ],
                              )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount: _searchResult == null ? 0 : _searchResult.length,
                    ) : _Teacherdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(5),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text("#${_Teacherdetails[index].id}",style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: ClipOval(
                                    child: new Image.network(_Teacherdetails[index].photo,fit: BoxFit.fill,),
                                  ),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Teacherdetails[index].name,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Teacherdetails[index].email,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.all(2),child:new Text(_Teacherdetails[index].phone,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                ],
                              )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount:_Teacherdetails == null ? 0 : _Teacherdetails.length,
                    )
                    ),
*/
                    _Teacherdetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        :
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: Text("ID No",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Container(child: Text("Photo",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15.0)),margin: EdgeInsets.all(10),),
                          ),
                          DataColumn(
                            label: Text("Name",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Email/Username",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),),
                          ),
                          DataColumn(
                            label: Text("Phone No",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15.0),),
                          ),
                        ],
                        rows: _searchResult.length != 0 || controller.text.isNotEmpty ?
                        _searchResult.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text(""+user.id),
                                ),
                                DataCell(
                                  new Container(
                                    width: 35.0,
                                    height: 35.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(user.photo)
                                        ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.all(10),
                                  ),
                                ),
                                DataCell(
                                  Text(user.name),
                                ),
                                DataCell(
                                  Text(user.email),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () {
                                        _launchCaller(user.phone);
                                        // UrlLauncher.launch("tel://<phone_number>");
                                        // UrlLauncher.launch(user.phone);
                                      },
                                      child: Text(user.phone)

                                  ),
                                ),
                              ]),
                        ).toList()
                            : _Teacherdetails.map(
                              (user) => DataRow(
                              cells: [
                                DataCell(
                                  Text(""+user.id),
                                ),
                                DataCell(
                                  /*ClipOval(
                                      child: new Image.network(user.photo,fit: BoxFit.fill,),
                                    )*/
                                  new Container(
                                    width: 35.0,
                                    height: 35.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(user.photo)
                                        ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.all(10),
                                  ),
                                ),
                                DataCell(
                                  Text(user.name),
                                ),
                                DataCell(
                                  GestureDetector(
                                      onTap: () {
                                        _launchMail(user.email);
                                        // UrlLauncher.launch("tel://<phone_number>");
                                        // UrlLauncher.launch(user.phone);
                                      },
                                      child: Text(user.email)

                                  ),
                                ),


                                DataCell(
                                  GestureDetector(
                                      onTap: () {
                                        _launchCaller(user.phone);
                                        // UrlLauncher.launch("tel://<phone_number>");
                                        // UrlLauncher.launch(user.phone);
                                      },
                                      child: Text(user.phone)

                                  ),
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

  _launchCaller(String phn ) async {
     var url = "tel:$phn";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMail(String email ) async {
    var url = "mailto:$email";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Teacherdetails.forEach((vehicleDetail) {
      if (vehicleDetail.phone.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.email.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.id.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Teacherdetails> _searchResult = [];
  List<Teacherdetails> _Teacherdetails = [];


}



class Teacherdetails {
  String sno, photo, name, phone,email,file,id;

  Teacherdetails({this.sno, this.photo, this.name, this.phone,this.email,this.file,this.id});

  factory Teacherdetails.fromJson(Map<String, dynamic> json) {
    return new Teacherdetails(
        photo: json['photo'].toString(),
        name: json['name'].toString() ,
        id:  json['teacher_id'].toString() ,
        phone:  json['phone'].toString() ,
        email: json['email'].toString()
    );
  }
}
