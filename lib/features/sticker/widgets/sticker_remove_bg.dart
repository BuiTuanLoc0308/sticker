import 'dart:io';
import 'package:flutter/material.dart';

OverlayEntry? _imgOverlay;

void imageOverlay(BuildContext context, File imageFile) {
  _imgOverlay = OverlayEntry(
    builder: (overlayEntryContext) {
      // Chiếm toàn bộ màn hình với Positioned.fill
      return Positioned.fill(
        child: Container(
          // 128 là mờ 50%
          color: Colors.black.withAlpha(128),
          alignment: Alignment.center,
          child: Image.file(
            imageFile,
            width: MediaQuery.of(overlayEntryContext).size.width * 0.7,
            height: MediaQuery.of(overlayEntryContext).size.width * 0.7,
          ),
        ),
      );
    },
  );
  // Lấy Overlay hiện tại từ context. Gọi '.insert()' để chèn overlay vào giao diện
  Overlay.of(context).insert(_imgOverlay!);
}
