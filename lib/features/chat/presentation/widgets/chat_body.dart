import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:my_stickers/data/stickers_data.dart';
import 'package:sticker_app/features/sticker/presentation/pages/sticker_page.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  // Tạo danh sách tất cả Sticker
  Map<String, List<Sticker>> allStickerList = {};
  // Tạo danh sách tất cả Sticker pro
  Map<String, List<Sticker>> allStickerPro = MyStickers.getStickerPro();
  // Để lưu Sticker đuọc chọn gần đây
  List<Sticker> recentsStickerList = [];
  // Lưu nội dung Sticker vào chat
  List<Sticker> chatContentList = [];
  // Dùng để loại bỏ tự động mở bàn phím
  final FocusNode _focusNode = FocusNode();
  // Số lượng thumbnail hiển thị
  List<Sticker> thumbList = MyStickers.getStickerThumb();
  // Lấy type Sticker của Sticker hiện tại
  String currentStickerType = '';
  // Kiểm tra sticker recents có được nhấn hay không
  bool isRecentSelected = false;

  @override
  void initState() {
    super.initState();
    // Mặc định currentStickerType ban đầu-
    // -là type của sticker vị trí đầu trong thumbnail
    currentStickerType = thumbList.first.type;
    // Đưa Recents và các Sticker của Recents vào đầu allStickerList
    allStickerList = {
      'Recents': recentsStickerList,
      ...MyStickers.getAllSticker(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _chatContentList()),
        _buildBottomChatUI(context),
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
            StickerPage(
              currentStickerType: currentStickerType,
              thumbList: thumbList,
              allStickerList: allStickerList,
              recentsStickerList: recentsStickerList,
              isRecentSelected: isRecentSelected,
              allStickerPro: allStickerPro,
              chatContentList: chatContentList,
            );
          },
          child: const Icon(Icons.emoji_emotions, size: 30),
        ),
      ),
    );
  }
}
