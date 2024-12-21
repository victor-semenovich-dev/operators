import 'package:flutter/material.dart';

import '../../model/camera_context.dart';
import '../../model/message.dart';

class MessagesWidget extends StatelessWidget {
  final List<Message> messages;
  final CameraContext cameraContext;
  final Function() onClick;

  const MessagesWidget({
    Key? key,
    required this.messages,
    required this.cameraContext,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> messageWidgets = [];
    for (int i = 0; i < messages.length; i++) {
      if (i > 0) {
        messageWidgets.add(const SizedBox(height: 8));
      }

      final Message message = messages[i];

      final cameraId = message.cameraId;
      final text = message.message;
      final messageText = cameraContext == CameraContext.CAMERA
          ? text
          : '${cameraId + 1}: $text';

      messageWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: RichText(
            text: TextSpan(
              text: messageText,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: '  ${message.dateTimeReadable()}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (messageWidgets.isEmpty) {
      return Container();
    }

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        children: [
          GestureDetector(
            onTap: onClick,
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 16),
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
