import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_shop.dart';

// ignore: must_be_immutable
class StickerThumbBar extends StatefulWidget {
  StateSetter modalSetState;
  ScrollController scrollController;
  String currentStickerType;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  bool isRecentSelected;
  Map<String, List<Sticker>> allStickerPro;
  Map<String, List<Sticker>> allStickerList;

  StickerThumbBar({
    super.key,
    required this.modalSetState,
    required this.scrollController,
    required this.currentStickerType,
    required this.thumbList,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.isRecentSelected,
    required this.allStickerPro,
    required this.allStickerList,
  });

  @override
  State<StickerThumbBar> createState() => _StickerThumbBarState();
}

class _StickerThumbBarState extends State<StickerThumbBar> {
  @override
  Widget build(BuildContext context) {
    return _buildThumbnailStickerUI(
      widget.modalSetState,
      widget.scrollController,
    );
  }

  Widget _buildThumbnailStickerUI(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Tạo thumb cho shop Sticker
          _shopStickerThumb(modalSetState, scrollController),
          // Tạo thumbnail cho recents Sticker
          Padding(
            padding: const EdgeInsets.only(right: 5, left: 10),
            child: _recentStickerThumb(modalSetState, scrollController),
          ),
          // Tạo danh sách thumbnail cho các Sticker
          ..._stickerThumbList(modalSetState, scrollController),
        ],
      ),
    );
  }

  Widget _recentStickerThumb(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isRecentSelected = true;
        });
        modalSetState(() {
          widget.currentStickerType = 'Recents';
          scrollController.jumpTo(0);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color:
              widget.isRecentSelected
                  ? Colors.black.withAlpha(32)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Icons.access_time),
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
            widget.isRecentSelected = false;
            modalSetState(() {
              widget.currentStickerType = thumbnail.type;
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

  Widget _shopStickerThumb(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    return GestureDetector(
      onTap: () {
        modalSetState(() {
          scrollController.jumpTo(0);
        });
        StickerShop(
          scrollController: scrollController,
          allStickerPro: widget.allStickerPro,
          recentsStickerList: widget.recentsStickerList,
          chatContentList: widget.chatContentList,
          currentStickerType: widget.currentStickerType,
          thumbList: widget.thumbList,
          isRecentSelected: widget.isRecentSelected,
          allStickerList: widget.allStickerList,
        );
      },
      child: Icon(Icons.add_reaction_outlined, size: 25),
    );
  }
}
