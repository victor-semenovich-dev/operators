import 'package:operators/src/intercom/model/camera.dart';
import 'package:operators/src/intercom/model/message.dart';

class MixerRouteState {
  final bool socketConnected;
  final bool socketClosed;
  final List<Camera>? cameras;
  final List<Message> messages;

  MixerRouteState({
    this.socketConnected = false,
    this.socketClosed = false,
    this.cameras,
    this.messages = const [],
  });

  MixerRouteState copyWith({
    bool? socketConnected,
    bool? socketClosed,
    Camera? camera,
    List<Message>? messages,
  }) {
    return MixerRouteState(
      socketConnected: socketConnected ?? this.socketConnected,
      socketClosed: socketClosed ?? this.socketClosed,
      cameras: cameras ?? this.cameras,
      messages: messages ?? this.messages,
    );
  }
}
