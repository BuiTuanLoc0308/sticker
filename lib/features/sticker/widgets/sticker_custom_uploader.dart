import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sticker_app/core/utils/media_picker.dart';
import 'package:sticker_app/features/sticker/widgets/sticker_remove_bg.dart';

void customStickerUploader<T>({required BuildContext context}) async {
  FocusScope.of(context).unfocus();

  final screenSize = MediaQuery.of(context).size.width;

  showModalBottomSheet<T>(
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
        future: loadMedia(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Hiện loading nếu chưa load xong
            return const Center(child: CircularProgressIndicator());
          }

          final images = snapshot.data!;
          // Nếu không có hình nào
          if (images.isEmpty) {
            return const Center(child: Text('Không có hình ảnh nào'));
          }

          return StatefulBuilder(
            builder: (
              BuildContext statefulBuilderContext,
              StateSetter modalSetState,
            ) {
              return DraggableScrollableSheet(
                initialChildSize: 0.85,
                maxChildSize: 0.85,
                expand: false,
                builder: (context, scrollController) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenSize * 0.02),
                        child: const Text(
                          'All Photo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                              // Lấy file từ AssetEntity
                              future: images[index].file,
                              // snapshot chứa trạng thái và dữ-
                              // -liệu (nếu có) từ Future
                              builder: (context, snapshot) {
                                // Kiểm tra snapshot.connectionState và-
                                // -snapshot.hasData để biết Future đã hoàn-
                                // -thành chưa và có dữ liệu hay không
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData &&
                                    snapshot.data != null) {
                                  // Hiển thị ảnh từ File
                                  return GestureDetector(
                                    onTap: () async {
                                      imageOverlay(context, snapshot.data!);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Image.file(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
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
}
