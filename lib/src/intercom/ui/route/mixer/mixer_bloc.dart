import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/model/mixer.dart';
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
    try {
      debugPrint('connect...');
      _webSocketChannel = WebSocketChannel.connect(socketUri);
      await _webSocketChannel.ready;
      debugPrint('connected!');
      _safeEmit(state.copyWith(socketConnected: true));
    } catch (e) {}
  }

  void _listenWebSocket() {
    _webSocketChannel.stream.listen((message) {
      try {
        final json = jsonDecode(message) as Map<String, dynamic>;
        if (json.containsKey('cameras')) {
          final mixer = Mixer.fromJson(json);
          _safeEmit(state.copyWith(
            cameraList: mixer.cameras,
            messages: mixer.incomingMessages,
          ));
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
    final messageMap = {
      'to': cameraId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'message': message,
    };
    final messageJson = json.encode(messageMap);
    _webSocketChannel.sink.add(messageJson);
  }

  void cancelMessages() {
    final messageMap = {
      'command': 'cancelIncomingMessages',
    };
    final messageJson = json.encode(messageMap);
    _webSocketChannel.sink.add(messageJson);
  }

  void _safeEmit(MixerRouteState state) {
    if (!this.isClosed) {
      emit(state);
    }
  }
}
