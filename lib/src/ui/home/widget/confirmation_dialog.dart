import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final Function() onConfirmationClick;

  const ConfirmationDialog({
    super.key,
    required this.message,
    required this.onConfirmationClick,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Да'),
          onPressed: () {
            onConfirmationClick();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
