import '../../../model/camera.dart';
import '../../../model/message.dart';

class MixerRouteState {
  final bool socketConnected;
  final bool socketClosed;
  final List<Camera>? cameraList;
  final List<Message> messages;

  MixerRouteState({
    this.socketConnected = false,
    this.socketClosed = false,
    this.cameraList,
    this.messages = const [],
  });

  MixerRouteState copyWith({
    bool? socketConnected,
    bool? socketClosed,
    List<Camera>? cameraList,
    List<Message>? messages,
  }) {
    return MixerRouteState(
      socketConnected: socketConnected ?? this.socketConnected,
      socketClosed: socketClosed ?? this.socketClosed,
      cameraList: cameraList ?? this.cameraList,
      messages: messages ?? this.messages,
    );
  }
}
