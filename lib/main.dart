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


  class FullScreenImage extends StatelessWidget {
    final String imgPath;
    FullScreenImage(this.imgPath);

    final LinearGradient backgroundGradient = LinearGradient(
      colors: [Color(0x10000000), Color(0x30000000)],
      begin: Alignment.topLeft, 
      end: Alignment.bottomRight
    );

    @override
    Widget build(BuildContext context)
    =>  Scaffold(
        body: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(gradient: backgroundGradient),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: imgPath,
                    child: Image.network(imgPath),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppBar(
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: Icon(Icons.close, color: Colors.black,),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
