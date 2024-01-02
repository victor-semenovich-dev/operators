import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../data/model/user.dart';
import '../../data/camera.dart';
import '../../repository/camera_repository.dart';
import '../widget/background_state_widget.dart';
import '../widget/camera_widget.dart';
import '../widget/foreground_service_widget.dart';
import '../widget/messages_widget.dart';
import '../widget/state_button.dart';

class CameraRoute extends StatefulWidget {
  final TableUser? user;
  final int _id;

  const CameraRoute(this._id, {Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraRouteState(_id);
}

class _CameraRouteState extends State<CameraRoute> with WidgetsBindingObserver {
  static const String cameraRequest = 'Попросить пустить камеру в трансляцию';
  static const String cameraAlreadyRequested =
      'Отменить запрос камеры в трансляцию';

  final int _id;
  final cameraRepository = CameraRepository();
  late StreamSubscription _streamSubscription;
  List<String> _messages = [];

  _CameraRouteState(this._id);

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    _streamSubscription =
        cameraRepository.getCameraStream(_id).listen((camera) {
      _processCameraMessages(camera);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    WakelockPlus.disable();
  }

  void _processCameraMessages(Camera camera) {
    setState(() {
      _messages = camera.incomingMessages.map((e) {
        if (e.author == null) {
          return e.text;
        } else {
          return "${e.author}: ${e.text}";
        }
      }).toList();
      debugPrint('messages - $_messages');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ForegroundServiceWidget(
      child: BackgroundStateWidget(
        onBackgroundStateChanged: (isInBackground) {
          debugPrint('isInBackground - $isInBackground');
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Камера $_id'),
            ),
            body: Overlay(
              initialEntries: [
                OverlayEntry(
                    builder: (context) => StreamBuilder<Camera>(
                        stream: cameraRepository.getCameraStream(_id),
                        builder: (context, snapshot) => snapshot.hasData
                            ? Stack(
                                children: [
                                  CameraWidget(
                                    widget.user,
                                    snapshot.data!,
                                    CameraContext.CAMERA,
                                    textSize: 100,
                                    circleSize: 80,
                                    circleMargin: 32,
                                  ),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(16),
                                          child: StateButton(
                                            onClick: snapshot.data!.isLive
                                                ? null
                                                : () {
                                                    cameraRepository
                                                        .setRequested(
                                                            _id,
                                                            !snapshot.data!
                                                                .isRequested);
                                                    cameraRepository.setReady(
                                                        _id, true);
                                                  },
                                            state: snapshot.data!.isRequested
                                                ? ButtonState.FILLED
                                                : ButtonState.NORMAL,
                                            text: snapshot.data!.isRequested
                                                ? cameraAlreadyRequested
                                                : cameraRequest,
                                          ))),
                                  AnimatedOpacity(
                                    opacity: _messages.isEmpty ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: MessagesWidget(
                                      messages: _messages,
                                      onClick: () {
                                        cameraRepository.messageRead(
                                            _id, CameraContext.CAMERA);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const Center(child: CircularProgressIndicator())))
              ],
            )),
      ),
    );
  }
}
