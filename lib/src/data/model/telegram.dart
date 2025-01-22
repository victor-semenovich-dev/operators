import 'event.dart';

class TelegramConfig {
  final String title;
  final Map<String, String> messages;
  final String chatId;
  final Role? role;
  final String? messageThreadId;

  TelegramConfig({
    required this.title,
    required this.messages,
    required this.chatId,
    this.role,
    this.messageThreadId,
  });

  @override
  String toString() {
    return 'TelegramConfig{'
        'title: $title, '
        'chatId: $chatId, '
        'messageThreadId: $messageThreadId'
        '}';
  }
}
