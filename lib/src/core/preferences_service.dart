import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;
  final Map<String, ValueNotifier<dynamic>> _notifiers = {};

  PreferencesService(this._prefs);

  static Future<PreferencesService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  ValueListenable<T> getListenable<T>(String key, T defaultValue) {
    if (!_notifiers.containsKey(key)) {
      _notifiers[key] = ValueNotifier<T>(_getValueFromPrefs(key, defaultValue));
    }
    return _notifiers[key] as ValueListenable<T>;
  }

  T _getValueFromPrefs<T>(String key, T defaultValue) {
    if (T == String) return (_prefs.getString(key) ?? defaultValue) as T;
    if (T == bool) return (_prefs.getBool(key) ?? defaultValue) as T;
    if (T == int) return (_prefs.getInt(key) ?? defaultValue) as T;
    if (T == double) return (_prefs.getDouble(key) ?? defaultValue) as T;
    if (T == List<String>)
      return (_prefs.getStringList(key) ?? defaultValue) as T;
    return defaultValue;
  }

  T getValue<T>(String key, T defaultValue) {
    if (_notifiers.containsKey(key)) {
      return _notifiers[key]!.value as T;
    }
    return _getValueFromPrefs(key, defaultValue);
  }

  Future<void> setValue<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }

    if (_notifiers.containsKey(key)) {
      _notifiers[key]!.value = value;
    }
  }

  // Compatibility methods to match streaming_shared_preferences API
  PreferenceWrapper<String> getString(String key,
          {required String defaultValue}) =>
      PreferenceWrapper<String>(getListenable<String>(key, defaultValue));

  PreferenceWrapper<bool> getBool(String key, {required bool defaultValue}) =>
      PreferenceWrapper<bool>(getListenable<bool>(key, defaultValue));

  Future<void> setString(String key, String value) =>
      setValue<String>(key, value);

  Future<void> setBool(String key, bool value) => setValue<bool>(key, value);
}

class PreferenceWrapper<T> extends StreamView<T> implements ValueListenable<T> {
  final ValueListenable<T> listenable;

  PreferenceWrapper(this.listenable) : super(_createStream(listenable));

  static Stream<T> _createStream<T>(ValueListenable<T> listenable) {
    late StreamController<T> controller;

    void listener() {
      controller.add(listenable.value);
    }

    controller = StreamController<T>(
      onListen: () {
        listenable.addListener(listener);
        controller.add(listenable.value);
      },
      onCancel: () {
        listenable.removeListener(listener);
      },
    );

    return controller.stream;
  }

  T getValue() => listenable.value;

  @override
  void addListener(VoidCallback listener) => listenable.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      listenable.removeListener(listener);

  @override
  T get value => listenable.value;
}
