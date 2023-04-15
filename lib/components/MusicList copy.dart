import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Loading.dart';
import 'package:flutter_application_1/data/http.dart';
import 'package:flutter_application_1/utils/cachedNetworkImage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PlayerStore extends ChangeNotifier {
  final player = AudioPlayer(); // Create a player
  int isPaly = -1;
  bool palyOrpause = false;
  String icon = '';
  bool isBottomAppBar = false;
  List musicList = [];
  double volume = 50.0;

  // 设置正在播放
  void setisPlay(int i) {
    isPaly = i;
    playMusic();
    notifyListeners();
  }

  // 获取音乐列表data
  void getMusicList(data) {
    musicList = data;
  }

  // 获取正在播放的音乐详情
  Map getDetail() {
    print(isPaly);
    if (isPaly != -1) {
      Map data = {
        'picUrl': musicList[isPaly]['al']['picUrl'],
        'name': musicList[isPaly]['name']
      };
      return data;
    } else {
      return {'picUrl': 'https://com.example.com.jpg', 'name': '歌曲名字'};
    }
  }

  // 点击列表时播放音乐
  void playMusic() async {
    icon = 'assets/icons/pause.svg';

    var data =
        await request('/song/url/v1?id=${musicList[isPaly]['id']}&level=hires');
    Map<String, dynamic> mapData = jsonDecode(data);
    List urlObject = mapData['data'];
    final duration = await player.setUrl(urlObject[0]['url']);
    await player.setVolume(50);
    print(duration);
    await player.play();
  }

  // 播放音乐或者暂停音乐
  void judgePaly() {
    palyOrpause = !palyOrpause;
    palyOrpause ? player.pause() : player.play();
    icon = palyOrpause ? 'assets/icons/play.svg' : 'assets/icons/pause.svg';
    notifyListeners();
  }

  // 上一曲
  void palyLeft() {
    if (isPaly > 0) {
      isPaly--;
      setisPlay(isPaly);
    }
  }

  // 下一曲
  void palyRight() {
    if (isPaly < musicList.length - 1) {
      isPaly++;
      setisPlay(isPaly);
    }
  }

  // 通过slider设置音量大小
  void setVolume(param) {
    volume = param;
    notifyListeners();
  }

  // 顺序播放音乐
  void loopPaly() {
    player.playerStateStream.listen((playerState) {
      print('55555 $playerState');
      if (playerState.processingState == ProcessingState.completed) {
        // 播放完成后执行相应的事件或方法
        print('音频播放完成');
        palyRight();
      }
    });
  }

  // 判断是否在播放
  bool judgeISplay() {
    if (isPaly == -1) {
      return true;
    } else {
      return false;
    }
  }

  // 设置底部音乐栏显示隐藏
  void setisBottomAppBar(bool show) {
    isBottomAppBar = show;
    notifyListeners();
  }

  // 退出时暂停并销毁播放器
  @override
  void dispose() {
    player.pause();
    player.dispose();
    super.dispose();
  }
}

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<StatefulWidget> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  // 关闭页面销毁
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void musicPlayer(BuildContext context, int i) async {
    final Player = Provider.of<PlayerStore>(context, listen: false);
    Player.setisPlay(i);
    Player.setisBottomAppBar(true);

    // setState(() {
    //   _isBottomAppBar = true;
    //   _isPaly = i;
    // });
    // if (isPaly) {
    // var data = await request('/song/url/v1?id=${tracks["id"]}&level=hires');
    // Map<String, dynamic> mapData = jsonDecode(data);
    // List urlObject = mapData['data'];
    // print('url: ${urlObject[0]["url"]}');
    // final duration = await player.setUrl(urlObject[0]['url']);
    // print(duration);
    // await player.play();
    // } else {}
  }

  // 获取歌单详情数据
  Future getSongListDetail(BuildContext context) async {
    final Id = ModalRoute.of(context)!.settings.arguments;
    var data = await request('/playlist/detail?id=$Id');
    Map<String, dynamic> mapData = jsonDecode(data);
    List trackIds = mapData['playlist']['trackIds'];
    trackIds = trackIds.sublist(0, trackIds.length > 50 ? 50 : trackIds.length);
    List Ids = [];
    trackIds.forEach((e) => Ids.add(e['id']));
    String IdsStr = Ids.join(',');
    var songDetail = await request('/song/detail?ids=$IdsStr');
    Map<String, dynamic> songs = jsonDecode(songDetail);
    Map<String, dynamic> musiclist = {
      'songs': songs['songs'],
      'coverImgUrl': mapData['playlist']['coverImgUrl'],
      'description': mapData['playlist']['description'],
      'name': mapData['playlist']['name']
    };
    return musiclist;
  }

  // 创建歌单详情widget
  Widget createSongListDetail(BuildContext context, AsyncSnapshot snapshot) {
    final Player = Provider.of<PlayerStore>(context, listen: false);
    if (snapshot.connectionState == ConnectionState.done) {
      Map musiclist = snapshot.data;
      List songs = musiclist['songs'];
      // 存储在仓库中
      Player.getMusicList(songs);
      String author = '';
      List authors = [];
      List items = [];
      return Column(
        children: [
          Container(
            height: 170,
            color: Colors.pink[500],
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10), // 设置圆角边框
                          child: Image.network(
                            musiclist['coverImgUrl'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: 130,
                        child: Text(
                          musiclist['name'],
                          // softWrap: true,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    musiclist['description'],
                    // softWrap: true,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              cacheExtent: 550,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                authors = [];
                items = [];
                authors = songs[index]['ar'];
                authors.forEach((
                  element,
                ) {
                  items.add(element['name']);
                });
                author = items.join('/');
                return InkWell(
                  onTap: () {
                    musicPlayer(context, index);
                  },
                  child: Container(
                      height: 60,
                      // width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(5), // 设置圆角边框
                                child:
                                    cachedImage(songs[index]['al']['picUrl'])),
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 140,
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        songs[index]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(author,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black38)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Consumer<PlayerStore>(
                            builder: (context, store, child) => Visibility(
                                visible: store.isPaly != index,
                                child: const SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Icon(Icons.play_circle),
                                  ),
                                )),
                          ),
                          Consumer<PlayerStore>(
                              builder: (context, store, child) {
                            return Visibility(
                                visible: store.isPaly == index,
                                child: const SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Icon(Icons.pause_circle),
                                  ),
                                ));
                          }),
                          const SizedBox(
                            width: 40,
                            child: Center(
                              child: Icon(Icons.more_vert_outlined),
                            ),
                          ),
                        ],
                      )),
                );
              },
              itemCount: songs.length,
            ),
          )
        ],
      );
    } else {
      return loading(context);
    }
  }

  // // 获取音乐列表
  // Future getMusicList(BuildContext context, List tracks) async {
  //   List ids = [];
  //   tracks.forEach((item) {
  //     ids.add(item['id']);
  //   });
  //   String params = ids.join(',');
  //   print(params);
  //   var data = await request('/song/url?id=$params');
  //   print(data);
  //   return data;
  // }

  // // 创建音乐列表widget
  // Widget createMusicList(BuildContext context, AsyncSnapshot snapshot) {
  //   if (snapshot.connectionState == ConnectionState.done) {
  //     return ListView(children: [],);
  //   } else {
  //     return loading(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final Player = Provider.of<PlayerStore>(context);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PlayerStore()),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('歌单'),
            backgroundColor: Colors.pink[600],
          ),
          body: FutureBuilder(
            builder: createSongListDetail,
            future: getSongListDetail(context),
          ),
          bottomNavigationBar: Consumer<PlayerStore>(
            builder: (context, store, child) {
              return BottomAppBar(
                  shape: const CircularNotchedRectangle(),
                  child: Visibility(
                    visible: store.isBottomAppBar,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      child: Flex(
                        mainAxisAlignment: MainAxisAlignment.center,
                        direction: Axis.horizontal, // Flex容器主轴方向是水平的
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 子部件在交叉轴上居中对齐
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                      child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(50), // 设置圆角边框
                                    child: Image.network(
                                        store.getDetail()['picUrl']),
                                  )),
                                  Container(
                                    width: 80,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      store.getDetail()['name'],
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      store.palyLeft();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/left.svg',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: store.judgePaly,
                                    child: SvgPicture.asset(
                                      store.icon,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      store.palyRight();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/right.svg',
                                      width: 50,
                                      height: 50,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/icons/order.svg',
                                    width: 50,
                                    height: 50,
                                    // alignment: Alignment.centerRight,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ));
  }
}
