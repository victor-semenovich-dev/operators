import 'package:chopper/chopper.dart';
import 'package:operators/src/data/remote/service/telegram.dart';

const PC_CHANNEL_ID = '-1002136201134';
const PC_CHANNEL_THREAD_ID = '1';
const VIDEO_CHANNEL_ID = '-1001924550770';
const VIDEO_CHANNEL_THREAD_ID = '1';
const TEST_CHANNEL_ID = '-970906901';

class TelegramRepository {
  final _chopper = ChopperClient(
    baseUrl: Uri.parse(
        'https://api.telegram.org/bot${const String.fromEnvironment('TELEGRAM_BOT_API_KEY')}'),
    services: [TelegramService.create()],
    interceptors: [HttpLoggingInterceptor()],
  );

  DateTime? lastTimeRemind;

  Future<void> sendMessageToTelegramChat(
      String message, String channelId) async {
    _chopper.getService<TelegramService>().sendMessage(channelId, message);
  }

  Future<void> sendMessageToTelegramChatThread(
      String message, String channelId, String threadId) async {
    _chopper
        .getService<TelegramService>()
        .sendMessageToThread(channelId, threadId, message);
  }
}
