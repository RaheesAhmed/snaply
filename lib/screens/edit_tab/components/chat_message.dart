/// Types of chat messages in the edit interface
enum ChatMessageType {
  text,
  image,
  textWithImage,
}

/// Model class for chat messages in the edit interface
class ChatMessage {
  final ChatMessageType type;
  final String? text;
  final String? imagePath;
  final bool isUser;
  final DateTime timestamp;
  final bool isAnimated;

  const ChatMessage({
    required this.type,
    this.text,
    this.imagePath,
    required this.isUser,
    required this.timestamp,
    this.isAnimated = false,
  });
}
