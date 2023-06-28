import 'package:chopper/chopper.dart';
import 'package:operators/src/data/remote/service/telegram.dart';

const MAIN_CHANNEL_ID = '-739507168';
const VIDEO_CHANNEL_ID = '-1001924550770';
const TEST_CHANNEL_ID = '-970906901';

class TelegramRepository {
  final _chopper = ChopperClient(
    baseUrl: Uri.parse(
        'https://api.telegram.org/bot${const String.fromEnvironment('TELEGRAM_BOT_API_KEY')}'),
    services: [TelegramService.create()],
    interceptors: [HttpLoggingInterceptor()],
  );

  DateTime? lastTimeRemind;

  Future<void> sendMessageToTelegramChannels(
      String message, List<String> channelIds) async {
    for (final channelId in channelIds) {
      _chopper.getService<TelegramService>().sendMessage(channelId, message);
    }
  }
}
