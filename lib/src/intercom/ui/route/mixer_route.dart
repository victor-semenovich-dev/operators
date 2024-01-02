import 'dart:async';

import 'package:flutter/material.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../data/camera.dart';
import '../../repository/camera_repository.dart';
import '../widget/background_state_widget.dart';
import '../widget/camera_widget.dart';
import '../widget/foreground_service_widget.dart';
import '../widget/messages_widget.dart';
import 'mixer_settings_route.dart';

class MixerRoute extends StatefulWidget {
  final TableUser? user;

  const MixerRoute({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MixerRouteState();
}

class _MixerRouteState extends State<MixerRoute> {
  final cameraRepository = CameraRepository();
  late StreamSubscription _streamSubscription;
  int _messagesShown = 0;
  bool _isInBackground = false;
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    _streamSubscription =
        cameraRepository.getAllCamerasStream().listen((cameraList) {
      _processCamerasMessages(cameraList);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    WakelockPlus.disable();
  }

  void _processCamerasMessages(List<Camera> cameraList) {
    setState(() {
      _messages.clear();
      for (var camera in cameraList) {
        for (var message in camera.outcomingMessages) {
          _messages.add('${camera.id}: ${message.text}');
        }
      }

      debugPrint(
          'messages - ${_messages.length} ($_messagesShown), $_isInBackground');

      _messagesShown = _messages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ForegroundServiceWidget(
      child: BackgroundStateWidget(
        onBackgroundStateChanged: (isInBackground) {
          _isInBackground = isInBackground;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Видеопульт'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MixerSettingsRoute())),
                tooltip: 'Настройки',
              ),
            ],
          ),
          body: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) {
                  return StreamBuilder(
                      stream: cameraRepository.getAllCamerasStream(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: CameraWidget(
                                                widget.user,
                                                snapshot.data![0],
                                                CameraContext.MIXER,
                                              ),
                                            ),
                                            const Divider(
                                                color: Colors.black, height: 1),
                                            Expanded(
                                              child: CameraWidget(
                                                widget.user,
                                                snapshot.data![2],
                                                CameraContext.MIXER,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(
                                          color: Colors.black, width: 1),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: CameraWidget(
                                                widget.user,
                                                snapshot.data![1],
                                                CameraContext.MIXER,
                                              ),
                                            ),
                                            const Divider(
                                                color: Colors.black, height: 1),
                                            Expanded(
                                              child: CameraWidget(
                                                widget.user,
                                                snapshot.data![3],
                                                CameraContext.MIXER,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  AnimatedOpacity(
                                    opacity: _messages.isEmpty ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: MessagesWidget(
                                      messages: _messages,
                                      onClick: () {
                                        cameraRepository.allMessagesRead(
                                            CameraContext.MIXER);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const Center(child: CircularProgressIndicator());
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
