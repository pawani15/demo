import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dashboard.dart';

class StudentAccount extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _StudentAccountPageState();
}

class _StudentAccountPageState extends State<StudentAccount>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xff182C61),
        title: Text("Student Profile"),
        leading: new IconButton( icon: new Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () =>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(),),
          ),
        ),
      ),
      body:  Container(
        width: double.infinity,
        child: new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Comming Soon",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold),),
                new SizedBox(width: 10,height: 10,),
              ],
            )
        ),
      ),
    );;
  }

}