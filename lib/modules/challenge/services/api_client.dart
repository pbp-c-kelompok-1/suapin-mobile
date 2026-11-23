import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../../social/social_config.dart';
import '../models/quest.dart';

/// Penghubung ke web app Django (modul challenge).
/// Pake CookieRequest yang sama dengan modul lain, jadi login sessionid ikut terkirim.
class ApiClient {
  final CookieRequest request;

  const ApiClient(this.request);

  String _url(String path) => '${SocialConfig.baseUrl}/challenge/$path';

  Future<DailyData> fetchDaily() async {
    final dynamic res = await request.get(_url('api/daily/'));
    if (res is! Map<String, dynamic>) {
      throw Exception('Format data dari server tidak dikenali.');
    }
    return DailyData.fromJson(res);
  }

  Future<void> claimQuest(String questId) async {
    final dynamic res = await request.postJson(
      _url('claim-quest/'),
      jsonEncode({'quest_id': questId}),
    );
    if (res is Map && res['ok'] == true) return;
    throw Exception(res is Map ? (res['message'] ?? 'Gagal klaim.') : 'Gagal klaim.');
  }
}