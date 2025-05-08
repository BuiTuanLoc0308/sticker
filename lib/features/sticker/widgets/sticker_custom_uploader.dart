import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sticker_app/core/utils/media_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sticker_app/features/sticker/widgets/sticker_remove_bg.dart';
import 'package:sticker_app/services/remove_bg_service.dart';

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
        future: loadMedia(),
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
                initialChildSize: 0.85,
                maxChildSize: 0.85,
                expand: false,
                builder: (context, scrollController) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'All Photo',
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
                              // Lấy file từ AssetEntity
                              future: images[index].file,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData &&
                                    snapshot.data != null) {
                                  // Hiển thị ảnh từ File
                                  return GestureDetector(
                                    onTap: () async {
                                      imageOverlay(context, snapshot.data!);
                                      // final originalFile = snapshot.data!;
                                      // final bgRemoved =
                                      //     await RemoveBgService.removeBackground(
                                      //       snapshot.data!,
                                      //     );
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
