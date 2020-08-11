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
import '../dashboard.dart';

class StudentTransport extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StudentTransportPageState();
}

class _StudentTransportPageState extends State<StudentTransport> with SingleTickerProviderStateMixin{

  TabController _tabController;
  bool _loading = false;
  TextEditingController controller = new TextEditingController();
  String clas = '' , subject = '',file =''; TextEditingController description=new TextEditingController(),
      title=new TextEditingController();
  DateTime date = new DateTime.now();
   Map classmap= new Map(),subjectsmap = new Map();
  List<String> filetypelist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
//    filetypelist.add("image");
//    filetypelist.add("doc");
//    filetypelist.add("pdf");
//    filetypelist.add("excel");
//    filetypelist.add("others");

    LoadTransport();
  }


  Future<Null> LoadTransport() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_student_transportdetails+id;
    Map<String, String> body = new Map();
    body['student_id'] = id;
    print("url is $url"+"body--"+body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          try {
            for (Map user in responseJson['result']) {
              _Transportdetails.add(Transportdetails.fromJson(user));
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

//  List<String> classlist= new List(),subjectsslist= new List();


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
      appBar:
      new AppBar(
        title: Text("Transport"),
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

          new Stack(
            children: <Widget>[
              new Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
                    shape: BoxShape.rectangle
                ),
                child: new Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:18.0),
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              new Text("Subject ",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                              SizedBox(height: 5 ,width: 10,),
//                              Padding(
//                                padding: const EdgeInsets.only(left:120.0),
//                                child: Row(
//                                  children: <Widget>[
//                                    Image.asset('assets/refresh_icon.png',),
//                                    SizedBox( width: 10,),
//                                    new Text("Home > Subject",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                                  ],
//                                ),
//                              ),
//
//                            ],
//                          ),
                        )
                      ],
                    )

                ),
              ),
              new Card(
                margin: new EdgeInsets.only(left: 20,right: 20,bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 5,
                child: new ListTile(
                  leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search ', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
//                  trailing: new IconButton(
//                    icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//                    onPressed: () {
//                      controller.clear();
//                      onSearchTextChanged('');
//                    },
//                  ),
                ),
              ),
              new Card(
                elevation: 5.0,
                margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top:70),
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: _loading ? new Constants().bodyProgress :  new Padding(padding: EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                          child: new Text("Transport List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                        ),
                        new Divider(height: 16,color: Theme.of(context).primaryColor,),
                        new Padding(padding: new EdgeInsets.all(5),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Route Name",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                                new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Number Of Vehicle",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                                new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Description",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                                new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text("Route Fare",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
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
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_searchResult[index].routename,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_searchResult[index].numvehicle,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_searchResult[index].description,style: TextStyle(color: Colors.black,fontSize: 11),maxLines: 2,textAlign: TextAlign.center),),flex: 1,),
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_searchResult[index].routefare,style: TextStyle(color: Colors.black,fontSize: 11),maxLines: 2,textAlign: TextAlign.center),),flex: 1,),
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
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Transportdetails[index].routename,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Transportdetails[index].numvehicle,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                      new Expanded(child: new Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        child: GestureDetector(child: new Text(
                                            _Transportdetails[index]
                                                .description,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11),
                                            maxLines: 2,
                                            textAlign: TextAlign.center),
                                          onTap: () {
                                            setState(() {
                                              _showDialog(context, index);
                                            });
                                          },

                                        ),
                                      ), flex: 1,),

                                      new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),child:new Text(_Transportdetails[index].routefare,style: TextStyle(color: Colors.black,fontSize: 11),maxLines: 2,textAlign: TextAlign.center),),flex: 1,),

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
          )
        ],
      ),
    );
  }

//  static const MethodChannel _channel = const MethodChannel('com.adrav.edecofy/filepicker');

//  Future<Null> Download(Homeworkdetails homeworkdetails) async {
//    String fileurl = await Constants().Clienturl()+"api_students/download_home_work/"+homeworkdetails.fileurl;
//    print("downloadurl--"+homeworkdetails.fileurl);
//    if(homeworkdetails.fileurl != "null") {
//      Constants().onDownLoading(context);
//      Directory appDocDir = await getExternalStorageDirectory();
//      var path = appDocDir.path;
//      new Directory(appDocDir.path + '/' + 'Edecofy').create(recursive: true);
//      String filePath = "$path/Edecofy/${homeworkdetails.filename}";
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

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Transportdetails.forEach((vehicleDetail) {
      if (vehicleDetail.routename.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.numvehicle.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.routefare.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });


    setState(() {});
  }
  List<Transportdetails> _searchResult = [];
  List<Transportdetails> _Transportdetails = [];

}

class Transportdetails {
  String  description, transid,routename,numvehicle,routefare;
  Transportdetails({this.transid, this.routename, this.numvehicle, this.description,this.routefare});
  factory Transportdetails.fromJson(Map<String, dynamic> json) {
    return new Transportdetails(
//      id: json[''].toString() ,
      transid: json['transport_id'].toString(),
      routename:  json['route_name'].toString() ,
      numvehicle: json['number_of_vehicle'].toString(),
      description: json['description'].toString(),
      routefare: json['route_fare'].toString(),

    );
  }
}