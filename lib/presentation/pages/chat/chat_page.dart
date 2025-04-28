import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:my_stickers/my_stickers.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Tạo danh sách tất cả Sticker
  Map<String, List<Sticker>> allStickerList = {};
  // Để lưu Sticker đuọc chọn gần đây
  List<Sticker> recentsStickerList = [];
  // Lưu nội dung sticker vào chat
  List<Sticker> chatContentList = [];
  // Dùng để loại bỏ tự động mở bàn phím
  final FocusNode _focusNode = FocusNode();
  // Dùng để chèn overlay vào giao diện
  OverlayEntry? _previewOverlay;
  // Số lượng thumbnail hiển thị
  List<Sticker> thumbList = MyStickers.getStickerThumb();
  // Lấy type Sticker của Sticker hiện tại
  String currentStickerType = '';

  bool isRecentSelected = false;

  @override
  void initState() {
    super.initState();
    // Mặc định currentStickerType ban đầu-
    // -là type của sticker vị trí đầu trong thumbnail
    currentStickerType = thumbList.first.type;
    // Đưa Recents và các Sticker của Recents vào allSticker
    allStickerList = {
      'Recents': recentsStickerList,
      ...MyStickers.getStickersByType(),
    };
  }

  @override
  Widget build(BuildContext buildContext) {
    return _buildUI(buildContext);
  }

  Widget _buildUI(BuildContext buildContext) {
    return Scaffold(
      appBar: _buildAppBarUI(buildContext),
      body: _buildChatBodyUI(buildContext),
    );
  }

  PreferredSizeWidget? _buildAppBarUI(BuildContext buildContext) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(buildContext);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: const Text('username'),
      actions: const [
        Icon(Icons.phone),
        Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Icon(Icons.video_camera_back),
        ),
      ],
    );
  }

  Widget _buildChatBodyUI(BuildContext chatBodyContext) {
    return Column(
      children: [
        Expanded(child: _chatContentList()),
        _buildBottomChatUI(chatBodyContext),
      ],
    );
  }

  Widget _chatContentList() {
    return ListView.builder(
      reverse: true,
      itemCount: chatContentList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              // Độ lớn dựa theo % độ lớn màn hình
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.25,
              child: Image.asset(chatContentList[index].path),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomChatUI(BuildContext chatBodyContext) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.add_circle, size: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: _textChatInputField(chatBodyContext),
            ),
          ),
          Icon(Icons.thumb_up, size: 30),
        ],
      ),
    );
  }

  Widget _textChatInputField(BuildContext chatBodyContext) {
    return TextFormField(
      focusNode: _focusNode,
      autofocus: false,
      onTapOutside: (event) {
        // Tắt bàn phím khi ấn ra ngoài
        FocusScope.of(chatBodyContext).unfocus();
      },
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: 'Aa',
        suffixIcon: GestureDetector(
          onTap: () {
            // Tránh tự động mở bàn phím
            _focusNode.unfocus();
            _buildStickerPickerUI(chatBodyContext);
          },
          child: const Icon(Icons.emoji_emotions, size: 30),
        ),
      ),
    );
  }

  Future<T?> _buildStickerPickerUI<T>(BuildContext chatBodyContext) async {
    FocusScope.of(chatBodyContext).unfocus();

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
      context: chatBodyContext,
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
                maxChildSize: 0.85,
                // Kéo xuống tối đa 20%
                minChildSize: 0.2,
                expand: false,
                builder: (context, scrollController) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      // Cách màn hình 1%
                      bottom: MediaQuery.of(chatBodyContext).size.height * 0.01,
                    ),
                    child: Column(
                      children: [
                        _buildThumbnailStickerUI(
                          modalSetState,
                          scrollController,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: _buildSearchStickerUI(),
                        ),
                        _buildFilteredStickerUI(
                          scrollController,
                          modalSetState,
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
      FocusScope.of(chatBodyContext).unfocus();
    }

    return result;
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
          isRecentSelected = true;
        });
        modalSetState(() {
          currentStickerType = 'Recents';
          scrollController.jumpTo(0);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color:
              isRecentSelected
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
    return List.generate(thumbList.length, (index) {
      Sticker thumbnail = thumbList[index];
      // thumbnail.type == currentStickerType ? isThumbnailSelected = true : false
      bool isThumbnailSelected = thumbnail.type == currentStickerType;

      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: GestureDetector(
          onTap: () {
            isRecentSelected = false;
            modalSetState(() {
              currentStickerType = thumbnail.type;
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
        _buildShopStickerUI(scrollController);
      },
      child: Icon(Icons.add_reaction_outlined, size: 25),
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
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
            child: _buildSearchStickerUI(),
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
          allStickerList.entries
              .where((entry) => entry.key != 'Recents')
              .expand((entry) {
                // Lấy key là loại của Sticker
                final String stickerType = entry.key;
                // Lấy value là tất cả các Sticker
                final List<Sticker> stickers = entry.value.take(5).toList();

                return stickers.isNotEmpty
                    ? [
                      _showStickerType(
                        modalSetState,
                        scrollController,
                        stickerType,
                        entry.value.length,
                        showCount: true,
                      ),
                      _filteredStickerList(
                        stickers,
                        stickers.map((sticker) => sticker.type).first,
                        scrollController,
                        showDetail: true,
                      ),
                    ]
                    : [];
              })
              .cast<Widget>()
              .toList(),
    );
  }

  Widget _buildSearchStickerUI() {
    return SizedBox(
      height: 40,
      child: TextFormField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: 'Search stickers',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 0, left: 10),
            child: const Icon(Icons.search),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0),
        ),
      ),
    );
  }

  Widget _buildFilteredStickerUI(
    ScrollController scrollController,
    StateSetter modalSetState,
  ) {
    final Map<String, List<Sticker>> filteredStickers =
        (currentStickerType == 'Recents')
            // Chỉ lấy 5 loại Sticker để hiện ở phần Recents
            ? Map.fromEntries(allStickerList.entries.take(5))
            // Chỉ lấy 1 loại Sticker theo currentStickerType
            : {currentStickerType: allStickerList[currentStickerType] ?? []};

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
                      (currentStickerType == 'Recents')
                          ? entry.value.take(5).toList()
                          : entry.value;

                  return stickers.isNotEmpty
                      ? [
                        _showStickerType(
                          modalSetState,
                          scrollController,
                          stickerType,
                          entry.value.length,
                        ),
                        _filteredStickerList(
                          stickers,
                          stickers.map((sticker) => sticker.type).first,
                          scrollController,
                        ),
                      ]
                      : [];
                })
                .cast<Widget>()
                .toList(),
      ),
    );
  }

  Widget _showStickerType(
    StateSetter modalSetState,
    ScrollController scrollController,
    String stickerType,
    int stickerCount, {
    bool showCount = false,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () {
            isRecentSelected = false;
            // Nếu ấn vào Recents thì không có action
            stickerType != 'Recents'
                ? setState(() {
                  _updateThumbnailSticker(
                    stickerThumb: thumbList,
                    stickerType: stickerType,
                    maxLength: thumbList.length,
                  );
                })
                : isRecentSelected = true;

            modalSetState(() {
              currentStickerType = stickerType;
              scrollController.jumpTo(0);
            });
          },
          child:
              showCount == true
                  ? Text(
                    '$stickerType ($stickerCount)',
                    style: const TextStyle(fontSize: 20),
                  )
                  : Text(stickerType, style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  void _updateThumbnailSticker({
    required List<Sticker> stickerThumb,
    required String stickerType,
    required int maxLength,
  }) {
    final Sticker thumb = stickerThumb.firstWhere(
      (sticker) => sticker.type == stickerType,
    );
    // Nếu đã có, xóa thumbnail
    stickerThumb.removeWhere((s) => s.type == stickerType);
    // Thêm lại vào đầu danh sách
    stickerThumb.insert(0, thumb);
    // Nếu số lượng thumb nhiều hơn cho phép thì xóa phần tử cuối
    if (maxLength > 10) {
      stickerThumb.removeLast();
    }
  }

  Widget _filteredStickerList(
    List<Sticker> stickers,
    String stickerType,
    ScrollController scrollController, {
    bool showDetail = false,
    bool isViewOnly = false,
  }) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final sticker = stickers[index];
        return GestureDetector(
          onLongPress: () => _showStickerPreview(sticker),
          onTap:
              isViewOnly
                  ? () {}
                  : () {
                    showDetail == true
                        ? _buildDetailShopStickerUI(
                          scrollController,
                          stickerType,
                        )
                        : {
                          Navigator.of(context).pop(),
                          // Nếu Sticker đã có trong Recents, xóa Sticker
                          setState(() {
                            recentsStickerList.removeWhere(
                              (s) => s.path == sticker.path,
                            );
                            // Thêm lại Sticker vào đầu danh sách
                            recentsStickerList.insert(0, sticker);
                            // Chỉ hiển thị 5 Sticker
                            if (recentsStickerList.length > 5) {
                              recentsStickerList.removeAt(5);
                            }
                            // Thêm Sticker mới chọn vào chat
                            chatContentList.insert(0, sticker);
                            _updateThumbnailSticker(
                              stickerThumb: thumbList,
                              stickerType: stickerType,
                              maxLength: thumbList.length,
                            );
                          }),
                          FocusScope.of(context).unfocus(),
                        };
                  },
          onLongPressEnd: (_) => _hideStickerPreview(),
          child: Image.asset(sticker.path),
        );
      }, childCount: stickers.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }

  Future<T?> _buildDetailShopStickerUI<T>(
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
              maxChildSize: 0.7,
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
                          child: Row(
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
                                stickerType,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Icon(Icons.share),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.02,
                        ),
                        sliver: _filteredStickerList(
                          allStickerList[stickerType] ?? [],
                          stickerType,
                          scrollController,
                          isViewOnly: true,
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

  void _showStickerPreview(Sticker sticker) {
    _previewOverlay = OverlayEntry(
      builder: (overlayEntryContext) {
        // Chiếm toàn bộ màn hình với Positioned.fill
        return Positioned.fill(
          child: Container(
            // 128 là mờ 50%
            color: Colors.black.withAlpha(128),
            alignment: Alignment.center,
            child: Image.asset(
              sticker.path,
              width: MediaQuery.of(overlayEntryContext).size.width * 0.7,
              height: MediaQuery.of(overlayEntryContext).size.width * 0.7,
            ),
          ),
        );
      },
    );
    // Lấy Overlay hiện tại từ context. Gọi '.insert()' để chèn overlay vào giao diện
    Overlay.of(context).insert(_previewOverlay!);
  }

  void _hideStickerPreview() {
    // Gỡ overlay ra khỏi giao diện
    _previewOverlay?.remove();
    // Cho về null để tránh lỗi khi tạo overlay mới
    _previewOverlay = null;
  }
}
