import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../../main.dart';
import '../../data/camera.dart';
import '../../repository/camera_repository.dart';
import '../painter/CameraPainter.dart';
import '../route/mixer_settings_route.dart';

enum CameraContext { MIXER, CAMERA }

class CameraWidget extends StatefulWidget {
  final TableUser? user;
  final Camera camera;
  final double textSize;
  final double circleSize;
  final double circleMargin;
  final CameraContext cameraContext;

  CameraWidget(
    this.user,
    this.camera,
    this.cameraContext, {
    this.textSize = 48,
    this.circleSize = 48,
    this.circleMargin = 8,
  });

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return CameraWidgetState(camera, cameraContext,
        textSize: textSize, circleSize: circleSize, circleMargin: circleMargin);
  }
}

class CameraWidgetState extends State<CameraWidget>
    with SingleTickerProviderStateMixin {
  final double textSize;
  final double circleSize;
  final double circleMargin;
  final CameraContext cameraContext;

  Camera camera;
  final cameraRepository = CameraRepository();

  late Animation<double> animation;
  late AnimationController animationController;

  CameraWidgetState(this.camera, this.cameraContext,
      {this.textSize = 48, this.circleSize = 48, this.circleMargin = 8});

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: circleSize, end: 2 * circleSize)
        .animate(animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.completed:
            if (camera.isRequested) animationController.reverse();
            break;
          case AnimationStatus.dismissed:
            if (camera.isRequested) animationController.forward();
            break;
          default:
            break;
        }
      });

    if (camera.isRequested && cameraContext == CameraContext.MIXER) {
      animationController.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant CameraWidget oldWidget) {
    final newCamera = widget.camera;
    bool isRequestedChanged = camera.isRequested != newCamera.isRequested;
    camera = newCamera;
    if (cameraContext == CameraContext.MIXER && isRequestedChanged) {
      if (camera.isRequested) {
        animationController.forward();
      } else {
        animationController.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<bool>(
        preference: preferences.getBool(KEY_IS_MANUAL_SELECTION_ENABLED,
            defaultValue: false),
        builder: (context, isManualSelectionEnabled) {
          return GestureDetector(
            onTap: () {
              switch (cameraContext) {
                case CameraContext.MIXER:
                  if (isManualSelectionEnabled) {
                    cameraRepository.setLive(camera.id);
                    cameraRepository.setRequested(camera.id, false);
                    cameraRepository.setOk(camera.id, true);
                  } else {
                    _sendMessage(context);
                  }
                  break;
                case CameraContext.CAMERA:
                  cameraRepository.setReady(camera.id, !camera.isReady);
                  if (camera.isReady) {
                    cameraRepository.setRequested(camera.id, false);
                  }
                  cameraRepository.setOk(camera.id, true);
                  break;
              }
            },
            onLongPress: () {
              if (cameraContext == CameraContext.MIXER) {
                cameraRepository.setOk(camera.id, !camera.isOk);
              }
            },
            child: CustomPaint(
              painter: CameraPainter(camera),
              child: Stack(children: [
                Container(
                  color: (camera?.isLive ?? false)
                      ? Colors.red[300]
                      : Colors.transparent,
                  child: Center(
                    child: Text('${camera.id}',
                        style: TextStyle(fontSize: textSize)),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.all(circleMargin),
                  child: ClipOval(
                    child: SizedBox(
                        width: animation.value,
                        height: animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                              color: (camera.isReady ?? true)
                                  ? Colors.green
                                  : Colors.red[600],
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(animation.value / 2)),
                              border:
                                  Border.all(color: Colors.black, width: 2)),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _sendMessage(context);
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(circleMargin),
                    // padding: EdgeInsets.all(circleSize),
                    child: Icon(
                      Icons.message,
                      size: circleSize,
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  void _sendMessage(BuildContext context) async {
    var editingController = TextEditingController();
    final message = await context.showFlash<String>(
        barrierColor: Colors.black54,
        barrierDismissible: true,
        persistent: false,
        builder: (context, controller) {
          return FlashBar(
            controller: controller,
            padding: EdgeInsets.symmetric(vertical: 16),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                cameraContext == CameraContext.CAMERA
                    ? 'Сообщение для оператора видеопульта:'
                    : 'Сообщение для оператора камеры ${camera.id}:',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            content: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 180),
                  color: Colors.grey.withAlpha(32),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: predefinedMessagesWidgets(controller),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextField(
                        controller: editingController,
                        autofocus: true,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (text) => controller.dismiss(text),
                      )),
                      InkWell(
                        onTap: () => controller.dismiss(editingController.text),
                        child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.send, color: Colors.blue)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
    if (message != null && message.trim().isNotEmpty) {
      await CameraRepository()
          .sendMessage(widget.user, camera.id, message, cameraContext);

      if (cameraContext == CameraContext.CAMERA) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Сообщение отправлено: "$message"')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Сообщение отправлено (${camera.id}): "$message"')));
      }
    }
  }

  List<Widget> predefinedMessagesWidgets(FlashController<String> controller) {
    final predefinedMessages = (cameraContext == CameraContext.MIXER)
        ? camera.incomingPredefinedMessages
        : camera.outcomingPredefinedMessages;
    predefinedMessages.sort((m1, m2) => m1.order - m2.order);
    return predefinedMessages
        .map((message) => InkWell(
              onTap: () => controller.dismiss(message.message),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.send),
                      Container(width: 8),
                      Text(
                        message.message,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }
}
