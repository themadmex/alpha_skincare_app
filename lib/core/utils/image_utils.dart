// lib/core/utils/image_utils.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<File> compressImage(File imageFile, {int quality = 85}) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize if too large
    img.Image resizedImage = image;
    if (image.width > AppConfig.maxImageSize || image.height > AppConfig.maxImageSize) {
      resizedImage = img.copyResize(
        image,
        width: image.width > image.height ? AppConfig.maxImageSize : null,
        height: image.height > image.width ? AppConfig.maxImageSize : null,
      );
    }

    // Compress
    final compressedBytes = img.encodeJpg(resizedImage, quality: quality);

    // Save to temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(compressedBytes);

    return tempFile;
  }

  static Future<Uint8List> preprocessForAnalysis(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to model input size (assuming 224x224)
    final resized = img.copyResize(image, width: 224, height: 224);

    // Convert to RGB if needed
    final rgb = img.fill(resized, color: img.ColorRgb8(0, 0, 0));

    // Normalize pixel values (0-1)
    final buffer = Float32List(224 * 224 * 3);
    var index = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = rgb.getPixel(x, y);
        buffer[index++] = pixel.r / 255.0;
        buffer[index++] = pixel.g / 255.0;
        buffer[index++] = pixel.b / 255.0;
      }
    }

    return buffer.buffer.asUint8List();
  }

  static Future<bool> isValidImageFile(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      return image != null;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getImageMetadata(File file) async {
    final stat = await file.stat();
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    return {
      'size': stat.size,
      'width': image?.width ?? 0,
      'height': image?.height ?? 0,
      'format': _getImageFormat(file.path),
      'created': stat.changed,
    };
  }

  static String _getImageFormat(String path) {
    final extension = path.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'JPEG';
      case 'png':
        return 'PNG';
      case 'gif':
        return 'GIF';
      case 'webp':
        return 'WebP';
      default:
        return 'Unknown';
    }
  }

  static Future<File> cropSquare(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final size = image.width < image.height ? image.width : image.height;
    final x = (image.width - size) ~/ 2;
    final y = (image.height - size) ~/ 2;

    final cropped = img.copyCrop(image, x: x, y: y, width: size, height: size);
    final croppedBytes = img.encodeJpg(cropped, quality: AppConfig.imageQuality);

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(croppedBytes);

    return tempFile;
  }

  static Future<void> cleanupTempImages() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();

      for (final file in files) {
        if (file is File &&
            (file.path.contains('compressed_') ||
                file.path.contains('cropped_') ||
                file.path.contains('temp_'))) {
          await file.delete();
        }
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }
}