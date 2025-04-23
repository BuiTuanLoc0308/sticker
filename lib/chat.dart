import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:my_stickers/my_stickers.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> koalaSticker = MyStickers.koala;
  List<String> christmasSticker = MyStickers.christmas;
  List<Sticker> allSticker = MyStickers.allSticker;

  List<String> displayedStickers = [];

  Map<String, List<String>> stickerType = {
    'koala': MyStickers.koala,
    'christmas': MyStickers.christmas,
  };

  @override
  void initState() {
    super.initState();
    displayedStickers = stickerType['koala']!;
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
  }

  Widget _buildUI(BuildContext scaffoldContext) {
    return Scaffold(
      appBar: _appBar(scaffoldContext),
      body: _chatBody(scaffoldContext),
    );
  }

  PreferredSizeWidget? _appBar(BuildContext appBarContext) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(appBarContext);
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
          Expanded(
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
        ],
      ),
    );
  }

  Future<T?> _openStickerPicker<T>(BuildContext rootContext) {
    return showModalBottomSheet<T>(
      isScrollControlled: true,
      context: rootContext,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(rootContext).size.height * 0.01,
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

  Widget _listAllSticker(StateSetter bottomSheetContext) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Icon(Icons.favorite, size: 35),
          ...stickerType.keys.map(
            (type) => Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  bottomSheetContext(() {
                    displayedStickers = stickerType[type]!;
                  });
                },
                child: Container(
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
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: 'Ex: koala, christmas, ...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _filteredSticker() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: displayedStickers.length,
        itemBuilder: (BuildContext gridContext, int index) {
          return GestureDetector(
            onLongPress: () {
              _showStickerPreview(index);
            },
            onTap: () {
              setState(() {
                chatContent.insert(0, displayedStickers[index]);
              });
              Navigator.of(context).pop();
            },
            onLongPressEnd: (details) {
              _hideStickerPreview();
            },
            child: Image.asset(displayedStickers[index]),
          );
        },
      ),
    );
  }

  OverlayEntry? _previewOverlay;

  void _showStickerPreview(int index) {
    _previewOverlay = OverlayEntry(
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final imageSize = screenSize.width * 0.7; // image 70% compare to screen

        return Positioned.fill(
          child: Container(
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

    Overlay.of(context).insert(_previewOverlay!);
  }

  void _hideStickerPreview() {
    _previewOverlay?.remove();
    _previewOverlay = null;
  }
}
