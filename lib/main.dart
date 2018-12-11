import 'package:Wallfy/FullScreenImage.dart';
import 'package:Wallfy/MenuItems.dart';
import 'package:Wallfy/about.dart';
import 'package:Wallfy/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';


void main() => runApp(Wallfy());

class Wallfy extends StatelessWidget {

  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

  @override
  Widget build(BuildContext context) =>
   MaterialApp(
     title: "Wallfy",
     debugShowCheckedModeBanner: false,
     navigatorObservers: <NavigatorObserver>[observer],
      home: WallfyHome(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
}

class WallfyHome extends StatefulWidget {
  @override
  _WallfyHomeState createState() => _WallfyHomeState();
}

class _WallfyHomeState extends State<WallfyHome> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;

  @override
    void initState() {
      super.initState();
      firestore();
    }

  void firestore() async {
    final Firestore firestore = Firestore();
    await firestore.settings(timestampsInSnapshotsEnabled: true);
    final CollectionReference collectionReference = firestore.collection('wallfy');
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
        actions: <Widget>[
          PopupMenuButton<MenuItems>(
            elevation: 3.0,
            onCanceled: () => {},
            tooltip: "Menu",
            onSelected: selectedMenuItem,
            itemBuilder: (BuildContext context){
              return menu.map((MenuItems menuItem) {
                return PopupMenuItem<MenuItems> (
                  value: menuItem,
                  child: Text(menuItem.title),
                );
              }).toList();
            },
          ),
          Padding(padding: const EdgeInsets.only(right: 2.0),),
        ],
      ),
      body: wallurls(context, wallpapersList),
    );

  void selectedMenuItem(MenuItems menu) {
    if (menu.id == 0) { 
      Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
    } else {
      if (menu.id == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
      }
    }
  }

  static const List<MenuItems> menu = const <MenuItems>[
    const MenuItems(id: 0, title: 'About'),
    const MenuItems(id: 1, title: 'Settings'),
  ];
}

Widget wallurls(BuildContext context, List<DocumentSnapshot> wallList) =>
  wallList != null ?
  StaggeredGridView.countBuilder(
    padding: const EdgeInsets.all(8.0),
    crossAxisCount: 4,
    itemCount: wallList.length,
    itemBuilder: (context, index) =>
      Material(
        elevation: 8.0,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => FullScreenImage(wallList[index].data['url'])
          )),
          child: Hero(
            tag: wallList[index].data['url'],
            child: FadeInImage(
              image: NetworkImage(wallList[index].data['url']),
              fit: BoxFit.cover,
              placeholder: AssetImage('wallfy.png'),
            ),
          ),
        ),
      ),
    staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 3),
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
  )
  : Center(child: CircularProgressIndicator(),);