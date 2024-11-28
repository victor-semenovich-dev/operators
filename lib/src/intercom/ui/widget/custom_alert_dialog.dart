import 'package:flutter/material.dart';

void showCustomDialog({
  required BuildContext context,
  required String message,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CustomAlertDialog(message: message);
    },
  );
}

class CustomAlertDialog extends StatelessWidget {
  final String message;

  const CustomAlertDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
