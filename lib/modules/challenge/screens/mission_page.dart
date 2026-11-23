import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/quest.dart';
import '../services/api_client.dart';

// Warna dari TND Color System (sama dengan versi web).
const _bg = Color(0xFFEAF7F1);
const _teal = Color(0xFF0DA69B);
const _blue = Color(0xFF2F80ED);
const _green = Color(0xFF1EA854);
const _text = Color(0xFF12201D);
const _text2 = Color(0xFF5B6B66);

// Data contoh supaya halaman tetap tampil walau server belum jalan.
const _mockData = DailyData(
  date: '2026-11-18',
  scansToday: 2,
  usedGrams: 1200,
  budgetGrams: 2000,
  quests: [
    Quest(id: 'scan_two', title: 'Scan 2 makanan', desc: 'Simpan minimal 2 hasil scan hari ini.', tone: 'blue', goal: 2, val: 2, xp: 15, done: true, claimed: false, failed: false),
    Quest(id: 'carbon_budget', title: 'Jaga budget karbon', desc: 'Jaga total emisi hari ini agar tidak melebihi budget.', tone: 'green', goal: 1, val: 1, xp: 20, done: true, claimed: true, failed: false),
    Quest(id: 'light_item', title: 'Satu pilihan ringan', desc: 'Catat satu makanan di bawah 150g CO2 hari ini.', tone: 'teal', goal: 1, val: 0, xp: 10, done: false, claimed: false, failed: false),
  ],
);

class MissionPage extends StatefulWidget {
  const MissionPage({super.key});

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  late final ApiClient _api;
  DailyData? _data;
  bool _loading = true;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    _api = ApiClient(context.read<CookieRequest>());
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await _api.fetchDaily();
      if (!mounted) return;
      setState(() {
        _data = d;
        _offline = false;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _data = _mockData;
        _offline = true;
        _loading = false;
      });
    }
  }

  Future<void> _claim(Quest q) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (!_offline) await _api.claimQuest(q.id);
      if (!mounted) return;
      setState(() {
        final d = _data!;
        _data = DailyData(
          date: d.date,
          scansToday: d.scansToday,
          usedGrams: d.usedGrams,
          budgetGrams: d.budgetGrams,
          quests: [
            for (final x in d.quests)
              x.id == q.id ? x.copyWith(claimed: true) : x
          ],
        );
      });
      messenger.showSnackBar(SnackBar(content: Text('+${q.xp} XP diklaim!')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Color _toneColor(String tone) =>
      tone == 'blue' ? _blue : (tone == 'teal' ? _teal : _green);

  @override
  Widget build(BuildContext context) {
    final d = _data;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: _loading || d == null
            ? const Center(child: CircularProgressIndicator(color: _teal))
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_offline) _offlineBanner(),
                    _header(d),
                    const SizedBox(height: 16),
                    _questCard(d),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _offlineBanner() => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3D6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Server belum terhubung, menampilkan data contoh.',
          style: TextStyle(fontSize: 12, color: _text),
        ),
      );

  Widget _header(DailyData d) => Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDeco(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Text('Misi Harian',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: _text)),
                ),
                CircleAvatar(
                  backgroundColor: _teal,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Budget karbon: ${(d.usedGrams / 1000).toStringAsFixed(1)} / '
              '${(d.budgetGrams / 1000).toStringAsFixed(1)} kg CO₂',
              style: const TextStyle(fontSize: 13, color: _text2),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: d.budgetProgress,
                minHeight: 10,
                backgroundColor: const Color(0xFFE4E9E8),
                color: d.budgetProgress >= 1 ? const Color(0xFFEB4848) : _green,
              ),
            ),
          ],
        ),
      );

  Widget _questCard(DailyData d) => Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDeco(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tantangan hari ini',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: _text)),
            const SizedBox(height: 12),
            for (final q in d.quests) _questTile(q),
          ],
        ),
      );

  Widget _questTile(Quest q) {
    final color = _toneColor(q.tone);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E9E8)),
      ),
      child: Row(
        children: [
          Icon(q.done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: _text)),
                const SizedBox(height: 2),
                Text(q.desc,
                    style: const TextStyle(fontSize: 12, color: _text2)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: q.progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE4E9E8),
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (q.claimed)
            const Icon(Icons.verified, color: _green)
          else if (q.done)
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _blue),
              onPressed: () => _claim(q),
              child: Text('+${q.xp} XP'),
            )
          else
            Text('${q.val}/${q.goal}', style: const TextStyle(color: _text2)),
        ],
      ),
    );
  }

  BoxDecoration _cardDeco() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFBFDCCF), blurRadius: 12, offset: Offset(4, 4)),
          BoxShadow(color: Colors.white, blurRadius: 12, offset: Offset(-4, -4)),
        ],
      );

}