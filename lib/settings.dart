import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: settingsBody()
    );
  }
}

ListView settingsBody() =>
  ListView(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.info),
        title: Text('Version', style: TextStyle(color: Colors.pink),),
        subtitle: Text('1.0.0')
      ),
      ListTile(
        leading: Icon(Icons.shop),
        title: Text('Rate on Google Play'),
        onTap: () => LaunchReview.launch(),
      ),
    ],
  );