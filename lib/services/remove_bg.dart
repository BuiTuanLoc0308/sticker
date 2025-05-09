import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class RemoveBgService {
  const RemoveBgService._();

  static const String _apiKey = 'EYruSa3XHLKDCMsjszK5opP7';

  static Future<File?> removeBackground(File imageFile) async {
    final http.MultipartRequest request =
        http.MultipartRequest(
            'POST',
            Uri.parse('https://api.remove.bg/v1.0/removebg'),
          )
          ..headers['X-Api-Key'] = _apiKey
          ..files.add(
            await http.MultipartFile.fromPath('image_file', imageFile.path),
          )
          ..fields['size'] = 'auto';

    final http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final Uint8List bytes = await response.stream.toBytes();
      final File file = File('${imageFile.path}_no_bg.png');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      return null;
    }
  }
}
