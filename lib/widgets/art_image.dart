import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Gambar jaringan dengan header browser, indikator loading,
/// pesan error, dan tombol coba lagi.
class ArtImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  const ArtImage({super.key, required this.url, this.fit = BoxFit.cover});

  @override
  State<ArtImage> createState() => _ArtImageState();
}

class _ArtImageState extends State<ArtImage> {
  int _retry = 0;

  static const Map<String, String> _headers = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
    'Accept': 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8',
  };

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.url,
      key: ValueKey('${widget.url}#$_retry'),
      fit: widget.fit,
      headers: kIsWeb ? null : _headers,
      webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        final v = progress.expectedTotalBytes != null
            ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
            : null;
        return Container(
          color: const Color(0xFF2A2522),
          child: Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2, value: v),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stack) {
        debugPrint('GAMBAR GAGAL: ${widget.url}\n$error');
        return GestureDetector(
          onTap: () => setState(() => _retry++),
          child: Container(
            color: const Color(0xFF2A2522),
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, color: Colors.white54, size: 30),
                  const SizedBox(height: 4),
                  const Text('Ketuk untuk muat ulang',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(
                    error.toString(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white30, fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
