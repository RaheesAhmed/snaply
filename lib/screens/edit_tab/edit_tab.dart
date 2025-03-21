import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/snaply_theme.dart';
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
  bool _isProcessing = false;
  File? _selectedImage;
  File? _processedImage;

  @override
  void initState() {
    super.initState();

    // Add welcome message
    _addBotMessage(
      "Upload an image and tell me how you'd like to edit it.",
      isWelcome: true,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      _messages.add(ChatMessage(
        type: ChatMessageType.image,
        imagePath: imagePath,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();

    // Add a response after image is uploaded
    Future.delayed(const Duration(milliseconds: 500), () {
      _addBotMessage(
        "Great! Now tell me how you'd like to edit this image. For example, 'Remove the background' or 'Make it look more vibrant'.",
      );
    });
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

    // Process with Gemini
    if (_selectedImage != null) {
      // Show processing message
      _addBotMessage("Processing your request...");

      // Process the image
      final result =
          await _geminiProcessor.processImage(_selectedImage!, message);

      if (result != null) {
        _processedImage = result.imageFile;

        // Add the processed image to chat
        setState(() {
          _messages.add(ChatMessage(
            type: ChatMessageType.image,
            imagePath: _processedImage!.path,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });

        _scrollToBottom();

        // Add description if available
        if (result.description.isNotEmpty) {
          _addBotMessage(result.description);
        } else {
          _addBotMessage("Here's your edited image! How does it look?");
        }
      } else {
        _addBotMessage(
          "I'm sorry, I couldn't process your request. Please try again with a different instruction.",
        );
      }
    } else {
      // No image uploaded yet, try to generate one
      _addBotMessage("Let me create an image based on your description...");

      final result = await _geminiProcessor.generateImage(message);

      if (result != null) {
        _processedImage = result.imageFile;

        // Add the generated image to chat
        setState(() {
          _messages.add(ChatMessage(
            type: ChatMessageType.image,
            imagePath: _processedImage!.path,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });

        _scrollToBottom();

        // Add description if available
        if (result.description.isNotEmpty) {
          _addBotMessage(result.description);
        } else {
          _addBotMessage("Here's the image I created! What do you think?");
        }
      } else {
        _addBotMessage(
          "I'm sorry, I couldn't generate an image from your description. Please try again with a different prompt.",
        );
      }
    }
  }

  void _addBotMessage(String message, {bool isWelcome = false}) {
    setState(() {
      _messages.add(ChatMessage(
        type: ChatMessageType.text,
        text: message,
        isUser: false,
        timestamp: DateTime.now(),
        isAnimated: true,
      ));
      _isProcessing = false;
    });

    _scrollToBottom();
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
                      child: MessageBubble(message: message),
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

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

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
          padding: message.type == ChatMessageType.text
              ? const EdgeInsets.all(SnaplyTheme.spaceSM)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isUser
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: message.type == ChatMessageType.text
              ? Text(
                  message.text!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isUser
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(message.imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
