import 'package:flutter/material.dart';
import 'package:operators/src/data/model/telegram.dart';

class NotificationConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? message;
  final List<TelegramConfig> telegramConfigs;
  final bool telegramInitialValue;

  final Function(
    String message,
    List<TelegramConfig> telegramConfigs,
  ) onConfirmationClick;

  const NotificationConfirmationDialog({
    super.key,
    this.title,
    this.message,
    required this.onConfirmationClick,
    required this.telegramConfigs,
    this.telegramInitialValue = false,
  });

  @override
  State<NotificationConfirmationDialog> createState() =>
      _NotificationConfirmationDialogState();
}

class _NotificationConfirmationDialogState
    extends State<NotificationConfirmationDialog> {
  late TextEditingController _controller;
  List<TelegramConfigValue> _telegramConfigsState = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message);
    final sortedConfigs = List<TelegramConfig>.from(widget.telegramConfigs)
      ..sort((a, b) => a.order.compareTo(b.order));
    for (final telegramConfig in sortedConfigs) {
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...telegramWidgets,
                ],
              ),
            ),
          ),
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
            widget.onConfirmationClick(
              _controller.text,
              _telegramConfigsState
                  .where((s) => s.isChecked)
                  .map((s) => s.config)
                  .toList(),
            );
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
