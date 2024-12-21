import 'package:flutter/material.dart';

void showConnectionErrorDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(message: 'Отсутствует соединение с сервером');
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
