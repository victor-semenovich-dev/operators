import 'package:flutter/material.dart';

enum ButtonState { NORMAL, FILLED }

class StateButton extends StatelessWidget {
  final ButtonState state;
  final String text;
  final void Function()? onClick;

  StateButton({required this.state, required this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    switch (state) {
      case ButtonState.NORMAL:
        backgroundColor = Colors.grey[300]!;
        textColor = Colors.black;
        break;
      case ButtonState.FILLED:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        break;
    }
    return Opacity(
      opacity: onClick == null ? 0.5 : 1.0,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 32, horizontal: 16)),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
        ),
        onPressed: onClick,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
