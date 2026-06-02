import 'package:flutter/material.dart';
import 'package:operators/src/data/util/platform_utils.dart'
    if (dart.library.html) 'package:operators/src/data/util/platform_utils_web.dart';

class AdvancedSafeArea extends StatelessWidget {
  final Widget child;
  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;

  const AdvancedSafeArea({
    super.key,
    required this.child,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      maintainBottomViewPadding: maintainBottomViewPadding,
      minimum: isPwaStandalone()
          ? minimum + const EdgeInsets.only(bottom: 48)
          : minimum,
      child: child,
    );
  }
}
