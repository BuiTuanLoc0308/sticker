import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_recent.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_shop.dart';

// ignore: must_be_immutable
class StickerThumb extends StatefulWidget {
  StateSetter modalSetState;
  ScrollController scrollController;
  Map<String, List<Sticker>> allStickerPro;
  bool isRecentSelected;
  List<Sticker> thumbList;
  String currentStickerType;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  Function(String) onStickerTypeChanged;

  StickerThumb({
    super.key,
    required this.modalSetState,
    required this.scrollController,
    required this.allStickerPro,
    required this.isRecentSelected,
    required this.thumbList,
    required this.currentStickerType,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.onStickerTypeChanged,
  });

  @override
  State<StickerThumb> createState() => _StickerThumbState();
}

class _StickerThumbState extends State<StickerThumb> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Tạo thumb cho shop Sticker
          StickerShop(
            modalSetState: widget.modalSetState,
            scrollController: widget.scrollController,
            allStickerPro: widget.allStickerPro,
            isRecentSelected: widget.isRecentSelected,
            thumbList: widget.thumbList,
            currentStickerType: widget.currentStickerType,
            recentsStickerList: widget.recentsStickerList,
            chatContentList: widget.chatContentList,
          ),
          // Tạo thumbnail cho recents Sticker
          Padding(
            padding: const EdgeInsets.only(right: 5, left: 10),
            child: StickerRecent(
              isRecentSelected: widget.isRecentSelected,
              modalSetState: widget.modalSetState,
              currentStickerType: widget.currentStickerType,
              scrollController: widget.scrollController,
              onStickerTypeChanged: (newType) {
                widget.modalSetState(() {
                  widget.onStickerTypeChanged(newType);
                });
              },
            ),
          ),
          // Tạo danh sách thumbnail cho các Sticker
          ..._stickerThumbList(widget.modalSetState, widget.scrollController),
        ],
      ),
    );
  }

  List<Widget> _stickerThumbList(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    // Lấy thumbnail hiện lên giao diện
    return List.generate(widget.thumbList.length, (index) {
      Sticker thumbnail = widget.thumbList[index];
      // thumbnail.type == currentStickerType ? isThumbnailSelected = true : false
      bool isThumbnailSelected = thumbnail.type == widget.currentStickerType;

      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: GestureDetector(
          onTap: () {
            modalSetState(() {
              widget.onStickerTypeChanged(thumbnail.type);
              scrollController.jumpTo(0);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 0),
            width: 45,
            height: 45,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color:
                  isThumbnailSelected
                      ? Colors.black.withAlpha(32)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(thumbnail.path, fit: BoxFit.cover),
          ),
        ),
      );
    });
  }
}
