import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String body;
  final Function() onSendClick;

  const NotificationDialog({
    Key? key,
    required this.title,
    required this.body,
    required this.onSendClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        TextButton(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Отправить'),
          onPressed: () {
            onSendClick();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
