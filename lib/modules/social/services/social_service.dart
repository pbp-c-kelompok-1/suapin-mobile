import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/social_models.dart';
import '../social_config.dart';

/// Error dari API Social yang pesannya aman ditampilkan ke user.
class SocialApiException implements Exception {
  final String message;
  final bool needsLogin; // true -> server membalas "belum login" (403 dari DRF)

  const SocialApiException(this.message, {this.needsLogin = false});

  @override
  String toString() => message;
}

/// Semua pemanggilan asinkron ke web service Django modul Social ada di sini.
///
/// Memakai CookieRequest (pbp_django_auth) yang sama dengan modul Autentikasi, jadi setelah
/// user login, cookie `sessionid` ikut terkirim otomatis dan server tahu siapa user-nya.
/// Halaman (screen) tidak memanggil URL langsung, cukup memanggil method di class ini.
class SocialService {
  final CookieRequest request;

  const SocialService(this.request);

  // ---------- Helper ----------

  /// GET lalu pastikan hasilnya Map JSON. CookieRequest.get sudah melakukan jsonDecode.
  /// loginRequired: endpoint ini wajib login, jadi balasan {"detail": ...} berarti belum login.
  Future<Map<String, dynamic>> _getMap(String path, {bool loginRequired = false}) async {
    final dynamic body = await _send(() => request.get(SocialConfig.api(path)));
    if (body is Map<String, dynamic>) {
      _throwIfDenied(body, loginRequired);
      return body;
    }
    throw const SocialApiException('Format data dari server tidak dikenali.');
  }

  /// POST JSON untuk aksi (kirim / terima / tolak / hapus / pilih kampus).
  Future<ActionResult> _postAction(
    String path, {
    Map<String, dynamic> data = const {},
    bool loginRequired = false,
  }) async {
    final dynamic body = await _send(
      () => request.postJson(SocialConfig.api(path), jsonEncode(data)),
    );
    if (body is! Map<String, dynamic>) {
      throw const SocialApiException('Format data dari server tidak dikenali.');
    }
    _throwIfDenied(body, loginRequired);
    return ActionResult(body['ok'] == true, (body['message'] ?? 'Terjadi kesalahan.').toString());
  }

  /// Bungkus pemanggilan jaringan: server mati / balasan bukan JSON -> pesan yang jelas.
  Future<dynamic> _send(Future<dynamic> Function() call) async {
    try {
      return await call();
    } on SocialApiException {
      rethrow;
    } catch (_) {
      throw SocialApiException(
        'Tidak bisa terhubung ke server (${SocialConfig.baseUrl}). Pastikan Django sudah jalan.',
      );
    }
  }

  /// Error bawaan DRF berbentuk {"detail": "..."}: 403 belum login, atau 404 data tidak ada.
  /// Balasan buatan kita sendiri selalu punya key "ok", jadi tidak ikut ditangani di sini.
  void _throwIfDenied(Map<String, dynamic> body, bool loginRequired) {
    final detail = body['detail'];
    if (detail == null || body.containsKey('ok')) return;
    if (loginRequired) {
      throw const SocialApiException('Masuk dulu untuk membuka fitur ini.', needsLogin: true);
    }
    throw SocialApiException(detail.toString());
  }

  // ---------- Leaderboard & Campus War ----------

  /// tab: 'friends' | 'campus' | 'national'
  Future<LeaderboardData> fetchLeaderboard(String tab) async =>
      LeaderboardData.fromJson(await _getMap('leaderboard/?tab=$tab'));

  Future<CampusWarData> fetchCampusWar() async =>
      CampusWarData.fromJson(await _getMap('campus-war/'));

  Future<List<University>> fetchUniversities() async {
    final dynamic body = await _send(() => request.get(SocialConfig.api('universities/')));
    if (body is! List) throw const SocialApiException('Gagal memuat daftar kampus.');
    return body.map((row) => University.fromJson(row as Map<String, dynamic>)).toList();
  }

  Future<ActionResult> chooseCampus(int universityId) =>
      _postAction('campus/', data: {'university': universityId}, loginRequired: true);

  // ---------- Teman ----------

  Future<FriendsData> fetchFriends({String query = ''}) async =>
      FriendsData.fromJson(
        await _getMap('friends/?q=${Uri.encodeQueryComponent(query)}', loginRequired: true),
      );

  Future<ActionResult> sendRequest(String username) =>
      _postAction('friends/request/', data: {'username': username}, loginRequired: true);

  Future<ActionResult> respond(int friendshipId, {required bool accept}) =>
      _postAction('friends/$friendshipId/respond/', data: {'action': accept ? 'accept' : 'reject'});

  Future<ActionResult> removeFriendship(int friendshipId) =>
      _postAction('friends/$friendshipId/delete/');
}
