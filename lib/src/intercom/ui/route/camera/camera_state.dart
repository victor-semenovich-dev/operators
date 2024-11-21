class CameraRouteState {
  final bool socketConnected;
  final bool socketClosed;
  final CameraState? cameraState;

  CameraRouteState({
    this.socketConnected = false,
    this.socketClosed = false,
    this.cameraState,
  });
}

class CameraState {
  final bool live;
  final bool ready;
  final bool attention;
  final bool change;

  CameraState({
    required this.live,
    required this.ready,
    required this.attention,
    required this.change,
  });
}
