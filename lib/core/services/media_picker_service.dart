import 'package:image_picker/image_picker.dart';

class MediaPickerService {
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>> pickMultipleMedia() async {
    final files = await _picker.pickMultipleMedia(limit: 30);

    return files;
  }
}
