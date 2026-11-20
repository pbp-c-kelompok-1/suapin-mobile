import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'models/story_models.dart';
import 'services/story_service.dart';
import 'story_challenges_screen.dart';
import 'story_detail_screen.dart';
import 'widgets/story_async_view.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Progression'),
        actions: [
          IconButton(
            tooltip: 'Duel 1v1',
            icon: const Icon(Icons.people_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const StoryChallengesScreen(),
              ),
            ),
          ),
        ],
      ),
      body: StoryAsyncView<StoryCatalog>(
        key: ObjectKey(request),
        load: StoryService(request).fetchComics,
        children: (context, catalog) => [
          Text(
            'Komik Suap.in',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Level ${catalog.userLevel} · Buka cerita seiring kenaikan levelmu.',
          ),
          const SizedBox(height: 16),
          if (catalog.comics.isEmpty)
            const StoryMessage(
              icon: Icons.auto_stories_outlined,
              title: 'Belum ada cerita',
              message: 'Cerita yang sudah terbit akan muncul di sini.',
            ),
          for (final comic in catalog.comics)
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: ListTile(
                enabled: comic.isUnlocked,
                isThreeLine: true,
                contentPadding: const EdgeInsets.all(16),
                leading: Icon(
                  comic.isUnlocked
                      ? Icons.auto_stories_outlined
                      : Icons.lock_outline,
                ),
                title: Text('Bab ${comic.bab}: ${comic.title}'),
                subtitle: Text(
                  [
                    if (comic.description.isNotEmpty) comic.description,
                    '${comic.pageCount} halaman · ${comic.isUnlocked ? 'Terbuka' : 'Terbuka di Level ${comic.unlockLevel}'}',
                  ].join('\n'),
                ),
                trailing: Icon(
                  comic.isUnlocked ? Icons.chevron_right : Icons.lock_outline,
                ),
                onTap: comic.isUnlocked
                    ? () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => StoryDetailScreen(
                            bab: comic.bab,
                            title: comic.title,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
