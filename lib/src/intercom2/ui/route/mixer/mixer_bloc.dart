import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../model/mixer.dart';
import 'mixer_state.dart';

class MixerBloc extends Cubit<MixerRouteState> {
  final Uri socketUri;

  WebSocketChannel? _webSocketChannel;

  MixerBloc({
    required this.socketUri,
  }) : super(MixerRouteState()) {
    _connectToWebSocket();
  }

  void reconnect() {
    _connectToWebSocket();
  }

  void reconnectionRequired(bool reconnectionRequired) {
    _safeEmit(state.copyWith(reconnectionRequired: reconnectionRequired));
  }

  Future<void> _connectToWebSocket() async {
    // this is needed to make the bloc listener work if there is a quick error on route start
    await Future.delayed(Duration.zero);
    try {
      debugPrint('connect...');
      _safeEmit(state.copyWith(
        connectionClosed: false,
        connectionError: false,
        connecting: true,
        reconnectionRequired: false,
      ));
      _webSocketChannel = WebSocketChannel.connect(socketUri);
      await _webSocketChannel?.ready.timeout(Duration(seconds: 5));
      debugPrint('connected!');
      _safeEmit(state.copyWith(connected: true, connecting: false));
      _listenWebSocket();
    } catch (e) {
      debugPrint('error: $e');
      _safeEmit(state.copyWith(connectionError: true, connecting: false));
    }
  }

  void _listenWebSocket() {
    _webSocketChannel?.stream.listen((message) {
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
        _safeEmit(state.copyWith(
          connected: false,
          connectionClosed: true,
        ));
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
        _webSocketChannel?.sink.add(messageJson);
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
    _webSocketChannel?.sink.add(messageJson);
  }

  Future<void> sendMessage({
    required int cameraId,
    required String message,
    String? userName,
  }) async {
    final messageMap = {
      'to': cameraId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'message': message,
      'userName': userName,
    };
    final messageJson = json.encode(messageMap);
    _webSocketChannel?.sink.add(messageJson);
  }

  void cancelMessages() {
    final messageMap = {
      'command': 'cancelIncomingMessages',
    };
    final messageJson = json.encode(messageMap);
    _webSocketChannel?.sink.add(messageJson);
  }

  void _safeEmit(MixerRouteState state) {
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
