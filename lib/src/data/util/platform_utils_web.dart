// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js_util' as js_util;

bool isPwaStandalone() {
  // Проверка стандартного медиа-запроса (Android/Desktop)
  final isStandalone =
      html.window.matchMedia('(display-mode: standalone)').matches == true;

  // Безопасная проверка свойства 'standalone' для iOS Safari
  final navigator = html.window.navigator;
  bool isIosStandalone = false;
  if (js_util.hasProperty(navigator, 'standalone')) {
    isIosStandalone = js_util.getProperty(navigator, 'standalone') == true;
  }

  return isStandalone || isIosStandalone;
}
