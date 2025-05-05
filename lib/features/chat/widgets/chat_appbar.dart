import 'package:flutter/material.dart';

PreferredSizeWidget? chatAppBar(BuildContext buildContext) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        // Navigator.pop(buildContext);
      },
      icon: const Icon(Icons.arrow_back_ios),
    ),
    title: const Text('username'),
    actions: const [
      Icon(Icons.phone),
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Icon(Icons.video_camera_back),
      ),
    ],
  );
}
