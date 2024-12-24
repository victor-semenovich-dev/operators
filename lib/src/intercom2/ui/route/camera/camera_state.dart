import '../../../model/camera.dart';
import '../../../model/message.dart';

class CameraRouteState {
  final bool connecting;
  final bool connected;
  final bool connectionClosed;
  final bool connectionError;
  final bool reconnectionRequired;
  final Camera? camera;
  final List<Message> messages;

  CameraRouteState({
    this.connecting = false,
    this.connected = false,
    this.connectionClosed = false,
    this.connectionError = false,
    this.reconnectionRequired = false,
    this.camera,
    this.messages = const [],
  });

  CameraRouteState copyWith({
    bool? connecting,
    bool? connected,
    bool? connectionClosed,
    bool? connectionError,
    bool? reconnectionRequired,
    Camera? camera,
    List<Message>? messages,
  }) {
    return CameraRouteState(
      connecting: connecting ?? this.connecting,
      connected: connected ?? this.connected,
      connectionClosed: connectionClosed ?? this.connectionClosed,
      connectionError: connectionError ?? this.connectionError,
      reconnectionRequired: reconnectionRequired ?? this.reconnectionRequired,
      camera: camera ?? this.camera,
      messages: messages ?? this.messages,
    );
  }

  @override
  String toString() {
    return 'CameraRouteState{connecting: $connecting, connected: $connected, connectionClosed: $connectionClosed, connectionError: $connectionError, reconnectionRequired: $reconnectionRequired}';
  }
}
