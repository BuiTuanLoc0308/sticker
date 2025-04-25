import 'package:collection/collection.dart';
import 'package:my_stickers/data/models/sticker.dart';

class MyStickers {
  static final List<Sticker> _allSticker = [
    ...List.generate(
        20,
        (_) => [
              Sticker(
                  path: 'packages/my_stickers/assets/koala/koala_birthday.png',
                  type: 'Koala'),
              Sticker(
                  path: 'packages/my_stickers/assets/koala/koala_sleep.png',
                  type: 'Koala'),
              Sticker(
                  path:
                      'packages/my_stickers/assets/christmas/mr_christmas.png',
                  type: 'Christmas'),
              Sticker(
                  path:
                      'packages/my_stickers/assets/christmas/christmas_tree.png',
                  type: 'Christmas'),
              Sticker(
                  path: 'packages/my_stickers/assets/love/love_birds.png',
                  type: 'Love'),
              Sticker(
                  path: 'packages/my_stickers/assets/love/love_dog.png',
                  type: 'Love'),
            ]).expand((e) => e),
  ];

  static List<Sticker> _thumbnailSticker = [
    Sticker(
      path: 'packages/my_stickers/assets/love/love_birds.png',
      type: 'Love',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/christmas/mr_christmas.png',
      type: 'Christmas',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/koala/koala_birthday.png',
      type: 'Koala',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/love/love_birds.png',
      type: 'Love 1',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/christmas/mr_christmas.png',
      type: 'Christmas 1',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/koala/koala_birthday.png',
      type: 'Koala 1',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/love/love_birds.png',
      type: 'Love 2',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/christmas/mr_christmas.png',
      type: 'Christmas 2',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/koala/koala_birthday.png',
      type: 'Koala 2',
    ),
  ];

  static List<Sticker> getStickers() {
    return _allSticker;
  }

  static List<Sticker> getThumbnailSticker() {
    return _thumbnailSticker;
  }

  static Map<String, List<Sticker>> getStickersByType() {
    final grouped = groupBy(_allSticker, (Sticker s) => s.type);
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map.fromEntries(sortedEntries);
  }
}
