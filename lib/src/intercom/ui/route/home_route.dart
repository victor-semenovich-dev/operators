import 'package:flutter/material.dart';
import 'package:operators/src/data/model/user.dart';

import '../widget/list_item.dart';
import 'camera_route.dart';
import 'mixer_route.dart';

class IntercomRoute extends StatelessWidget {
  final TableUser? user;

  const IntercomRoute({Key? key, required this.user}) : super(key: key);

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
        ],
      ),
    );
  }
}
