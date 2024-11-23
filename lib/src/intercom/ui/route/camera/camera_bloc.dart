import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:operators/src/intercom/ui/route/camera/camera_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../model/camera.dart';

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
    emit(state.copyWith(socketConnected: true));
    // TODO add timeout
  }

  void toggleReady() {
    // TODO not implemented
  }

  void toggleAttention() {
    // TODO not implemented
    // cameraRepository.setRequested(
    //     _id, !snapshot.data!.isRequested);
    // cameraRepository.setReady(_id, true);
  }

  Future<void> sendMessage(String message) async {
    // TODO not implemented
  }

  void _listenWebSocket() {
    _webSocketChannel.stream.listen((message) {
      try {
        final json = jsonDecode(message) as Map<String, dynamic>;
        if (json.containsKey('cameras')) {
          final List cameras = json['cameras'];
          final Map<String, dynamic> cameraData = cameras[id];
          final camera = Camera(
            live: cameraData['live'],
            ready: cameraData['ready'],
            attention: cameraData['attention'],
            change: cameraData['change'],
          );
          emit(state.copyWith(camera: camera));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }).onDone(() {
      emit(state.copyWith(socketClosed: true));
    });
  }

  @override
  Future<void> close() {
    _webSocketChannel.sink.close();
    return super.close();
  }
}
