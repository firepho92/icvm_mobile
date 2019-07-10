import 'package:flutter/material.dart';
import './FirstPage.dart';
import './ThirdPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  _MyHomePageState();
  List<Widget> _tabList = [
    FirstPage(),
    ThirdPage()
  ];
  int _currentIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabList.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (currentIndex) {
          setState(() {
            _currentIndex = currentIndex;
          });
          _tabController.animateTo(_currentIndex);
        },
        items: [
          BottomNavigationBarItem(
            title: Text("Inicio"),
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            title: Text("Stock"),
            icon: Icon(Icons.assignment)
          )
        ]
        ),
      body: TabBarView(
        controller: _tabController,
        children: _tabList
        ),
    );
  }
}