import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Loading.dart';
import 'package:flutter_application_1/data/http.dart';

class SongList {
  // 获取推荐音乐数据
  static Future getRecommendMusic() async {
    var data = await request('/personalized?limit=10');
    Map<String, dynamic> mapData = jsonDecode(data);
    return mapData['result'];
  }

  // 获取排行榜音乐数据
  static Future getRankingList() async {
    var data = await request('/toplist');
    Map<String, dynamic> mapData = jsonDecode(data);
    List sublist = mapData['list'];
    return sublist.sublist(0, 10);
  }
}

Widget createSongList(BuildContext context, AsyncSnapshot snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
    List result = snapshot.data;
    List<Widget> SongList = [];
    for (var i = 0; i < result.length; i++) {
      SongList.add(Container(
          width: 100,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/musicList',
                    arguments: result[i]['id']);
              },
              child: Column(
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      // child: Image.network(result[i]['picUrl']),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15), // 设置圆角边框
                        child: Image.network(
                          result[i]['picUrl'] ?? result[i]['coverImgUrl'],
                          fit: BoxFit.fill,
                        ),
                      )),
                  SizedBox(
                    width: 100,
                    height: 30,
                    child: Text(
                      result[i]['description'] ?? result[i]['name'],
                      // softWrap: true,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ))));
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: SongList,
    );
  } else {
    return loading(context);
  }
}
