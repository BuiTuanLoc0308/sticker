import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

Future<T?> customStickerUploader<T>({required BuildContext context}) async {
  FocusScope.of(context).unfocus();
  final screenSize = MediaQuery.of(context).size.width;

  final result = await showModalBottomSheet<T>(
    barrierColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      side: BorderSide(color: Colors.black, width: 0.5),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext modalContext) {
      return FutureBuilder<List<AssetEntity>>(
        future: _loadImage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final images = snapshot.data!;

          return StatefulBuilder(
            builder: (
              BuildContext statefulBuilderContext,
              StateSetter modalSetState,
            ) {
              return DraggableScrollableSheet(
                initialChildSize: 0.5,
                maxChildSize: 0.8,
                minChildSize: 0.2,
                expand: false,
                builder: (context, scrollController) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Recents',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenSize * 0.02),
                        child: const Text('Create a sticker from a photo'),
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                              ),
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder<File?>(
                              future:
                                  images[index].file, // Lấy file từ AssetEntity
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData &&
                                    snapshot.data != null) {
                                  // Hiển thị ảnh từ File
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Image.file(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    },
  );

  return result;
}

Future<List<AssetEntity>> _loadImage() async {
  // Yêu cầu quyền truy cập
  final PermissionState ps = await PhotoManager.requestPermissionExtend();

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

  if (albums.isEmpty) {
    debugPrint('Không tìm thấy album nào.');
    return [];
  }

  // Lấy danh sách ảnh trong album đầu tiên (mới nhất)
  final AssetPathEntity recentAlbum = albums.first;

  final List<AssetEntity> images = await recentAlbum.getAssetListRange(
    start: 0,
    end: 20, // Số lượng ảnh muốn lấy
  );

  debugPrint('Tìm thấy ${images.length} ảnh');

  return images;
}
