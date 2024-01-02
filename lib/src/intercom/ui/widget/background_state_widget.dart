import 'package:flutter/material.dart';

class BackgroundStateWidget extends StatefulWidget {
  final Function(bool) onBackgroundStateChanged;
  final Widget child;

  const BackgroundStateWidget({
    required this.onBackgroundStateChanged,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<BackgroundStateWidget> createState() => _BackgroundStateWidgetState();
}

class _BackgroundStateWidgetState extends State<BackgroundStateWidget>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('state - $state');
    if (state == AppLifecycleState.paused) {
      widget.onBackgroundStateChanged(true);
    }
    if (state == AppLifecycleState.resumed) {
      widget.onBackgroundStateChanged(false);
    }
  }
}
