import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sticker_app/services/grant_permission.dart';

Future<List<AssetPathEntity>> fetchAlbums() async {
  try {
    await grantPermission();

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();

    return albums;
  } catch (e) {
    debugPrint('Error fetch albums: $e');

    return [];
  }
}
