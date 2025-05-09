import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_add.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_recent.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_shop.dart';

// ignore: must_be_immutable
class StickerThumb extends StatefulWidget {
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

  StateSetter modalSetState;
  ScrollController scrollController;
  Map<String, List<Sticker>> allStickerPro;
  bool isRecentSelected;
  List<Sticker> thumbList;
  String currentStickerType;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  Function(String) onStickerTypeChanged;

  @override
  State<StickerThumb> createState() => _StickerThumbState();
}

class _StickerThumbState extends State<StickerThumb> {
  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          // Tạo thumb cho shop Sticker
          StickerShop(
            modalSetState: widget.modalSetState,
            scrollController: widget.scrollController,
            allStickerPro: widget.allStickerPro,
            isRecentSelected: widget.isRecentSelected,
            thumbList: widget.thumbList,
            recentsStickerList: widget.recentsStickerList,
            chatContentList: widget.chatContentList,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: screenSize * 0.04,
              right: screenSize * 0.02,
            ),
            child: const StickerAdd(),
          ),
          // Tạo thumbnail cho recents Sticker
          StickerRecent(
            isRecentSelected: widget.isRecentSelected,
            modalSetState: widget.modalSetState,
            currentStickerType: widget.currentStickerType,
            scrollController: widget.scrollController,
            onStickerTypeChanged: (String newType) {
              widget.modalSetState(() {
                widget.onStickerTypeChanged(newType);
              });
            },
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
    return List<Widget>.generate(widget.thumbList.length, (int index) {
      Sticker thumbnail = widget.thumbList[index];
      // thumbnail.type == currentStickerType ? isThumbnailSelected = true : false
      bool isThumbnailSelected = thumbnail.type == widget.currentStickerType;

      final double screenSize = MediaQuery.of(context).size.width;

      return Padding(
        padding: EdgeInsets.only(right: screenSize * 0.01),
        child: GestureDetector(
          onTap: () {
            modalSetState(() {
              widget.onStickerTypeChanged(thumbnail.type);
              scrollController.jumpTo(0);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(),
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
