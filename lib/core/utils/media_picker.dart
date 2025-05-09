import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

Future<List<AssetEntity>> loadMedia() async {
  // Yêu cầu quyền truy cập
  final PermissionState ps = await PhotoManager.requestPermissionExtend();

  // Nếu đã từ chối cấp quyền, mở setting
  if (!ps.isAuth) {
    await PhotoManager.openSetting();
    return <AssetEntity>[];
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
      orders: <OrderOption>[const OrderOption()],
    ),
  );

  // Nếu album rỗng, trả rỗng
  if (albums.isEmpty) {
    debugPrint('Không tìm thấy album nào');
    return <AssetEntity>[];
  }

  // Lấy danh sách ảnh trong album
  final AssetPathEntity recentAlbum = albums.first;

  // Lấy tổng số lượng ảnh
  final int totalPhoto = await recentAlbum.assetCountAsync;

  // Lấy toàn bộ ảnh từ thư viện hình ảnh của điện thoại
  final List<AssetEntity> images = await recentAlbum.getAssetListRange(
    start: 0,
    end: totalPhoto,
  );

  debugPrint('Have $totalPhoto photo');

  return images;
}
