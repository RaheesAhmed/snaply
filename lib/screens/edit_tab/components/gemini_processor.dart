import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../services/gemini_service.dart';

/// A utility class to handle image processing with Gemini API
class GeminiProcessor {
  final GeminiService _geminiService = GeminiService();

  /// Process an image with the given prompt
  /// Returns the processed image as a File or null if processing failed
  Future<ProcessedImageResult?> processImage(
      File imageFile, String prompt) async {
    try {
      debugPrint('Starting image processing with prompt: $prompt');

      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      debugPrint(
          'Image converted to base64, size: ${base64Image.length} characters');

      // Call Gemini API
      debugPrint('Calling Gemini editImage API...');
      final result = await _geminiService.editImage(base64Image, prompt);

      if (result != null) {
        debugPrint('Received response from Gemini API');
        debugPrint('Description: ${result.description}');
        debugPrint(
            'Image data received, size: ${result.imageData.length} bytes');

        // Save the processed image to a temporary file
        final tempDir = Directory.systemTemp.createTempSync();
        final tempFile = File('${tempDir.path}/processed_image.png');
        await tempFile.writeAsBytes(result.imageData);
        debugPrint('Processed image saved to: ${tempFile.path}');

        return ProcessedImageResult(
          imageFile: tempFile,
          description: result.description,
        );
      } else {
        debugPrint('Gemini API returned null result');
      }
    } catch (e, stackTrace) {
      debugPrint('Error processing image: $e');
      debugPrint('Stack trace: $stackTrace');
    }

    return null;
  }

  /// Generate an image from a text prompt
  /// Returns the generated image as a File or null if generation failed
  Future<ProcessedImageResult?> generateImage(String prompt) async {
    try {
      debugPrint('Starting image generation with prompt: $prompt');

      // Call Gemini API
      debugPrint('Calling Gemini generateImage API...');
      final result = await _geminiService.generateImage(prompt);

      if (result != null) {
        debugPrint('Received response from Gemini API');
        debugPrint('Description: ${result.description}');
        debugPrint(
            'Image data received, size: ${result.imageData.length} bytes');

        // Save the generated image to a temporary file
        final tempDir = Directory.systemTemp.createTempSync();
        final tempFile = File('${tempDir.path}/generated_image.png');
        await tempFile.writeAsBytes(result.imageData);
        debugPrint('Generated image saved to: ${tempFile.path}');

        return ProcessedImageResult(
          imageFile: tempFile,
          description: result.description,
        );
      } else {
        debugPrint('Gemini API returned null result');
      }
    } catch (e, stackTrace) {
      debugPrint('Error generating image: $e');
      debugPrint('Stack trace: $stackTrace');
    }

    return null;
  }
}

/// Result of image processing
class ProcessedImageResult {
  final File imageFile;
  final String description;

  ProcessedImageResult({
    required this.imageFile,
    required this.description,
  });
}
