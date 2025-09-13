import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:operators/src/intercom2/ui/route/camera/camera_route.dart'
    as camera2;
import 'package:operators/src/intercom2/ui/route/mixer/mixer_route.dart'
    as mixer2;
import 'package:operators/src/intercom2/ui/widget/custom_alert_dialog.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../repository/camera_state.dart';
import '../widget/list_item.dart';
import 'camera_route.dart';
import 'mixer_route.dart';

const KEY_INTERCOM_SERVER_LOCATION = "intercom_server_location";
const KEY_INTERCOM_WEB_SOCKET = 'intercom_web_socket';
const VALUE_LOCATION_USA = "usa";
const VALUE_LOCATION_EU = "eu";
const VALUE_LOCATION_LOCAL = "local";

class IntercomRoute extends StatefulWidget {
  final TableUser? user;

  const IntercomRoute({Key? key, required this.user}) : super(key: key);

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
            defaultValue: 'ws://172.16.51.13:8080')
        .getValue();

    _socketAddressController = TextEditingController(
      text: wsAddress,
    );
    _socketAddressController.addListener(() {
      setState(() {
        _isAddressFormatCorrect = true;
      });
    });

    if (kIsWeb) {
      final serverLocation = preferences
          .getString(KEY_INTERCOM_SERVER_LOCATION,
              defaultValue: VALUE_LOCATION_EU)
          .getValue();
      if (serverLocation == VALUE_LOCATION_LOCAL) {
        onLocationChanged(VALUE_LOCATION_EU);
      }

      Future.delayed(Duration.zero).then(
        (_) => _showLocalSocketNotSupportedDialog(),
      );
    }

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
      body: PreferenceBuilder<String>(
          preference: preferences.getString(KEY_INTERCOM_SERVER_LOCATION,
              defaultValue: kIsWeb ? VALUE_LOCATION_EU : VALUE_LOCATION_LOCAL),
          builder: (context, serverLocation) {
            if (serverLocation == VALUE_LOCATION_USA) {
              intercomFirebaseDatabase = usaFirebaseDatabase;
            } else if (serverLocation == VALUE_LOCATION_EU) {
              intercomFirebaseDatabase = euFirebaseDatabase;
            }

            return ListView(
              children: [
                ListItem(
                  'Видеопульт',
                  () => _validateAndOpenMixerRoute(serverLocation),
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                  'Камера 1',
                  () => _validateAndOpenCameraRoute(serverLocation, 0),
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                  'Камера 2',
                  () => _validateAndOpenCameraRoute(serverLocation, 1),
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                  'Камера 3',
                  () => _validateAndOpenCameraRoute(serverLocation, 2),
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                  'Камера 4',
                  () => _validateAndOpenCameraRoute(serverLocation, 3),
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                  'Камера 5',
                  () => _validateAndOpenCameraRoute(serverLocation, 4),
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                  'Камера 6',
                  () => _validateAndOpenCameraRoute(serverLocation, 5),
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                RadioListTile(
                  value: VALUE_LOCATION_USA,
                  groupValue: serverLocation,
                  onChanged: onLocationChanged,
                  title: Text('United States (us-central1)'),
                ),
                RadioListTile(
                  value: VALUE_LOCATION_EU,
                  groupValue: serverLocation,
                  onChanged: onLocationChanged,
                  title: Text('Belgium (europe-west1)'),
                ),
                RadioListTile(
                  value: VALUE_LOCATION_LOCAL,
                  groupValue: serverLocation,
                  onChanged: kIsWeb ? null : onLocationChanged,
                  title: Text('Локальный сокет'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _socketAddressController,
                    enabled: !kIsWeb && serverLocation == VALUE_LOCATION_LOCAL,
                    decoration: InputDecoration(
                      labelText: 'Адрес сокета',
                      errorText: _isAddressFormatCorrect
                          ? null
                          : 'Неверный формат адреса',
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void onLocationChanged(String? value) {
    if (value != null) {
      preferences.setString(KEY_INTERCOM_SERVER_LOCATION, value);
    }
  }

  void _validateAndOpenMixerRoute(String location) {
    if (location == VALUE_LOCATION_LOCAL) {
      final socketUri = _validateAndGetSocketUri();
      if (socketUri != null) {
        preferences.setString(KEY_INTERCOM_WEB_SOCKET, socketUri.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => mixer2.MixerRoute(
              socketUri: socketUri,
              userName: widget.user?.shortName ?? widget.user?.name,
            ),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MixerRoute(
            user: widget.user,
          ),
        ),
      );
    }
  }

  void _validateAndOpenCameraRoute(String location, int cameraId) {
    if (location == VALUE_LOCATION_LOCAL) {
      final socketUri = _validateAndGetSocketUri();
      if (socketUri != null) {
        preferences.setString(KEY_INTERCOM_WEB_SOCKET, socketUri.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => camera2.CameraRoute(
              id: cameraId,
              socketUri: socketUri,
              userName: widget.user?.shortName ?? widget.user?.name,
            ),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraRoute(
            cameraId + 1,
            user: widget.user,
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

  void _showLocalSocketNotSupportedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          child: RichText(
            text: TextSpan(
              text: 'Эта версия приложения не поддерживает подключение '
                  'через локальный сокет. Чтобы подключиться к нему, '
                  'перейди по ссылке ',
              // style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'http://172.16.51.13:8000/',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse('http://172.16.51.13:8000/'));
                    },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
