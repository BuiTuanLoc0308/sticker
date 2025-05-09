import 'package:flutter/material.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_custom_uploader.dart';

class StickerAdd extends StatelessWidget {
  const StickerAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();

        customStickerUploader(context: context);
      },
      child: const Icon(Icons.add_reaction_outlined, size: 25),
    );
  }
}
