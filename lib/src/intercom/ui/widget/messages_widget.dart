import 'package:flutter/material.dart';
import 'package:operators/src/intercom/data/camera.dart';
import 'package:operators/src/intercom/ui/widget/camera_widget.dart';

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
      final author = message.author;
      final prefix = cameraId == null
          ? (author == null ? '' : author)
          : "$cameraId ${author == null ? '' : '($author)'}".trim();

      final text = message.text;

      final messageText = "${prefix.isEmpty ? '' : '$prefix: $text'}";

      messageWidgets.add(
        Text(
          messageText,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
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
