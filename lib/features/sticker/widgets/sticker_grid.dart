import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/core/utils/sticker_preview.dart';
import 'package:sticker_app/core/utils/thumb_update.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_shop_detail.dart';

// ignore: must_be_immutable
class StickerGrid extends StatefulWidget {
  List<Sticker> stickers;
  String stickerType;
  ScrollController scrollController;
  bool isViewOnly = false;
  bool isLocked = false;
  List<Sticker> thumbList;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  Map<String, List<Sticker>> allStickerPro;

  StickerGrid({
    super.key,
    required this.stickers,
    required this.stickerType,
    required this.scrollController,
    required this.isViewOnly,
    required this.isLocked,
    required this.thumbList,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.allStickerPro,
  });

  @override
  State<StickerGrid> createState() => _StickerGridState();
}

class _StickerGridState extends State<StickerGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final sticker = widget.stickers[index];
        return GestureDetector(
          onLongPress: () => showStickerPreview(context, sticker),
          onTap:
              widget.isViewOnly
                  ? () {}
                  : () async {
                    sticker.isPro
                        ? await stickerShopDetail(
                          context: context,
                          scrollController: widget.scrollController,
                          stickerType: widget.stickerType,
                          allStickerPro: widget.allStickerPro,
                          thumbList: widget.thumbList,
                          recentsStickerList: widget.recentsStickerList,
                          chatContentList: widget.chatContentList,
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
                            );
                          }),
                          FocusScope.of(context).unfocus(),
                        };
                  },
          onLongPressEnd: (_) => hideStickerPreview(),
          child:
              sticker.isPro && widget.isLocked
                  ? Stack(
                    children: [
                      Opacity(opacity: 0.5, child: Image.asset(sticker.path)),
                      Center(child: Icon(Icons.lock, color: Colors.red)),
                    ],
                  )
                  : Image.asset(sticker.path),
        );
      }, childCount: widget.stickers.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
