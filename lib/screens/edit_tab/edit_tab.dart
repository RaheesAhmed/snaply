import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/snaply_theme.dart';
import '../../services/gallery_service.dart';
import '../../services/event_bus.dart';
import 'components/chat_message.dart';
import 'components/chat_input.dart';
import 'components/image_upload_area.dart';
import 'components/gemini_processor.dart';

/// Edit tab with chatbot-style image editing interface
class EditTab extends StatefulWidget {
  const EditTab({super.key});

  @override
  State<EditTab> createState() => _EditTabState();
}

class _EditTabState extends State<EditTab> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final GeminiProcessor _geminiProcessor = GeminiProcessor();
  final GalleryService _galleryService = GalleryService();
  late final StreamSubscription<AppEvent> _eventSubscription;
  bool _isProcessing = false;
  File? _selectedImage;
  File? _processedImage;
  File? _activeImage; // Track the active image for continued edits

  @override
  void initState() {
    super.initState();

    // Listen for events
    _eventSubscription = EventBus().events.listen((event) {
      if (event.type == EventType.editImage && event.data is File) {
        final File imageFile = event.data as File;
        _handleImagePicked(imageFile.path);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _eventSubscription.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: SnaplyTheme.durationShort,
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _handleImagePicked(String imagePath) {
    final File imageFile = File(imagePath);
    setState(() {
      _selectedImage = imageFile;
      _activeImage = imageFile; // Set as active image
      _messages.add(ChatMessage(
        type: ChatMessageType.image,
        imagePath: imagePath,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      // No automatic response after image upload
    });

    _scrollToBottom();
  }

  void _handleMessageSent(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        type: ChatMessageType.text,
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isProcessing = true;
    });

    _scrollToBottom();

    // Add a placeholder for the processing image
    int processingIndex = _messages.length;
    setState(() {
      _messages.add(ChatMessage(
        type: ChatMessageType.processing,
        text: "Processing...",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();

    // Process with Gemini
    if (_activeImage != null) {
      // Process the image
      final result =
          await _geminiProcessor.processImage(_activeImage!, message);

      // Remove the processing message
      setState(() {
        _messages.removeAt(processingIndex);
      });

      if (result != null) {
        setState(() {
          if (result.isTextOnly) {
            // For text-only responses
            _messages.add(ChatMessage(
              type: ChatMessageType.text,
              text: result.description,
              isUser: false,
              timestamp: DateTime.now(),
            ));
          } else {
            // For responses with both text and image
            _processedImage = result.imageFile;
            _activeImage =
                result.imageFile; // Update active image to the processed one

            // Save to gallery
            _saveToGallery(_processedImage!, result.description);

            _messages.add(ChatMessage(
              type: ChatMessageType.textWithImage,
              text: result.description,
              imagePath: _processedImage!.path,
              isUser: false,
              timestamp: DateTime.now(),
            ));
          }
          _isProcessing = false;
        });

        _scrollToBottom();
      } else {
        // Only add a minimal error message if API fails completely
        setState(() {
          _messages.add(ChatMessage(
            type: ChatMessageType.text,
            text: "Failed to process image. Try again.",
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isProcessing = false;
        });
        _scrollToBottom();
      }
    } else {
      // No image uploaded yet, generate one
      final result = await _geminiProcessor.generateImage(message);

      // Remove the processing message
      setState(() {
        _messages.removeAt(processingIndex);
      });

      if (result != null) {
        setState(() {
          if (result.isTextOnly) {
            // For text-only responses
            _messages.add(ChatMessage(
              type: ChatMessageType.text,
              text: result.description,
              isUser: false,
              timestamp: DateTime.now(),
            ));
          } else {
            // For responses with both text and image
            _processedImage = result.imageFile;
            _activeImage = result.imageFile; // Set as active image

            // Save to gallery
            _saveToGallery(_processedImage!, result.description);

            _messages.add(ChatMessage(
              type: ChatMessageType.textWithImage,
              text: result.description,
              imagePath: _processedImage!.path,
              isUser: false,
              timestamp: DateTime.now(),
            ));
          }
          _isProcessing = false;
        });

        _scrollToBottom();
      } else {
        // Only add a minimal error message if API fails completely
        setState(() {
          _messages.add(ChatMessage(
            type: ChatMessageType.text,
            text: "Failed to generate image. Try again.",
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isProcessing = false;
        });
        _scrollToBottom();
      }
    }
  }

  // Save image to gallery
  Future<void> _saveToGallery(File imageFile, String description) async {
    try {
      await _galleryService.saveImage(
        imageFile.path,
        description,
        DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error saving to gallery: $e');
    }
  }

  // Download image to user's device
  Future<void> _downloadImage(File imageFile) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final String fileName = 'snaply_${const Uuid().v4()}.png';
        final String filePath = '${directory.path}/$fileName';

        // Copy the file to downloads folder
        await imageFile.copy(filePath);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image saved to $filePath'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleShowImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        _handleImagePicked(pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? ImageUploadArea(onTap: _handleShowImagePicker)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(SnaplyTheme.spaceMD),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: SnaplyTheme.spaceSM),
                      child: MessageBubble(
                        message: message,
                        onImageTap: (file) => _downloadImage(file),
                      ),
                    );
                  },
                ),
        ),
        ChatInput(
          onSendMessage: _handleMessageSent,
          onAttachImage: _handleShowImagePicker,
          isProcessing: _isProcessing,
        ),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(File)? onImageTap;

  const MessageBubble({
    super.key,
    required this.message,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    // Special handling for processing messages
    if (message.type == ChatMessageType.processing) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.only(
            top: SnaplyTheme.spaceXS,
            bottom: SnaplyTheme.spaceXS,
          ),
          padding: const EdgeInsets.all(SnaplyTheme.spaceSM),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Processing your request...",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: SnaplyTheme.spaceXS),
              Shimmer.fromColors(
                baseColor: theme.colorScheme.surfaceVariant,
                highlightColor: theme.colorScheme.surface,
                child: Container(
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: SnaplyTheme.spaceXS,
            bottom: SnaplyTheme.spaceXS,
            left: isUser ? SnaplyTheme.spaceLG : 0,
            right: isUser ? 0 : SnaplyTheme.spaceLG,
          ),
          padding: message.type == ChatMessageType.image
              ? EdgeInsets.zero
              : const EdgeInsets.all(SnaplyTheme.spaceSM),
          decoration: BoxDecoration(
            color: isUser
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: _buildMessageContent(context, theme),
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, ThemeData theme) {
    final isUser = message.isUser;

    switch (message.type) {
      case ChatMessageType.text:
        return Text(
          message.text!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isUser
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
        );

      case ChatMessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(message.imagePath!),
            fit: BoxFit.cover,
          ),
        );

      case ChatMessageType.textWithImage:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.text != null && message.text!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: SnaplyTheme.spaceSM),
                child: Text(
                  message.text!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isUser
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (message.imagePath != null)
              GestureDetector(
                onTap: () {
                  if (!isUser && onImageTap != null) {
                    onImageTap!(File(message.imagePath!));
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(message.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (!isUser)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.download,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );

      case ChatMessageType.processing:
        // This is handled in the build method
        return const SizedBox.shrink();
    }
  }
}
