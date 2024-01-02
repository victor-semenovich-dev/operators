import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../widget/list_item.dart';
import 'camera_route.dart';
import 'mixer_route.dart';

class IntercomRoute extends StatelessWidget {
  const IntercomRoute({Key? key}) : super(key: key);

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
              () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MixerRoute()),
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
                        builder: (context) => const CameraRoute(1)),
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
                        builder: (context) => const CameraRoute(2)),
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
                        builder: (context) => const CameraRoute(3)),
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
                        builder: (context) => const CameraRoute(4)),
                  )),
          const Divider(
            color: Colors.black,
            height: 1,
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final info = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${info.version} (${info.buildNumber})'),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
