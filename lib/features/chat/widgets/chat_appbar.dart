import 'package:flutter/material.dart';

PreferredSizeWidget? chatAppBar(BuildContext context) {
  final screenSize = MediaQuery.of(context).size.width;

  return AppBar(
    leading: IconButton(
      onPressed: () {
        // Navigator.pop(buildContext);
      },
      icon: const Icon(Icons.arrow_back_ios),
    ),
    title: const Text('username'),
    actions: [
      Icon(Icons.phone),
      Padding(
        padding: EdgeInsets.only(
          right: screenSize * 0.03,
          left: screenSize * 0.02,
        ),
        child: Icon(Icons.video_camera_back),
      ),
    ],
  );
}
