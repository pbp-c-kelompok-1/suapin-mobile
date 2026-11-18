// Test pengolahan JSON modul Social (tanpa internet).
// Contoh JSON di bawah sama bentuknya dengan respons API /social/api/... di repo web.
// Jalankan: flutter test test/social_models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:suapin_mobile/modules/social/models/social_models.dart';

void main() {
  test('LeaderboardData membaca baris peringkat dari JSON', () {
    final data = LeaderboardData.fromJson({
      'tab': 'national',
      'tabs': [],
      'min_scans': 3,
      'my_scans': 1,
      'scans_needed': 2,
      'reason': '',
      'results': [
        {'pos': 1, 'username': 'nami', 'campus': 'UI', 'scans': 3, 'avg_co2': 300,
         'total_kg': 0.9, 'is_me': false, 'gap': false},
        {'pos': 7, 'username': 'iqbal', 'campus': null, 'scans': 4, 'avg_co2': 812,
         'total_kg': 3, 'is_me': true, 'gap': true},
      ],
    });
    expect(data.results.length, 2);
    expect(data.results.first.username, 'nami');
    expect(data.results.last.campus, isNull);
    expect(data.results.last.totalKg, 3.0); // angka bulat dari JSON tetap jadi double
    expect(data.results.last.isMe && data.results.last.gap, isTrue);
    expect(data.scansNeeded, 2);
  });

  test('CampusWarData: kampus yang belum masuk peringkat punya pos null', () {
    final data = CampusWarData.fromJson({
      'period_start': '2026-11-01',
      'min_scans': 3,
      'my_campus': {'id': 1, 'name': 'Universitas Indonesia', 'short_name': 'UI', 'city': 'Depok'},
      'results': [
        {'id': 1, 'name': 'Universitas Indonesia', 'short_name': 'UI', 'city': 'Depok', 'pos': 1,
         'avg_co2': 450, 'scans': 6, 'active_members': 2, 'member_count': 2, 'total_kg': 2.7},
        {'id': 2, 'name': 'Institut Teknologi Bandung', 'short_name': 'ITB', 'city': 'Bandung',
         'pos': null, 'avg_co2': null, 'scans': 0, 'active_members': 0, 'member_count': 0, 'total_kg': 0},
      ],
    });
    expect(data.myCampus?.shortName, 'UI');
    expect(data.results[0].pos, 1);
    expect(data.results[1].pos, isNull);
    expect(data.results[1].avgCo2, isNull);
  });

  test('FriendsData membaca teman, permintaan, dan hasil pencarian', () {
    final data = FriendsData.fromJson({
      'q': 'a',
      'friends': [
        {'user': {'id': 2, 'username': 'nami', 'campus': 'UI'}, 'xp': 120, 'friendship_id': 5},
      ],
      'incoming': [
        {'id': 9, 'user': {'id': 3, 'username': 'acan', 'campus': null}, 'status': 'pending',
         'created_at': '2026-11-18T10:00:00+07:00'},
      ],
      'outgoing': [],
      'results': [
        {'user': {'id': 3, 'username': 'acan', 'campus': null}, 'status': 'received', 'friendship_id': 9},
      ],
    });
    expect(data.friends.single.friendshipId, 5);
    expect(data.incoming.single.user.username, 'acan');
    expect(data.outgoing, isEmpty);
    expect(data.results.single.status, 'received');
  });
}
