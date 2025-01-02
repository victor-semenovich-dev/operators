import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/camera_context.dart';
import '../../widget/camera_widget.dart';
import '../../widget/custom_alert_dialog.dart';
import '../../widget/flash_wrapper.dart';
import '../../widget/lifecycle_widget.dart';
import '../../widget/messages_widget.dart';
import '../../widget/progress_overlay.dart';
import '../../widget/state_button.dart';
import '../../widget/wakelock_widget.dart';
import 'camera_bloc.dart';
import 'camera_state.dart';

class CameraRoute extends StatelessWidget {
  final int id; // 0 based
  final Uri socketUri;
  final String? userName;

  const CameraRoute({
    Key? key,
    required this.id,
    required this.socketUri,
    this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WakelockWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Камера ${id + 1}'),
        ),
        body: BlocProvider<CameraBloc>(
          create: (_) => CameraBloc(
            id: id,
            socketUri: socketUri,
          ),
          child: FlashWrapper(
            child: BlocConsumer<CameraBloc, CameraRouteState>(
              listener: (context, state) {
                debugPrint('listener: $state');
                if (state.connectionClosed && !state.reconnectionRequired) {
                  debugPrint('showConnectionClosedDialog');
                  showConnectionClosedDialog(context: context);
                }
                if (state.connectionError && !state.reconnectionRequired) {
                  debugPrint('showConnectionErrorDialog');
                  showConnectionErrorDialog(context: context);
                }
              },
              builder: (context, state) {
                final camera = state.camera;
                return LifecycleWidget(
                  onLifecycleStateChanged: (lifecycleState) {
                    if (lifecycleState == AppLifecycleState.paused) {
                      context.read<CameraBloc>().reconnectionRequired(true);
                    }
                    if (lifecycleState == AppLifecycleState.resumed &&
                        state.reconnectionRequired) {
                      if (state.connected) {
                        context.read<CameraBloc>().reconnectionRequired(false);
                      } else {
                        context.read<CameraBloc>().reconnect();
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      if (camera != null)
                        CameraWidget(
                          cameraContext: CameraContext.CAMERA,
                          cameraId: id,
                          stateLive: camera.live,
                          stateReady: camera.ready,
                          stateAttention: camera.attention,
                          stateChange: camera.change,
                          textSize: 100,
                          circleSize: 80,
                          circleMargin: 32,
                          onTap: context.read<CameraBloc>().toggleReady,
                          sendMessage: (message) async {
                            await context.read<CameraBloc>().sendMessage(
                                  message: message,
                                  userName: userName,
                                );
                          },
                        ),
                      if (camera != null)
                        SafeArea(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: StateButton(
                                    onClick: camera.live || camera.change
                                        ? null
                                        : context
                                            .read<CameraBloc>()
                                            .toggleAttention,
                                    state: camera.attention
                                        ? ButtonState.FILLED
                                        : ButtonState.NORMAL,
                                    text: camera.attention
                                        ? 'Отменить запрос камеры в трансляцию'
                                        : 'Попросить пустить камеру в трансляцию',
                                  ))),
                        ),
                      AnimatedOpacity(
                        opacity: state.messages.isEmpty ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: MessagesWidget(
                          messages: state.messages,
                          cameraContext: CameraContext.CAMERA,
                          onClick: context.read<CameraBloc>().cancelMessages,
                        ),
                      ),
                      if (state.connecting) const ProgressOverlay(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
