import 'package:Edecofy/Admin/message_admin.dart';
import 'package:Edecofy/Admin/admin_group_chat.dart';
import 'package:Edecofy/Admin/admin_private_chat.dart';
import 'package:Edecofy/const.dart';
import 'package:Edecofy/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AdminPrivatemessagesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AdminPrivatemessagesPageState();
}

class _AdminPrivatemessagesPageState extends State<AdminPrivatemessagesPage>
    with SingleTickerProviderStateMixin {


  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Message System"),
        backgroundColor: Color(0xff182C61),
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
          ),
          new Card(
            elevation: 5.0,
            margin: new EdgeInsets.only(
                left: 10, right: 10, bottom: 10, top: 40),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: new DefaultTabController(
              length: 3,
              child: new Scaffold(
                appBar: TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: Theme
                      .of(context)
                      .primaryColor,
                  tabs: [
                    new Tab(text: "New Messages", icon: Icon(Icons.message),),
                    new Tab(text: "Group Messages", icon: Icon(Icons.group)),
                  ],
                  controller: _tabController,
                  indicatorColor: Theme
                      .of(context)
                      .primaryColor,
                ),
                body: TabBarView(
                  children: [
                    new NewMessages(),
                    new GroupMessages(),
                  ],
                  controller: _tabController,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}

class NewMessages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  TextEditingController controller = new TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadPrivatemessages();
  }

  Future<Null> LoadPrivatemessages() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() +
        Constants.Admin_Load_Privateusers;
    Map<String, String> body = new Map();
    body['admin_id'] = id;
    print("url is $url" + "body--" + body.toString());
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
              _MessageDetails.add(AdminMessageDetails.fromJson(user));
            }
          } catch (e) {
            _MessageDetails = new List();
          }
        }
        setState(() {
          _loading = false;
        });
      }
      else {
        print("erroe--" + response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading ? new Constants().bodyProgress : new Stack(
      children: <Widget>[
        new Container(padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 20, right: 20),
            child: new Column(
              children: <Widget>[

                new SizedBox(width: 5, height: 5,),
                new Expanded(child: new ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                      children: <Widget>[
                        new InkWell(child: new Row(
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    new Padding(padding: new EdgeInsets.all(5),
                                        child: new Text(
                                          _MessageDetails[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),)),
                                    new Padding(padding: new EdgeInsets.all(5),
                                        child: new Text(
                                            _MessageDetails[index].date))
                                  ],
                                ),
                                new Padding(padding: new EdgeInsets.all(5),
                                    child: new Text(
                                      _MessageDetails[index].message,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,))
                              ],
                            ), flex: 8,),
                          ],
                        ),
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new AdminPrivatechatPage(messageDetails: _MessageDetails[index],)));
                          },
                        ),
                        new SizedBox(width: 5, height: 5,),
                        new Divider(height: 1, color: Colors.grey,),
                      ],
                    );
                  }, itemCount: _MessageDetails.length,
                ))
              ],
            )),
        new Align(
          alignment: Alignment.bottomRight,
          child: new InkWell(child: new Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: new Icon(Icons.message, color: Colors.white, size: 30,),
          ), onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                new AdminMessagesystem()));
          },
          ),
        )
      ],
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _MessageDetails.forEach((vehicleDetail) {
      if (vehicleDetail.name.toLowerCase().contains(text.toLowerCase()) ||
          vehicleDetail.date.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.message.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<AdminMessageDetails> _searchResult = [];
  List<AdminMessageDetails> _MessageDetails = [];

}

class AdminMessageDetails {
  String name, message, photo, date, messagethread;

  AdminMessageDetails(
      {this.name, this.message, this.photo, this.date, this.messagethread});

  factory AdminMessageDetails.fromJson(Map<String, dynamic> json) {
    return new AdminMessageDetails(
        message: json['receiver_type'].toString(),
        name: json['receiver_name'].toString(),
        messagethread: json['message_thread_code'].toString(),
        //photo:  json['description'].toString() ,
        date: json['last_message_timestamp'] == null ? "NA" : new DateFormat(
            'dd-MM-yyyy').format(new DateTime.fromMillisecondsSinceEpoch(
            int.tryParse(json['last_message_timestamp']) * 1000)).toString()
    );
  }
}

class GroupMessages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _GroupMessagesState();
}

class _GroupMessagesState extends State<GroupMessages> {
  TextEditingController controller = new TextEditingController();
  bool _loading = false;
  List Groupmessageslist = new List();
  List Groupmemberslist = new List();

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    LoadGroupmessages();
  }

  Future<Null> LoadGroupmessages() async {
    String id = await sp.ReadString("Userid");
    var url = await Constants().Clienturl() + Constants.Load_Groups_Addmin+id;
    Map<String, String> body = new Map();
    body['admin_id'] = id;
    print("url is $url" + "body--" + body.toString());
    http.post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"})
        .then((response) {
      if (response.statusCode == 200) {
        print("response --> ${response.body}");
        var responseJson = json.decode(response.body);
        if (responseJson['status'].toString() == "true" &&
            responseJson['result'] != null) {
          print("response json ${responseJson}");
          try {
            Groupmessageslist = responseJson['result'];
          } catch (e) {
            Groupmessageslist = new List();
          }
        }
        else {
          Groupmessageslist = new List();
        }
        setState(() {
          _loading = false;
        });
      }
      else {
        print("erroe--" + response.body);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading ? new Constants().bodyProgress : new Container(
        padding: EdgeInsets.all(5.0),
        child: new Column(
          children: <Widget>[
            /*new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search..', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),*/
            new SizedBox(width: 5, height: 5,),
            new Expanded(child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Groupmemberslist =
                    json.decode(Groupmessageslist[index]['members']);
                return new Column(
                  children: <Widget>[
                    new InkWell(child: new Row(
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
                                    child: new Text(
                                      Groupmessageslist[index]['group_name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),)),
                                new Padding(padding: new EdgeInsets.all(5),
                                    child: new Text(
                                        Groupmessageslist[index]['last_message_timestamp'] ==
                                            null ? "NA" : new DateFormat(
                                            'dd-MM-yyyy').format(new DateTime
                                            .fromMillisecondsSinceEpoch(
                                            int.tryParse(
                                                Groupmessageslist[index]['last_message_timestamp']) *
                                                1000)).toString()))
                              ],
                            ),
                            new Padding(padding: new EdgeInsets.all(5),
                                child: new Text(
                                  Groupmemberslist.join(", "),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,))
                          ],
                        ), flex: 8,),
                      ],
                    ),
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new AdminGroupchatPage(
                              messageDetails: Groupmessageslist[index],)));
                      },
                    ),
                    new SizedBox(width: 5, height: 5,),
                    new Divider(height: 1, color: Colors.grey,),
                  ],
                );
              }, itemCount: Groupmessageslist.length,
            ))
          ],
        ));
  }
}