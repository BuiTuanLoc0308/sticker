import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_filtered.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_search.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_thumb.dart';

void stickerPicker<T>({
  required BuildContext context,
  required Map<String, List<Sticker>> allStickerPro,
  required bool isRecentSelected,
  required List<Sticker> thumbList,
  required String currentStickerType,
  required List<Sticker> recentsStickerList,
  required List<Sticker> chatContentList,
  required Map<String, List<Sticker>> allStickerList,
  required Function(String) onStickerTypeChanged,
}) async {
  FocusScope.of(context).unfocus();

  final double screenSize = MediaQuery.of(context).size.width;

  showModalBottomSheet<T>(
    // Không làm mờ đằng sau modal
    barrierColor: Colors.transparent,
    // Bo tròn góc
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      // Màu viền
      side: BorderSide(width: 0.5),
    ),
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext modalContext) {
      return Padding(
        padding: EdgeInsets.only(
          // Trả về chiều cao của phần bị che bởi bàn phím
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (
            BuildContext statefulBuilderContext,
            StateSetter modalSetState,
          ) {
            return DraggableScrollableSheet(
              // Khi mở cố định tại 40% màn hình
              initialChildSize: 0.4,
              // Kéo lên tối đa 85%
              maxChildSize: 0.8,
              // Kéo xuống tối đa 20%
              minChildSize: 0.2,
              expand: false,
              builder: (
                BuildContext context,
                ScrollController scrollController,
              ) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: screenSize * 0.03,
                    right: screenSize * 0.03,
                  ),
                  child: Column(
                    children: <Widget>[
                      StickerThumb(
                        modalSetState: modalSetState,
                        scrollController: scrollController,
                        allStickerPro: allStickerPro,
                        isRecentSelected: isRecentSelected,
                        thumbList: thumbList,
                        currentStickerType: currentStickerType,
                        recentsStickerList: recentsStickerList,
                        chatContentList: chatContentList,
                        onStickerTypeChanged: (String newType) {
                          modalSetState(() {
                            currentStickerType = newType;
                            isRecentSelected = newType == 'Recents';
                          });

                          onStickerTypeChanged(newType);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenSize * 0.02,
                          bottom: screenSize * 0.01,
                        ),
                        child: const StickerSearch(),
                      ),
                      StickerFiltered(
                        currentStickerType: currentStickerType,
                        allStickerList: allStickerList,
                        scrollController: scrollController,
                        modalSetState: modalSetState,
                        isRecentSelected: isRecentSelected,
                        thumbList: thumbList,
                        recentsStickerList: recentsStickerList,
                        chatContentList: chatContentList,
                        allStickerPro: allStickerPro,
                        onStickerTypeChanged: (String newType) {
                          modalSetState(() {
                            currentStickerType = newType;
                            isRecentSelected = newType == 'Recents';
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}
