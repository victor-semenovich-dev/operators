import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/camera.dart';
import '../../../model/camera_context.dart';
import '../../widget/camera_widget.dart';
import '../../widget/custom_alert_dialog.dart';
import '../../widget/flash_wrapper.dart';
import '../../widget/lifecycle_widget.dart';
import '../../widget/messages_widget.dart';
import '../../widget/progress_overlay.dart';
import '../../widget/wakelock_widget.dart';
import 'mixer_bloc.dart';
import 'mixer_settings_route.dart';
import 'mixer_state.dart';

class MixerRoute extends StatelessWidget {
  final Uri socketUri;
  final String? userName;

  const MixerRoute({
    Key? key,
    required this.socketUri,
    this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WakelockWidget(
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
        body: BlocProvider<MixerBloc>(
          create: (_) => MixerBloc(socketUri: socketUri),
          child: FlashWrapper(
            child: BlocConsumer<MixerBloc, MixerRouteState>(
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
                final cameraList = state.cameraList;
                return LifecycleWidget(
                  onLifecycleStateChanged: (lifecycleState) {
                    if (lifecycleState == AppLifecycleState.paused) {
                      context.read<MixerBloc>().reconnectionRequired(true);
                    }
                    if (lifecycleState == AppLifecycleState.resumed &&
                        state.reconnectionRequired) {
                      if (state.connected) {
                        context.read<MixerBloc>().reconnectionRequired(false);
                      } else {
                        context.read<MixerBloc>().reconnect();
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      if (cameraList != null)
                        _camerasWidget(context, cameraList),
                      AnimatedOpacity(
                        opacity: state.messages.isEmpty ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: MessagesWidget(
                          messages: state.messages,
                          cameraContext: CameraContext.MIXER,
                          onClick: context.read<MixerBloc>().cancelMessages,
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

  Widget _camerasWidget(BuildContext context, List<Camera> cameraList) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _singleCameraWidget(context, 0, cameraList[0]),
              ),
              const Divider(color: Colors.black, height: 1),
              Expanded(
                child: _singleCameraWidget(context, 2, cameraList[2]),
              ),
              const Divider(color: Colors.black, height: 1),
              Expanded(
                child: _singleCameraWidget(context, 4, cameraList[4]),
              ),
            ],
          ),
        ),
        const VerticalDivider(color: Colors.black, width: 1),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _singleCameraWidget(context, 1, cameraList[1]),
              ),
              const Divider(color: Colors.black, height: 1),
              Expanded(
                child: _singleCameraWidget(context, 3, cameraList[3]),
              ),
              const Divider(color: Colors.black, height: 1),
              Expanded(
                child: _singleCameraWidget(context, 5, cameraList[5]),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _singleCameraWidget(BuildContext context, int id, Camera camera) {
    return CameraWidget(
      cameraContext: CameraContext.MIXER,
      cameraId: id,
      stateLive: camera.live,
      statePreview: camera.preview,
      stateReady: camera.ready,
      stateAttention: camera.attention,
      stateChange: camera.change,
      onTap: () {
        context.read<MixerBloc>().setLive(cameraId: id);
      },
      onLongPress: () {
        context.read<MixerBloc>().toggleChange(cameraId: id);
      },
      sendMessage: (message) async {
        await context
            .read<MixerBloc>()
            .sendMessage(cameraId: id, message: message, userName: userName);
      },
    );
  }
}
