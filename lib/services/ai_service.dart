// lib/services/ai_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:image/image.dart' as img;

class AIService {
  static const String _modelPath = 'assets/models/skin_analysis_model.tflite';
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      print('AI Model loaded successfully');
    } catch (e) {
      print('Failed to load AI model: $e');
      throw Exception('Failed to load AI model');
    }
  }

  Future<Map<String, dynamic>> analyzeSkin(File imageFile) async {
    if (_interpreter == null) {
      await loadModel();
    }

    try {
      // Preprocess image
      final preprocessedImage = await _preprocessImage(imageFile);

      // Prepare input and output tensors
      final input = [preprocessedImage];
      final output = List.filled(1 * 6, 0.0).reshape([1, 6]);

      // Run inference
      _interpreter!.run(input, output);

      // Parse results
      return _parseResults(output[0]);
    } catch (e) {
      print('Skin analysis failed: $e');
      throw Exception('Skin analysis failed');
    }
  }

  Future<List<List<List<double>>>> _preprocessImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to model input size (224x224)
    final resized = img.copyResize(image, width: 224, height: 224);

    // Normalize pixel values to [0,1]
    final normalized = List.generate(224, (y) =>
        List.generate(224, (x) =>
            List.generate(3, (c) {
              final pixel = resized.getPixel(x, y);
              switch (c) {
                case 0: return pixel.r / 255.0;
                case 1: return pixel.g / 255.0;
                case 2: return pixel.b / 255.0;
                default: return 0.0;
              }
            })));

    return normalized;
  }

  Map<String, dynamic> _parseResults(List<double> output) {
    // Model outputs: [hydration, sun_damage, acne, wrinkles, pores, redness]
    final metrics = {
      'hydration': (output[0] * 100).round(),
      'sunDamage': (output[1] * 100).round(),
      'acne': (output[2] * 100).round(),
      'wrinkles': (output[3] * 100).round(),
      'pores': (output[4] * 100).round(),
      'redness': (output[5] * 100).round(),
    };

    // Calculate overall score
    final overallScore = metrics.values.reduce((a, b) => a + b) ~/ metrics.length;

    return {
      'overallScore': overallScore,
      'metrics': metrics,
      'confidence': _calculateConfidence(output),
      'recommendations': _generateRecommendations(metrics),
    };
  }

  double _calculateConfidence(List<double> output) {
    // Simple confidence calculation based on prediction certainty
    final avgConfidence = output.map((v) => (v - 0.5).abs() * 2).reduce((a, b) => a + b) / output.length;
    return avgConfidence;
  }

  Map<String, dynamic> _generateRecommendations(Map<String, int> metrics) {
    final recommendations = <String, dynamic>{
      'immediate': <String>[],
      'routine': {
        'morning': <String>[],
        'evening': <String>[],
      },
      'products': <String>[],
    };

    // Generate recommendations based on metrics
    if (metrics['hydration']! < 60) {
      recommendations['immediate'].add('Increase hydration with a hyaluronic acid serum');
      recommendations['products'].add('Hydrating serum');
    }

    if (metrics['sunDamage']! > 40) {
      recommendations['immediate'].add('Use broad-spectrum SPF 30+ daily');
      recommendations['routine']['morning'].add('Apply sunscreen as final step');
    }

    if (metrics['acne']! > 30) {
      recommendations['products'].add('Salicylic acid cleanser');
      recommendations['routine']['evening'].add('Use gentle acne treatment');
    }

    return recommendations;
  }

  void dispose() {
    _interpreter?.close();
  }
}