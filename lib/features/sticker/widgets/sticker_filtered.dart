import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_grid.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_show_type.dart';

// ignore: must_be_immutable
class StickerFiltered extends StatefulWidget {
  StickerFiltered({
    super.key,
    required this.currentStickerType,
    required this.allStickerList,
    required this.scrollController,
    required this.modalSetState,
    required this.isRecentSelected,
    required this.thumbList,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.allStickerPro,
    required this.onStickerTypeChanged,
  });

  String currentStickerType;
  Map<String, List<Sticker>> allStickerList;
  ScrollController scrollController;
  StateSetter modalSetState;
  bool isRecentSelected;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  Map<String, List<Sticker>> allStickerPro;
  Function(String) onStickerTypeChanged;

  @override
  State<StickerFiltered> createState() => _StickerFilteredState();
}

class _StickerFilteredState extends State<StickerFiltered> {
  @override
  Widget build(BuildContext context) {
    final Map<String, List<Sticker>> filteredStickers =
        (widget.currentStickerType == 'Recents')
            ? Map<String, List<Sticker>>.fromEntries(
              widget.allStickerList.entries.take(5),
            )
            : <String, List<Sticker>>{
              widget.currentStickerType:
                  widget.allStickerList[widget.currentStickerType] ??
                  <Sticker>[],
            };

    return Expanded(
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers:
            filteredStickers.entries
                .expand((MapEntry<String, List<Sticker>> entry) {
                  // Lấy key là loại của Sticker
                  final String stickerType = entry.key;
                  // Lấy value là tất cả các Sticker
                  final List<Sticker> stickers =
                      (widget.currentStickerType == 'Recents')
                          ? entry.value.take(5).toList()
                          : entry.value;

                  return stickers.isNotEmpty
                      ? <StatefulWidget>[
                        StickerShowType(
                          modalSetState: widget.modalSetState,
                          scrollController: widget.scrollController,
                          stickerType: stickerType,
                          stickerCount: entry.value.length,
                          showCount: false,
                          isViewOnly:
                              widget.currentStickerType == 'Recents'
                                  ? false
                                  : true,
                          isRecentSelected: widget.isRecentSelected,
                          thumbList: widget.thumbList,
                          onStickerTypeChanged: (String newType) {
                            setState(() {
                              widget.currentStickerType = newType;
                              widget.isRecentSelected = newType == 'Recents';
                            });
                            widget.onStickerTypeChanged(newType);
                          },
                        ),
                        StickerGrid(
                          stickers: stickers,
                          stickerType: stickerType,
                          scrollController: widget.scrollController,
                          isViewOnly:
                              widget.currentStickerType == 'Recents'
                                  ? true
                                  : false,
                          isLocked: true,
                          thumbList: widget.thumbList,
                          recentsStickerList: widget.recentsStickerList,
                          chatContentList: widget.chatContentList,
                          allStickerPro: widget.allStickerPro,
                        ),
                      ]
                      : <Widget>[];
                })
                .cast<Widget>()
                .toList(),
      ),
    );
  }
}
