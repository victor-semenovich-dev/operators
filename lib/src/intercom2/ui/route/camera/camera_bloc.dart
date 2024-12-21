import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../model/mixer.dart';
import 'camera_state.dart';

class CameraBloc extends Cubit<CameraRouteState> {
  final int id;
  final Uri socketUri;

  WebSocketChannel? _webSocketChannel;

  CameraBloc({
    required this.id,
    required this.socketUri,
  }) : super(CameraRouteState()) {
    _connectToWebSocket();
  }

  Future<void> _connectToWebSocket() async {
    debugPrint('connect...');
    // this is needed to make the bloc listener work if there is a quick error on route start
    await Future.delayed(Duration.zero);
    try {
      _webSocketChannel = WebSocketChannel.connect(socketUri);
      await _webSocketChannel?.ready.timeout(Duration(seconds: 3));
      debugPrint('connected!');
      _safeEmit(state.copyWith(socketConnected: true));
      _listenWebSocket();
    } catch (e) {
      debugPrint('error: $e');
      _safeEmit(state.copyWith(socketClosed: true));
    }
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
      _webSocketChannel?.sink.add(messageJson);
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
      _webSocketChannel?.sink.add(messageJson);
    }
  }

  Future<void> sendMessage(String message) async {
    final messageMap = {
      'from': id,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'message': message,
    };
    final messageJson = json.encode(messageMap);
    _webSocketChannel?.sink.add(messageJson);
  }

  void cancelMessages() {
    final messageMap = {
      'command': 'cancelOutcomingMessages',
      'to': id,
    };
    final messageJson = json.encode(messageMap);
    _webSocketChannel?.sink.add(messageJson);
  }

  void _listenWebSocket() {
    _webSocketChannel?.stream.listen((message) {
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
      _safeEmit(state.copyWith(socketClosed: true));
    });
  }

  void _safeEmit(CameraRouteState state) {
    if (!this.isClosed) {
      emit(state);
    }
  }

  @override
  Future<void> close() {
    _webSocketChannel?.sink.close();
    return super.close();
  }
}
