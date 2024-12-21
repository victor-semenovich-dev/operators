import 'package:flutter/material.dart';
import 'package:operators/main.dart';

import '../widget/list_item.dart';
import 'camera/camera_route.dart';
import 'mixer/mixer_route.dart';

const KEY_INTERCOM_WEB_SOCKET = 'intercom_web_socket';

class IntercomRoute extends StatefulWidget {
  const IntercomRoute({Key? key}) : super(key: key);

  @override
  State<IntercomRoute> createState() => _IntercomRouteState();
}

class _IntercomRouteState extends State<IntercomRoute> {
  late TextEditingController _socketAddressController;
  bool _isAddressFormatCorrect = true;

  @override
  void initState() {
    final wsAddress = preferences
        .getString(KEY_INTERCOM_WEB_SOCKET,
            defaultValue: 'ws://192.168.61.141:8080')
        .getValue();

    _socketAddressController = TextEditingController(
      text: wsAddress,
    );
    _socketAddressController.addListener(() {
      setState(() {
        _isAddressFormatCorrect = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _socketAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбери роль'),
      ),
      body: ListView(
        children: [
          ListItem(
            'Видеопульт',
            () => _validateAndOpenMixerRoute(),
          ),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          ListItem(
            'Камера 1',
            () => _validateAndOpenCameraRoute(0),
          ),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          ListItem(
            'Камера 2',
            () => _validateAndOpenCameraRoute(1),
          ),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          ListItem(
            'Камера 3',
            () => _validateAndOpenCameraRoute(2),
          ),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          ListItem(
            'Камера 4',
            () => _validateAndOpenCameraRoute(3),
          ),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _socketAddressController,
              decoration: InputDecoration(
                labelText: 'Адрес сервера',
                errorText:
                    _isAddressFormatCorrect ? null : 'Неверный формат адреса',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndOpenMixerRoute() {
    final socketUri = _validateAndGetSocketUri();
    if (socketUri != null) {
      preferences.setString(KEY_INTERCOM_WEB_SOCKET, socketUri.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MixerRoute(
            socketUri: socketUri,
          ),
        ),
      );
    }
  }

  void _validateAndOpenCameraRoute(int cameraId) {
    final socketUri = _validateAndGetSocketUri();
    if (socketUri != null) {
      preferences.setString(KEY_INTERCOM_WEB_SOCKET, socketUri.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraRoute(
            id: cameraId,
            socketUri: socketUri,
          ),
        ),
      );
    }
  }

  Uri? _validateAndGetSocketUri() {
    final address = _socketAddressController.value.text;
    try {
      final uri = Uri.parse(address);
      if (uri.isAbsolute) {
        return uri;
      } else {
        setState(() {
          _isAddressFormatCorrect = false;
        });
      }
    } on FormatException {
      setState(() {
        _isAddressFormatCorrect = false;
      });
    }
    return null;
  }
}
