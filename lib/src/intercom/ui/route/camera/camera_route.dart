import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/ui/route/camera/camera_bloc.dart';
import 'package:operators/src/intercom/ui/route/camera/camera_state.dart';
import 'package:operators/src/intercom/ui/widget/messages_widget_2.dart';
import 'package:operators/src/intercom/ui/widget/wakelock_widget.dart';

import '../../../model/camera_context.dart';
import '../../widget/camera_widget_2.dart';
import '../../widget/state_button.dart';

class CameraRoute extends StatelessWidget {
  final int id; // 0 based
  final Uri socketUri;

  const CameraRoute({
    Key? key,
    required this.id,
    required this.socketUri,
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
          child: BlocBuilder<CameraBloc, CameraRouteState>(
              builder: (context, state) {
            final camera = state.camera;
            return Stack(
              children: [
                if (camera != null)
                  CameraWidget2(
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
                    sendMessage: context.read<CameraBloc>().sendMessage,
                  ),
                if (camera != null)
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          child: StateButton(
                            onClick: camera.live
                                ? null
                                : () {
                                    context
                                        .read<CameraBloc>()
                                        .toggleAttention();
                                  },
                            state: camera.attention
                                ? ButtonState.FILLED
                                : ButtonState.NORMAL,
                            text: camera.attention
                                ? 'Отменить запрос камеры в трансляцию'
                                : 'Попросить пустить камеру в трансляцию',
                          ))),
                // TODO show messages
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
                if (camera == null && !state.socketClosed)
                  const Center(child: CircularProgressIndicator()),
                if (state.socketClosed) const SizedBox(), // TODO socket closed
              ],
            );
          }),
        ),
      ),
    );
  }
}
