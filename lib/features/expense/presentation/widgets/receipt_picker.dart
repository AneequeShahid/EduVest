import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// Thin, mockable wrapper around image picking so the page can be tested
/// without the platform channel.
abstract class ReceiptPicker {
  Future<File?> pick(ImageSource source);
}

class ImagePickerReceiptPicker implements ReceiptPicker {
  final ImagePicker _picker;

  ImagePickerReceiptPicker([ImagePicker? picker])
      : _picker = picker ?? ImagePicker();

  @override
  Future<File?> pick(ImageSource source) async {
    // imageQuality compresses the JPEG before upload (keeps receipts <2MB).
    final x = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1600,
    );
    return x == null ? null : File(x.path);
  }
}
