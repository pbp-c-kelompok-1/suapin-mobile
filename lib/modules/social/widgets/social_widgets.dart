import 'package:flutter/material.dart';

/// Warna status karbon, sama dengan situs web (scanner.services.get_carbon_status):
/// <= 600 g hijau, <= 1200 g kuning, > 1200 g merah.
Color carbonColor(int grams) {
  if (grams <= 600) return const Color(0xFF16A34A);
  if (grams <= 1200) return const Color(0xFFF5A623);
  return const Color(0xFFEB4848);
}

/// Pesan di tengah layar untuk keadaan kosong / error / belum login, dengan tombol opsional.
class StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

/// Lingkaran nomor peringkat; 3 besar diberi warna emas / perak / perunggu.
class RankBadge extends StatelessWidget {
  final int? pos;

  const RankBadge({super.key, required this.pos});

  @override
  Widget build(BuildContext context) {
    const medals = {1: Color(0xFFF5B301), 2: Color(0xFF9AA5B1), 3: Color(0xFFCD7F32)};
    final color = medals[pos] ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final isMedal = medals.containsKey(pos);
    return CircleAvatar(
      radius: 18,
      backgroundColor: color,
      child: Text(
        pos == null ? '–' : '$pos',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isMedal ? Colors.white : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

/// Label kecil "420 g/scan" berwarna sesuai status karbon.
class Co2Chip extends StatelessWidget {
  final int grams;
  final String suffix;

  const Co2Chip({super.key, required this.grams, this.suffix = 'g/scan'});

  @override
  Widget build(BuildContext context) {
    final color = carbonColor(grams);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$grams $suffix',
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

/// Tampilkan pesan singkat di bawah layar (hasil aksi kirim / terima / hapus, dll).
void showSocialSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade700 : null,
    ));
}
