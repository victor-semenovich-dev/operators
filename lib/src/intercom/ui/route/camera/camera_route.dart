import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/ui/route/camera/camera_bloc.dart';
import 'package:operators/src/intercom/ui/route/camera/camera_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../data/camera.dart';
import '../../../repository/camera_repository.dart';
import '../../widget/camera_context.dart';
import '../../widget/camera_widget_2.dart';
import '../../widget/messages_widget.dart';
import '../../widget/state_button.dart';

class CameraRoute extends StatefulWidget {
  final int id;
  final Uri socketUri;

  const CameraRoute({
    Key? key,
    required this.id,
    required this.socketUri,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraRouteState();
}

class _CameraRouteState extends State<CameraRoute> with WidgetsBindingObserver {
  static const String cameraRequest = 'Попросить пустить камеру в трансляцию';
  static const String cameraAlreadyRequested =
      'Отменить запрос камеры в трансляцию';

  final cameraRepository = CameraRepository();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Камера ${widget.id + 1}'),
      ),
      body: BlocProvider<CameraBloc>(
        create: (_) => CameraBloc(
          id: widget.id,
          socketUri: widget.socketUri,
        ),
        child: BlocBuilder<CameraBloc, CameraRouteState>(
            builder: (context, state) {
          final camera = state.cameraState;
          return Stack(
            children: [
              if (camera != null)
                CameraWidget2(
                  cameraContext: CameraContext.CAMERA,
                  cameraId: widget.id,
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
                                  context.read<CameraBloc>().toggleAttention();
                                },
                          state: camera.attention
                              ? ButtonState.FILLED
                              : ButtonState.NORMAL,
                          text: camera.attention
                              ? cameraAlreadyRequested
                              : cameraRequest,
                        ))),
              // TODO show messages
              AnimatedOpacity(
                opacity: _messages.isEmpty ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: MessagesWidget(
                  messages: _messages,
                  cameraContext: CameraContext.CAMERA,
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
    );
  }
}
