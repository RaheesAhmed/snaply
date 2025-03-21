import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Model class for gallery image metadata
class GalleryImage {
  final String id;
  final String path;
  final String description;
  final DateTime timestamp;

  GalleryImage({
    required this.id,
    required this.path,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      id: json['id'],
      path: json['path'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Service to manage gallery images
class GalleryService {
  static const _galleryKey = 'gallery_images';
  final Uuid _uuid = const Uuid();

  // Singleton pattern
  static final GalleryService _instance = GalleryService._internal();

  factory GalleryService() {
    return _instance;
  }

  GalleryService._internal();

  /// Save an image to the gallery
  Future<GalleryImage> saveImage(
    String originalPath,
    String description,
    DateTime timestamp,
  ) async {
    try {
      // Create a unique ID for the image
      final id = _uuid.v4();

      // Get the application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final galleryDir = Directory('${appDir.path}/gallery');

      // Ensure gallery directory exists
      if (!galleryDir.existsSync()) {
        galleryDir.createSync(recursive: true);
      }

      // Copy the image to the gallery directory with a unique name
      final File originalFile = File(originalPath);
      final String extension = originalPath.split('.').last;
      final String newPath = '${galleryDir.path}/$id.$extension';

      await originalFile.copy(newPath);

      // Create a gallery image object
      final galleryImage = GalleryImage(
        id: id,
        path: newPath,
        description: description,
        timestamp: timestamp,
      );

      // Save the metadata to SharedPreferences
      await _saveMetadata(galleryImage);

      debugPrint('Image saved to gallery: $newPath');
      return galleryImage;
    } catch (e) {
      debugPrint('Error saving image to gallery: $e');
      rethrow;
    }
  }

  /// Get all gallery images
  Future<List<GalleryImage>> getAllImages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonList = prefs.getStringList(_galleryKey) ?? [];

      return jsonList
          .map((json) => GalleryImage.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.timestamp
            .compareTo(a.timestamp)); // Sort by timestamp, newest first
    } catch (e) {
      debugPrint('Error getting gallery images: $e');
      return [];
    }
  }

  /// Delete an image from the gallery
  Future<bool> deleteImage(String id) async {
    try {
      // Get current images
      final List<GalleryImage> images = await getAllImages();
      final imageToDelete = images.firstWhere((img) => img.id == id);

      // Delete the file
      final file = File(imageToDelete.path);
      if (await file.exists()) {
        await file.delete();
      }

      // Remove from metadata
      final updatedImages = images.where((img) => img.id != id).toList();

      // Save updated metadata
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _galleryKey,
        updatedImages.map((img) => jsonEncode(img.toJson())).toList(),
      );

      return true;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Save image metadata to SharedPreferences
  Future<void> _saveMetadata(GalleryImage image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existingJsonList =
          prefs.getStringList(_galleryKey) ?? [];

      // Convert the list of JSON strings to GalleryImage objects
      final List<GalleryImage> existingImages = existingJsonList
          .map((json) => GalleryImage.fromJson(jsonDecode(json)))
          .toList();

      // Add the new image
      existingImages.add(image);

      // Convert back to JSON strings
      final List<String> updatedJsonList =
          existingImages.map((img) => jsonEncode(img.toJson())).toList();

      // Save back to SharedPreferences
      await prefs.setStringList(_galleryKey, updatedJsonList);
    } catch (e) {
      debugPrint('Error saving image metadata: $e');
      rethrow;
    }
  }
}
