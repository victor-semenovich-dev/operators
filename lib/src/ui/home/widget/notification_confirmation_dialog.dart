import 'package:flutter/material.dart';
import 'package:operators/src/data/model/telegram.dart';

class NotificationConfirmationDialog extends StatefulWidget {
  final String? title;
  final String message;
  final List<TelegramConfig> telegramConfigs;
  final bool telegramInitialValue;

  final Function(List<TelegramConfig> telegramConfigs) onConfirmationClick;

  const NotificationConfirmationDialog({
    super.key,
    this.title,
    required this.message,
    required this.onConfirmationClick,
    required this.telegramConfigs,
    this.telegramInitialValue = true,
  });

  @override
  State<NotificationConfirmationDialog> createState() =>
      _NotificationConfirmationDialogState();
}

class _NotificationConfirmationDialogState
    extends State<NotificationConfirmationDialog> {
  List<TelegramConfigValue> _telegramConfigsState = [];

  @override
  void initState() {
    super.initState();
    for (final telegramConfig in widget.telegramConfigs) {
      _telegramConfigsState.add(
        TelegramConfigValue(telegramConfig, widget.telegramInitialValue),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final telegramWidgets = _telegramConfigsState.map((s) => CheckboxListTile(
          value: s.isChecked,
          onChanged: (value) {
            setState(() => s.isChecked = value ?? false);
          },
          title: Text(s.config.title),
        ));
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title ?? ''),
      contentPadding: EdgeInsets.zero,
      content: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.message),
          ),
          ...telegramWidgets,
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            widget.onConfirmationClick(_telegramConfigsState
                .where((s) => s.isChecked)
                .map((s) => s.config)
                .toList());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class TelegramConfigValue {
  final TelegramConfig config;
  bool isChecked;

  TelegramConfigValue(this.config, this.isChecked);
}
