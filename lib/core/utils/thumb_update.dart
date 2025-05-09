import 'package:my_stickers/data/models/sticker.dart';

void updateThumbnailSticker({
  required List<Sticker> stickerThumb,
  required String stickerType,
}) {
  // Tìm thumb đó trên thanh thumb bar
  final Sticker thumb = stickerThumb.firstWhere(
    (sticker) => sticker.type == stickerType,
  );
  // Nếu đã có, xóa thumbnail
  stickerThumb.removeWhere((s) => s.type == stickerType);
  // Thêm lại vào đầu danh sách
  stickerThumb.insert(0, thumb);
}
