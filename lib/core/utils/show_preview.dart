import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';

OverlayEntry? _previewOverlay;

void showStickerPreview(BuildContext context, Sticker sticker) {
  _previewOverlay = OverlayEntry(
    builder: (overlayEntryContext) {
      return GestureDetector(
        onTap: () {
          _previewOverlay?.remove();
          _previewOverlay = null;
        },
        child: Positioned.fill(
          child: Container(
            color: Colors.black.withAlpha(128),
            alignment: Alignment.center,
            child: Image.asset(
              sticker.path,
              width: MediaQuery.of(overlayEntryContext).size.width * 0.7,
              height: MediaQuery.of(overlayEntryContext).size.width * 0.7,
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(_previewOverlay!);
}
