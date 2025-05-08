import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

Future<List<AssetEntity>> loadMedia() async {
  // Yêu cầu quyền truy cập
  final PermissionState ps = await PhotoManager.requestPermissionExtend();

  // Nếu đã từ chối cấp quyền, mở setting
  if (!ps.isAuth) {
    await PhotoManager.openSetting();
    return [];
  }

  // Xóa cache phòng trường hợp dữ liệu cũ
  await PhotoManager.clearFileCache();

  // Lấy danh sách album ảnh
  final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
    type: RequestType.image,
    filterOption: FilterOptionGroup(
      imageOption: const FilterOption(
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
      orders: [const OrderOption(type: OrderOptionType.createDate, asc: false)],
    ),
  );

  // Nếu album rỗng, trả rỗng
  if (albums.isEmpty) {
    debugPrint('Không tìm thấy album nào.');
    return [];
  }

  // Lấy danh sách ảnh trong album
  final AssetPathEntity recentAlbum = albums.first;

  final int totalPhoto = await recentAlbum.assetCountAsync;

  final List<AssetEntity> images = await recentAlbum.getAssetListRange(
    start: 0,
    end: totalPhoto, // Lấy toàn bộ ảnh
  );

  debugPrint('Have $totalPhoto photo');

  return images;
}
