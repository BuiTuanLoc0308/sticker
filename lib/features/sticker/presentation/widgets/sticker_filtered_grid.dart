import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/core/utils/hide_preview.dart';
import 'package:sticker_app/core/utils/show_preview.dart';
import 'package:sticker_app/core/utils/update_thumb.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_detail.dart';

// ignore: must_be_immutable
class StickerFilteredGrid extends StatefulWidget {
  List<Sticker> stickers;
  String stickerType;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  List<Sticker> thumbList;
  String currentStickerType;
  Map<String, List<Sticker>> allStickerList;
  StateSetter modalSetState;
  ScrollController scrollController;
  bool isRecentSelected;

  StickerFilteredGrid({
    super.key,
    required this.stickers,
    required this.stickerType,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.thumbList,
    required this.scrollController,
    required this.allStickerList,
    required this.currentStickerType,
    required this.isRecentSelected,
    required this.modalSetState,
  });

  @override
  State<StickerFilteredGrid> createState() => _StickerFilteredGridState();
}

class _StickerFilteredGridState extends State<StickerFilteredGrid> {
  @override
  Widget build(BuildContext context) {
    return _filteredStickerList(
      widget.stickers,
      widget.stickerType,
      widget.scrollController,
    );
  }

  Widget _filteredStickerList(
    List<Sticker> stickers,
    String stickerType,
    ScrollController scrollController, {
    bool isViewOnly = false,
    bool lockProSticker = false,
  }) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final sticker = stickers[index];
        bool isLocked = lockProSticker && sticker.isPro;

        return GestureDetector(
          onLongPress: () => showStickerPreview(context, sticker),
          onTap:
              isViewOnly
                  ? () {}
                  : () {
                    sticker.isPro
                        ? StickerDetail(
                          currentStickerType: widget.currentStickerType,
                          thumbList: widget.thumbList,
                          allStickerList: widget.allStickerList,
                          recentsStickerList: widget.recentsStickerList,
                          chatContentList: widget.chatContentList,
                          scrollController: scrollController,
                          modalSetState: widget.modalSetState,
                          isRecentSelected: widget.isRecentSelected,
                          stickerType: stickerType,
                        )
                        : {
                          Navigator.of(context).pop(),
                          // Nếu Sticker đã có trong Recents, xóa Sticker
                          setState(() {
                            widget.recentsStickerList.removeWhere(
                              (s) => s.path == sticker.path,
                            );
                            // Thêm lại Sticker vào đầu danh sách
                            widget.recentsStickerList.insert(0, sticker);
                            // Chỉ hiển thị 5 Sticker
                            if (widget.recentsStickerList.length > 5) {
                              widget.recentsStickerList.removeAt(5);
                            }
                            // Thêm Sticker mới chọn vào chat
                            widget.chatContentList.insert(0, sticker);
                            updateThumbnailSticker(
                              stickerThumb: widget.thumbList,
                              stickerType: sticker.type,
                              maxLength: widget.thumbList.length,
                            );
                          }),
                          FocusScope.of(context).unfocus(),
                        };
                  },
          onLongPressEnd: (_) => hideStickerPreview(),
          child:
              isLocked
                  ? Stack(
                    children: [
                      Opacity(opacity: 0.5, child: Image.asset(sticker.path)),
                      Center(
                        child: Icon(Icons.lock, size: 24, color: Colors.red),
                      ),
                    ],
                  )
                  : Image.asset(sticker.path),
        );
      }, childCount: stickers.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
