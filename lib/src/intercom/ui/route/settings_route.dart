import 'package:flutter/material.dart';
import 'package:operators/main.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({Key? key}) : super(key: key);

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  late TextEditingController _telegramApiKeyController;

  @override
  void initState() {
    super.initState();
    _telegramApiKeyController = TextEditingController(
      text: preferences.getValue<String>('telegram_bot_api_key', ''),
    );
  }

  @override
  void dispose() {
    _telegramApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          preferences.setString(
              'telegram_bot_api_key', _telegramApiKeyController.text);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Настройки'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _telegramApiKeyController,
                decoration: const InputDecoration(
                  labelText: 'Telegram Bot API Key',
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  preferences.setString('telegram_bot_api_key', value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
