import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../../main.dart';
import '../../model/camera_context.dart';
import '../painter/CameraPainter.dart';
import '../route/mixer/mixer_settings_route.dart';

class CameraWidget extends StatefulWidget {
  final Function() onTap;
  final Function()? onLongPress;
  final Future<void> Function(String message) sendMessage;
  final int cameraId; // 0 based
  final bool stateLive;
  final bool statePreview;
  final bool stateReady;
  final bool stateAttention;
  final bool stateChange;
  final double textSize;
  final double circleSize;
  final double circleMargin;
  final CameraContext cameraContext;

  CameraWidget({
    required this.cameraContext,
    required this.cameraId,
    required this.stateLive,
    required this.stateReady,
    required this.statePreview,
    required this.stateAttention,
    required this.stateChange,
    required this.onTap,
    this.onLongPress,
    required this.sendMessage,
    this.textSize = 48,
    this.circleSize = 48,
    this.circleMargin = 8,
  });

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _CameraWidgetState(cameraContext);
  }
}

class _CameraWidgetState extends State<CameraWidget>
    with SingleTickerProviderStateMixin {
  final mixerPredefinedMessages = [
    'Оставь камеру в таком положении',
    'Дай крупный план',
    'Дай общий план',
    'Покажи кафедру',
    'Покажи инструменты',
    'Покажи зал',
    'Сделай отъезд',
    'Сделай наезд',
  ];
  final cameraPredefinedMessages = [
    'Сейчас будет отъезд',
    'Сейчас будет наезд',
  ];

  final CameraContext cameraContext;

  late Animation<double> animation;
  late AnimationController animationController;

  _CameraWidgetState(this.cameraContext);

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation =
        Tween<double>(begin: widget.circleSize, end: 2 * widget.circleSize)
            .animate(animationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            switch (status) {
              case AnimationStatus.completed:
                if (widget.stateAttention) animationController.reverse();
                break;
              case AnimationStatus.dismissed:
                if (widget.stateAttention) animationController.forward();
                break;
              default:
                break;
            }
          });

    if (widget.stateAttention && cameraContext == CameraContext.MIXER) {
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
    bool isAttentionChanged = widget.stateAttention != oldWidget.stateAttention;
    if (cameraContext == CameraContext.MIXER && isAttentionChanged) {
      if (widget.stateAttention) {
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
              if (cameraContext == CameraContext.MIXER &&
                  !isManualSelectionEnabled) {
                _sendMessage(context);
              } else {
                widget.onTap();
              }
            },
            onLongPress: widget.onLongPress,
            child: CustomPaint(
              painter: CameraPainter(showCross: widget.stateChange),
              child: Stack(children: [
                Container(
                  color: (widget.stateLive)
                      ? Colors.red[300]
                      : (widget.statePreview
                          ? Colors.green[300]
                          : Colors.transparent),
                  child: Center(
                    child: Text('${widget.cameraId + 1}',
                        style: TextStyle(fontSize: widget.textSize)),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.all(widget.circleMargin),
                  child: ClipOval(
                    child: SizedBox(
                        width: animation.value,
                        height: animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                              color: (widget.stateReady)
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
                    padding: EdgeInsets.all(widget.circleMargin),
                    child: Icon(
                      Icons.message,
                      size: widget.circleSize,
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
                    : 'Сообщение для оператора камеры ${widget.cameraId + 1}:',
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
                        autofocus: !kIsWeb,
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
      await widget.sendMessage(message);

      if (cameraContext == CameraContext.CAMERA) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Сообщение отправлено: "$message"')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Сообщение отправлено (${widget.cameraId + 1}): "$message"')));
      }
    }
  }

  List<Widget> predefinedMessagesWidgets(FlashController<String> controller) {
    final predefinedMessages = (cameraContext == CameraContext.MIXER)
        ? mixerPredefinedMessages
        : cameraPredefinedMessages;
    return predefinedMessages
        .map((message) => InkWell(
              onTap: () => controller.dismiss(message),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.send),
                      Container(width: 8),
                      Text(
                        message,
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
