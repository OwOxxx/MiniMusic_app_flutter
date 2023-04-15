import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/http.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    requst();
  }

  requst() async {
    var data = await request('/personalized');
    var d = jsonDecode(data);
    for (var i = 0; i < d['result'].length; i++) {
      print(d['result'][i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = "首页";
    Widget flatButton() {
      return TextButton(
        child: const Text('路由跳转home页面'),
        // textColor: Colors.red,
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                flatButton(),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
