import 'package:flutter/material.dart';

import '../services/story_service.dart';

/// Loading, error/coba lagi, dan pull-to-refresh untuk ketiga halaman Story.
class StoryAsyncView<T> extends StatefulWidget {
  final Future<T> Function() load;
  final List<Widget> Function(BuildContext context, T data) children;

  const StoryAsyncView({super.key, required this.load, required this.children});

  @override
  State<StoryAsyncView<T>> createState() => _StoryAsyncViewState<T>();
}

class _StoryAsyncViewState<T> extends State<StoryAsyncView<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.load();
  }

  Future<void> _reload() async {
    final future = widget.load();
    setState(() {
      _future = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder menampilkan kegagalan beserta tombol coba lagi.
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        final error = snapshot.error;
        final needsLogin = error is StoryApiException && error.needsLogin;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: StoryMessage(
            icon: needsLogin ? Icons.login : Icons.cloud_off_outlined,
            title: needsLogin
                ? 'Masuk untuk membuka Story'
                : 'Story gagal dimuat',
            message: error is StoryApiException
                ? error.message
                : 'Terjadi kesalahan. Silakan coba lagi.',
            onRetry: _reload,
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: widget.children(context, snapshot.data as T),
        ),
      );
    },
  );
}

class StoryMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const StoryMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Column(
      children: [
        Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        if (onRetry != null) ...[
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
          ),
        ],
      ],
    ),
  );
}
