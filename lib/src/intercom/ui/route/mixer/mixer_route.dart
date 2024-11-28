import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/model/camera.dart';
import 'package:operators/src/intercom/ui/route/mixer/mixer_bloc.dart';
import 'package:operators/src/intercom/ui/route/mixer/mixer_state.dart';
import 'package:operators/src/intercom/ui/widget/camera_widget_2.dart';
import 'package:operators/src/intercom/ui/widget/flash_wrapper.dart';
import 'package:operators/src/intercom/ui/widget/messages_widget_2.dart';
import 'package:operators/src/intercom/ui/widget/wakelock_widget.dart';

import '../../../model/camera_context.dart';
import 'mixer_settings_route.dart';

class MixerRoute extends StatelessWidget {
  final Uri socketUri;

  const MixerRoute({Key? key, required this.socketUri}) : super(key: key);

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
            child: BlocBuilder<MixerBloc, MixerRouteState>(
              builder: (context, state) {
                final cameraList = state.cameraList;
                return Stack(
                  children: [
                    if (cameraList != null) _camerasWidget(context, cameraList),
                    AnimatedOpacity(
                      opacity: state.messages.isEmpty ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: MessagesWidget2(
                        messages: state.messages,
                        cameraContext: CameraContext.MIXER,
                        onClick: () {
                          // TODO cancel messages
                        },
                      ),
                    ),
                    if (!state.socketConnected)
                      const Center(child: CircularProgressIndicator()),
                    if (state.socketClosed)
                      const SizedBox(), // TODO socket closed
                  ],
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
              )
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
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _singleCameraWidget(BuildContext context, int id, Camera camera) {
    return CameraWidget2(
      cameraContext: CameraContext.MIXER,
      cameraId: id,
      stateLive: camera.live,
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
            .sendMessage(cameraId: id, message: message);
      },
    );
  }
}
