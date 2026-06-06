import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as web;

bool isPwaStandalone() {
  // Проверка стандартного медиа-запроса (Android/Desktop)
  final isStandalone =
      web.window.matchMedia('(display-mode: standalone)').matches;

  // Безопасная проверка свойства 'standalone' для iOS Safari
  final navigator = web.window.navigator;
  bool isIosStandalone = false;
  if (navigator.hasProperty('standalone'.toJS).toDart) {
    isIosStandalone =
        (navigator.getProperty('standalone'.toJS) as JSBoolean).toDart;
  }

  return isStandalone || isIosStandalone;
}
