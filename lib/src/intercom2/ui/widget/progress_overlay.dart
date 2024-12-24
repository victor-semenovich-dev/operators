import 'package:flutter/material.dart';

class ProgressOverlay extends StatelessWidget {
  const ProgressOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white70,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
