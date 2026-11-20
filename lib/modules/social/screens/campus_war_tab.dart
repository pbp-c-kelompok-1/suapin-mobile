import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/social_models.dart';
import '../services/social_service.dart';
import '../widgets/social_widgets.dart';

/// Tab "Campus War": peringkat kampus bulan ini + tombol untuk memilih kampus sendiri.
class CampusWarTab extends StatefulWidget {
  const CampusWarTab({super.key});

  @override
  State<CampusWarTab> createState() => _CampusWarTabState();
}

class _CampusWarTabState extends State<CampusWarTab> {
  late final SocialService _service;
  late Future<CampusWarData> _future;

  @override
  void initState() {
    super.initState();
    _service = SocialService(context.read<CookieRequest>());
    _future = _service.fetchCampusWar();
  }

  Future<void> _load() async {
    final future = _service.fetchCampusWar();
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {}
  }

  /// Event tombol "Pilih kampus": ambil daftar kampus, tampilkan bottom sheet, lalu kirim POST.
  Future<void> _chooseCampus(University? current) async {
    final List<University> universities;
    try {
      universities = await _service.fetchUniversities();
    } on SocialApiException catch (e) {
      if (mounted) showSocialSnack(context, e.message, error: true);
      return;
    }
    if (!mounted) return;

    final picked = await showModalBottomSheet<University>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(title: Text('Pilih kampus kamu', style: TextStyle(fontWeight: FontWeight.bold))),
            for (final uni in universities)
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(uni.shortName),
                subtitle: Text(uni.name),
                trailing: uni.id == current?.id ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(sheetContext, uni),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;

    try {
      final result = await _service.chooseCampus(picked.id);
      if (!mounted) return;
      showSocialSnack(context, result.message, error: !result.ok);
      if (result.ok) _load();
    } on SocialApiException catch (e) {
      if (mounted) showSocialSnack(context, e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: FutureBuilder<CampusWarData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ListView(children: [
              StateMessage(
                icon: Icons.cloud_off,
                title: 'Gagal memuat Campus War',
                message: snapshot.error.toString(),
                actionLabel: 'Coba lagi',
                onAction: _load,
              ),
            ]);
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                child: ListTile(
                  leading: const Icon(Icons.school),
                  title: Text('Kampusmu: ${data.myCampus?.shortName ?? 'belum dipilih'}'),
                  subtitle: Text(
                    'Rata-rata gram CO₂ per scan bulan ini (sejak ${data.periodStart}). '
                    'Kampus butuh minimal ${data.minScans} scan.',
                  ),
                  trailing: TextButton(
                    onPressed: () => _chooseCampus(data.myCampus),
                    child: const Text('Pilih'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final campus in data.results) _CampusTile(campus: campus, minScans: data.minScans),
            ],
          );
        },
      ),
    );
  }
}

class _CampusTile extends StatelessWidget {
  final CampusRank campus;
  final int minScans;

  const _CampusTile({required this.campus, required this.minScans});

  @override
  Widget build(BuildContext context) {
    final ranked = campus.pos != null;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: RankBadge(pos: campus.pos),
        title: Text(campus.shortName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          ranked
              ? '${campus.activeMembers} aktif dari ${campus.memberCount} anggota • ${campus.scans} scan'
              : 'Belum masuk peringkat • butuh ${minScans - campus.scans} scan lagi',
        ),
        trailing: ranked ? Co2Chip(grams: campus.avgCo2!) : null,
      ),
    );
  }
}
