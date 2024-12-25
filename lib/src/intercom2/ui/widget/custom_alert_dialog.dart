import 'package:flutter/material.dart';

void showConnectionErrorDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
          message:
              'Не удалось подключиться к сокету. Убедитесь, что он запущен, и проверьте адрес.');
    },
  ).then((_) {
    Navigator.of(context).pop();
  });
}

void showConnectionClosedDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
          message: 'Соединение с сокетом прервано. Попробуйте зайти снова.');
    },
  ).then((_) {
    Navigator.of(context).pop();
  });
}

class CustomAlertDialog extends StatelessWidget {
  final String message;

  const CustomAlertDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
