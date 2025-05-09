import 'dart:io';
import 'package:http/http.dart' as http;

class RemoveBgService {
  // Lấy key từ removebg
  static const _apiKey = 'EYruSa3XHLKDCMsjszK5opP7';

  static Future<File?> removeBackground(File imageFile) async {
    final request =
        http.MultipartRequest(
            'POST',
            Uri.parse('https://api.remove.bg/v1.0/removebg'),
          )
          ..headers['X-Api-Key'] = _apiKey
          ..files.add(
            await http.MultipartFile.fromPath('image_file', imageFile.path),
          )
          ..fields['size'] = 'auto';

    final response = await request.send();

    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();
      final file = File('${imageFile.path}_no_bg.png');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      return null;
    }
  }
}
