import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/social_models.dart';
import '../services/social_service.dart';
import '../widgets/social_widgets.dart';

/// Tab "Teman": cari user, kirim / terima / tolak permintaan, dan hapus teman.
///
/// Semua aksi memanggil API POST lalu memuat ulang daftar dari server, jadi tampilan selalu
/// sama dengan data di database (dan dengan halaman Teman di situs web).
class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  late final SocialService _service;
  final _searchController = TextEditingController();
  late Future<FriendsData> _future;
  bool _busy = false; // true selama aksi POST berjalan -> tombol dinonaktifkan (cegah klik ganda)

  @override
  void initState() {
    super.initState();
    _service = SocialService(context.read<CookieRequest>());
    _future = _service.fetchFriends();
  }

  @override
  void dispose() {
    _searchController.dispose(); // controller wajib dibuang supaya tidak bocor memori
    super.dispose();
  }

  Future<void> _load() async {
    final future = _service.fetchFriends(query: _searchController.text.trim());
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {}
  }

  /// Jalankan satu aksi (kirim/terima/tolak/hapus), tampilkan pesannya, lalu muat ulang daftar.
  Future<void> _run(Future<ActionResult> Function() action) async {
    setState(() => _busy = true);
    try {
      final result = await action();
      if (mounted) showSocialSnack(context, result.message, error: !result.ok);
    } on SocialApiException catch (e) {
      if (mounted) showSocialSnack(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (mounted) await _load();
  }

  Future<void> _confirmRemove(FriendItem friend) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus teman?'),
        content: Text('Kamu tidak akan lagi berteman dengan ${friend.user.username}.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (yes == true) await _run(() => _service.removeFriendship(friend.friendshipId));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: FutureBuilder<FriendsData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            final needsLogin = error is SocialApiException && error.needsLogin;
            return ListView(children: [
              StateMessage(
                icon: needsLogin ? Icons.lock_outline : Icons.cloud_off,
                title: needsLogin ? 'Masuk dulu' : 'Gagal memuat teman',
                message: needsLogin
                    ? 'Fitur teman hanya untuk pengguna yang sudah masuk (login).'
                    : error.toString(),
                actionLabel: 'Coba lagi',
                onAction: _load,
              ),
            ]);
          }
          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildContent(FriendsData data) {
    final query = _searchController.text.trim();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Widget input: kolom pencarian username. Event: tekan Enter / ikon cari.
        TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _load(),
          decoration: InputDecoration(
            hintText: 'Cari username…',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _load),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (query.isNotEmpty) ...[
          _SectionTitle('Hasil pencarian "$query"'),
          if (data.results.isEmpty) const Text('Tidak ada user yang cocok.'),
          for (final result in data.results)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _Avatar(result.user.username),
              title: Text(result.user.username),
              subtitle: Text(result.user.campus ?? 'Belum pilih kampus'),
              trailing: _searchAction(result),
            ),
        ],
        if (data.incoming.isNotEmpty) ...[
          _SectionTitle('Permintaan masuk (${data.incoming.length})'),
          for (final request in data.incoming)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _Avatar(request.user.username),
              title: Text(request.user.username),
              subtitle: const Text('ingin berteman denganmu'),
              trailing: Wrap(spacing: 4, children: [
                IconButton.filledTonal(
                  tooltip: 'Tolak',
                  icon: const Icon(Icons.close),
                  onPressed: _busy ? null : () => _run(() => _service.respond(request.id, accept: false)),
                ),
                IconButton.filled(
                  tooltip: 'Terima',
                  icon: const Icon(Icons.check),
                  onPressed: _busy ? null : () => _run(() => _service.respond(request.id, accept: true)),
                ),
              ]),
            ),
        ],
        if (data.outgoing.isNotEmpty) ...[
          _SectionTitle('Permintaan terkirim (${data.outgoing.length})'),
          for (final request in data.outgoing)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _Avatar(request.user.username),
              title: Text(request.user.username),
              subtitle: const Text('menunggu jawaban'),
              trailing: TextButton(
                onPressed: _busy ? null : () => _run(() => _service.removeFriendship(request.id)),
                child: const Text('Batalkan'),
              ),
            ),
        ],
        _SectionTitle('Teman kamu (${data.friends.length})'),
        if (data.friends.isEmpty)
          const Text('Belum ada teman. Cari username di atas untuk menambahkan.'),
        for (final friend in data.friends)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: _Avatar(friend.user.username),
            title: Text(friend.user.username),
            subtitle: Text('${friend.user.campus ?? 'Belum pilih kampus'} • ${friend.xp} XP'),
            trailing: IconButton(
              tooltip: 'Hapus teman',
              icon: const Icon(Icons.person_remove_outlined),
              onPressed: _busy ? null : () => _confirmRemove(friend),
            ),
          ),
      ],
    );
  }

  /// Tombol di hasil pencarian bergantung pada status hubungan (lihat friends.relation_status).
  Widget _searchAction(SearchResult result) {
    switch (result.status) {
      case 'friends':
        return const Chip(label: Text('Teman'));
      case 'sent':
        return const Chip(label: Text('Terkirim'));
      case 'received':
        return FilledButton(
          onPressed: _busy ? null : () => _run(() => _service.respond(result.friendshipId!, accept: true)),
          child: const Text('Terima'),
        );
      default:
        return FilledButton.tonal(
          onPressed: _busy ? null : () => _run(() => _service.sendRequest(result.user.username)),
          child: const Text('Tambah'),
        );
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String username;

  const _Avatar(this.username);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(child: Text(username.isEmpty ? '?' : username[0].toUpperCase()));
  }
}
