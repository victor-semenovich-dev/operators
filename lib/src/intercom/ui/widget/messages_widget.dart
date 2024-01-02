import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessagesWidget extends StatelessWidget {
  final List<String> messages;
  final Function() onClick;

  const MessagesWidget({Key? key, required this.messages, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> messageWidgets = [];
    for (int i = 0; i < messages.length; i++) {
      if (i > 0) {
        messageWidgets.add(const SizedBox(height: 8));
      }
      messageWidgets.add(Text(messages[i],
          style: const TextStyle(color: Colors.white, fontSize: 20)));
    }

    if (messageWidgets.isEmpty) {
      return Container();
    }

    return Container(
      alignment: Alignment.center,
      child: Wrap(
        children: [
          GestureDetector(
            onTap: onClick,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [...messageWidgets],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
