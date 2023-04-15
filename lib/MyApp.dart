import 'package:flutter/material.dart';
import 'package:flutter_application_1/Tabs.dart';
import 'package:flutter_application_1/modules/HomePage.dart';
// 导入路由组件
import 'package:flutter_application_1/modules/LoginPage.dart';
import 'package:flutter_application_1/button_demo.dart';
import 'package:flutter_application_1/components/MusicList.dart';
import 'package:flutter_application_1/modules/OtherPage.dart';
import 'package:flutter_application_1/modules/SettingPage.dart';
import 'package:flutter_application_1/route_demo.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        // '/login': (context) => const LoginPage(title: '我的页面'),
        // '/': (context) => const Tabs(),
        '/home': (context) => RouteDemo(),
        '/button': (context) => ButtonDemo(),
        '/musicList': (context) => const MusicList()
      },
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    SettingPage(),
    OtherPage()
  ];

  void _ontab(int index) {
    setState(() {
      _selectedIndex = index;
      print(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _ontab,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.queue_music,
              color: Colors.blue,
            ),
            label: "发现",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.miscellaneous_services_sharp,
              color: Colors.blue,
            ),
            label: "设置",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.mail,
                color: Colors.blue,
              ),
              label: "其他"),
        ],
      ),
    );
  }
}
