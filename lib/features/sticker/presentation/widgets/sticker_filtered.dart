import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_filtered_grid.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_show_type.dart';

// ignore: must_be_immutable
class StickerFiltered extends StatefulWidget {
  String currentStickerType;
  List<Sticker> thumbList;
  Map<String, List<Sticker>> allStickerList;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  ScrollController scrollController;
  StateSetter modalSetState;
  bool isRecentSelected;

  StickerFiltered({
    super.key,
    required this.currentStickerType,
    required this.thumbList,
    required this.allStickerList,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.scrollController,
    required this.modalSetState,
    required this.isRecentSelected,
  });

  @override
  State<StickerFiltered> createState() => _StickerFilteredState();
}

class _StickerFilteredState extends State<StickerFiltered> {
  @override
  Widget build(BuildContext context) {
    return _buildFilteredStickerUI(
      widget.scrollController,
      widget.modalSetState,
    );
  }

  Widget _buildFilteredStickerUI(
    ScrollController scrollController,
    StateSetter modalSetState,
  ) {
    final Map<String, List<Sticker>> filteredStickers =
        (widget.currentStickerType == 'Recents')
            // Chỉ lấy 5 loại Sticker để hiện ở phần Recents
            ? Map.fromEntries(widget.allStickerList.entries.take(5))
            // Chỉ lấy 1 loại Sticker theo currentStickerType
            : {
              widget.currentStickerType:
                  widget.allStickerList[widget.currentStickerType] ?? [],
            };

    return Expanded(
      child: CustomScrollView(
        controller: scrollController,
        slivers:
            filteredStickers.entries
                .expand((entry) {
                  // Lấy key là loại của Sticker
                  final String stickerType = entry.key;
                  // Lấy value là tất cả các Sticker
                  final List<Sticker> stickers =
                      (widget.currentStickerType == 'Recents')
                          ? entry.value.take(5).toList()
                          : entry.value;

                  return stickers.isNotEmpty
                      ? [
                        StickerShowType(
                          scrollController: scrollController,
                          modalSetState: modalSetState,
                          stickerType: stickerType,
                          length: entry.value.length,
                          currentStickerType: widget.currentStickerType,
                          thumbList: widget.thumbList,
                          isRecentSelected: widget.isRecentSelected,
                        ),
                        StickerFilteredGrid(
                          stickers: stickers,
                          stickerType: stickerType,
                          recentsStickerList: widget.recentsStickerList,
                          chatContentList: widget.chatContentList,
                          thumbList: widget.thumbList,
                          scrollController: scrollController,
                          allStickerList: widget.allStickerList,
                          currentStickerType: widget.currentStickerType,
                          isRecentSelected: widget.isRecentSelected,
                          modalSetState: modalSetState,
                        ),
                      ]
                      : [];
                })
                .cast<Widget>()
                .toList(),
      ),
    );
  }
}
