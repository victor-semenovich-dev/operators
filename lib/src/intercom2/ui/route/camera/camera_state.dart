import '../../../model/camera.dart';
import '../../../model/message.dart';

class CameraRouteState {
  final bool socketConnected;
  final bool socketClosed;
  final Camera? camera;
  final List<Message> messages;

  CameraRouteState({
    this.socketConnected = false,
    this.socketClosed = false,
    this.camera,
    this.messages = const [],
  });

  CameraRouteState copyWith({
    bool? socketConnected,
    bool? socketClosed,
    Camera? camera,
    List<Message>? messages,
  }) {
    return CameraRouteState(
      socketConnected: socketConnected ?? this.socketConnected,
      socketClosed: socketClosed ?? this.socketClosed,
      camera: camera ?? this.camera,
      messages: messages ?? this.messages,
    );
  }

  @override
  String toString() {
    return 'CameraRouteState{socketConnected: $socketConnected, socketClosed: $socketClosed, camera: $camera, messages: $messages}';
  }
}
