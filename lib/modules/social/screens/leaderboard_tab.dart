import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/social_models.dart';
import '../services/social_service.dart';
import '../widgets/social_widgets.dart';

/// Tab "Peringkat": leaderboard CO2 dengan pilihan lingkup Teman / Kampus / Nasional.
///
/// Alur: pilih lingkup (event) -> _load() memanggil API secara asinkron -> FutureBuilder
/// menampilkan loading / error / daftar peringkat dari JSON.
class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({super.key});

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  static const _scopes = {'friends': 'Teman', 'campus': 'Kampus', 'national': 'Nasional'};

  late final SocialService _service;
  String _tab = 'national';
  late Future<LeaderboardData> _future;

  @override
  void initState() {
    super.initState();
    // context.read -> ambil CookieRequest yang dibagikan lewat Provider di main.dart.
    _service = SocialService(context.read<CookieRequest>());
    _future = _service.fetchLeaderboard(_tab);
  }

  /// Muat ulang data; dipanggil saat ganti lingkup atau tarik-untuk-refresh.
  Future<void> _load() async {
    final future = _service.fetchLeaderboard(_tab);
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {
      // Error sudah ditampilkan oleh FutureBuilder; di sini cukup mengakhiri animasi refresh.
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Widget input: pilihan lingkup peringkat.
          SegmentedButton<String>(
            segments: [
              for (final entry in _scopes.entries)
                ButtonSegment(value: entry.key, label: Text(entry.value)),
            ],
            selected: {_tab},
            onSelectionChanged: (selection) {
              _tab = selection.first;
              _load();
            },
          ),
          const SizedBox(height: 12),
          FutureBuilder<LeaderboardData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return StateMessage(
                  icon: Icons.cloud_off,
                  title: 'Gagal memuat peringkat',
                  message: snapshot.error.toString(),
                  actionLabel: 'Coba lagi',
                  onAction: _load,
                );
              }
              return _LeaderboardBody(data: snapshot.data!, onSwitchToNational: () {
                setState(() => _tab = 'national');
                _load();
              });
            },
          ),
        ],
      ),
    );
  }
}

class _LeaderboardBody extends StatelessWidget {
  final LeaderboardData data;
  final VoidCallback onSwitchToNational;

  const _LeaderboardBody({required this.data, required this.onSwitchToNational});

  @override
  Widget build(BuildContext context) {
    // Pesan khusus kalau daftar kosong karena suatu alasan (lihat `reason` di api_views.py).
    switch (data.reason) {
      case 'login':
        return StateMessage(
          icon: Icons.lock_outline,
          title: 'Masuk dulu',
          message: 'Peringkat teman dan kampus hanya bisa dilihat setelah kamu masuk.',
          actionLabel: 'Lihat peringkat nasional',
          onAction: onSwitchToNational,
        );
      case 'campus':
        return const StateMessage(
          icon: Icons.school_outlined,
          title: 'Kamu belum memilih kampus',
          message: 'Pilih kampusmu di tab Campus War untuk melihat peringkat kampus.',
        );
      case 'no_friends':
        return const StateMessage(
          icon: Icons.group_add_outlined,
          title: 'Belum ada teman',
          message: 'Tambahkan teman di tab Teman untuk bersaing bersama.',
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Diurutkan dari rata-rata gram CO₂ per scan paling kecil. '
              'Minimal ${data.minScans} scan untuk masuk peringkat.'
              '${data.scansNeeded > 0 && data.myScans > 0 ? '\nKamu butuh ${data.scansNeeded} scan lagi.' : ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (data.results.isEmpty)
          const StateMessage(
            icon: Icons.emoji_events_outlined,
            title: 'Belum ada peringkat',
            message: 'Belum ada pengguna dengan scan yang cukup.',
          ),
        for (final entry in data.results) ...[
          if (entry.gap)
            const Center(child: Text('⋯', style: TextStyle(fontSize: 20, color: Colors.grey))),
          _RankTile(entry: entry),
        ],
      ],
    );
  }
}

class _RankTile extends StatelessWidget {
  final LeaderboardEntry entry;

  const _RankTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      // Baris milik user yang login diberi warna latar berbeda.
      color: entry.isMe ? scheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: RankBadge(pos: entry.pos),
        title: Text(entry.isMe ? '${entry.username} (kamu)' : entry.username,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${entry.campus ?? 'Belum pilih kampus'} • ${entry.scans} scan • ${entry.totalKg} kg CO₂',
        ),
        trailing: Co2Chip(grams: entry.avgCo2),
      ),
    );
  }
}
