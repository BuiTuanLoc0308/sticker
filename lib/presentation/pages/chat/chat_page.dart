import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:my_stickers/my_stickers.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Để lưu tất cả Sticker cùng với type của Sticker
  Map<String, List<Sticker>> allSticker = MyStickers.getStickersByType();
  // Để lưu Sticker đuọc chọn gần đây
  List<Sticker> recentsSticker = [];
  // Lưu nội dung sticker vào chat
  List<Sticker> chatContent = [];
  // Dùng để loại bỏ tự động mở bàn phím
  final FocusNode _focusNode = FocusNode();
  // Dùng để chèn overlay vào giao diện
  OverlayEntry? _previewOverlay;
  // Lấy danh sách thumbnail
  List<Sticker> thumbnailSticker = MyStickers.getThumbnailSticker();
  // Lấy type Sticker của Sticker hiện tại
  String currentStickerType = '';

  @override
  void initState() {
    super.initState();
    // Mặc định currentStickerType ban đầu-
    // -là type của sticker vị trí đầu trong thumbnail
    currentStickerType = thumbnailSticker.first.type;
    // Đưa Recents và các Sticker của Recents vào allSticker
    allSticker = {'Recents': recentsSticker, ...MyStickers.getStickersByType()};
  }

  @override
  Widget build(BuildContext buildContext) {
    return _buildUI(buildContext);
  }

  Widget _buildUI(BuildContext buildContext) {
    return Scaffold(
      appBar: _appBar(buildContext),
      body: _buildChatBody(buildContext),
    );
  }

  PreferredSizeWidget? _appBar(BuildContext buildContext) {
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

  Widget _buildChatBody(BuildContext chatBodyContext) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: chatContent.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    // Độ lớn dựa theo % độ lớn màn hình
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    child: Image.asset(chatContent[index].path),
                  ),
                ),
              );
            },
          ),
        ),
        _buildBottomChat(chatBodyContext),
      ],
    );
  }

  Widget _buildBottomChat(BuildContext chatBodyContext) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.add_circle, size: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
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
                      _openStickerPicker(chatBodyContext);
                    },
                    child: const Icon(Icons.emoji_emotions, size: 30),
                  ),
                ),
              ),
            ),
          ),
          Icon(Icons.thumb_up, size: 30),
        ],
      ),
    );
  }

  Future<T?> _openStickerPicker<T>(BuildContext chatBodyContext) async {
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
                        _buildThumbnailSticker(modalSetState, scrollController),
                        _buildSearchStickerUI(),
                        _buildFilteredStickerUI(scrollController),
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

  bool isRecentSelected = false;

  Widget _buildThumbnailSticker(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Tạo thumbnail cho Recents Sticker
          _recentThumbnailSticker(modalSetState, scrollController),
          // Tạo danh sách thumbnail cho các Sticker
          ..._listThumbnailSticker(modalSetState, scrollController),
        ],
      ),
    );
  }

  Widget _recentThumbnailSticker(
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
        padding: const EdgeInsets.all(3),
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

  List<Widget> _listThumbnailSticker(
    StateSetter modalSetState,
    ScrollController scrollController,
  ) {
    return List.generate(thumbnailSticker.length, (index) {
      Sticker thumbnail = thumbnailSticker[index];
      // thumbnail.type == currentStickerType ? isThumbnailSelected = true : false
      bool isThumbnailSelected = thumbnail.type == currentStickerType;

      return Padding(
        padding: const EdgeInsets.only(left: 5),
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

  Widget _buildSearchStickerUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }

  Widget _buildFilteredStickerUI(ScrollController scrollController) {
    final Map<String, List<Sticker>> filteredStickers =
        (currentStickerType == 'Recents')
            // Chỉ lấy 5 loại Sticker để hiện ở phần Recents
            ? Map.fromEntries(allSticker.entries.take(5))
            // Chỉ lấy 1 loại Sticker theo currentStickerType
            : {currentStickerType: allSticker[currentStickerType] ?? []};

    return Expanded(
      child: CustomScrollView(
        controller: scrollController,
        slivers:
            // Duyệt qua từng entry
            filteredStickers.entries.expand((entry) {
              // Gọi hàm lấy key là loại Sticker
              final String stickerType = entry.key;
              // Gọi hàm lấy value là các Sticker và chỉ lấy 10 Sticker
              final List<Sticker> stickers =
                  (currentStickerType == 'Recents')
                      ? entry.value.take(10).toList()
                      : entry.value;

              return [
                // Hiện loại Sticker trên đầu list
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      stickerType,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                // Tạo list Sticker nếu có Sticker
                stickers.isNotEmpty
                    ? SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final sticker = stickers[index];
                        return GestureDetector(
                          onLongPress: () => _showStickerPreview(sticker),
                          onTap: () {
                            Navigator.of(context).pop();
                            // Nếu Sticker đã có trong Recents, xóa Sticker
                            setState(() {
                              recentsSticker.removeWhere(
                                (s) => s.path == sticker.path,
                              );
                              // Thêm lại Sticker vào đầu danh sách
                              recentsSticker.insert(0, sticker);
                              // Chỉ hiển thị 5 Sticker
                              if (recentsSticker.length > 5) {
                                recentsSticker.removeAt(5);
                              }
                              // Thêm Sticker mới chọn vào chat
                              chatContent.insert(0, sticker);
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onLongPressEnd: (_) => _hideStickerPreview(),
                          child: Image.asset(sticker.path),
                        );
                      }, childCount: stickers.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                    )
                    // Nếu loại Sticker đó rỗng trả về 1 icon
                    : SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.add_link, size: 40),
                      ),
                    ),
              ];
            }).toList(),
      ),
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
