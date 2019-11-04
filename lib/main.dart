import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:llk_app/utils/LogUtils.dart';
import 'ScaffoldElement.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'llk',
      theme: ThemeData(primaryColor: const Color(0xFF63CA6C)),
      home: MyHomePage(title: 'HomePage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String TAG = '_MyHomePageState';
  ScaffoldElement element = new ScaffoldElement();

  @override
  void initState() {
    super.initState();
    LogUtils.d(TAG, 'initState');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: element.getAppBar(),
      bottomNavigationBar: element.getBottomNavigationBar((index) => {
            setState(() {
              element.setTabIndex(index);
            })
          }),
      drawer: element.getDrawer(),
      body: element.getCurrentPage(),
    );
  }
}
