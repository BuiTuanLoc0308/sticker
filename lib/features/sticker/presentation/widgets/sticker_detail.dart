import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:sticker_app/features/sticker/presentation/widgets/sticker_filtered.dart';

// ignore: must_be_immutable
class StickerDetail extends StatefulWidget {
  String stickerType;
  String currentStickerType;
  List<Sticker> thumbList;
  Map<String, List<Sticker>> allStickerList;
  List<Sticker> recentsStickerList;
  List<Sticker> chatContentList;
  StateSetter modalSetState;
  ScrollController scrollController;
  bool isRecentSelected;

  StickerDetail({
    super.key,
    required this.currentStickerType,
    required this.thumbList,
    required this.allStickerList,
    required this.recentsStickerList,
    required this.chatContentList,
    required this.scrollController,
    required this.modalSetState,
    required this.isRecentSelected,
    required this.stickerType,
  });

  @override
  State<StickerDetail> createState() => _StickerDetailState();
}

class _StickerDetailState extends State<StickerDetail> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _buildDetailStickerUI(
        widget.scrollController,
        widget.stickerType,
      ),
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

  Future<T?> _buildDetailStickerUI<T>(
    ScrollController scrollController,
    String stickerType,
  ) {
    return showModalBottomSheet<T>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
              maxChildSize: 0.6,
              minChildSize: 0.2,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: _topDetailStickerUI(stickerType),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.02,
                        ),
                        sliver: _detailStickerList(
                          scrollController,
                          stickerType,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: MaterialButton(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01,
                          ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Add to Library',
                            style: TextStyle(fontSize: 25),
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

  Widget _topDetailStickerUI(String stickerType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Center(
        //     child: Text(
        //       'Cancel',
        //       style: TextStyle(fontSize: 18),
        //     ),
        //   ),
        // ),
        Text(
          '$stickerType Pro',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        // Icon(Icons.share),
      ],
    );
  }

  Widget _detailStickerList(
    ScrollController scrollController,
    String stickerType,
  ) {
    // return _filteredStickerList(
    //   allStickerPro[stickerType] ?? [],
    //   stickerType,
    //   scrollController,
    //   isViewOnly: true,
    //   lockProSticker: false,
    // );
    return StickerFiltered(
      currentStickerType: widget.currentStickerType,
      thumbList: widget.thumbList,
      allStickerList: widget.allStickerList,
      recentsStickerList: widget.recentsStickerList,
      chatContentList: widget.chatContentList,
      scrollController: scrollController,
      modalSetState: widget.modalSetState,
      isRecentSelected: widget.isRecentSelected,
    );
  }
}
