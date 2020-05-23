import 'package:flutter/material.dart';

import 'package:flutter_text_art_filter/pages/images_list.dart';
import 'package:flutter_text_art_filter/pages/settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _title = 'Text Art Filter';
  int _currentIndex = 0;
  final List<Widget> _bottomNavigationPages = <Widget>[
    ImagesListPage(),
    SettingsPage()
  ];

  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        {
          _title = 'Text Art Filter';
          setState(() {
            _currentIndex = 0;
          });
        }
        break;
      case 1:
        {
          _title = 'Settings';
          setState(() {
            _currentIndex = 1;
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(_title),
      ),
      body: Center(
        child: _bottomNavigationPages[_currentIndex],
      ),
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          onTap: _onTabTapped,
          currentIndex: _currentIndex,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: SizedBox(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: SizedBox(height: 0.0),
            ),
          ],
        ),
      ),
    );
  }
}
