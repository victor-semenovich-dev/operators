import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/model/mixer.dart';
import 'package:operators/src/intercom/ui/route/camera/camera_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CameraBloc extends Cubit<CameraRouteState> {
  final int id;
  final Uri socketUri;

  late WebSocketChannel _webSocketChannel;

  CameraBloc({
    required this.id,
    required this.socketUri,
  }) : super(CameraRouteState()) {
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

  void toggleReady() {
    final camera = state.camera;
    if (camera != null) {
      final newReady = !camera.ready;
      final messageMap = {
        'id': id,
        'ready': newReady,
        'change': false,
        'attention': false,
      };
      final messageJson = json.encode(messageMap);
      _webSocketChannel.sink.add(messageJson);
    }
  }

  void toggleAttention() {
    final camera = state.camera;
    if (camera != null) {
      final newAttention = !camera.attention;
      final messageMap = {
        'id': id,
        'ready': true,
        'change': false,
        'attention': newAttention,
      };
      final messageJson = json.encode(messageMap);
      _webSocketChannel.sink.add(messageJson);
    }
  }

  Future<void> sendMessage(String message) async {
    final messageMap = {
      'from': id,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'message': message,
    };
    final messageJson = json.encode(messageMap);
    _webSocketChannel.sink.add(messageJson);
  }

  void _listenWebSocket() {
    _webSocketChannel.stream.listen((message) {
      try {
        final json = jsonDecode(message) as Map<String, dynamic>;
        final mixer = Mixer.fromJson(json);
        _safeEmit(state.copyWith(
          camera: mixer.cameras[id],
          messages:
              mixer.outcomingMessages.where((e) => e.cameraId == id).toList(),
        ));
      } catch (e) {
        debugPrint(e.toString());
      }
    }).onDone(() {
      if (!this.isClosed) {
        _safeEmit(state.copyWith(socketClosed: true));
      }
    });
  }

  void _safeEmit(CameraRouteState state) {
    if (!this.isClosed) {
      emit(state);
    }
  }

  @override
  Future<void> close() {
    _webSocketChannel.sink.close();
    return super.close();
  }
}
