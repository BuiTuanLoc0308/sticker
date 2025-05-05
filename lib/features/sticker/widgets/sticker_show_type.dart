import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/core/utils/thumb_update.dart';

// ignore: must_be_immutable
class StickerShowType extends StatefulWidget {
  StateSetter modalSetState;
  ScrollController scrollController;
  String stickerType;
  int stickerCount;
  bool showCount;
  bool isRecentSelected;
  List<Sticker> thumbList;
  Function(String) onStickerTypeChanged;
  bool isViewOnly;

  StickerShowType({
    super.key,
    required this.modalSetState,
    required this.scrollController,
    required this.stickerType,
    required this.stickerCount,
    required this.showCount,
    required this.isRecentSelected,
    required this.thumbList,
    required this.onStickerTypeChanged,
    required this.isViewOnly,
  });

  @override
  State<StickerShowType> createState() => _StickerShowTypeState();
}

class _StickerShowTypeState extends State<StickerShowType> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap:
              widget.isViewOnly
                  ? () {}
                  : () {
                    widget.isRecentSelected = false;
                    // Nếu ấn vào Recents thì không có action
                    widget.stickerType != 'Recents'
                        ? setState(() {
                          updateThumbnailSticker(
                            stickerThumb: widget.thumbList,
                            stickerType: widget.stickerType,
                          );
                        })
                        : widget.isRecentSelected = true;

                    widget.modalSetState(() {
                      widget.onStickerTypeChanged(widget.stickerType);
                      widget.scrollController.jumpTo(0);
                    });
                  },
          child:
              widget.showCount
                  ? Text(
                    '${widget.stickerType} (${widget.stickerCount})',
                    style: const TextStyle(fontSize: 20),
                  )
                  : Row(
                    children: [
                      Text(widget.stickerType, style: TextStyle(fontSize: 20)),
                      if (!widget.isViewOnly) Icon(Icons.chevron_right),
                    ],
                  ),
        ),
      ),
    );
  }
}
