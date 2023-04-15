import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Loading.dart';
import 'package:flutter_application_1/components/SongList.dart';
import 'package:flutter_application_1/utils/cachedNetworkImage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_application_1/data/http.dart';

import '../components/appBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 获取banners数据
  Future getBanner() async {
    var data = await request('/banner?type=1');
    Map<String, dynamic> mapData = jsonDecode(data);
    return mapData['banners'];
  }

  // 创建更新banners函数
  Widget createByDataSwiper(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      List banners = snapshot.data;
      List imageUrls = [];
      for (var i = 0; i < banners.length; i++) {
        // Map <String ,dynamic> img = jsonEncode(bannsers[i]);
        imageUrls.add(banners[i]['pic']);
      }
      return Swiper(
        /// 轮播图数量
        itemCount: imageUrls.length,

        /// 设置轮播图自动播放
        autoplay: true,

        /// 轮播条目组件
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // 设置圆角边框
                child: Image.network(
                  /// 图片 URL 链接
                  imageUrls[index],

                  /// 缩放方式
                  fit: BoxFit.fill,
                )),
          );
        },

        /// 轮播图指示器
        pagination: const SwiperPagination(),
      );
    } else {
      return loading(context);
    }
  }

  // 整个主页的list
  List<Widget> _getData() {
    List<Widget> list = [
      SizedBox(
          height: 200,
          // padding: const EdgeInsets.all(10),
          child:
              FutureBuilder(future: getBanner(), builder: createByDataSwiper)),
      SizedBox(
        height: 90,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  children: const [
                    Icon(
                      Icons.library_music,
                      size: 50,
                    )
                  ],
                ),
                Row(
                  children: const [Text('每日推荐')],
                )
              ]),
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  children: const [
                    Icon(
                      Icons.library_music,
                      size: 50,
                    )
                  ],
                ),
                Row(
                  children: const [Text('每日推荐')],
                )
              ]),
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  children: const [
                    Icon(
                      Icons.library_music,
                      size: 50,
                    )
                  ],
                ),
                Row(
                  children: const [Text('每日推荐')],
                )
              ]),
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  children: const [
                    Icon(
                      Icons.library_music,
                      size: 50,
                    )
                  ],
                ),
                Row(
                  children: const [Text('每日推荐')],
                )
              ]),
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  children: const [
                    Icon(
                      Icons.library_music,
                      size: 50,
                    )
                  ],
                ),
                Row(
                  children: const [Text('每日推荐')],
                )
              ]),
            )
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: const [
                Text(
                  "推荐音乐",
                  style: TextStyle(fontSize: 15, height: 1),
                ),
                Icon(Icons.keyboard_arrow_right_rounded)
              ],
            ),
            SizedBox(
              height: 130,
              child: FutureBuilder(
                future: SongList.getRecommendMusic(),
                builder: createSongList,
              ),
            ),
            const Divider(
              height: 50,
              color: Colors.red,
            )
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: const [
                Text(
                  "排行榜",
                  style: TextStyle(fontSize: 15, height: 1),
                ),
                Icon(Icons.keyboard_arrow_right_rounded)
              ],
            ),
            SizedBox(
              height: 130,
              child: FutureBuilder(
                future: SongList.getRankingList(),
                builder: createSongList,
              ),
            ),
            const Divider(
              height: 50,
              color: Colors.red,
            )
          ],
        ),
      )
    ];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),
      body: Container(
        child: homeBody(context),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text('wo shi Email'),
              accountName: Text('我是Drawer'),
              onDetailsPressed: () {},
            ),
            ListTile(
              title: Text('ListTile1'),
              subtitle: Text(
                'ListSubtitle1',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: CircleAvatar(child: Text("1")),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(), //分割线
            ListTile(
              title: Text('ListTile2'),
              subtitle: Text(
                'ListSubtitle2',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: CircleAvatar(child: Text("2")),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(), //分割线
            ListTile(
              title: Text('ListTile3'),
              subtitle: Text(
                'ListSubtitle3',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: CircleAvatar(child: Text("3")),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(), //分割线
            new AboutListTile(
              icon: new CircleAvatar(child: new Text("4")),
              child: new Text("AboutListTile"),
              applicationName: "AppName",
              applicationVersion: "1.0.1",
              applicationLegalese: "applicationLegalese",
              aboutBoxChildren: <Widget>[
                new Text("第一条..."),
                new Text("第二条...")
              ],
            ),
            Divider(), //分割线
          ],
        ),
      ),
    );
  }

  ListView homeBody(BuildContext context) {
    return ListView(
      children: _getData(),
    );
  }
}
