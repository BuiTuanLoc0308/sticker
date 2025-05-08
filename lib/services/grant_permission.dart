import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> grantPermission() async {
  try {
    final bool photosGranted = await Permission.photos.isGranted;

    if (!photosGranted) {
      final Map<Permission, PermissionStatus> statuses =
          await [Permission.photos].request();
      if (statuses[Permission.photos] == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
      }
    }
  } catch (e) {
    debugPrint('Error granted permission: $e');
  }
}
