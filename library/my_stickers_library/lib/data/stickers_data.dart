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
                type: 'Koala',
              ),
              Sticker(
                  path: 'packages/my_stickers/assets/koala/koala_night.png',
                  type: 'Koala',
                  isPro: true),
              Sticker(
                  path:
                      'packages/my_stickers/assets/christmas/mr_christmas.png',
                  type: 'Christmas'),
              Sticker(
                path:
                    'packages/my_stickers/assets/christmas/christmas_tree.png',
                type: 'Christmas',
              ),
              Sticker(
                  path:
                      'packages/my_stickers/assets/christmas/christmas_cat.png',
                  type: 'Christmas',
                  isPro: true),
              Sticker(
                path: 'packages/my_stickers/assets/love/love_birds.png',
                type: 'Love',
              ),
              Sticker(
                  path: 'packages/my_stickers/assets/love/love_bee.png',
                  type: 'Love',
                  isPro: true),
              Sticker(
                path: 'packages/my_stickers/assets/love/love_dog.png',
                type: 'Love',
              ),
              Sticker(
                path: 'packages/my_stickers/assets/food/french_fries.png',
                type: 'Food',
              ),
              Sticker(
                  path: 'packages/my_stickers/assets/food/burger.png',
                  type: 'Food',
                  isPro: true),
              Sticker(
                path: 'packages/my_stickers/assets/food/pizza.png',
                type: 'Food',
              ),
            ]).expand((e) => e),
  ];

  // static Map<String, List<Sticker>> getAllSticker() {
  //   final grouped = groupBy(_allSticker, (Sticker s) => s.type);

  //   // Sau đó shuffle luôn thứ tự các nhóm
  //   final shuffledEntries = grouped.entries.toList()..shuffle();

  //   return Map.fromEntries(shuffledEntries);
  // }

  static Map<String, List<Sticker>> getAllSticker() {
    final Map<String, List<Sticker>> groupedStickers = {};

    for (final sticker in _allSticker) {
      groupedStickers.putIfAbsent(sticker.type, () => []);
      groupedStickers[sticker.type]!.add(sticker);
    }

    // Sắp xếp mỗi nhóm: isPro == false trước, isPro == true sau
    for (final type in groupedStickers.keys) {
      groupedStickers[type]!.sort((a, b) {
        if (a.isPro == b.isPro) return 0;
        return a.isPro ? 1 : -1;
      });
    }

    final entries = groupedStickers.entries.toList()..shuffle();
    final shuffledMap = Map<String, List<Sticker>>.fromEntries(entries);

    return shuffledMap;
  }

  static Map<String, List<Sticker>> getStickerPro() {
    final proStickers =
        _allSticker.where((sticker) => sticker.isPro == true).toList();
    final grouped = groupBy(proStickers, (Sticker s) => s.type);

    return grouped;
  }

  static List<Sticker> getStickerThumb() {
    final grouped = groupBy(_allSticker, (Sticker s) => s.type);
    final thumbs = grouped.values.map((stickers) => stickers.first).toList()
      ..shuffle();

    return thumbs;
  }
}
