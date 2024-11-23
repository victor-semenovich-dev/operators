import 'package:flutter/material.dart';

class FlashWrapper extends StatelessWidget {
  final Widget child;

  const FlashWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(builder: (context) {
          return child;
        }),
      ],
    );
  }
}
