import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class GroupMessages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _GroupMessagesState();
}

class _GroupMessagesState extends State<GroupMessages>{
  TextEditingController controller = new TextEditingController();


  @override
  void initState() {
    Map<String, dynamic> json = new Map();
    json['title']= "";
    json['description']= "";
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    _GroupMessageDetails.add(GroupMessageDetails.fromJson(json));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Padding(padding: EdgeInsets.all(5.0),
        child: new Column(
          children: <Widget>[
            new Card(
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              child: new ListTile(
                title: new Container(padding: EdgeInsets.only(left: 15,right: 5,top: 5,bottom: 5),child: new Text("Select Group Name",style: TextStyle(color: Theme.of(context).primaryColor),),),
                trailing: new Icon(Icons.arrow_drop_down,color: Theme.of(context).primaryColor),
              ),
            ),
            new Expanded(child: new ListView.builder(itemBuilder: (BuildContext context, int index) {
              return new Column(
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(child: ClipOval(
                        child: new Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/1024px-User_icon_2.svg.png",fit: BoxFit.fill,),
                      ),flex: 2,),
                      new Expanded(child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Padding(padding: new EdgeInsets.all(5),child: new Text("Muni",style: TextStyle(fontWeight: FontWeight.bold),)),
                              Checkbox(
                                  value: _GroupMessageDetails[index].select,
                                  materialTapTargetSize: MaterialTapTargetSize.padded,
                                  onChanged: (bool val) {
                                    setState(() {
                                      _GroupMessageDetails[index].select = val;
                                    });
                                  }
                              ),
                            ],
                          ),
                          new Padding(padding: new EdgeInsets.all(5),child:new Text("Hai , how r u , whay r u dng?whay r u dngwhay r u dng",maxLines: 1,overflow: TextOverflow.ellipsis,))
                        ],
                      ),flex: 8,),
                    ],
                  ),
                  new SizedBox(width: 5,height: 5,),
                  new Divider(height: 1,color: Colors.grey,),
                ],
              );
            },itemCount: _GroupMessageDetails.length,
            ))
          ],
        ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _GroupMessageDetails.forEach((vehicleDetail) {
      if (vehicleDetail.name.toLowerCase().contains(text.toLowerCase()) || vehicleDetail.date.toLowerCase().contains(text.toLowerCase())
          || vehicleDetail.message.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(vehicleDetail);
    });

    setState(() {});
  }

  List<GroupMessageDetails> _searchResult = [];
  List<GroupMessageDetails> _GroupMessageDetails = [];

}

class GroupMessageDetails {
  String  name, message,photo,date;
  bool select;

  GroupMessageDetails({this.name, this.message, this.photo,this.date,this.select});

  factory GroupMessageDetails.fromJson(Map<String, dynamic> json) {
    return new GroupMessageDetails(
        message: json['title'].toString() ,
        name:  json['description'].toString() ,
        photo:  json['description'].toString(),
        select: false
    );
  }
}