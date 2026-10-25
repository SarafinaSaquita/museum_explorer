import 'package:flutter/material.dart';
import '../models/artwork.dart';
import '../widgets/art_image.dart';

class DetailPage extends StatelessWidget {
  final Artwork art;
  const DetailPage({super.key, required this.art});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 380,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => _FullImagePage(art: art)),
                ),
                child: Hero(
                  tag: 'art-${art.id}',
                  child: ArtImage(url: art.detailImageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(art.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(art.artist,
                      style: const TextStyle(
                          color: Color(0xFFE0B25C), fontSize: 15)),
                  const SizedBox(height: 6),
                  const Text('Ketuk gambar untuk memperbesar',
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (art.type.isNotEmpty) _Tag(art.type),
                      if (art.department.isNotEmpty) _Tag(art.department),
                      if (art.culture.isNotEmpty) _Tag(art.culture),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Row('Tahun', art.date),
                  _Row('Teknik / Media', art.technique),
                  _Row('Kredit', art.creditLine),
                  if (art.description.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Deskripsi',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(art.description, style: const TextStyle(height: 1.5)),
                  ],
                  const SizedBox(height: 24),
                  if (art.museumUrl.isNotEmpty)
                    SelectableText('Sumber: ${art.museumUrl}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);
  @override
  Widget build(BuildContext context) => Chip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        visualDensity: VisualDensity.compact,
      );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: Colors.white54)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _FullImagePage extends StatelessWidget {
  final Artwork art;
  const _FullImagePage({required this.art});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: Text(art.title)),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        child: Center(
          child: ArtImage(url: art.detailImageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
