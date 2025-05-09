import 'package:flutter/material.dart';

PreferredSizeWidget? chatAppBar(BuildContext context) {
  final double screenSize = MediaQuery.of(context).size.width;

  return AppBar(
    leading: IconButton(
      onPressed: () {
        // Navigator.pop(buildContext);
      },
      icon: const Icon(Icons.arrow_back_ios),
    ),
    title: const Text('username'),
    actions: <Widget>[
      const Icon(Icons.phone),
      Padding(
        padding: EdgeInsets.only(
          right: screenSize * 0.03,
          left: screenSize * 0.02,
        ),
        child: const Icon(Icons.video_camera_back),
      ),
    ],
  );
}
