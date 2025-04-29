import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_filtered_grid.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_search.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_show_type.dart';

// ignore: must_be_immutable
class StickerShop extends StatefulWidget {
  ScrollController scrollController;
  Map<String, List<Sticker>> allStickerPro;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  String currentStickerType;
  List<Sticker> thumbList;
  bool isRecentSelected;
  Map<String, List<Sticker>> allStickerList;

  StickerShop({
    super.key,
    required this.scrollController,
    required this.allStickerPro,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.currentStickerType,
    required this.thumbList,
    required this.isRecentSelected,
    required this.allStickerList,
  });

  @override
  State<StickerShop> createState() => _StickerShopState();
}

class _StickerShopState extends State<StickerShop> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _buildShopStickerUI(widget.scrollController),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Show loading spinner
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return snapshot.data ?? const SizedBox();
        }
      },
    );
  }

  Future<T?> _buildShopStickerUI<T>(ScrollController scrollController) {
    return showModalBottomSheet<T>(
      useSafeArea: true,
      // Bo tròn góc
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // Màu viền
        side: BorderSide(color: Colors.black, width: 0.5),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (
            BuildContext statefulBuilderContext,
            StateSetter modalSetState,
          ) {
            return Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.02,
              ),
              child: Column(
                children: [
                  _topShopStickerUI(modalContext),
                  Expanded(
                    child: _shopStickerList(modalSetState, scrollController),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _topShopStickerUI(BuildContext modalContext) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
            child: StickerSearch(),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Đóng modal khi nhấn Done
            Navigator.pop(modalContext);
          },
          child: Text(
            'Done',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _shopStickerList(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    return CustomScrollView(
      controller: scrollController,
      slivers:
          widget.allStickerPro.entries
              .expand((entry) {
                // Lấy key là loại của Sticker
                final String stickerType = entry.key;
                // Lấy value là tất cả các Sticker
                final List<Sticker> stickers = entry.value.take(5).toList();

                return stickers.isNotEmpty
                    ? [
                      // _showStickerType(
                      //   modalSetState,
                      //   scrollController,
                      //   stickerType,
                      //   entry.value.length,
                      //   showCount: true,
                      // ),
                      StickerShowType(
                        scrollController: scrollController,
                        modalSetState: modalSetState,
                        stickerType: stickerType,
                        length: entry.value.length,
                        currentStickerType: widget.currentStickerType,
                        thumbList: widget.thumbList,
                        isRecentSelected: widget.isRecentSelected,
                      ),
                      // _filteredStickerList(
                      //   stickers,
                      //   stickers.map((sticker) => sticker.type).first,
                      //   scrollController,
                      //   lockProSticker: false,
                      // ),
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
    );
  }
}
