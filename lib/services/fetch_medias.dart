import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sticker_app/models/media.dart';
import 'package:transparent_image/transparent_image.dart';

Future<List<Media>> fetchMedias({
  required AssetPathEntity album,
  required int page,
}) async {
  List<Media> medias = [];

  try {
    final List<AssetEntity> entities = await album.getAssetListPaged(
      page: page,
      size: 30,
    );

    for (var entity in entities) {
      Media media = Media(
        entity,
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: AssetEntityImageProvider(
            entity,
            thumbnailSize: ThumbnailSize.square(500),
            isOriginal: false,
          ),
          fit: BoxFit.cover,
        ),
      );
      medias.add(media);
    }
  } catch (e) {
    debugPrint('Error petch media: $e');
  }

  return medias;
}
