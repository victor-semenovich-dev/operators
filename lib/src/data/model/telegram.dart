class TelegramConfig {
  final String title;
  final String chatId;
  final String? messageThreadId;

  TelegramConfig({
    required this.title,
    required this.chatId,
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
