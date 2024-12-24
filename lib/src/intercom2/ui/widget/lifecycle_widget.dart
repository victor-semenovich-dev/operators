import 'package:flutter/material.dart';

class LifecycleWidget extends StatefulWidget {
  final Widget child;
  final Function(AppLifecycleState state) onLifecycleStateChanged;

  const LifecycleWidget({
    super.key,
    required this.child,
    required this.onLifecycleStateChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return _LifecycleWidgetState();
  }
}

class _LifecycleWidgetState extends State<LifecycleWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.onLifecycleStateChanged(state);
  }
}
