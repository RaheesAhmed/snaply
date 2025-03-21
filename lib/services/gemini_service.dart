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
      debugPrint('ERROR: GEMINI_API_KEY is not set in .env file');
    } else {
      debugPrint(
          'Gemini API initialized with key: ${_apiKey.substring(0, 4)}...');
    }
  }

  /// Generate image using Gemini 2.0 Flash API
  /// [prompt] Text prompt describing the image to generate
  /// Returns a Future with the image data and description
  Future<GeminiImageResult?> generateImage(String prompt) async {
    try {
      debugPrint('Generating image with prompt: "$prompt"');

      // Construct the URL with API key
      final url = '$_baseUrl/models/$_modelName:generateContent?key=$_apiKey';
      debugPrint('Using endpoint: $url');

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
        safetySettings: [
          SafetySetting(
            category: "HARM_CATEGORY_DANGEROUS_CONTENT",
            threshold: "BLOCK_MEDIUM_AND_ABOVE",
          ),
        ],
      );

      final requestJson = jsonEncode(request.toJson());
      debugPrint(
          'Request payload: ${requestJson.substring(0, min(100, requestJson.length))}...');

      // Send the request
      debugPrint('Sending request to Gemini API...');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: requestJson,
      );

      // Handle response
      debugPrint('Received response with status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Successful response received');
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('Response headers: ${response.headers}');
        debugPrint('Response JSON: ${jsonResponse.keys.join(', ')}');

        final geminiResponse = GeminiResponse.fromJson(jsonResponse);
        debugPrint(
            'Parsed response: ${geminiResponse.candidates.length} candidates');

        // Process response to extract image and text
        if (geminiResponse.candidates.isNotEmpty) {
          final candidate = geminiResponse.candidates.first;
          debugPrint(
              'Processing first candidate, finish reason: ${candidate.finishReason}');
          String? description;
          Uint8List? imageData;

          for (final part in candidate.content.parts) {
            if (part.text != null) {
              debugPrint(
                  'Found text response: "${part.text!.substring(0, min(50, part.text!.length))}..."');
              description = part.text;
            }
            if (part.inlineData != null) {
              debugPrint(
                  'Found image data with mime type: ${part.inlineData!.mimeType}');
              // Decode base64 image
              imageData = base64Decode(part.inlineData!.data);
              debugPrint('Decoded image data size: ${imageData.length} bytes');
            }
          }

          if (imageData != null) {
            debugPrint('Returning image result with ${imageData.length} bytes');
            return GeminiImageResult(
              imageData: imageData,
              description: description ?? '',
            );
          } else if (description != null && description.isNotEmpty) {
            debugPrint('No image data found, but returning text-only response');
            return GeminiImageResult(
              imageData: Uint8List(0),
              description: description,
              isTextOnly: true,
            );
          } else {
            debugPrint('No image data or text found in response');
          }
        } else {
          debugPrint('No candidates found in response');
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('Exception when calling Gemini API: $e');
      debugPrint('Stack trace: $stackTrace');
    }

    debugPrint('Returning null from generateImage');
    return null;
  }

  /// Edit an image using Gemini 2.0 Flash API
  /// [imageBase64] Image to edit in base64 format
  /// [prompt] Text prompt describing the edits to make
  /// Returns a Future with the edited image data and description
  Future<GeminiImageResult?> editImage(
      String imageBase64, String prompt) async {
    try {
      debugPrint('Editing image with prompt: "$prompt"');

      // Construct the URL with API key
      final url = '$_baseUrl/models/$_modelName:generateContent?key=$_apiKey';
      debugPrint('Using endpoint: $url');

      // Create the request body with proper mime type and encoding for image data
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
        safetySettings: [
          SafetySetting(
            category: "HARM_CATEGORY_DANGEROUS_CONTENT",
            threshold: "BLOCK_MEDIUM_AND_ABOVE",
          ),
        ],
      );

      debugPrint(
          'Request created with image (${imageBase64.length} chars) and prompt: "$prompt"');

      // Send the request
      debugPrint('Sending request to Gemini API...');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      // Handle response
      debugPrint('Received response with status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Successful response received');
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('Response headers: ${response.headers}');
        debugPrint('Response JSON: ${jsonResponse.keys.join(', ')}');

        final geminiResponse = GeminiResponse.fromJson(jsonResponse);
        debugPrint(
            'Parsed response: ${geminiResponse.candidates.length} candidates');

        // Process response to extract image and text
        if (geminiResponse.candidates.isNotEmpty) {
          final candidate = geminiResponse.candidates.first;
          debugPrint(
              'Processing first candidate, finish reason: ${candidate.finishReason}');
          String? description;
          Uint8List? imageData;

          for (final part in candidate.content.parts) {
            if (part.text != null) {
              debugPrint(
                  'Found text response: "${part.text!.substring(0, min(50, part.text!.length))}..."');
              description = part.text;
            }
            if (part.inlineData != null) {
              debugPrint(
                  'Found image data with mime type: ${part.inlineData!.mimeType}');
              // Decode base64 image
              imageData = base64Decode(part.inlineData!.data);
              debugPrint('Decoded image data size: ${imageData.length} bytes');
            }
          }

          if (imageData != null) {
            debugPrint('Returning image result with ${imageData.length} bytes');
            return GeminiImageResult(
              imageData: imageData,
              description: description ?? '',
            );
          } else if (description != null && description.isNotEmpty) {
            debugPrint('No image data found, but returning text-only response');
            return GeminiImageResult(
              imageData: Uint8List(0),
              description: description,
              isTextOnly: true,
            );
          } else {
            debugPrint('No image data or text found in response');
          }
        } else {
          debugPrint('No candidates found in response');
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('Exception when calling Gemini API: $e');
      debugPrint('Stack trace: $stackTrace');
    }

    debugPrint('Returning null from editImage');
    return null;
  }

  // Helper to get substring safely
  int min(int a, int b) => a < b ? a : b;
}

/// Result class for Gemini image generation
class GeminiImageResult {
  final Uint8List imageData;
  final String description;
  final bool isTextOnly;

  GeminiImageResult({
    required this.imageData,
    required this.description,
    this.isTextOnly = false,
  });
}
