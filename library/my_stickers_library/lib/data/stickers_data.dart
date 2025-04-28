import 'package:collection/collection.dart';
import 'package:my_stickers/data/models/sticker.dart';

class MyStickers {
  static final List<Sticker> _allSticker = [
    ...List.generate(
        30,
        (_) => [
              Sticker(
                path: 'packages/my_stickers/assets/koala/koala_birthday.png',
                type: 'Koala',
              ),
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
                  type: 'Love',
                  isPro: true),
              Sticker(
                  path: 'packages/my_stickers/assets/love/love_dog.png',
                  type: 'Love',
                  isPro: true),
              Sticker(
                  path: 'packages/my_stickers/assets/food/french_fries.png',
                  type: 'Food',
                  isPro: true),
              Sticker(
                  path: 'packages/my_stickers/assets/food/pizza.png',
                  type: 'Food',
                  isPro: true),
            ]).expand((e) => e),
  ];

  static List<Sticker> _thumbnailSticker = [
    Sticker(
      path: 'packages/my_stickers/assets/koala/koala_birthday.png',
      type: 'Koala',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/christmas/mr_christmas.png',
      type: 'Christmas',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/love/love_birds.png',
      type: 'Love',
    ),
    Sticker(
      path: 'packages/my_stickers/assets/food/french_fries.png',
      type: 'Food',
    ),
  ];

  static List<Sticker> getStickerThumb() {
    return _thumbnailSticker;
  }

  static Map<String, List<Sticker>> getStickersByType() {
    final grouped = groupBy(_allSticker, (Sticker s) => s.type);
    final shuffledEntries = grouped.entries.toList()..shuffle();
    return Map.fromEntries(shuffledEntries);
  }

  static Map<String, List<Sticker>> getStickerPro() {
    final proStickers =
        _allSticker.where((sticker) => sticker.isPro == true).toList();
    final grouped = groupBy(proStickers, (Sticker s) => s.type);
    return grouped;
  }
}
