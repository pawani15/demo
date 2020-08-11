import 'package:Edecofy/Student/student_private_message.dart';
import 'package:Edecofy/const.dart';
import 'package:Edecofy/dashboard.dart';
import 'package:Edecofy/prrivatemessages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';


class StudentPrivatechatPage extends StatefulWidget {
  final StudentMessageDetails messageDetails;
  StudentPrivatechatPage({this.messageDetails});
  @override
  State<StatefulWidget> createState() => new _StudentPrivatechatPageState();
}

class _StudentPrivatechatPageState extends State<StudentPrivatechatPage>
    with SingleTickerProviderStateMixin {
  String message = "";
  bool _loading = false;
  List chatlist = new List();
  TextEditingController messasecont = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  String id = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadPrivatemessages("up");
  }

  Future<Null> LoadPrivatemessages(String d) async {
    id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Student_Load_Privateuserschat+widget.messageDetails.messagethread ;
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
              chatlist = responseJson['result'];
              if(d == "down") {
                messasecont.text = '';
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              }
            });
          }catch(e){
            chatlist = new List();
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

  Future<Null> Sendmessage(BuildContext context) async {
    String id = await sp.ReadString("Userid");
    if(messasecont.text == ""){
      Constants().ShowAlertDialog(context, "Please fill message");
      return;
    }
    Constants().onLoading(context);
    var url = await Constants().Clienturl() + Constants.Student_Send_Privatechat+widget.messageDetails.messagethread;
    Map<String, String> body = new Map();
    body['student_id'] = id;
    body['type_page']="send_reply";
   // body[Constants.logintype == "student" ? 'login_user_id' : 'parent_id'] = id;
    body['message'] = messasecont.text;
    body['attached_file_on_messaging'] = widget.messageDetails.messagethread;
    print("url is $url"+"body--"+body.toString());
    http.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        Navigator.of(context).pop();
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['result']['status'].toString() == "true") {
          print("response json ${responseJson}");
          LoadPrivatemessages("down");
        }
        else{
          Constants().ShowAlertDialog(context, responseJson[''][''].toString());
        //  Constants().ShowAlertDialog(context, responseJson['result']['message'].toString());
        }
      }
      else {
        Navigator.of(context).pop();
        print("erroe--"+response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading ? new Constants().bodyProgress : new Scaffold(
      appBar: new AppBar(
        title: Text("Message System"),
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
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
                shape: BoxShape.rectangle
            ),
            child: new Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Private Messages", style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),),
                    new SizedBox(width: 10, height: 10,),
                  ],
                )
            ),
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(
                left: 10, right: 10, bottom: 10, top: 90),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(child: ClipOval(
                      child: new Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/1024px-User_icon_2.svg.png",
                        fit: BoxFit.fill,),
                    ), flex: 2,),
                    new Expanded(child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Padding(padding: new EdgeInsets.all(5),
                                child: new Text(widget.messageDetails.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),)),
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.all(5),
                            child: new Text(
                              widget.messageDetails.message, maxLines: 1,
                              overflow: TextOverflow.ellipsis,))
                      ],
                    ), flex: 6,),
                    new Expanded(child: new Container(
                      padding: new EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 20),
                      child: new Text(widget.messageDetails.date,),
                      alignment: Alignment.bottomLeft,), flex: 2,
                    )
                  ],
                ),
                new Container(
                  margin: EdgeInsets.all(5),
                  color: Colors.grey[200],
                  height: 3,
                ),
                new Expanded(child: new ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                      children: <Widget>[
                        chatlist[index]['id'].toString() != id ? new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Expanded(child:
                            new Column(
                              children: <Widget>[ new Container(
                                decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 5),
                                child: new Text(chatlist[index]['message'],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.white),),
                              ),
                                new Text(new DateFormat('MMM dd').format(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                        int.tryParse(
                                            chatlist[index]['timestamp']) *
                                            1000)).toString()),
                              ],),
                              flex: 1,),
                            new Expanded(child: new Container(), flex: 1,),
                          ],) :
                        new Row(crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Expanded(child: new Container(), flex: 1,),
                            new Expanded(child:
                            new Column(children: <Widget>[
                              new Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                child: new Text(chatlist[index]['message'],
                                  textAlign: TextAlign.end,),
                              ),
                              new Text(new DateFormat('MMM dd')
                                  .format(
                                  new DateTime.fromMillisecondsSinceEpoch(
                                      int.tryParse(
                                          chatlist[index]['timestamp']) * 1000))
                                  .toString()),
                            ],),
                              flex: 1,),
                          ],)
                      ],
                    );
                  },
                  itemCount: chatlist.length,
                )),
                new Container(child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type your message here",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        style: TextStyle(height: 0.5),
                        controller: messasecont,
                      ), flex: 8,
                    ),
                    new Expanded(child: new IconButton(icon: Icon(Icons.image,
                      color: Theme
                          .of(context)
                          .primaryColor,), onPressed: null), flex: 1,),
                    new Expanded(child: new IconButton(icon: Icon(Icons.send,
                      color: Theme
                          .of(context)
                          .primaryColor,), onPressed: () => Sendmessage(context)), flex: 1,),
                  ],
                ), margin: EdgeInsets.all(5),),
              ],
            ),
          )
        ],
      ),
    );
  }

}