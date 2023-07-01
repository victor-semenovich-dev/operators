import 'package:flutter/material.dart';

class NotificationConfirmationDialog extends StatefulWidget {
  final String? title;
  final String message;
  final bool telegramInitialValue;

  final Function(
    bool telegramSendToMainChannel,
    bool telegramSendToVideoChannel,
  ) onConfirmationClick;

  const NotificationConfirmationDialog({
    super.key,
    this.title,
    required this.message,
    required this.onConfirmationClick,
    this.telegramInitialValue = true,
  });

  @override
  State<NotificationConfirmationDialog> createState() =>
      _NotificationConfirmationDialogState();
}

class _NotificationConfirmationDialogState
    extends State<NotificationConfirmationDialog> {
  late bool _telegramMainChannelCheckboxValue;
  late bool _telegramVideoChannelCheckboxValue;

  @override
  void initState() {
    super.initState();
    _telegramMainChannelCheckboxValue = widget.telegramInitialValue;
    _telegramVideoChannelCheckboxValue = widget.telegramInitialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title ?? ''),
      contentPadding: EdgeInsets.zero,
      content: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.message),
          ),
          CheckboxListTile(
            value: _telegramMainChannelCheckboxValue,
            onChanged: (value) {
              setState(
                () => _telegramMainChannelCheckboxValue = value ?? false,
              );
            },
            title: Text('Telegram: Операторы Операторовичи'),
          ),
          CheckboxListTile(
            value: _telegramVideoChannelCheckboxValue,
            onChanged: (value) {
              setState(
                () => _telegramVideoChannelCheckboxValue = value ?? false,
              );
            },
            title: Text('Telegram: GethMedia #Video'),
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
              _telegramMainChannelCheckboxValue,
              _telegramVideoChannelCheckboxValue,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
