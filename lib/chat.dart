import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:my_stickers/my_stickers.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Khởi tạo displayedStickers rỗng
  List<Sticker> displayedStickers = [];

  // Để lưu sticker đuọc chọn gần đây
  List<Sticker> favoriteSticker = [];

  // Lưu nội dung sticker chat
  List<Sticker> chatContent = [];

  // Dùng để loại bỏ tự động mở bàn phím
  final FocusNode _focusNode = FocusNode();

  // Mặc định giá trị Type ban đầu là Koala
  String currentStickerType = 'Koala';

  // Dùng để chèn overlay vào giao diện
  OverlayEntry? _previewOverlay;

  // Lấy danh sách sticker
  List<Sticker> allStickers = MyStickers.getStickers();

  // Lấy danh sách thumbnail
  List<Sticker> thumbnailSticker = MyStickers.getThumbnailSticker();

  // Chia sticker theo từng type
  Map<String, List<Sticker>> getStickersByType = MyStickers.getStickersByType();

  @override
  void initState() {
    super.initState();
    // Mặc định displayedStickers chứa sticker koala
    displayedStickers = getStickersByType['Koala'] ?? [];
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
                    width: 100,
                    height: 100,
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
          Icon(Icons.add_circle),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Aa',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // Bỏ focus để tránh mở bàn phím
                      _focusNode.unfocus();
                      _openStickerPicker(chatBodyContext);
                    },
                    child: const Icon(Icons.emoji_emotions),
                  ),
                ),
              ),
            ),
          ),
          Icon(Icons.favorite),
        ],
      ),
    );
  }

  Future<T?> _openStickerPicker<T>(BuildContext chatBodyContext) async {
    // Bỏ focus trước khi mở modal
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
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (
              BuildContext statefulBuilderContext,
              StateSetter modalSetState,
            ) {
              return DraggableScrollableSheet(
                initialChildSize: 0.4,
                maxChildSize: 0.85,
                minChildSize: 0.2,
                expand: false,
                builder: (context, scrollController) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(chatBodyContext).size.height * 0.01,
                    ),
                    child: Column(
                      children: [
                        _buildThumbnailSticker(modalSetState),
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
    // Bỏ focus sau khi modal đóng
    if (context.mounted) {
      FocusScope.of(chatBodyContext).unfocus();
    }

    return result;
  }

  bool isFavoriteSelected = false;

  Widget _buildThumbnailSticker(StateSetter modalSetState) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isFavoriteSelected = true;
              });
              modalSetState(() {
                currentStickerType = 'Favorite Sticker';
                displayedStickers = favoriteSticker;
              });
            },
            child: Icon(
              Icons.favorite,
              size: 35,
              color: isFavoriteSelected ? Colors.red : Colors.black,
            ),
          ),
          // Tạo danh sách thumbnail
          ..._listThumbnailSticker(modalSetState),
        ],
      ),
    );
  }

  List<Widget> _listThumbnailSticker(StateSetter modalSetState) {
    return List.generate(thumbnailSticker.length, (index) {
      Sticker thumbnail = thumbnailSticker[index];
      // thumbnail.type == currentStickerType ? true : false
      bool isThumbnailSelected = thumbnail.type == currentStickerType;

      return Padding(
        padding: const EdgeInsets.only(left: 5),
        child: GestureDetector(
          onTap: () {
            isFavoriteSelected = false;
            modalSetState(() {
              currentStickerType = thumbnail.type;
              displayedStickers =
                  allStickers
                      .where((sticker) => sticker.type == thumbnail.type)
                      .toList();
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 0),
            width: 45,
            height: 45,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isThumbnailSelected ? Colors.grey : Colors.transparent,
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
    return Expanded(
      child: CustomScrollView(
        // Gán scrollController vào CustomScrollView
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(currentStickerType, style: TextStyle(fontSize: 20)),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate((gridContext, index) {
              return GestureDetector(
                onLongPress: () {
                  _showStickerPreview(index);
                },
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    Sticker selectedSticker = displayedStickers[index];
                    // Nếu đã có trong chatContent, xóa nó
                    favoriteSticker.removeWhere(
                      (sticker) => sticker.path == selectedSticker.path,
                    );
                    // Thêm lại lên đầu danh sách
                    favoriteSticker.insert(0, selectedSticker);
                    chatContent.insert(0, selectedSticker);
                  });
                  FocusScope.of(context).unfocus();
                },
                onLongPressEnd: (details) {
                  _hideStickerPreview();
                },
                child: Image.asset(displayedStickers[index].path),
              );
            }, childCount: displayedStickers.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _showStickerPreview(int index) {
    _previewOverlay = OverlayEntry(
      builder: (overlayEntryContext) {
        final screenSize = MediaQuery.of(overlayEntryContext).size;
        // Độ lớn của sticker dựa theo độ lớn màn hình
        final imageSize = screenSize.width * 0.7;
        // Chiếm toàn bộ màn hình với Positioned.fill
        return Positioned.fill(
          child: Container(
            // 128 là mờ 50%
            color: Colors.black.withAlpha(128),
            alignment: Alignment.center,
            child: Image.asset(
              displayedStickers[index].path,
              width: imageSize,
              height: imageSize,
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
