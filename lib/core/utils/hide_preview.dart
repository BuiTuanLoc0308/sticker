import 'package:flutter/material.dart';

OverlayEntry? _previewOverlay;

void hideStickerPreview() {
  _previewOverlay?.remove();
  _previewOverlay = null;
}
