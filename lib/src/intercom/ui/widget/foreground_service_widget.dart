import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ForegroundServiceWidget extends StatelessWidget {
  final Widget child;

  const ForegroundServiceWidget({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return child;
    } else {
      return WillStartForegroundTask(
        onWillStart: () async => true,
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'foreground_service_channel_id',
          channelName: 'Работа в фоне',
          iconData: const NotificationIconData(
            resType: ResourceType.drawable,
            resPrefix: ResourcePrefix.ic,
            name: 'info_24dp',
          ),
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: false,
          playSound: false,
        ),
        notificationTitle: 'Интерком',
        notificationText: 'Приложение работает в фоновом режиме',
        foregroundTaskOptions: const ForegroundTaskOptions(
          allowWifiLock: true,
        ),
        child: child,
      );
    }
  }
}
