import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../data/camera.dart';
import '../ui/widget/camera_widget.dart';
import 'camera_state.dart';

class CameraRepository {
  static final CameraRepository _instance = CameraRepository._internal();
  factory CameraRepository() => _instance;

  List<CameraState> _cameraStateList = [
    CameraState(1),
    CameraState(2),
    CameraState(3),
    CameraState(4),
  ];

  CameraRepository._internal();

  Stream<Camera> getCameraStream(int id) =>
      _cameraStateList.firstWhere((state) => state.id == id).open();

  Stream<List<Camera>> getAllCamerasStream() {
    List<Stream<Camera>> streamList =
        _cameraStateList.map((e) => e.open()).toList();
    return Rx.combineLatestList(streamList);
  }

  void setLive(int id) => _cameraStateList
      .forEach((cameraState) => cameraState.setLive(cameraState.id == id));

  void setReady(int id, bool isReady) =>
      _cameraStateList.firstWhere((state) => state.id == id).setReady(isReady);

  void setRequested(int id, bool isRequested) => _cameraStateList
      .firstWhere((state) => state.id == id)
      .setRequested(isRequested);

  Future<void> sendMessage(
          int id, String message, CameraContext cameraContext) =>
      _cameraStateList
          .firstWhere((state) => state.id == id)
          .sendMessage(message, cameraContext);

  void messageRead(int id, CameraContext cameraContext) => _cameraStateList
      .firstWhere((state) => state.id == id)
      .messageRead(cameraContext);

  void allMessagesRead(CameraContext cameraContext) => _cameraStateList
      .forEach((cameraState) => cameraState.messageRead(cameraContext));

  void setOk(int id, bool isOk) =>
      _cameraStateList.firstWhere((state) => state.id == id).setCameraOk(isOk);
}
