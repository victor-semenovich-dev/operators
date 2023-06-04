import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? title;
  final String message;
  final Function() onConfirmationClick;

  const ConfirmationDialog({
    super.key,
    this.title,
    required this.message,
    required this.onConfirmationClick,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title == null ? null : Text(title ?? ''),
      content: Text(message),
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
            onConfirmationClick();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
