import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../components/app_icon.dart';
import '../theme/snaply_theme.dart';

/// Premium home screen for Snaply featuring a chatbot-style image editing interface
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isProcessing = false;
  late AnimationController _uploadAnimationController;
  late AnimationController _processingAnimationController;
  bool _isComposing = false;
  File? _selectedImage;
  bool _showUploadHint = false;

  @override
  void initState() {
    super.initState();
    _uploadAnimationController = AnimationController(
      vsync: this,
      duration: SnaplyTheme.durationMedium,
    );
    _processingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Add welcome message
    _addBotMessage(
      "Welcome to Snaply! Upload an image and tell me how you'd like to edit it.",
      isWelcome: true,
    );

    // Show upload hint after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showUploadHint = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _uploadAnimationController.dispose();
    _processingAnimationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: SnaplyTheme.durationMedium,
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _uploadAnimationController.forward(from: 0.0);
          _showUploadHint = false;
        });

        // Add the image message to the chat
        _addUserImageMessage(_selectedImage!);

        // Automatically prompt for editing instructions
        Future.delayed(const Duration(milliseconds: 500), () {
          _addBotMessage(
            "Great! Now tell me how you'd like to edit this image. For example, 'Remove the background' or 'Make it look more vibrant'.",
          );
        });
      }
    } catch (e) {
      // Show error
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

  void _addUserMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isComposing = false;
    });
    _scrollToBottom();
  }

  void _addUserImageMessage(File image) {
    setState(() {
      _messages.add(ChatMessage(
        isUser: true,
        timestamp: DateTime.now(),
        image: image,
      ));
    });
    _scrollToBottom();
  }

  void _addBotMessage(String message, {bool isWelcome = false}) {
    // Add a slight delay for natural conversation flow
    Future.delayed(Duration(milliseconds: isWelcome ? 300 : 800), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: message,
            isUser: false,
            timestamp: DateTime.now(),
            isAnimated: true,
          ));
          _isProcessing = false;
        });
        _scrollToBottom();
      }
    });
  }

  Future<void> _processMessage(String text) async {
    // Simulate AI processing
    _addUserMessage(text);

    setState(() {
      _isProcessing = true;
    });

    // Simulate response delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Example response logic based on message text (would be replaced with actual Gemini API calls)
    if (_selectedImage == null) {
      _addBotMessage(
        "Please upload an image first so I can help you edit it.",
      );
    } else if (text.toLowerCase().contains('background')) {
      _addBotMessage(
        "I'll remove the background for you. Give me a moment...",
      );
      // Simulate processing
      await Future.delayed(const Duration(milliseconds: 2000));
      // Here you would actually process the image with Gemini API
      // For now, we'll just send back a confirmation
      _addBotMessage(
        "Background removed! How does this look? Would you like to make any additional adjustments?",
      );
    } else if (text.toLowerCase().contains('vibrant') ||
        text.toLowerCase().contains('color')) {
      _addBotMessage(
        "I'll enhance the colors to make your image more vibrant. Processing...",
      );
      // Simulate processing
      await Future.delayed(const Duration(milliseconds: 2000));
      _addBotMessage(
        "I've enhanced the colors! The image looks much more vibrant now. Anything else you'd like to adjust?",
      );
    } else {
      _addBotMessage(
        "I'll apply your requested edit. Give me a moment to process...",
      );
      // Simulate processing
      await Future.delayed(const Duration(milliseconds: 2000));
      _addBotMessage(
        "Edit complete! What do you think? Would you like to make any other changes?",
      );
    }
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    _processMessage(text);
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SnaplyTheme.spaceLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: SnaplyTheme.spaceMD),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageSourceOption(
                    icon: Icons.photo_camera,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _ImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: SnaplyTheme.spaceLG),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(size: 28),
            const SizedBox(width: SnaplyTheme.spaceXS),
            Text(
              'Snaply',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help/tips dialog
              _showTipsDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages area
            Expanded(
              child: Container(
                color: theme.colorScheme.surface,
                child: _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppIcon(size: 60),
                            const SizedBox(height: SnaplyTheme.spaceMD),
                            Text(
                              'Start editing with Snaply',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          // Dismiss keyboard when tapping on messages
                          FocusScope.of(context).unfocus();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(SnaplyTheme.spaceMD),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) =>
                              _buildMessage(_messages[index]),
                        ),
                      ),
              ),
            ),

            // "AI is typing" indicator
            if (_isProcessing)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SnaplyTheme.spaceMD,
                  vertical: SnaplyTheme.spaceXS,
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: SnaplyTheme.spaceXS),
                    Text(
                      'AI is processing...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

            // Upload hint
            if (_showUploadHint && _selectedImage == null)
              AnimatedOpacity(
                opacity: _showUploadHint ? 1.0 : 0.0,
                duration: SnaplyTheme.durationMedium,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: SnaplyTheme.spaceMD,
                    right: SnaplyTheme.spaceMD,
                    bottom: SnaplyTheme.spaceSM,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SnaplyTheme.spaceMD,
                    vertical: SnaplyTheme.spaceSM,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: SnaplyTheme.spaceSM),
                      Expanded(
                        child: Text(
                          'Tap the + button to upload an image for editing',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Divider
            Divider(
                height: 1, color: theme.colorScheme.outline.withOpacity(0.3)),

            // Message input area
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SnaplyTheme.spaceMD,
                vertical: SnaplyTheme.spaceSM,
              ),
              color: theme.colorScheme.surface,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Add image button
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    onPressed: _showImageSourceDialog,
                    iconSize: 26,
                    color: theme.colorScheme.primary,
                  ),

                  // Text input field
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: SnaplyTheme.spaceSM),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        onChanged: (text) {
                          setState(() {
                            _isComposing = text.isNotEmpty;
                          });
                        },
                        onSubmitted: _isComposing ? _handleSubmitted : null,
                        decoration: InputDecoration(
                          hintText: 'Type your editing instructions...',
                          hintStyle: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.7)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: SnaplyTheme.spaceMD,
                            vertical: SnaplyTheme.spaceSM,
                          ),
                        ),
                        style: theme.textTheme.bodyMedium,
                        maxLines: 3,
                        minLines: 1,
                      ),
                    ),
                  ),

                  // Send button
                  AnimatedContainer(
                    duration: SnaplyTheme.durationShort,
                    curve: Curves.easeInOut,
                    width: _isComposing ? 48 : 0,
                    child: _isComposing
                        ? IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () =>
                                _handleSubmitted(_messageController.text),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: SnaplyTheme.spaceMD),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bot avatar
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: SnaplyTheme.spaceXS),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                radius: 16,
                child: Icon(
                  Icons.auto_fix_high,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),

          // Message content
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: message.image != null
                    ? SnaplyTheme.spaceSM
                    : SnaplyTheme.spaceMD,
                vertical: message.image != null
                    ? SnaplyTheme.spaceSM
                    : SnaplyTheme.spaceMD,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image content if present
                  if (message.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        message.image!,
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    ),

                  // Text content if present
                  if (message.text != null)
                    message.isAnimated && !isUser
                        ? _AnimatedText(
                            text: message.text!,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: isUser
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          )
                        : Text(
                            message.text!,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: isUser
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                ],
              ),
            ),
          ),

          // User avatar (blank space to align with bot avatar)
          if (isUser) const SizedBox(width: 32),
        ],
      ),
    );
  }

  void _showTipsDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Editing Tips',
          style: theme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TipItem(
              icon: Icons.photo,
              title: 'Upload an Image',
              description: 'Tap the + button to upload a photo to edit.',
            ),
            const SizedBox(height: SnaplyTheme.spaceMD),
            _TipItem(
              icon: Icons.chat,
              title: 'Be Specific',
              description: 'Describe exactly what changes you want to make.',
            ),
            const SizedBox(height: SnaplyTheme.spaceMD),
            _TipItem(
              icon: Icons.refresh,
              title: 'Iterate',
              description: 'Request additional changes after initial edits.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String? text;
  final bool isUser;
  final DateTime timestamp;
  final File? image;
  final bool isAnimated;

  ChatMessage({
    this.text,
    required this.isUser,
    required this.timestamp,
    this.image,
    this.isAnimated = false,
  });
}

class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(SnaplyTheme.spaceMD),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(SnaplyTheme.spaceMD),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: SnaplyTheme.spaceSM),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(SnaplyTheme.spaceXS),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: SnaplyTheme.spaceSM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _AnimatedText({
    required this.text,
    required this.style,
  });

  @override
  State<_AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<_AnimatedText>
    with SingleTickerProviderStateMixin {
  String _displayedText = '';
  late Timer _timer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _charIndex + 1);
          _charIndex++;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}
