import '../../../model/camera.dart';
import '../../../model/message.dart';

class MixerRouteState {
  final bool connecting;
  final bool connected;
  final bool connectionClosed;
  final bool connectionError;
  final bool reconnectionRequired;
  final List<Camera>? cameraList;
  final List<Message> messages;

  MixerRouteState({
    this.connecting = false,
    this.connected = false,
    this.connectionClosed = false,
    this.connectionError = false,
    this.reconnectionRequired = false,
    this.cameraList,
    this.messages = const [],
  });

  MixerRouteState copyWith({
    bool? connecting,
    bool? connected,
    bool? connectionClosed,
    bool? connectionError,
    bool? reconnectionRequired,
    List<Camera>? cameraList,
    List<Message>? messages,
  }) {
    return MixerRouteState(
      connecting: connecting ?? this.connecting,
      connected: connected ?? this.connected,
      connectionClosed: connectionClosed ?? this.connectionClosed,
      connectionError: connectionError ?? this.connectionError,
      reconnectionRequired: reconnectionRequired ?? this.reconnectionRequired,
      cameraList: cameraList ?? this.cameraList,
      messages: messages ?? this.messages,
    );
  }

  @override
  String toString() {
    return 'MixerRouteState{connecting: $connecting, connected: $connected, connectionClosed: $connectionClosed, connectionError: $connectionError, reconnectionRequired: $reconnectionRequired}';
  }
}
