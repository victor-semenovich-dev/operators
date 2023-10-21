import 'package:chopper/chopper.dart';
import 'package:operators/src/data/remote/service/telegram.dart';

const MAIN_CHANNEL_ID = '-1002054563759';
const MAIN_CHANNEL_THREAD_ID = '5';
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

  Future<void> sendMessageToTelegramChannel(
      String message, String channelId) async {
    _chopper.getService<TelegramService>().sendMessage(channelId, message);
  }

  Future<void> sendMessageToTelegramThread(
      String message, String channelId, String threadId) async {
    _chopper
        .getService<TelegramService>()
        .sendMessageToThread(channelId, threadId, message);
  }
}
