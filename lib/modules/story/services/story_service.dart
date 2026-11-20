import 'dart:async';

import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/story_models.dart';
import '../story_config.dart';

class StoryApiException implements Exception {
  final String message;
  final bool needsLogin;

  const StoryApiException(this.message, {this.needsLogin = false});

  @override
  String toString() => message;
}

class StoryService {
  final CookieRequest request;

  const StoryService(this.request);

  Future<T> _fetch<T>(
    String path,
    T Function(Map<String, dynamic>) decode,
  ) async {
    try {
      final dynamic body = await request
          .get(StoryConfig.api(path))
          .timeout(const Duration(seconds: 15));
      if (body is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      final detail = body['detail'];
      if (detail != null) {
        final message = detail.toString();
        final lower = message.toLowerCase();
        final needsLogin =
            lower.contains('authentication') ||
            lower.contains('autentikasi') ||
            lower.contains('kredensial') ||
            lower.contains('not authenticated');
        if (needsLogin) {
          throw const StoryApiException(
            'Sesi login belum tersedia atau sudah berakhir. '
            'Masuk ke akun Anda, lalu coba lagi.',
            needsLogin: true,
          );
        }
        throw StoryApiException(message);
      }
      return decode(body);
    } on StoryApiException {
      rethrow;
    } on TimeoutException {
      throw const StoryApiException(
        'Server terlalu lama merespons. Silakan coba lagi.',
      );
    } on FormatException {
      throw const StoryApiException(
        'Data Story dari server belum tersedia dalam format yang sesuai.',
      );
    } on TypeError {
      throw const StoryApiException(
        'Format data Story dari server tidak sesuai.',
      );
    } catch (_) {
      throw const StoryApiException(
        'Tidak dapat menghubungi server. Periksa koneksi, lalu coba lagi.',
      );
    }
  }

  Future<StoryCatalog> fetchComics() =>
      _fetch('comics/', StoryCatalog.fromJson);

  Future<StoryDetail> fetchChapter(int bab) =>
      _fetch('comics/$bab/', StoryDetail.fromJson);

  Future<List<StoryDuel>> fetchDuels() => _fetch(
    'challenges/',
    (json) => (json['challenges'] as List)
        .map((duel) => StoryDuel.fromJson(duel as Map<String, dynamic>))
        .toList(),
  );
}
