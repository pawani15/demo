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

class NoticeboardPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _NoticeboardPageState();
}

class _NoticeboardPageState extends State<NoticeboardPage> with SingleTickerProviderStateMixin{
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
    LoadNoticeBoard();
  }

  Future<Null> LoadNoticeBoard() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Noticeboard;
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
              _Noticeboarddetails.add(Noticeboarddetails.fromJson(user,i));
              i++;
            }
          }catch(e){
            _Noticeboarddetails = new List();
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

  displaynotice(Noticeboarddetails noticeboarddetails) async{
    Constants().onLoading(context);
    Map body = new Map();
    var  url = await Constants().Clienturl() + Constants.View_Notice+noticeboarddetails.id;
    print("url--"+url+'body is${json.encode(body)} $body');
    http.post(url,headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true") {
          print("response json ${responseJson}");
          List list = responseJson['result']['view_data'];
          if(list.length > 0)
            displayNoticedialog(list);
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  displayNoticedialog(List notice) async {
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
                              Icons.warning,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 2),
                          ),flex: 2,
                        ),
                        Expanded(
                          child: new Container(child: new Text("Notice Deatils",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),margin: EdgeInsets.only(left: 5),),flex: 7,
                        ),
                        Expanded(
                          child: new InkWell(child: Icon(Icons.close,color: Colors.red,size: 25,), onTap: () => Navigator.of(context).pop()),flex: 1,
                        )
                      ],)),
                new SizedBox(height: 20,width: 20,),
                new Container(margin: EdgeInsets.all(5.0),
                    child:new Column(
                      children: <Widget>[
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Title:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(notice[0]['notice_title'].toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],),
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Notice:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(notice[0]['notice'].toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],),
                        new Container(margin: EdgeInsets.all(5),child:
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Text("Date:",style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold)),flex: 3,
                            ),
                            Expanded(
                              child: new Text(new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(notice[0]['create_timestamp']) * 1000)).toString(),style: TextStyle(color: Theme.of(context).primaryColor)),flex: 7,
                            )
                          ],
                        )),
                        new Divider(height: 1,color: Colors.grey[300],)
                      ],
                    )),
                new SizedBox(width: 30,height: 30,),
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
                                  Constants().ShowAlertDialog(context, "Coming Soon!");
                                },
                                child: new Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(15),
                                            bottomLeft:
                                            Radius.circular(15))),
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
                                            "Print",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold,
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
            )

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Notice Board"),
        backgroundColor: Color(0xff182C61),
//        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
//          onPressed: () => Navigator.push(
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
//                    new SizedBox(width: 15,height: 15,),
//                    new Container(
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        color: Colors.orange
//                      ),
//                      child: new Icon(FontAwesomeIcons.stickyNote,color: Colors.white,size: 25,),
//                      padding: new EdgeInsets.all(5),
//                      margin: EdgeInsets.all(5),
//                    ),
//                    new Text("Notice Board",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
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
                    hintText: 'Search your things..', border: InputBorder.none),
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
            margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 100),
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
                      child: new Text("Noticeboard List",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    ),
                    new Divider(height: 16,color: Theme.of(context).primaryColor,),
                    new Padding(padding: new EdgeInsets.all(5),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("#",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 1,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("Title",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 2,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("Notice",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 3,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("Date",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 2,),
                        new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("View Notice",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),flex: 2,),
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
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("${_searchResult[index].sno}",style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_searchResult[index].title,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 2,),
                              new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_searchResult[index].notice,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center,maxLines: 2,),),flex: 3,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_searchResult[index].date,style: TextStyle(color: Colors.grey,fontSize: 11),textAlign: TextAlign.center)),flex: 2,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child: new InkWell(child: new Container(child :new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //new Padding(padding: EdgeInsets.only(right: 5),child: new Text("Download",style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),),),
                                      new Icon(Icons.remove_red_eye,color: Colors.white,size: 12,)
                                    ],
                                  ),padding: new EdgeInsets.all(5),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                    onTap: (){
                                      displaynotice(_searchResult[index]);
                                    },
                                  )),flex: 2,),
                                ],
                          )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount: _searchResult == null ? 0 : _searchResult.length,
                    ) : _Noticeboarddetails.length == 0 ? new Container(child: new Center(child: new Text("No Records found",style: new TextStyle(fontSize: 16.0,color: Colors.red))))
                        : new ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.all(5),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text("${_Noticeboarddetails[index].sno}",style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 1,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_Noticeboarddetails[index].title,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 2,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_Noticeboarddetails[index].notice,style: TextStyle(color: Colors.black,fontSize: 11),maxLines: 2,textAlign: TextAlign.center),),flex: 3,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child:new Text(_Noticeboarddetails[index].date,style: TextStyle(color: Colors.black,fontSize: 11),textAlign: TextAlign.center)),flex: 3,),
                                  new Expanded(child: new Padding(padding: EdgeInsets.symmetric(horizontal: 3,vertical: 6),child: new InkWell(child: new Container(child :new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //new Padding(padding: EdgeInsets.only(right: 5),child: new Text("Download",style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),),),
                                      new Icon(Icons.remove_red_eye,color: Colors.white,size:12)
                                    ],
                                  ),padding: new EdgeInsets.all(5),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                    onTap: (){
                                    displaynotice(_Noticeboarddetails[index]);
                                    },
                                  )),flex: 2,),
                                ],
                              )),
                          new Divider(height: 1,color: Colors.grey,),
                        ],
                      );
                    },itemCount:_Noticeboarddetails == null ? 0 : _Noticeboarddetails.length,
                    )
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  Future<Null> Downloadsyllabus(String syllabuscode) async {
    var url = await Constants().Clienturl()+Constants.DownloadSyllabus+syllabuscode;
    print("downloadurl--"+url);
    Constants().onDownLoading(context);
    Directory appDocDir = await getExternalStorageDirectory();
    var path =appDocDir.path;
    new Directory(appDocDir.path+'/'+'Edecofy').create(recursive: true);
    String appDocPath = "$path/Edecofy/$syllabuscode.pdf";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    File file = new File(appDocPath);
    if(!await file.exists())
      file.create();
    await file.writeAsBytes(bytes);
    var filePath = '/$path/Edecofy/${syllabuscode}.pdf';
    print(filePath);
    //OpenFile.open(filePath);
    var openfile = "file://${file.path}";
    var args = {'url': filePath};
    Navigator.of(context).pop();
    //platform.invokeMethod('viewPdf', args);
  }


  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _Noticeboarddetails.forEach((vehicleDetail) {
      if (vehicleDetail.sno.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.title.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.notice.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.date.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<Noticeboarddetails> _searchResult = [];
  List<Noticeboarddetails> _Noticeboarddetails = [];

}

class Noticeboarddetails {
  String sno, title, notice, subject,uploader,date,file,id;

  Noticeboarddetails({this.sno, this.title, this.notice, this.subject,this.uploader,this.date,this.file,this.id});

  factory Noticeboarddetails.fromJson(Map<String, dynamic> json,int no) {
    return new Noticeboarddetails(
        title: json['notice_title'].toString(),
        notice: json['notice'].toString() ,
        date: new DateFormat('dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['create_timestamp']) * 1000)).toString(),
        id:  json['notice_id'].toString() ,
        sno: no.toString()
    );
  }
}