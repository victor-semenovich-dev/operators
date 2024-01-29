import 'package:flutter/material.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../../main.dart';
import '../widget/list_item.dart';
import 'camera_route.dart';
import 'mixer_route.dart';

const KEY_INTERCOM_SERVER_LOCATION = "intercom_server_location";
const VALUE_LOCATION_USA = "usa";
const VALUE_LOCATION_EU = "eu";

class IntercomRoute extends StatelessWidget {
  final TableUser? user;

  const IntercomRoute({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбери роль'),
      ),
      body: PreferenceBuilder<String>(
          preference: preferences.getString(KEY_INTERCOM_SERVER_LOCATION,
              defaultValue: VALUE_LOCATION_USA),
          builder: (context, serverLocation) {
            return ListView(
              children: [
                ListItem(
                    'Видеопульт',
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MixerRoute(
                              user: user,
                            ),
                          ),
                        )),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                    'Камера 1',
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraRoute(
                              1,
                              user: user,
                            ),
                          ),
                        )),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                    'Камера 2',
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraRoute(
                              2,
                              user: user,
                            ),
                          ),
                        )),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                    'Камера 3',
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraRoute(
                              3,
                              user: user,
                            ),
                          ),
                        )),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                ListItem(
                    'Камера 4',
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraRoute(
                              4,
                              user: user,
                            ),
                          ),
                        )),
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
}
