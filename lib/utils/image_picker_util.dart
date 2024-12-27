// lib/utils/image_picker_util.dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? quality,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil gambar: $e');
    }
  }

  static Future<List<File>> pickMultiImage({
    int? quality,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: quality,
      );

      return pickedFiles.map((file) => File(file.path)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil beberapa gambar: $e');
    }
  }

  static Future<File?> pickVideo({
    required ImageSource source,
    Duration? maxDuration,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: source,
        maxDuration: maxDuration,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil video: $e');
    }
  }
}
