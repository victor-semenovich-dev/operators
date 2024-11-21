import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketWidget extends StatefulWidget {
  final Uri wsUrl;

  const WebSocketWidget({super.key, required this.wsUrl});

  @override
  State<StatefulWidget> createState() {
    return _WebSocketWidgetState();
  }
}

class _WebSocketWidgetState extends State<WebSocketWidget> {
  late WebSocketChannel _webSocketChannel;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  void _connectToWebSocket() async {
    debugPrint('connect to ${widget.wsUrl}');
    _webSocketChannel = WebSocketChannel.connect(widget.wsUrl);
    await _webSocketChannel.ready;
  }
}
