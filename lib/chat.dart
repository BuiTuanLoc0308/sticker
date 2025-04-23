import 'package:flutter/material.dart';
import 'package:my_stickers/my_stickers.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //* Khởi tạo displayedStickers rỗng
  List<String> displayedStickers = [];

  Map<String, List<String>> stickerType = {
    'Koala': MyStickers.koala,
    'Christmas': MyStickers.christmas,
    'Koala 1': MyStickers.koala,
    'Christmas 1': MyStickers.christmas,
    'Koala 2': MyStickers.koala,
    'Christmas 2': MyStickers.christmas,
    'Koala 3': MyStickers.koala,
    'Christmas 3': MyStickers.christmas,
    'Koala 4': MyStickers.koala,
    'Christmas 4': MyStickers.christmas,
    'Koala 5': MyStickers.koala,
    'Christmas 5': MyStickers.christmas,
    'Koala 6': MyStickers.koala,
    'Christmas 6': MyStickers.christmas,
  };

  @override
  void initState() {
    super.initState();

    //* Mặc định displayedStickers chứa MyStickers.koala
    displayedStickers = stickerType['Koala']!;
  }

  @override
  Widget build(BuildContext buildContext) {
    return _buildUI(buildContext);
  }

  Widget _buildUI(BuildContext buildContext) {
    return Scaffold(
      appBar: _appBar(buildContext),
      body: _chatBody(buildContext),
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

  List<String> chatContent = [];

  Widget _chatBody(BuildContext chatBodyContext) {
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
                    child: Image.asset(chatContent[index]),
                  ),
                ),
              );
            },
          ),
        ),
        _bottomChat(chatBodyContext),
      ],
    );
  }

  Widget _bottomChat(BuildContext chatBodyContext) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.add_circle),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Aa',
                  suffixIcon: GestureDetector(
                    onTap: () {
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

  Future<T?> _openStickerPicker<T>(BuildContext chatBodyContext) {
    return showModalBottomSheet<T>(
      isScrollControlled: true,
      context: chatBodyContext,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (
            BuildContext statefulBuilderContext,
            StateSetter modalSetState,
          ) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(chatBodyContext).size.height * 0.01,
                ),
                child: Column(
                  children: [
                    _listAllSticker(modalSetState),
                    _searchBarBottomSheet(),
                    _filteredSticker(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //* Mặc định giá trị Type ban đầu là Koala
  String currentStickerTypeKey = 'Koala';

  Widget _listAllSticker(StateSetter modalSetState) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Icon(Icons.favorite, size: 35),

          //* stickerType.keys là Iterable<String> chứa tất cả các key (ví dụ: "Koala", "Christmas1",...)
          //* type chính là từng phần tử trong tập keys đó
          //* map sẽ duyệt từng type trong keys và trả về widget tương ứng cho từng cái
          ...stickerType.keys.map(
            (type) => Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  modalSetState(() {
                    //! print(type);

                    //* Cho currentStickerTypeKey = key trong stickerType
                    currentStickerTypeKey = type;
                    displayedStickers = stickerType[type]!;
                  });
                },
                child: Container(
                  //* Set chiều dài rộng cho sticker
                  width: 35,
                  height: 35,
                  color: Colors.transparent,
                  child: Image.asset(
                    stickerType[type]!.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBarBottomSheet() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        height: 40,
        child: TextFormField(
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

  Widget _filteredSticker() {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          //* Dùng để thêm Text trước Gridview
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                currentStickerTypeKey,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          //* Khởi tạo Gridview
          SliverGrid(
            delegate: SliverChildBuilderDelegate((
              BuildContext gridContext,
              int index,
            ) {
              return GestureDetector(
                //* Giữ sticker để hiện preview
                onLongPress: () {
                  _showStickerPreview(index);
                },

                //* Click để gửi sticker
                onTap: () {
                  setState(() {
                    chatContent.insert(0, displayedStickers[index]);
                  });
                  Navigator.of(context).pop();
                },

                //* Thả giữ sticker sẽ tự động tắt preview
                onLongPressEnd: (details) {
                  _hideStickerPreview();
                },
                child: Image.asset(displayedStickers[index]),
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

  //* Dùng để hiện preview cho sticker
  OverlayEntry? _previewOverlay;

  void _showStickerPreview(int index) {
    _previewOverlay = OverlayEntry(
      builder: (overlayEntryContext) {
        final screenSize = MediaQuery.of(overlayEntryContext).size;

        //* Độ lớn của sticker dựa theo độ lớn màn hình
        final imageSize = screenSize.width * 0.7;

        //* Chiếm toàn bộ màn hình với Positioned.fill
        return Positioned.fill(
          child: Container(
            //* 128 là mờ 50%
            color: Colors.black.withAlpha(128),
            alignment: Alignment.center,
            child: Image.asset(
              displayedStickers[index],
              width: imageSize,
              height: imageSize,
            ),
          ),
        );
      },
    );

    //* Lấy Overlay hiện tại từ context → gọi .insert() để chèn overlay vào giao diện
    Overlay.of(context).insert(_previewOverlay!);
  }

  void _hideStickerPreview() {
    //* Gỡ overlay ra khỏi giao diện
    _previewOverlay?.remove();

    //* Cho về null để tránh lỗi khi tạo overlay mới
    _previewOverlay = null;
  }
}
