import 'dart:io';
import 'package:http/http.dart';

class ImageUploaderService {
  final String _imageUrl;

  ImageUploaderService(this._imageUrl);

  Future<String> uploadImage(File image) async {
    final MultipartRequest request =
        MultipartRequest('POST', Uri.parse(_imageUrl));
    request.files.add(await MultipartFile.fromPath('picture', image.path));
    final StreamedResponse result = await request.send();

    if (result.statusCode != 200) {
      return null;
    }

    final Response response = await Response.fromStream(result);
    print(response.body);

    return Uri.parse(_imageUrl).origin + response.body;
  }
}
