import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_filtered.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_search.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_thumb_bar.dart';

// ignore: must_be_immutable
class StickerPage extends StatefulWidget {
  String currentStickerType;
  List<Sticker> thumbList;
  Map<String, List<Sticker>> allStickerList;
  List<Sticker> recentsStickerList;
  bool isRecentSelected;
  Map<String, List<Sticker>> allStickerPro;
  List<Sticker> chatContentList;

  StickerPage({
    super.key,
    required this.currentStickerType,
    required this.thumbList,
    required this.allStickerList,
    required this.recentsStickerList,
    required this.isRecentSelected,
    required this.allStickerPro,
    required this.chatContentList,
  });

  @override
  State<StickerPage> createState() => _StickerPageState();
}

class _StickerPageState extends State<StickerPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _buildStickerPickerUI(context),
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

  Future<T?> _buildStickerPickerUI<T>(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final result = await showModalBottomSheet<T>(
      // Không làm mờ đằng sau modal
      barrierColor: Colors.transparent,
      // Bo tròn góc
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // Màu viền
        side: BorderSide(color: Colors.black, width: 0.5),
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
                // Khi mở cố định tại % màn hình
                initialChildSize: 0.5,
                // Kéo lên tối đa %
                maxChildSize: 0.85,
                // Kéo xuống tối đa %
                minChildSize: 0.4,
                expand: false,
                builder: (context, scrollController) {
                  return Padding(
                    padding: EdgeInsets.only(
                      // Căn lề dựa theo màn hình
                      left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Column(
                      children: [
                        StickerThumbBar(
                          modalSetState: modalSetState,
                          scrollController: scrollController,
                          currentStickerType: widget.currentStickerType,
                          thumbList: widget.thumbList,
                          recentsStickerList: widget.recentsStickerList,
                          chatContentList: widget.chatContentList,
                          isRecentSelected: widget.isRecentSelected,
                          allStickerPro: widget.allStickerPro,
                          allStickerList: widget.allStickerList,
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: StickerSearch(),
                        ),
                        StickerFiltered(
                          currentStickerType: widget.currentStickerType,
                          thumbList: widget.thumbList,
                          allStickerList: widget.allStickerList,
                          recentsStickerList: widget.recentsStickerList,
                          chatContentList: widget.chatContentList,
                          scrollController: scrollController,
                          modalSetState: modalSetState,
                          isRecentSelected: widget.isRecentSelected,
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
    // Tránh tự động mở chat sau khi tắt modal
    if (context.mounted) {
      FocusScope.of(context).unfocus();
    }

    return result;
  }
}
