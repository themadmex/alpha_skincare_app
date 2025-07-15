import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

// Processing result
class ProcessingResult {
  final Uint8List imageBytes;
  final Map<String, dynamic> metadata;
  final bool success;
  final String? error;

  const ProcessingResult({
    required this.imageBytes,
    this.metadata = const {},
    this.success = true,
    this.error,
  });

  const ProcessingResult.error(String error, Uint8List originalBytes)
      : this(
    imageBytes: originalBytes,
    success: false,
    error: error,
  );
}

// Base processing step
abstract class ImageProcessingStep {
  const ImageProcessingStep();

  Future<ProcessingResult> process(Uint8List imageBytes, Map<String, dynamic> metadata);

  String get name;

  bool get isRequired => true;
}

// Resize step
class ResizeStep extends ImageProcessingStep {
  final int? maxWidth;
  final int? maxHeight;
  final img.Interpolation interpolation;
  final bool maintainAspectRatio;

  const ResizeStep({
    this.maxWidth,
    this.maxHeight,
    this.interpolation = img.Interpolation.lanczos3,
    this.maintainAspectRatio = true,
  });

  @override
  String get name => 'Resize';

  @override
  Future<ProcessingResult> process(Uint8List imageBytes, Map<String, dynamic> metadata) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return ProcessingResult.error('Failed to decode image', imageBytes);
      }

      final originalWidth = image.width;
      final originalHeight = image.height;

      // Calculate new dimensions
      final newDimensions = _calculateDimensions(originalWidth, originalHeight);

      if (newDimensions.width == originalWidth && newDimensions.height == originalHeight) {
        // No resize needed
        return ProcessingResult(
          imageBytes: imageBytes,
          metadata: {
            ...metadata,
            'resize_applied': false,
            'original_size': {'width': originalWidth, 'height': originalHeight},
          },
        );
      }

      final resizedImage = img.copyResize(
        image,
        width: newDimensions.width,
        height: newDimensions.height,
        interpolation: interpolation,
      );

      final encoded = img.encodeJpg(resizedImage, quality: 90);

      return ProcessingResult(
        imageBytes: Uint8List.fromList(encoded),
        metadata: {
          ...metadata,
          'resize_applied': true,
          'original_size': {'width': originalWidth, 'height': originalHeight},
          'new_size': {'width': newDimensions.width, 'height': newDimensions.height},
          'size_reduction': ((imageBytes.length - encoded.length) / imageBytes.length * 100).toStringAsFixed(1) + '%',
        },
      );
    } catch (e) {
      return ProcessingResult.error('Resize failed: $e', imageBytes);
    }
  }

  ({int width, int height}) _calculateDimensions(int originalWidth, int originalHeight) {
    if (maxWidth == null && maxHeight == null) {
      return (width: originalWidth, height: originalHeight);
    }

    if (!maintainAspectRatio) {
      return (
      width: maxWidth ?? originalWidth,
      height: maxHeight ?? originalHeight,
      );
    }

    final aspectRatio = originalWidth / originalHeight;

    int newWidth = maxWidth ?? originalWidth;
    int newHeight = maxHeight ?? originalHeight;

    if (maxWidth != null && maxHeight != null) {
      if (originalWidth > maxWidth || originalHeight > maxHeight) {
        if (originalWidth / maxWidth > originalHeight / maxHeight) {
          newWidth = maxWidth;
          newHeight = (newWidth / aspectRatio).round();
        } else {
          newHeight = maxHeight;
          newWidth = (newHeight * aspectRatio).round();
        }
      }
    } else if (maxWidth != null) {
      if (originalWidth > maxWidth) {
        newWidth = maxWidth;
        newHeight = (newWidth / aspectRatio).round();
      }
    } else if (maxHeight != null) {
      if (originalHeight > maxHeight) {
        newHeight = maxHeight;
        newWidth = (newHeight * aspectRatio).round();
      }
    }

    return (width: newWidth, height: newHeight);
  }
}

// Compression step
class CompressionStep extends ImageProcessingStep {
  final int quality;
  final String format;

  const CompressionStep({
    this.quality = 85,
    this.format = 'jpg',
  });

  @override
  String get name => 'Compression';

  @override
  Future<ProcessingResult> process(Uint8List imageBytes, Map<String, dynamic> metadata) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return ProcessingResult.error('Failed to decode image', imageBytes);
      }

      final originalSize = imageBytes.length;

      List<int> encoded;
      switch (format.toLowerCase()) {
        case 'png':
          encoded = img.encodePng(image);
          break;
        case 'webp':
          encoded = img.encodeWebP(image, quality: quality);
          break;
        case 'jpg':
        case 'jpeg':
        default:
          encoded = img.encodeJpg(image, quality: quality);
      }

      final compressedSize = encoded.length;

      return ProcessingResult(
        imageBytes: Uint8List.fromList(encoded),
        metadata: {
          ...metadata,
          'compression_applied': true,
          'compression_quality': quality,
          'compression_format': format,
          'original_file_size': originalSize,
          'compressed_file_size': compressedSize,
          'compression_ratio': ((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(1) + '%',
        },
      );
    } catch (e) {
      return ProcessingResult.error('Compression failed: $e', imageBytes);
    }
  }
}

// Crop step
class CropStep extends ImageProcessingStep {
  final Rect? cropRect;
  final bool cropToSquare;
  final bool centerCrop;

  const CropStep({
    this.cropRect,
    this.cropToSquare = false,
    this.centerCrop = true,
  });

  @override
  String get name => 'Crop';

  @override
  Future<ProcessingResult> process(Uint8List imageBytes, Map<String, dynamic> metadata) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return ProcessingResult.error('Failed to decode image', imageBytes);
      }

      img.Image croppedImage;

      if (cropToSquare) {
        final size = math.min(image.width, image.height);
        final x = centerCrop ? (image.width - size) ~/ 2 : 0;
        final y = centerCrop ? (image.height - size) ~/ 2 : 0;

        croppedImage = img.copyCrop(image, x: x, y: y, width: size, height: size);
      } else if (cropRect != null) {
        croppedImage = img.copyCrop(
          image,
          x: cropRect!.left.toInt(),
          y: cropRect!.top.toInt(),
          width: cropRect!.width.toInt(),
          height: cropRect!.height.toInt(),
        );
      } else {
        // No crop needed
        return ProcessingResult(
          imageBytes: imageBytes,
          metadata: {
            ...metadata,
            'crop_applied': false,
          },
        );
      }

      final encoded = img.encodeJpg(croppedImage, quality: 90);

      return ProcessingResult(
        imageBytes: Uint8List.fromList(encoded),
        metadata: {
          ...metadata,
          'crop_applied': true,
          'crop_type': cropToSquare ? 'square' : 'rectangle',
          'original_dimensions': {'width': image.width, 'height': image.height},
          'cropped_dimensions': {'width': croppedImage.width, 'height': croppedImage.height},
        },
      );
    } catch (e) {
      return ProcessingResult.error('Crop failed: $e', imageBytes);
    }
  }
}

// Enhancement step
class EnhancementStep extends ImageProcessingStep {
  final double? brightness;
  final double? contrast;
  final double? saturation;
  final double? gamma;
  final bool autoEnhance;

  const EnhancementStep({
    this.brightness,
    this.contrast,
    this.saturation,
    this.gamma,
    this.autoEnhance = false,
  });

  @override
  String get name => 'Enhancement';

  @override
  Future<ProcessingResult> process(Uint8List imageBytes, Map<String, dynamic> metadata) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return ProcessingResult.error('Failed to decode image', imageBytes);
      }

      img.Image enhancedImage = image;
      final appliedEnhancements = <String, dynamic>{};

      if (autoEnhance) {
        // Auto-enhance based on image analysis
        enhancedImage = img.adjustColor(
          enhancedImage,
          brightness: 1.05,
          contrast: 1.1,
          saturation: 1.05,
        );
        appliedEnhancements['auto_enhance'] = true;
      } else {
        // Apply manual adjustments
        if (brightness != null || contrast != null || saturation != null || gamma != null) {
          enhancedImage = img.adjustColor(
            enhancedImage,
            brightness: brightness,
            contrast: contrast,
            saturation: saturation,
            gamma: gamma,
          );

          if (brightness != null) appliedEnhancements['brightness'] = brightness;
          if (contrast != null) appliedEnhancements['contrast'] = contrast;
          if (saturation != null) appliedEnhancements['saturation'] = saturation;
          if (gamma != null) appliedEnhancements['gamma'] = gamma;
        }
      }

      if (appliedEnhancements.isEmpty) {
        return ProcessingResult(
          imageBytes: imageBytes,
          metadata: {
            ...metadata,
            'enhancement_applied': false,
          },
        );
      }

      final encoded = img.encodeJpg(enhancedImage, quality: 90);

      return ProcessingResult(
        imageBytes: Uint8List.fromList(encoded),
        metadata: {
          ...metadata,
          'enhancement_applied': true,
          'enhancements': appliedEnhancements,
        },
      );
    } catch (e) {
      return ProcessingResult.error('Enhancement failed: $e', imageBytes);
    }
  }
}

// Noise reduction step
class NoiseReductionStep extends ImageProcessingStep {
  final double weight;
  final int iterations;

  const NoiseReductionStep({
    this.weight = 0.3,
    this.iterations = 1,
  });

  @override
  String get name => 'Noise Reduction';

  @override
  Future<ProcessingResult> process(Uint8List imageBytes, Map<String, dynamic> metadata) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return ProcessingResult.error('Failed to decode image', imageBytes);
      }

      img.Image smoothedImage = image;

      for (int i = 0; i < iterations; i++) {
        smoothedImage = img.smooth(smoothedImage, weight: weight);
      }

      final encoded = img.encodeJpg(smoothedImage, quality: 90);

      return ProcessingResult(
        imageBytes: Uint8List.fromList(encoded),
        metadata: {
          ...metadata,
          'noise_reduction_applied': true,
          'noise_reduction_weight': weight,
          'noise_reduction_iterations': iterations,
        },
      );
    } catch (e) {
      return ProcessingResult.error('Noise reduction failed: $e', imageBytes);
    }
  }
}

// Rotation step
class RotationStep extends ImageProcessingStep {
  final double angle;

  const RotationStep({required this.angle});

  @override
  String get name => 'Rotation';

  @override
  Future<ProcessingResult> process(Uint8List imageBytes, Map<String, dynamic> metadata) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return ProcessingResult.error('Failed to decode image', imageBytes);
      }

      if (angle == 0) {
        return ProcessingResult(
          imageBytes: imageBytes,
          metadata: {
            ...metadata,
            'rotation_applied': false,
          },
        );
      }

      final rotatedImage = img.copyRotate(image, angle: angle);
      final encoded = img.encodeJpg(rotatedImage, quality: 90);

      return ProcessingResult(
        imageBytes: Uint8List.fromList(encoded),
        metadata: {
          ...metadata,
          'rotation_applied': true,
          'rotation_angle': angle,
        },
      );
    } catch (e) {
      return ProcessingResult.error('Rotation failed: $e', imageBytes);
    }
  }
}

// Flip step
class FlipStep extends ImageProcessingStep {
  final bool horizontal;
  final bool vertical;

  const FlipStep({
    this.horizontal = false,
    this.vertical = false,
  });

  @override
  String get name => 'Flip';

  @override
  Future<ProcessingResult> process(Uint8List imageBytes, Map<String, dynamic> metadata) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return ProcessingResult.error('Failed to decode image', imageBytes);
      }

      if (!horizontal && !vertical) {
        return ProcessingResult(
          imageBytes: imageBytes,
          metadata: {
            ...metadata,
            'flip_applied': false,
          },
        );
      }

      img.Image flippedImage = image;

      if (horizontal) {
        flippedImage = img.flipHorizontal(flippedImage);
      }

      if (vertical) {
        flippedImage = img.flipVertical(flippedImage);
      }

      final encoded = img.encodeJpg(flippedImage, quality: 90);

      return ProcessingResult(
        imageBytes: Uint8List.fromList(encoded),
        metadata: {
          ...metadata,
          'flip_applied': true,
          'flip_horizontal': horizontal,
          'flip_vertical': vertical,
        },
      );
    } catch (e) {
      return ProcessingResult.error('Flip failed: $e', imageBytes);
    }
  }
}

// Image processing pipeline
class ImageProcessingPipeline {
  final List<ImageProcessingStep> _steps = [];
  final bool stopOnError;

  ImageProcessingPipeline({this.stopOnError = true});

  // Add steps
  ImageProcessingPipeline addStep(ImageProcessingStep step) {
    _steps.add(step);
    return this;
  }

  ImageProcessingPipeline resize({
    int? maxWidth,
    int? maxHeight,
    img.Interpolation interpolation = img.Interpolation.lanczos3,
    bool maintainAspectRatio = true,
  }) {
    return addStep(ResizeStep(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      interpolation: interpolation,
      maintainAspectRatio: maintainAspectRatio,
    ));
  }

  ImageProcessingPipeline compress({
    int quality = 85,
    String format = 'jpg',
  }) {
    return addStep(CompressionStep(
      quality: quality,
      format: format,
    ));
  }

  ImageProcessingPipeline crop({
    Rect? cropRect,
    bool cropToSquare = false,
    bool centerCrop = true,
  }) {
    return addStep(CropStep(
      cropRect: cropRect,
      cropToSquare: cropToSquare,
      centerCrop: centerCrop,
    ));
  }

  ImageProcessingPipeline enhance({
    double? brightness,
    double? contrast,
    double? saturation,
    double? gamma,
    bool autoEnhance = false,
  }) {
    return addStep(EnhancementStep(
      brightness: brightness,
      contrast: contrast,
      saturation: saturation,
      gamma: gamma,
      autoEnhance: autoEnhance,
    ));
  }

  ImageProcessingPipeline reduceNoise({
    double weight = 0.3,
    int iterations = 1,
  }) {
    return addStep(NoiseReductionStep(
      weight: weight,
      iterations: iterations,
    ));
  }

  ImageProcessingPipeline rotate(double angle) {
    return addStep(RotationStep(angle: angle));
  }

  ImageProcessingPipeline flip({
    bool horizontal = false,
    bool vertical = false,
  }) {
    return addStep(FlipStep(
      horizontal: horizontal,
      vertical: vertical,
    ));
  }

  // Process image through pipeline
  Future<ProcessingResult> process(Uint8List imageBytes) async {
    var currentBytes = imageBytes;
    var metadata = <String, dynamic>{
      'pipeline_steps': _steps.map((step) => step.name).toList(),
      'processing_start_time': DateTime.now().toIso8601String(),
    };

    for (int i = 0; i < _steps.length; i++) {
      final step = _steps[i];
      final stepStartTime = DateTime.now();

      try {
        final result = await step.process(currentBytes, metadata);

        metadata['step_${i}_${step.name.toLowerCase().replaceAll(' ', '_')}'] = {
          'success': result.success,
          'duration_ms': DateTime.now().difference(stepStartTime).inMilliseconds,
          'error': result.error,
        };

        if (!result.success) {
          if (stopOnError) {
            return ProcessingResult.error(
              'Pipeline failed at step ${i + 1} (${step.name}): ${result.error}',
              currentBytes,
            );
          } else {
            // Continue with original bytes if step failed and stopOnError is false
            continue;
          }
        }

        currentBytes = result.imageBytes;
        metadata.addAll(result.metadata);
      } catch (e) {
        final errorMessage = 'Step ${i + 1} (${step.name}) threw exception: $e';
        metadata['step_${i}_${step.name.toLowerCase().replaceAll(' ', '_')}'] = {
          'success': false,
          'error': errorMessage,
          'duration_ms': DateTime.now().difference(stepStartTime).inMilliseconds,
        };

        if (stopOnError) {
          return ProcessingResult.error(errorMessage, currentBytes);
        }
      }
    }

    metadata['processing_end_time'] = DateTime.now().toIso8601String();
    metadata['total_steps'] = _steps.length;
    metadata['final_file_size'] = currentBytes.length;

    return ProcessingResult(
      imageBytes: currentBytes,
      metadata: metadata,
    );
  }

  // Clear all steps
  void clear() {
    _steps.clear();
  }

  // Get step count
  int get stepCount => _steps.length;

  // Check if pipeline is empty
  bool get isEmpty => _steps.isEmpty;

  // Get steps
  List<ImageProcessingStep> get steps => List.unmodifiable(_steps);
}

// Pre-configured pipelines
class ImagePipelines {
  // Standard web image pipeline
  static ImageProcessingPipeline webImage({
    int maxWidth = 1200,
    int maxHeight = 1200,
    int quality = 85,
  }) {
    return ImageProcessingPipeline()
        .resize(maxWidth: maxWidth, maxHeight: maxHeight)
        .compress(quality: quality);
  }

  // Thumbnail pipeline
  static ImageProcessingPipeline thumbnail({
    int size = 200,
    int quality = 80,
  }) {
    return ImageProcessingPipeline()
        .crop(cropToSquare: true)
        .resize(maxWidth: size, maxHeight: size)
        .compress(quality: quality);
  }

  // ML analysis pipeline
  static ImageProcessingPipeline mlAnalysis({
    int size = 224,
    bool autoEnhance = true,
  }) {
    return ImageProcessingPipeline()
        .resize(maxWidth: size, maxHeight: size)
        .enhance(autoEnhance: autoEnhance)
        .reduceNoise()
        .compress(quality: 95);
  }

  // High quality pipeline
  static ImageProcessingPipeline highQuality({
    int maxWidth = 2048,
    int maxHeight = 2048,
    int quality = 95,
  }) {
    return ImageProcessingPipeline()
        .resize(maxWidth: maxWidth, maxHeight: maxHeight)
        .enhance(autoEnhance: true)
        .reduceNoise()
        .compress(quality: quality);
  }

  // Social media pipeline
  static ImageProcessingPipeline socialMedia({
    int maxWidth = 1080,
    int maxHeight = 1080,
    int quality = 90,
  }) {
    return ImageProcessingPipeline()
        .crop(cropToSquare: true)
        .resize(maxWidth: maxWidth, maxHeight: maxHeight)
        .enhance(
      brightness: 1.05,
      contrast: 1.1,
      saturation: 1.1,
    )
        .compress(quality: quality);
  }

  // Face detection pipeline
  static ImageProcessingPipeline faceDetection(Rect faceRect) {
    return ImageProcessingPipeline()
        .crop(cropRect: faceRect)
        .resize(maxWidth: 400, maxHeight: 400)
        .enhance(autoEnhance: true)
        .compress(quality: 90);
  }

  // Scan result pipeline
  static ImageProcessingPipeline scanResult({
    int maxWidth = 800,
    int maxHeight = 800,
    int quality = 85,
  }) {
    return ImageProcessingPipeline()
        .resize(maxWidth: maxWidth, maxHeight: maxHeight)
        .enhance(
      brightness: 1.02,
      contrast: 1.05,
    )
        .compress(quality: quality);
  }

  // Profile picture pipeline
  static ImageProcessingPipeline profilePicture({
    int size = 300,
    int quality = 90,
  }) {
    return ImageProcessingPipeline()
        .crop(cropToSquare: true)
        .resize(maxWidth: size, maxHeight: size)
        .enhance(
      brightness: 1.03,
      contrast: 1.05,
      saturation: 1.05,
    )
        .compress(quality: quality);
  }

  // Storage optimization pipeline
  static ImageProcessingPipeline storageOptimized({
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 75,
  }) {
    return ImageProcessingPipeline()
        .resize(maxWidth: maxWidth, maxHeight: maxHeight)
        .compress(quality: quality);
  }

  // Print quality pipeline
  static ImageProcessingPipeline printQuality({
    int maxWidth = 3000,
    int maxHeight = 3000,
    int quality = 98,
  }) {
    return ImageProcessingPipeline()
        .resize(maxWidth: maxWidth, maxHeight: maxHeight)
        .enhance(autoEnhance: true)
        .compress(quality: quality, format: 'jpg');
  }
}

// Batch processing utility
class BatchImageProcessor {
  final ImageProcessingPipeline pipeline;
  final int maxConcurrency;

  BatchImageProcessor({
    required this.pipeline,
    this.maxConcurrency = 3,
  });

  Future<List<ProcessingResult>> processImages(List<Uint8List> images) async {
    final results = <ProcessingResult>[];

    for (int i = 0; i < images.length; i += maxConcurrency) {
      final batch = images.skip(i).take(maxConcurrency).toList();
      final futures = batch.map((imageBytes) => pipeline.process(imageBytes));
      final batchResults = await Future.wait(futures);
      results.addAll(batchResults);
    }

    return results;
  }
}

// Image processing metrics
class ProcessingMetrics {
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  static String calculateCompressionRatio(int originalSize, int compressedSize) {
    final ratio = (originalSize - compressedSize) / originalSize * 100;
    return '${ratio.toStringAsFixed(1)}%';
  }

  static Map<String, dynamic> extractMetrics(ProcessingResult result) {
    final metrics = <String, dynamic>{};

    if (result.metadata.containsKey('original_file_size')) {
      metrics['original_size'] = formatFileSize(result.metadata['original_file_size']);
    }

    if (result.metadata.containsKey('compressed_file_size')) {
      metrics['compressed_size'] = formatFileSize(result.metadata['compressed_file_size']);
    }

    if (result.metadata.containsKey('compression_ratio')) {
      metrics['compression_ratio'] = result.metadata['compression_ratio'];
    }

    if (result.metadata.containsKey('original_size') && result.metadata.containsKey('new_size')) {
      final originalSize = result.metadata['original_size'];
      final newSize = result.metadata['new_size'];
      metrics['dimension_change'] = '${originalSize['width']}x${originalSize['height']} → ${newSize['width']}x${newSize['height']}';
    }

    return metrics;
  }
}

// Extension methods for easier pipeline creation
extension ImageProcessingPipelineExtensions on Uint8List {
  Future<ProcessingResult> processWithPipeline(ImageProcessingPipeline pipeline) {
    return pipeline.process(this);
  }

  Future<ProcessingResult> webOptimize({
    int maxWidth = 1200,
    int maxHeight = 1200,
    int quality = 85,
  }) {
    return ImagePipelines.webImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
    ).process(this);
  }

  Future<ProcessingResult> createThumbnail({
    int size = 200,
    int quality = 80,
  }) {
    return ImagePipelines.thumbnail(
      size: size,
      quality: quality,
    ).process(this);
  }

  Future<ProcessingResult> prepareForML({
    int size = 224,
    bool autoEnhance = true,
  }) {
    return ImagePipelines.mlAnalysis(
      size: size,
      autoEnhance: autoEnhance,
    ).process(this);
  }

  Future<ProcessingResult> optimizeForStorage({
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 75,
  }) {
    return ImagePipelines.storageOptimized(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
    ).process(this);
  }
}