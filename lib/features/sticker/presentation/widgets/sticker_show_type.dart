import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/core/utils/update_thumb.dart';

// ignore: must_be_immutable
class StickerShowType extends StatefulWidget {
  ScrollController scrollController;
  StateSetter modalSetState;
  String stickerType;
  int length;
  String currentStickerType;
  List<Sticker> thumbList;
  bool isRecentSelected;

  StickerShowType({
    super.key,
    required this.scrollController,
    required this.modalSetState,
    required this.stickerType,
    required this.length,
    required this.currentStickerType,
    required this.thumbList,
    required this.isRecentSelected,
  });

  @override
  State<StickerShowType> createState() => _StickerShowTypeState();
}

class _StickerShowTypeState extends State<StickerShowType> {
  @override
  Widget build(BuildContext context) {
    return _showStickerType(
      widget.modalSetState,
      widget.scrollController,
      widget.stickerType,
      widget.length,
    );
  }

  Widget _showStickerType(
    StateSetter modalSetState,
    ScrollController scrollController,
    String stickerType,
    int stickerCount, {
    bool showCount = false,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () {
            widget.isRecentSelected = false;
            // Nếu ấn vào chữ Recents thì không có action
            stickerType != 'Recents'
                ? setState(() {
                  updateThumbnailSticker(
                    stickerThumb: widget.thumbList,
                    stickerType: stickerType,
                    maxLength: widget.thumbList.length,
                  );
                })
                : widget.isRecentSelected = true;

            modalSetState(() {
              widget.currentStickerType = stickerType;
              scrollController.jumpTo(0);
            });
          },
          child:
              showCount == true
                  ? Text(
                    '$stickerType ($stickerCount)',
                    style: const TextStyle(fontSize: 20),
                  )
                  : Text(stickerType, style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
