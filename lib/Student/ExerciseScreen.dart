// Question COunter

import 'package:Edecofy/Student/Student_QuestionScreen.dart';
import 'package:Edecofy/Student/Subject_AnswerDialog.dart';
import 'package:Edecofy/const.dart';
import 'package:flutter/material.dart';

class StudentOnlineExam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Exam'),
        backgroundColor: Color(0xff182C61),
      ),
      drawer: Constants().drawer(context),
      body: Column(
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
//                    new Text("Academic Syllabus",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                    new SizedBox(width: 15,height: 15,),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Image(image: AssetImage('assets/refresh_icon.png')),
//                        new Text("Home > Academic Syllabus",style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
//                      ],
//                    ),
//                  ],
//                )
//            ),
          ),
          SearchBar(),
          QuestionCard(),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return  new Card(
      margin: new EdgeInsets.only(left: 20,right: 20,bottom: 0,top: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
      elevation: 5,
      child: new ListTile(
        leading: new Icon(Icons.search,color: Theme.of(context).primaryColor,),
        title: new TextField(
         // controller: controller,
          decoration: new InputDecoration(
              hintText: 'Search ', border: InputBorder.none),
         // onChanged: onSearchTextChanged,
        ),
//        trailing: new IconButton(
//          icon: new Icon(Icons.cancel,color: Theme.of(context).primaryColor,),
//          onPressed: () {
//           // controller.clear();
//           // onSearchTextChanged('');
//          },
//        ),
      ),
    );

  }
}

class QuestionCard extends StatefulWidget {
  int currentSelection = -1;

  createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5.0,
        margin: new EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 20),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(

                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    ' Online Exam',
                    style: TextStyle(fontSize: 20,color: Color(0xff182C61)),
                  ),
                ),

                Divider(
                  thickness: 2,
                  color: Colors.grey[500],
                ),


                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start
                    ,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('S No'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                         // alignment: Alignment.centerLeft,
                          child: Text('Subject'),
                        ),
                      ),

                      Expanded(
                        child: Container(
                         // alignment: Alignment.centerLeft,
                          child: Text('Exam Date/Time'),
                        ),
                      ),

                      Expanded(
                        child: Container(
                        //  alignment: Alignment.centerRight,
                          child: Text('Action'),
                        ),
                      ),
                      Container()
                    ],
                  ),
                ),

                Divider(
                  thickness: 2,
                  color: Colors.grey[500],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            Divider(
                              thickness: 2,
                              color: Colors.grey[500],
                            ),
                      itemCount: 4,

                      itemBuilder: (context, index) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left:5),
                                  child: Container(
                                    child: Text('${index + 1}'),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              
                              Expanded(
                                child: Container(
                                  //alignment: Alignment.center,
                                  child: Text('Loreum Ipsum'),
                                ),
                              ),
                              
                              
                              Expanded(
                                child: Container(
                                 // alignment: Alignment.center,
                                  child: Column(
                                  //  mainAxisAlignment: MainAxisAlignment.start,
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                          child: Text('Date:-4/1/2020',
                                          style: TextStyle(
                        color: Colors.black,
                        fontSize: 12)
                        ),

                                      ),
                                      Container(
                                        //padding: EdgeInsets.symmetric(vertical: 8),
                                        //margin: EdgeInsets.only(left:3,right: 3),
                                        child: Text('Time:-10:30Am-11:30Am',
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 12)
                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text('Take Exam ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10)),
//                                          margin: EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 0)
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => QuestionScreen(),
                                                ));
                                          },
                                          child: Container(
                                            child: IconButton(
                                              icon:Icon(Icons.arrow_forward,
                                                size: 10,),
                                              color: Colors.white,
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => QuestionScreen(),
                                                    ));
                                              },
                                            ),
                                            margin: EdgeInsets.all(5),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
                  thickness: 2,
                ),
                Container(
                  margin: EdgeInsets.only(right: 40),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('showing pages'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('1-10'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
//            Align(
//              heightFactor: 11,
//              alignment: Alignment.bottomRight,
//              child: Container(
//                child: IconButton(
//                  icon: Icon(Icons.add),
//                  onPressed: () {},
//                ),
//                decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  color: Colors.blue,
//                ),
//              ),
//            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    child: IconButton(
                      icon: Icon(Icons.add),
                        tooltip: "Take Test",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionScreen(),
                            ));
                      },

                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    child: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                        tooltip:"View Result",
                      onPressed: () {
                        Widget w = AnswerDialog.show(context);
                        showDialog(context: context,child:  w);
                      },

                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
