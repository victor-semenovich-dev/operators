import 'package:chopper/chopper.dart';

part 'telegram.chopper.dart';

@ChopperApi()
abstract class TelegramService extends ChopperService {
  static TelegramService create([ChopperClient? client]) =>
      _$TelegramService(client);

  @Get(path: '/sendMessage')
  Future<Response<dynamic>> sendMessage(
    @Query('chat_id') String chatId,
    @Query('text') String text,
  );
}
