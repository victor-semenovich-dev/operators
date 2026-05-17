class TelegramConfig {
  final String title;
  final String chatId;
  final String? messageThreadId;
  final int order;

  TelegramConfig({
    required this.title,
    required this.chatId,
    this.messageThreadId,
    this.order = 0,
  });

  @override
  String toString() {
    return 'TelegramConfig{'
        'title: $title, '
        'chatId: $chatId, '
        'messageThreadId: $messageThreadId, '
        'order: $order'
        '}';
  }
}
