import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'models/story_models.dart';
import 'services/story_service.dart';
import 'widgets/story_async_view.dart';

class StoryDetailScreen extends StatelessWidget {
  final int bab;
  final String title;

  const StoryDetailScreen({super.key, required this.bab, required this.title});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: Text('Bab $bab: $title')),
      body: StoryAsyncView<StoryDetail>(
        key: ObjectKey(request),
        load: () => StoryService(request).fetchChapter(bab),
        children: (context, detail) => [
          Text(
            detail.comic.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (detail.comic.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(detail.comic.description),
          ],
          const SizedBox(height: 16),
          if (detail.pages.isEmpty)
            const StoryMessage(
              icon: Icons.menu_book_outlined,
              title: 'Halaman belum tersedia',
              message: 'Bab ini belum memiliki konten untuk dibaca.',
            ),
          for (final page in detail.pages) _StoryPageCard(page: page),
        ],
      ),
    );
  }
}

class _StoryPageCard extends StatelessWidget {
  final StoryPage page;

  const _StoryPageCard({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halaman ${page.position}', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(page.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(page.narration),
            const Divider(height: 32),
            Text(
              page.speakerOne,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(page.dialogueOne),
            const SizedBox(height: 12),
            Text(
              page.speakerTwo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(page.dialogueTwo),
            const Divider(height: 32),
            Text('Pelajaran hari ini', style: theme.textTheme.titleSmall),
            Text(page.takeaway),
            const SizedBox(height: 8),
            Text(
              page.action,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (page.sourceLabel.isNotEmpty || page.sourceUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Sumber: ${page.sourceLabel}',
                style: theme.textTheme.labelMedium,
              ),
              if (page.sourceUrl.isNotEmpty) SelectableText(page.sourceUrl),
            ],
          ],
        ),
      ),
    );
  }
}
