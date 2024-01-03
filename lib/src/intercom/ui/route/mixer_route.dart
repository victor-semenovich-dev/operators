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
  final List<Message> _messages = [];

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
        _messages.addAll(
          camera.outcomingMessages.map(
            (m) => Message(
              text: m.text,
              author: m.author,
              dateTime: m.dateTime,
              cameraId: camera.id,
            ),
          ),
        );
      }
      _messages.sort((m1, m2) {
        if (m1.dateTime == null || m2.dateTime == null) {
          return 0;
        } else {
          return m1.dateTime!.compareTo(m2.dateTime!);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ForegroundServiceWidget(
      child: BackgroundStateWidget(
        onBackgroundStateChanged: (isInBackground) {},
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
                                      cameraContext: CameraContext.MIXER,
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
