import 'package:flutter/foundation.dart';

class StoryConfig {
  static const _override = String.fromEnvironment('SUAPIN_API');

  static String get baseUrl {
    if (_override.isNotEmpty) {
      return _override.replaceFirst(RegExp(r'/+$'), '');
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  static String api(String path) => '$baseUrl/story/api/$path';
}
