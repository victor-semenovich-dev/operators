import 'camera.dart';
import 'message.dart';

class Mixer {
  final List<Camera> cameras;
  final List<Message> incomingMessages;
  final List<Message> outcomingMessages;

  Mixer({
    required this.cameras,
    required this.incomingMessages,
    required this.outcomingMessages,
  });

  Mixer.fromJson(Map<String, dynamic> json)
      : cameras =
            (json['cameras'] as List).map((e) => Camera.fromJson(e)).toList(),
        incomingMessages =
            (json['incoming'] as List).map((e) => Message.fromJson(e)).toList(),
        outcomingMessages = (json['outcoming'] as List)
            .map((e) => Message.fromJson(e))
            .toList();
}
