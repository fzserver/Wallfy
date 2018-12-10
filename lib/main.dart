import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';


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
        primarySwatch: Colors.pink,
      ),
    );
}

class wallfyHome extends StatefulWidget {
  @override
  _wallfyHomeState createState() => _wallfyHomeState();
}

class _wallfyHomeState extends State<wallfyHome> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference = Firestore.instance.collection('wallfy');  

  @override
    void initState() {
      super.initState();
      subscription = collectionReference.snapshots().listen((datasnapshot){
        setState(() {
          wallpapersList = datasnapshot.documents;     
        });
      });
    }
    
  @override
    void dispose() {
      subscription?.cancel();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(
        title: Text('Wallfy'),
      ),
      body: wallurls(context, wallpapersList),
    );
}

Widget wallurls(BuildContext context, List<DocumentSnapshot> wallList) =>
  wallList != null ?
  StaggeredGridView.countBuilder(
    padding: const EdgeInsets.all(8.0),
    crossAxisCount: 4,
    itemCount: wallList.length,
    itemBuilder: (context, index) {
      String imgPath = wallList[index].data['url'];
      Material(
        elevation: 8.0,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: InkWell(
          child: Hero(
            
          ),
        ),
      );
    },
    staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 3),
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
  )
  : Center(child: CircularProgressIndicator(),);
