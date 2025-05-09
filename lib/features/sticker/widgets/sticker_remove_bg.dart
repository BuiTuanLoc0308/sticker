import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sticker_app/services/remove_bg_service.dart';

OverlayEntry? _imgOverlay;

void imageOverlay(BuildContext context, File imageFile) {
  final screenSize = MediaQuery.of(context).size.width;

  late void Function(void Function()) setState;
  bool isLoading = false;
  bool isCutDone = false;
  File? displayedImage = imageFile;

  _imgOverlay = OverlayEntry(
    builder: (overlayEntryContext) {
      return StatefulBuilder(
        builder: (context, setStateOverlay) {
          setState = setStateOverlay;
          return Stack(
            children: [
              Container(color: Colors.black),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Image.file(
                              displayedImage!,
                              width: screenSize,
                              height: screenSize,
                            ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: screenSize * 0.02),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: screenSize * 0.02),
                            child: IconButton(
                              onPressed: hideImage,
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (isCutDone) {
                              // hideImage();
                            } else {
                              setState(() {
                                isLoading = true;
                              });

                              final result =
                                  await RemoveBgService.removeBackground(
                                    imageFile,
                                  );

                              if (result != null) {
                                setState(() {
                                  isLoading = false;
                                  isCutDone = true;
                                  displayedImage = result;
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          icon: Icon(isCutDone ? Icons.check : Icons.cut),
                          label: Text(
                            isCutDone
                                ? "Use this sticker"
                                : "Cut out an object",
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(
                              top: screenSize * 0.035,
                              bottom: screenSize * 0.035,
                            ),
                            backgroundColor:
                                isCutDone ? Colors.green : Colors.grey,
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );

  Overlay.of(context).insert(_imgOverlay!);
}

void hideImage() {
  // Xóa overlay hiện tại
  _imgOverlay?.remove();
  _imgOverlay = null;
}
