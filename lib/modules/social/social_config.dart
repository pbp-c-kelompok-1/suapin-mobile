import 'package:flutter/foundation.dart' show kIsWeb;

/// Alamat server Django (web service) yang dipakai modul Social.
///
/// - Flutter di Chrome (`flutter run -d chrome`)  -> http://localhost:8000
/// - Emulator Android (`flutter run`)             -> http://10.0.2.2:8000
///   (10.0.2.2 adalah alamat laptop dilihat dari dalam emulator)
/// - Mau langsung ke server PWS? Jalankan dengan:
///   flutter run --dart-define=SUAPIN_API=https://syahid-arkan-suapin.pws.cs.ui.ac.id
class SocialConfig {
  static const String _override = String.fromEnvironment('SUAPIN_API');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    return kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
  }

  /// Semua endpoint modul Social diawali /social/api/ (lihat social/urls.py di repo web).
  static String api(String path) => '$baseUrl/social/api/$path';
}
