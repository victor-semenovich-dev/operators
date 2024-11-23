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
  const MixerRoute({Key? key}) : super(key: key);

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
          create: (_) => MixerBloc(),
          child: FlashWrapper(
            child: BlocBuilder<MixerBloc, MixerRouteState>(
              builder: (context, state) {
                final cameras = state.cameras;
                return Stack(
                  children: [
                    if (cameras != null) _camerasWidget(context, cameras),
                    AnimatedOpacity(
                      opacity: state.messages.isEmpty ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: MessagesWidget2(
                        messages: state.messages,
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

  Widget _camerasWidget(BuildContext context, List<Camera> cameras) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _singleCameraWidget(context, 0, cameras[0]),
              ),
              const Divider(color: Colors.black, height: 1),
              Expanded(
                child: _singleCameraWidget(context, 2, cameras[2]),
              )
            ],
          ),
        ),
        const VerticalDivider(color: Colors.black, width: 1),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _singleCameraWidget(context, 1, cameras[1]),
              ),
              const Divider(color: Colors.black, height: 1),
              Expanded(
                child: _singleCameraWidget(context, 3, cameras[3]),
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
        context.read<MixerBloc>().toggleLive(cameraId: id);
      },
      sendMessage: (message) async {
        await context
            .read<MixerBloc>()
            .sendMessage(cameraId: id, message: message);
      },
    );
  }
}
