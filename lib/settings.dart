import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/foundation.dart';

class Settings extends StatefulWidget {

  @override
  SettingsState createState() =>
    SettingsState();
}

class SettingsState extends State<Settings> {
  
  String version = "";
  
  @override
    void initState() {
      super.initState();
      getPackageInfo();
    }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
          version = packageInfo.version;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: settingsBody(version)
    );
  }
}

ListView settingsBody(String version) =>
  ListView(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.info),
        title: Text('Version', style: TextStyle(color: Colors.pink),),
        subtitle: Text('$version')
      ),
      ListTile(
        leading: Icon(Icons.shop),
        title: Text('Rate on Google Play'),
        onTap: () => LaunchReview.launch(),
      ),
    ],
  );