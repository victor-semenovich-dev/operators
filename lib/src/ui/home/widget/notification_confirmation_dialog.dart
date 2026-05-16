import 'package:flutter/material.dart';
import 'package:operators/src/data/model/telegram.dart';

class NotificationConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? message;
  final List<TelegramConfig> telegramConfigs;
  final bool telegramInitialValue;
  final bool showRefreshTable;

  final Function(
    String message,
    List<TelegramConfig> telegramConfigs,
    bool refreshTable,
  ) onConfirmationClick;

  const NotificationConfirmationDialog({
    super.key,
    this.title,
    this.message,
    required this.onConfirmationClick,
    required this.telegramConfigs,
    this.telegramInitialValue = false,
    this.showRefreshTable = false,
  });

  @override
  State<NotificationConfirmationDialog> createState() =>
      _NotificationConfirmationDialogState();
}

class _NotificationConfirmationDialogState
    extends State<NotificationConfirmationDialog> {
  late TextEditingController _controller;
  List<TelegramConfigValue> _telegramConfigsState = [];
  bool _refreshTable = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message);
    for (final telegramConfig in widget.telegramConfigs) {
      _telegramConfigsState.add(
        TelegramConfigValue(telegramConfig, widget.telegramInitialValue),
      );
    }
    _refreshTable = widget.showRefreshTable;
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
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          ...telegramWidgets,
          if (widget.showRefreshTable)
            CheckboxListTile(
              value: _refreshTable,
              onChanged: (value) {
                setState(() => _refreshTable = value ?? false);
              },
              title: Text('Убрать событие'),
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
              _refreshTable,
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
