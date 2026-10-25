import 'package:flutter/material.dart';

/// Tampilan kondisi LOADING: menunggu data dari server.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat koleksi dari server...'),
        ],
      ),
    );
  }
}

/// Tampilan kondisi ERROR: permintaan gagal atau data tidak dapat diproses.
class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 56, color: Colors.white38),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat data.\nPeriksa koneksi internet kamu.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.white38),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tampilan SUCCESS tetapi data kosong (mis. pencarian tanpa hasil).
class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_search, size: 56, color: Colors.white38),
            SizedBox(height: 12),
            Text('Tidak ada karya yang ditemukan.'),
          ],
        ),
      ),
    );
  }
}
