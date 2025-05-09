import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_grid.dart';

Future<T?> stickerShopDetail<T>({
  required BuildContext context,
  required ScrollController scrollController,
  required String stickerType,
  required Map<String, List<Sticker>> allStickerPro,
  required List<Sticker> thumbList,
  required List<Sticker> recentsStickerList,
  required List<Sticker> chatContentList,
}) {
  final screenSize = MediaQuery.of(context).size.height;

  return showModalBottomSheet<T>(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
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
          return DraggableScrollableSheet(
            initialChildSize: 0.4,
            maxChildSize: 0.7,
            minChildSize: 0.2,
            expand: false,
            builder: (context, scrollController) {
              return Padding(
                padding: EdgeInsets.only(
                  top: screenSize * 0.01,
                  left: screenSize * 0.01,
                  right: screenSize * 0.01,
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenSize * 0.005),
                        child: Center(
                          child: Text(
                            '$stickerType Premium',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(screenSize * 0.01),
                      sliver: StickerGrid(
                        stickers: allStickerPro[stickerType] ?? [],
                        stickerType: stickerType,
                        scrollController: scrollController,
                        isViewOnly: true,
                        isLocked: false,
                        thumbList: thumbList,
                        recentsStickerList: recentsStickerList,
                        chatContentList: chatContentList,
                        allStickerPro: allStickerPro,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenSize * 0.01,
                          bottom: screenSize * 0.02,
                        ),
                        child: MaterialButton(
                          padding: EdgeInsets.all(screenSize * 0.015),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            // Biến các sticker này isPro = false và-
                            // đưa vào chung với nhóm sticker đó
                          },
                          child: Text(
                            'Add to Library',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}
