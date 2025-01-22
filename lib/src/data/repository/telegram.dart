import 'package:chopper/chopper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:operators/src/data/model/telegram.dart';
import 'package:operators/src/data/remote/service/telegram.dart';
import 'package:rxdart/rxdart.dart';

import '../model/event.dart';

const MARKS_REMINDER_KEY = 'marksReminder';

const TEST_CHANNEL_ID = '-970906901';

class TelegramRepository {
  final _chopper = ChopperClient(
    baseUrl: Uri.parse(
        'https://api.telegram.org/bot${const String.fromEnvironment('TELEGRAM_BOT_API_KEY')}'),
    services: [TelegramService.create()],
    interceptors: [HttpLoggingInterceptor()],
  );

  DateTime? lastTimeRemind;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("/telegram");
  final _telegramConfigsSubject = BehaviorSubject<List<TelegramConfig>>();
  late Stream<List<TelegramConfig>> telegramConfigsStream =
      _telegramConfigsSubject.stream;

  TelegramRepository() {
    _dbRef.onValue.listen((event) {
      final snapshotMap = event.snapshot.value as Map;
      final telegramConfigList = <TelegramConfig>[];
      for (String key in snapshotMap.keys) {
        telegramConfigList.add(_parseTelegramConfig(snapshotMap[key]));
      }
      _telegramConfigsSubject.add(telegramConfigList);
    });
  }

  Future<void> sendMessageToTelegramChat(
      String message, String channelId) async {
    await _chopper
        .getService<TelegramService>()
        .sendMessage(channelId, message);
  }

  Future<void> sendMessageToTelegramChatThread(
      String message, String channelId, String threadId) async {
    await _chopper
        .getService<TelegramService>()
        .sendMessageToThread(channelId, threadId, message);
  }

  static TelegramConfig _parseTelegramConfig(Map data) {
    final messages = <String, String>{};
    final messagesData = data['messages'];
    if (messagesData != null) {
      // this code is needed to convert the <dynamic, dynamic> map
      // to the <String, String> one
      final messagesMap = messagesData as Map;
      for (final key in messagesMap.keys) {
        messages[key] = messagesMap[key];
      }
    }

    return TelegramConfig(
      title: data['title'],
      messages: messages,
      chatId: data['chatId'].toString(),
      role: stringToRole(data['role'].toString()),
      messageThreadId: data['messageThreadId'].toString(),
    );
  }
}
