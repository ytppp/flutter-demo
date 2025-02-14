import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String kGuessSpKey = 'guess-config';
const String kMuyuSpKey = 'muyu-config';

class SpStorage {
  SpStorage._(); // 私有化构造

  static SpStorage? _storage;
  SharedPreferences? _sp;

  static SpStorage get instance {
    _storage = _storage ?? SpStorage._();
    return _storage!;
  }

  Future<void> initSpWhenNull() async {
    if (_sp != null) return;
    _sp = _sp ?? await SharedPreferences.getInstance();
  }

  Future<bool> saveGuessConfig({
    required bool guessing,
    required int value,
    required bool isGuessOver
  }) async {
    await initSpWhenNull();
    String content = json.encode({
      'guessing': guessing,
      'value': value,
      'isGuessOver': isGuessOver
    });
    return _sp!.setString(kGuessSpKey, content);
  }

  Future<Map<String, dynamic>> getGuessConfig() async {
    await initSpWhenNull();
    String content = _sp!.getString(kGuessSpKey) ?? "{}";
    return json.decode(content);
  }

  Future<bool> saveMuyuConfig({
    required int counter,
    required int activeImageIndex,
    required int activeAudioIndex
  }) async {
    await initSpWhenNull();
    String content = json.encode({
      'counter': counter,
      'activeImageIndex': activeImageIndex,
      'activeAudioIndex': activeAudioIndex
    });
    return _sp!.setString(kMuyuSpKey, content);
  }

  Future<Map<String, dynamic>> getMuyuConfig() async {
    await initSpWhenNull();
    String content = _sp!.getString(kMuyuSpKey) ?? "{}";
    return json.decode(content);
  }
}