import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/http.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
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
        title: const TextField(),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(weight: 200),
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
