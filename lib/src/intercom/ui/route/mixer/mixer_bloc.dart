import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/model/camera.dart';
import 'package:operators/src/intercom/ui/route/mixer/mixer_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MixerBloc extends Cubit<MixerRouteState> {
  final Uri socketUri;

  late WebSocketChannel _webSocketChannel;

  MixerBloc({
    required this.socketUri,
  }) : super(MixerRouteState()) {
    _connectToWebSocket().then((_) => _listenWebSocket());
  }

  Future<void> _connectToWebSocket() async {
    debugPrint('connect...');
    _webSocketChannel = WebSocketChannel.connect(socketUri);
    await _webSocketChannel.ready;
    debugPrint('connected!');
    _safeEmit(state.copyWith(socketConnected: true));
    // TODO add timeout
  }

  void _listenWebSocket() {
    _webSocketChannel.stream.listen((message) {
      try {
        final json = jsonDecode(message) as Map<String, dynamic>;
        if (json.containsKey('cameras')) {
          final List cameras = json['cameras'];
          List<Camera> cameraList = <Camera>[];

          for (var i = 0; i < cameras.length; i++) {
            final Map<String, dynamic> cameraData = cameras[i];
            cameraList.add(
              Camera(
                live: cameraData['live'],
                ready: cameraData['ready'],
                attention: cameraData['attention'],
                change: cameraData['change'],
              ),
            );
          }

          _safeEmit(state.copyWith(cameraList: cameraList));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }).onDone(() {
      if (!this.isClosed) {
        _safeEmit(state.copyWith(socketClosed: true));
      }
    });
  }

  void toggleChange({required int cameraId}) {
    final cameraList = state.cameraList;
    if (cameraList != null) {
      final camera = cameraList[cameraId];
      if (!camera.live) {
        final newChange = !camera.change;
        final messageMap = {
          'id': cameraId,
          'change': newChange,
          'attention': false,
        };
        final messageJson = json.encode(messageMap);
        _webSocketChannel.sink.add(messageJson);
      }
    }
  }

  void setLive({required int cameraId}) {
    final messageMap = {
      'id': cameraId,
      'live': true,
      'change': false,
      'attention': false,
    };
    final messageJson = json.encode(messageMap);
    _webSocketChannel.sink.add(messageJson);
  }

  Future<void> sendMessage({
    required int cameraId,
    required String message,
  }) async {
    // TODO not implemented
  }

  void _safeEmit(MixerRouteState state) {
    if (!this.isClosed) {
      emit(state);
    }
  }
}
