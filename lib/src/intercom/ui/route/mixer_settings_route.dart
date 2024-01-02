import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../../main.dart';

const KEY_IS_MANUAL_SELECTION_ENABLED = 'is_manual_selection_enabled';

class MixerSettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: _body(),
    );
  }

  Widget _body() {
    return PreferenceBuilder<bool>(
        preference: preferences.getBool(KEY_IS_MANUAL_SELECTION_ENABLED,
            defaultValue: false),
        builder: (context, value) {
          return InkWell(
            onTap: () =>
                preferences.setBool(KEY_IS_MANUAL_SELECTION_ENABLED, !value),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Ручное переключение камер',
                    style: TextStyle(fontSize: 16),
                  )),
                  Switch(
                      value: value,
                      onChanged: (value) => preferences.setBool(
                          KEY_IS_MANUAL_SELECTION_ENABLED, value)),
                ],
              ),
            ),
          );
        });
  }
}
