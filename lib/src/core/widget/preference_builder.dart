import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PreferenceBuilder<T> extends StatelessWidget {
  final ValueListenable<T> preference;
  final Widget Function(BuildContext context, T value) builder;

  const PreferenceBuilder({
    super.key,
    required this.preference,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: preference,
      builder: (context, value, _) => builder(context, value),
    );
  }
}
