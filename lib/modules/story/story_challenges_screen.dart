import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'models/story_models.dart';
import 'services/story_service.dart';
import 'widgets/story_async_view.dart';

class StoryChallengesScreen extends StatelessWidget {
  const StoryChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text('Duel 1v1')),
      body: StoryAsyncView<List<StoryDuel>>(
        key: ObjectKey(request),
        load: StoryService(request).fetchDuels,
        children: (context, duels) => [
          if (duels.isEmpty)
            const StoryMessage(
              icon: Icons.people_outline,
              title: 'Belum ada duel',
              message: 'Duel yang Anda ikuti akan muncul di sini.',
            ),
          for (final duel in duels) _DuelCard(duel: duel),
        ],
      ),
    );
  }
}

class _DuelCard extends StatelessWidget {
  final StoryDuel duel;

  const _DuelCard({required this.duel});

  String _score(DuelScore value) => duel.metric == 'most_scans'
      ? '${value.count} scan'
      : '${value.co2.toStringAsFixed(1)} g CO₂ · ${value.count} scan';

  @override
  Widget build(BuildContext context) {
    final status = switch (duel.status) {
      'pending' => 'Menunggu',
      'active' => 'Berlangsung',
      'finished' => 'Selesai',
      _ => duel.status,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${duel.challenger} vs ${duel.opponent}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('$status · ${duel.durationDays} hari'),
            Text(
              duel.metric == 'most_scans'
                  ? 'Scan terbanyak'
                  : 'Emisi CO₂ terendah',
            ),
            if (duel.endsAt != null)
              Text(
                'Batas waktu: ${MaterialLocalizations.of(context).formatMediumDate(duel.endsAt!.toLocal())}',
              ),
            if (duel.error.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(duel.error),
            ] else if (duel.status != 'pending') ...[
              const SizedBox(height: 12),
              if (duel.challengerScore case final score?)
                Text('${duel.challenger}: ${_score(score)}'),
              if (duel.opponentScore case final score?)
                Text('${duel.opponent}: ${_score(score)}'),
              if (duel.status == 'finished')
                Text(
                  duel.winner == null
                      ? 'Hasil seri'
                      : 'Pemenang: ${duel.winner}',
                ),
            ],
          ],
        ),
      ),
    );
  }
}
