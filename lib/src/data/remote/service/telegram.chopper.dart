// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$TelegramService extends TelegramService {
  _$TelegramService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = TelegramService;

  @override
  Future<Response<dynamic>> sendMessage(
    String chatId,
    String text,
  ) {
    final Uri $url = Uri.parse('/sendMessage');
    final Map<String, dynamic> $params = <String, dynamic>{
      'chat_id': chatId,
      'text': text,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
