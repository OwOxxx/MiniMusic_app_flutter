import 'package:flutter/material.dart';

Widget loading(BuildContext context) {
  return const Center(
    child: CircularProgressIndicator(
      value: 0.3,
      backgroundColor: Colors.greenAccent,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    ),
  );
}
