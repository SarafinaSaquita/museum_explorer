import 'package:flutter/material.dart';

import '../models/artwork.dart';
import '../pages/detail_page.dart';
import '../services/art_service.dart';
import 'art_image.dart';

/// Galeri karya (grid 2 kolom) dengan pemuatan bertahap (infinite scroll).
/// Halaman pertama berasal dari FutureBuilder pada HomePage; halaman
/// berikutnya dimuat di sini saat pengguna menggulir mendekati akhir daftar.
class ArtGrid extends StatefulWidget {
  final ArtPage first;
  final ArtService service;
  final String query;
  final String type;
  final int pageSize;

  const ArtGrid({
    super.key,
    required this.first,
    required this.service,
    required this.query,
    required this.type,
    required this.pageSize,
  });

  @override
  State<ArtGrid> createState() => _ArtGridState();
}

class _ArtGridState extends State<ArtGrid> {
  final ScrollController _scroll = ScrollController();
  late final List<Artwork> _items = List<Artwork>.of(widget.first.items);
  late int _skip = widget.first.rawCount;
  late bool _hasMore = widget.first.rawCount == widget.pageSize;
  bool _loadingMore = false;
  String? _moreError;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >=
          _scroll.position.maxScrollExtent - 400) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Memuat halaman data berikutnya (asynchronous).
  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() {
      _loadingMore = true;
      _moreError = null;
    });
    try {
      final page = await widget.service.fetch(
        query: widget.query,
        type: widget.type,
        skip: _skip,
        limit: widget.pageSize,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _skip += page.rawCount;
        _hasMore = page.rawCount == widget.pageSize;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _moreError = 'Gagal memuat data berikutnya.');
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) => _ArtCard(art: _items[i]),
              childCount: _items.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: _loadingMore
                  ? const CircularProgressIndicator()
                  : _moreError != null
                      ? TextButton(
                          onPressed: _loadMore,
                          child: Text('$_moreError Ketuk untuk ulangi'),
                        )
                      : !_hasMore
                          ? const Text('— Akhir koleksi —',
                              style: TextStyle(color: Colors.white38))
                          : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}

/// Kartu satu karya: gambar penuh dengan judul dan seniman di atas gradien.
class _ArtCard extends StatelessWidget {
  final Artwork art;
  const _ArtCard({required this.art});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DetailPage(art: art)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(tag: 'art-${art.id}', child: ArtImage(url: art.imageUrl)),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 28, 10, 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE6000000)],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      art.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      art.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
