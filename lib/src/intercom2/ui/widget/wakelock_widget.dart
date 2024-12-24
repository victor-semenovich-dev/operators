import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WakelockWidget extends StatefulWidget {
  final Widget child;

  const WakelockWidget({super.key, required this.child});

  @override
  State<StatefulWidget> createState() {
    return _WakelockWidgetState();
  }
}

class _WakelockWidgetState extends State<WakelockWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      WakelockPlus.disable();
    }
    if (state == AppLifecycleState.resumed) {
      WakelockPlus.enable();
    }
  }
}
