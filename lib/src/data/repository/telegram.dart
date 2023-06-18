import 'package:chopper/chopper.dart';
import 'package:operators/src/data/remote/service/telegram.dart';

class TelegramRepository {
  final _chopper = ChopperClient(
    baseUrl: Uri.parse(
        'https://api.telegram.org/bot${const String.fromEnvironment('TELEGRAM_BOT_API_KEY')}'),
    services: [TelegramService.create()],
    interceptors: [HttpLoggingInterceptor()],
  );

  final List<String> _channelIds = [
    '-739507168', // main operators channel
    '-1001924550770', // video channel
  ];

  Future<void> sendMessageToTelegramChannels(String title, String body) async {
    final message = '$title\n\n$body';
    for (final channelId in _channelIds) {
      _chopper.getService<TelegramService>().sendMessage(channelId, message);
    }
  }
}
