import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 顶部栏目·
AppBar homeAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    backgroundColor: const Color.fromARGB(250, 236, 44, 100),
    elevation: 0,
    leading: IconButton(
      icon: SvgPicture.asset(
        "./assets/icons/menu.svg",
        width: 20,
        height: 20,
      ),
      onPressed: () {
        print('4545456');
      },
    ),
    title: RichText(
      text: TextSpan(
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        children: const [
          TextSpan(
            text: "Mini",
            style: TextStyle(color: Color.fromARGB(255, 255, 164, 128)),
          ),
          TextSpan(
            text: "Music",
            style: TextStyle(color: Colors.amberAccent),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset("assets/icons/search.svg"),
      ),
      IconButton(
        icon: SvgPicture.asset("assets/icons/notification.svg"),
        iconSize: 30.0,
        onPressed: () {},
      ),
    ],
  );
}
