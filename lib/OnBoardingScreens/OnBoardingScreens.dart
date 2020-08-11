import 'dart:io';

import 'package:Edecofy/dashboard.dart';
import 'package:Edecofy/login.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);

  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final int _totalPages = 5;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Container(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              _currentPage = page;
              setState(() {});
            },
            children: <Widget>[
              _buildPageContent(
                  image: 'assets/onlin_payment.png',
                  title: 'FEES/ONLINE PAYMENT',
                  body:
                  'Pay online,Instant,Easy,safe & Secure '),
              _buildPageContent(
                  image: 'assets/notification.png',
                  title: 'SMS/PUSH NOTIFICATION',
                  body:
                    'Get Notified Instant'),
              _buildPageContent(
                  image: 'assets/report_analytics.png',
                  title: 'REPORT ANALYIS',
                  body:
                  'Helps in better Decission Making'),
              _buildPageContent(
                  image: 'assets/gps.png',
                  title: 'GPS TRACKING',
                  body:
                  'Track the vehicle,where ever you are'),
              _buildPageContent(
                  image: 'assets/attendance.png',
                  title: 'ATTENDANCE',
                  body:
                  'Monitor Daily,Monthly,Yearly Attendance Report')
            ],
          ),
        ),
      ),
      bottomSheet: _currentPage != 5
          ? Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              splashColor: Colors.blue[50],
              child: Text(
                'SKIP',
                style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              child: Row(children: [
                for (int i = 0; i < _totalPages; i++) i == _currentPage ? _buildPageIndicator(true) : _buildPageIndicator(false)
              ]),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              splashColor: Colors.blue[50],
              child: Text(
                'NEXT',
                style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      )
          : InkWell(
        onTap: () =>  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        ),
        child: Container(
          height: Platform.isIOS ? 70 : 60,
         color: Colors.blue,
          alignment: Alignment.center,
          child: Text(
            'GET STARTED NOW',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent({
    String image,
    String title,
    String body,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.asset(image),
          ),
          SizedBox(height: 40),
          Center(
            child: Text(
              title,
              style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 16, height: 2.0, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              body,
              style: TextStyle(fontSize: 15, height: 2.0),
            ),
          ),
        ],
      ),
    );
  }
}