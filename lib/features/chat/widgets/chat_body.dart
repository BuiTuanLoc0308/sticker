import 'package:flutter/material.dart';
import 'package:my_stickers/data/models/sticker.dart';
import 'package:my_stickers/data/stickers_data.dart';
import 'package:sticker_app/features/sticker/pages/sticker_page.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_custom_uploader.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  // Dùng để loại bỏ tự động mở bàn phím
  final FocusNode _focusNode = FocusNode();
  // Lưu nội dung sticker vào chat
  List<Sticker> chatContentList = [];
  // Danh sách các Sticker Pro
  Map<String, List<Sticker>> allStickerPro = MyStickers.getStickerPro();
  // Kiểm tra xem Recents có được chọn hay không
  bool isRecentSelected = false;
  // Số lượng thumbnail hiển thị
  List<Sticker> thumbList = MyStickers.getStickerThumb();
  // Lấy type Sticker của Sticker hiện tại
  String currentStickerType = '';
  // Để lưu Sticker đuọc chọn gần đây
  List<Sticker> recentsStickerList = [];
  // Tạo danh sách tất cả Sticker
  Map<String, List<Sticker>> allStickerList = {};

  @override
  void initState() {
    super.initState();
    // Mặc định currentStickerType ban đầu-
    // -là type của sticker vị trí đầu trong thumbnail
    currentStickerType = thumbList.first.type;
    // Đưa Recents và các Sticker của Recents vào allSticker
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
    final screenSize = MediaQuery.of(context).size.width;

    return ListView.builder(
      reverse: true,
      itemCount: chatContentList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(screenSize * 0.01),
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              // Độ lớn dựa theo % độ lớn màn hình
              width: screenSize * 0.25,
              height: screenSize * 0.25,
              child: Image.asset(chatContentList[index].path),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomChatUI(BuildContext chatBodyContext) {
    final screenSize = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.add_circle, size: 30),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: screenSize * 0.02,
                right: screenSize * 0.02,
              ),
              child: _textChatInputField(chatBodyContext),
            ),
          ),
          Icon(Icons.thumb_up, size: 30),
        ],
      ),
    );
  }

  Widget _textChatInputField(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      autofocus: false,
      onTapOutside: (event) {
        // Tắt bàn phím khi ấn ra ngoài
        FocusScope.of(context).unfocus();
      },
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.04,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: 'Aa',
        suffixIcon: GestureDetector(
          onTap: () async {
            // Tránh tự động mở bàn phím
            _focusNode.unfocus();

            await stickerPicker(
              context: context,
              allStickerPro: allStickerPro,
              isRecentSelected: isRecentSelected,
              thumbList: thumbList,
              currentStickerType: currentStickerType,
              recentsStickerList: recentsStickerList,
              chatContentList: chatContentList,
              allStickerList: allStickerList,
              onStickerTypeChanged: (newType) {
                setState(() {
                  currentStickerType = newType;
                  isRecentSelected = newType == 'Recents';
                });
              },
            );

            if (mounted) {
              _focusNode.unfocus();
            }
          },
          child: const Icon(Icons.emoji_emotions, size: 30),
        ),
      ),
    );
  }
}
