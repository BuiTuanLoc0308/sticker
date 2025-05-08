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
      return StatefulBuilder(
        builder: (
          BuildContext statefulBuilderContext,
          StateSetter modalSetState,
        ) {
          _loadImage();

          return DraggableScrollableSheet(
            initialChildSize: 0.85,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Recents',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenSize * 0.02),
                    child: Text('Create a sticker from a photo'),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                      itemCount: 30,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(
                          'lk jdsa djsalk djlsak djlsak jdla dj lkasjd',
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

  return result;
}

Future _loadImage() async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();

  List<AssetPathEntity> albums = [];

  if (ps.isAuth) {
    albums = await PhotoManager.getAssetPathList(type: RequestType.image);
  } else {
    PhotoManager.openSetting();
  }

  return albums;
}
