import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quest.dart';

/// Penghubung ke web app Django (DRF).

class ApiClient {
  final String baseUrl;
  final String token;

  ApiClient({String? baseUrl, String? token})
      : baseUrl = baseUrl ??
            const String.fromEnvironment('API_BASE',
                defaultValue: 'http://10.0.2.2:8000'),
        token = token ?? const String.fromEnvironment('API_TOKEN');

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Token $token',
      };

  Future<DailyData> fetchDaily() async {
    final res = await http
        .get(Uri.parse('$baseUrl/api/challenge/daily/'), headers: _headers)
        .timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat misi (HTTP ${res.statusCode})');
    }
    return DailyData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> claimQuest(String questId) async {
    final res = await http
        .post(Uri.parse('$baseUrl/api/challenge/daily/$questId/claim/'),
            headers: _headers)
        .timeout(const Duration(seconds: 8));
    if (res.statusCode != 201) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      throw Exception(body['detail'] ?? 'Gagal klaim (HTTP ${res.statusCode})');
    }
  }
}
