import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/core/utils/thumb_update.dart';

// ignore: must_be_immutable
class StickerShowType extends StatefulWidget {
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

  StateSetter modalSetState;
  ScrollController scrollController;
  String stickerType;
  int stickerCount;
  bool showCount;
  bool isRecentSelected;
  List<Sticker> thumbList;
  Function(String) onStickerTypeChanged;
  bool isViewOnly;

  @override
  State<StickerShowType> createState() => _StickerShowTypeState();
}

class _StickerShowTypeState extends State<StickerShowType> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.005,
        ),
        child: GestureDetector(
          onTap:
              widget.isViewOnly
                  ? () {}
                  : () {
                    widget.isRecentSelected = widget.stickerType == 'Recents';
                    // Nếu đã là Recents và đang được chọn => không làm gì
                    if (widget.stickerType == 'Recents' &&
                        widget.isRecentSelected) {
                      return;
                    }
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
                    children: <Widget>[
                      Text(
                        widget.stickerType,
                        style: const TextStyle(fontSize: 20),
                      ),
                      if (!widget.isViewOnly && widget.stickerType != 'Recents')
                        const Icon(Icons.chevron_right),
                    ],
                  ),
        ),
      ),
    );
  }
}
