import 'package:flutter/material.dart';
import '../../../theme/snaply_theme.dart';

/// Input area for chat messages in the edit interface
class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final VoidCallback onAttachImage;
  final bool isProcessing;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.onAttachImage,
    this.isProcessing = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    widget.onSendMessage(text);
    setState(() {
      _textController.clear();
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SnaplyTheme.spaceSM,
        vertical: SnaplyTheme.spaceSM,
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              onPressed: widget.isProcessing ? null : widget.onAttachImage,
              color: theme.colorScheme.primary,
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Describe your edit...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: SnaplyTheme.spaceMD,
                    vertical: SnaplyTheme.spaceSM,
                  ),
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.trim().isNotEmpty;
                  });
                },
                onSubmitted: widget.isProcessing ? null : _handleSubmitted,
                enabled: !widget.isProcessing,
              ),
            ),
            const SizedBox(width: SnaplyTheme.spaceXS),
            AnimatedContainer(
              duration: SnaplyTheme.durationShort,
              curve: Curves.easeInOut,
              width: 48,
              height: 48,
              child: widget.isProcessing
                  ? Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                      color: theme.colorScheme.primary,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
