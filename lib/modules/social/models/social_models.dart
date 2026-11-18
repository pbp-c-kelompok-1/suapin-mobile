// Model Dart untuk JSON dari API Social (Django REST Framework).
//
// Setiap class punya factory `fromJson` yang mengubah Map hasil jsonDecode menjadi objek
// Dart yang type-safe. Nama field JSON mengikuti serializer di social/serializers.py (repo web).

/// Angka dari JSON bisa terbaca int (420) atau double (2.5), jadi diambil sebagai num dulu.
int? _int(dynamic value) => value == null ? null : (value as num).toInt();
double _double(dynamic value) => value == null ? 0.0 : (value as num).toDouble();

/// Ringkasan user: dipakai di daftar teman, permintaan, dan hasil pencarian.
class SocialUser {
  final int id;
  final String username;
  final String? campus; // singkatan kampus, contoh "UI"; null kalau belum memilih kampus

  const SocialUser({required this.id, required this.username, this.campus});

  factory SocialUser.fromJson(Map<String, dynamic> json) => SocialUser(
        id: json['id'] as int,
        username: json['username'] as String,
        campus: json['campus'] as String?,
      );
}

/// Satu baris leaderboard (LeaderboardRowSerializer).
class LeaderboardEntry {
  final int pos;
  final String username;
  final String? campus;
  final int scans;
  final int avgCo2; // rata-rata gram CO2 per scan (nilai yang dipakai untuk peringkat)
  final double totalKg;
  final bool isMe;
  final bool gap; // true -> tampilkan "⋯" di atas baris ini (barisku jauh di bawah 50 besar)

  const LeaderboardEntry({
    required this.pos,
    required this.username,
    required this.campus,
    required this.scans,
    required this.avgCo2,
    required this.totalKg,
    required this.isMe,
    required this.gap,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
        pos: json['pos'] as int,
        username: json['username'] as String,
        campus: json['campus'] as String?,
        scans: json['scans'] as int,
        avgCo2: _int(json['avg_co2']) ?? 0,
        totalKg: _double(json['total_kg']),
        isMe: json['is_me'] as bool? ?? false,
        gap: json['gap'] as bool? ?? false,
      );
}

/// Seluruh respons GET /social/api/leaderboard/.
class LeaderboardData {
  final String tab;
  final int minScans;
  final int myScans;
  final int scansNeeded;
  final String reason; // '' | 'login' | 'campus' | 'no_friends'
  final List<LeaderboardEntry> results;

  const LeaderboardData({
    required this.tab,
    required this.minScans,
    required this.myScans,
    required this.scansNeeded,
    required this.reason,
    required this.results,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) => LeaderboardData(
        tab: json['tab'] as String,
        minScans: json['min_scans'] as int,
        myScans: json['my_scans'] as int,
        scansNeeded: json['scans_needed'] as int,
        reason: json['reason'] as String? ?? '',
        results: (json['results'] as List)
            .map((row) => LeaderboardEntry.fromJson(row as Map<String, dynamic>))
            .toList(),
      );
}

/// Data kampus (UniversitySerializer), dipakai untuk pilihan kampus.
class University {
  final int id;
  final String name;
  final String shortName;
  final String city;

  const University({required this.id, required this.name, required this.shortName, required this.city});

  factory University.fromJson(Map<String, dynamic> json) => University(
        id: json['id'] as int,
        name: json['name'] as String,
        shortName: json['short_name'] as String,
        city: json['city'] as String? ?? '',
      );
}

/// Satu kampus di Campus War (CampusRankSerializer).
class CampusRank {
  final int id;
  final String name;
  final String shortName;
  final int? pos; // null -> belum masuk peringkat (scan kampus masih kurang)
  final int? avgCo2;
  final int scans;
  final int activeMembers;
  final int memberCount;
  final double totalKg;

  const CampusRank({
    required this.id,
    required this.name,
    required this.shortName,
    required this.pos,
    required this.avgCo2,
    required this.scans,
    required this.activeMembers,
    required this.memberCount,
    required this.totalKg,
  });

  factory CampusRank.fromJson(Map<String, dynamic> json) => CampusRank(
        id: json['id'] as int,
        name: json['name'] as String,
        shortName: json['short_name'] as String,
        pos: _int(json['pos']),
        avgCo2: _int(json['avg_co2']),
        scans: _int(json['scans']) ?? 0,
        activeMembers: _int(json['active_members']) ?? 0,
        memberCount: _int(json['member_count']) ?? 0,
        totalKg: _double(json['total_kg']),
      );
}

/// Seluruh respons GET /social/api/campus-war/.
class CampusWarData {
  final String periodStart;
  final int minScans;
  final University? myCampus;
  final List<CampusRank> results;

  const CampusWarData({
    required this.periodStart,
    required this.minScans,
    required this.myCampus,
    required this.results,
  });

  factory CampusWarData.fromJson(Map<String, dynamic> json) => CampusWarData(
        periodStart: json['period_start'] as String,
        minScans: json['min_scans'] as int,
        myCampus: json['my_campus'] == null
            ? null
            : University.fromJson(json['my_campus'] as Map<String, dynamic>),
        results: (json['results'] as List)
            .map((row) => CampusRank.fromJson(row as Map<String, dynamic>))
            .toList(),
      );
}

/// Satu teman (FriendRowSerializer).
class FriendItem {
  final SocialUser user;
  final int xp;
  final int friendshipId; // dipakai untuk tombol "Hapus teman"

  const FriendItem({required this.user, required this.xp, required this.friendshipId});

  factory FriendItem.fromJson(Map<String, dynamic> json) => FriendItem(
        user: SocialUser.fromJson(json['user'] as Map<String, dynamic>),
        xp: _int(json['xp']) ?? 0,
        friendshipId: json['friendship_id'] as int,
      );
}

/// Permintaan teman yang masih menunggu (PendingRequestSerializer).
class PendingRequest {
  final int id; // id Friendship -> dipakai untuk terima / tolak / batal
  final SocialUser user; // "orang satunya"

  const PendingRequest({required this.id, required this.user});

  factory PendingRequest.fromJson(Map<String, dynamic> json) => PendingRequest(
        id: json['id'] as int,
        user: SocialUser.fromJson(json['user'] as Map<String, dynamic>),
      );
}

/// Hasil pencarian user (SearchResultSerializer).
class SearchResult {
  final SocialUser user;
  final String status; // 'none' | 'friends' | 'sent' | 'received'
  final int? friendshipId;

  const SearchResult({required this.user, required this.status, required this.friendshipId});

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        user: SocialUser.fromJson(json['user'] as Map<String, dynamic>),
        status: json['status'] as String,
        friendshipId: json['friendship_id'] as int?,
      );
}

/// Seluruh respons GET /social/api/friends/.
class FriendsData {
  final List<FriendItem> friends;
  final List<PendingRequest> incoming;
  final List<PendingRequest> outgoing;
  final List<SearchResult> results;

  const FriendsData({
    required this.friends,
    required this.incoming,
    required this.outgoing,
    required this.results,
  });

  factory FriendsData.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) parse) =>
        (json[key] as List).map((row) => parse(row as Map<String, dynamic>)).toList();
    return FriendsData(
      friends: list('friends', FriendItem.fromJson),
      incoming: list('incoming', PendingRequest.fromJson),
      outgoing: list('outgoing', PendingRequest.fromJson),
      results: list('results', SearchResult.fromJson),
    );
  }
}

/// Balasan aksi POST: {"ok": true/false, "message": "..."}.
class ActionResult {
  final bool ok;
  final String message;

  const ActionResult(this.ok, this.message);
}
