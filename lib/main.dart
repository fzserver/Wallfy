import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';


void main() => runApp(wallfy());

class wallfy extends StatelessWidget {

  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

  @override
  Widget build(BuildContext context) =>
   MaterialApp(
     title: "Wallfy",
     debugShowCheckedModeBanner: false,
     navigatorObservers: <NavigatorObserver>[observer],
      home: wallfyHome(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
    );
}

class wallfyHome extends StatefulWidget {
  @override
  _wallfyHomeState createState() => _wallfyHomeState();
}

class _wallfyHomeState extends State<wallfyHome> {
  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(
        title: Text('Wallfy'),
      ),
    );
}