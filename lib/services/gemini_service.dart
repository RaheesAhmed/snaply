import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/gemini_models.dart';

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String _modelName = 'gemini-2.0-flash-exp-image-generation';
  late final String _apiKey;

  // Singleton pattern
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (_apiKey.isEmpty) {
      debugPrint('Warning: GEMINI_API_KEY is not set in .env file');
    }
  }

  /// Generate image using Gemini 2.0 Flash API
  /// [prompt] Text prompt describing the image to generate
  /// Returns a Future with the image data and description
  Future<GeminiImageResult?> generateImage(String prompt) async {
    try {
      // Construct the URL with API key
      final url = '$_baseUrl/models/$_modelName:generateContent?key=$_apiKey';

      // Create the request body
      final request = GeminiRequest(
        contents: [
          Content(
            parts: [
              Part(text: prompt),
            ],
          ),
        ],
        generationConfig: GenerationConfig(
          temperature: 1.0,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseModalities: ['image', 'text'],
        ),
      );

      // Send the request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      // Handle response
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final geminiResponse = GeminiResponse.fromJson(jsonResponse);

        // Process response to extract image and text
        if (geminiResponse.candidates.isNotEmpty) {
          final candidate = geminiResponse.candidates.first;
          String? description;
          Uint8List? imageData;

          for (final part in candidate.content.parts) {
            if (part.text != null) {
              description = part.text;
            }
            if (part.inlineData != null) {
              // Decode base64 image
              imageData = base64Decode(part.inlineData!.data);
            }
          }

          if (imageData != null) {
            return GeminiImageResult(
              imageData: imageData,
              description: description ?? '',
            );
          }
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception when calling Gemini API: $e');
    }

    return null;
  }

  /// Edit an image using Gemini 2.0 Flash API
  /// [imageBase64] Image to edit in base64 format
  /// [prompt] Text prompt describing the edits to make
  /// Returns a Future with the edited image data and description
  Future<GeminiImageResult?> editImage(
      String imageBase64, String prompt) async {
    try {
      // Construct the URL with API key
      final url = '$_baseUrl/models/$_modelName:generateContent?key=$_apiKey';

      // Create the request body
      final request = GeminiRequest(
        contents: [
          Content(
            parts: [
              Part(
                inlineData: InlineData(
                  mimeType: 'image/jpeg',
                  data: imageBase64,
                ),
              ),
              Part(text: prompt),
            ],
          ),
        ],
        generationConfig: GenerationConfig(
          temperature: 0.8,
          topK: 32,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseModalities: ['image', 'text'],
        ),
      );

      // Send the request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      // Handle response
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final geminiResponse = GeminiResponse.fromJson(jsonResponse);

        // Process response to extract image and text
        if (geminiResponse.candidates.isNotEmpty) {
          final candidate = geminiResponse.candidates.first;
          String? description;
          Uint8List? imageData;

          for (final part in candidate.content.parts) {
            if (part.text != null) {
              description = part.text;
            }
            if (part.inlineData != null) {
              // Decode base64 image
              imageData = base64Decode(part.inlineData!.data);
            }
          }

          if (imageData != null) {
            return GeminiImageResult(
              imageData: imageData,
              description: description ?? '',
            );
          }
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception when calling Gemini API: $e');
    }

    return null;
  }
}

/// Result class for Gemini image generation
class GeminiImageResult {
  final Uint8List imageData;
  final String description;

  GeminiImageResult({
    required this.imageData,
    required this.description,
  });
}
