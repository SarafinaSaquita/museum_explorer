import 'package:flutter/material.dart';

import '../services/art_service.dart';
import '../widgets/art_grid.dart';
import '../widgets/state_views.dart';

/// Halaman utama: pencarian, filter kategori, dan galeri karya.
/// Pengambilan data memakai FutureBuilder untuk menangani kondisi
/// loading, success, dan error.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _pageSize = 20;
  static const Map<String, String> _categories = {
    'Semua': '',
    'Lukisan': 'Painting',
    'Patung': 'Sculpture',
    'Gambar': 'Drawing',
    'Tekstil': 'Textile',
    'Cetak': 'Print',
  };

  final ArtService _service = ArtService();
  final TextEditingController _searchCtrl = TextEditingController();

  String _query = '';
  String _type = '';
  int _generation = 0; // berubah setiap muat ulang, untuk mereset grid
  late Future<ArtPage> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchFirstPage();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Mengambil halaman pertama sesuai kata kunci dan kategori saat ini.
  Future<ArtPage> _fetchFirstPage() {
    return _service.fetch(
      query: _query,
      type: _type,
      skip: 0,
      limit: _pageSize,
    );
  }

  /// Membuat Future baru sehingga FutureBuilder kembali ke kondisi loading.
  void _reload() {
    setState(() {
      _generation++;
      _future = _fetchFirstPage();
    });
  }

  void _submitSearch(String value) {
    _query = value;
    _reload();
    FocusScope.of(context).unfocus();
  }

  void _selectType(String type) {
    _type = type;
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Museum Explorer'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              onSubmitted: _submitSearch,
              decoration: InputDecoration(
                hintText: 'Cari karya... (mis. cat, monet, samurai)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchCtrl.clear();
                          _submitSearch('');
                        },
                      ),
                filled: true,
                fillColor: const Color(0xFF2A2522),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _categories.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(e.key),
                    selected: _type == e.value,
                    onSelected: (_) => _selectType(e.value),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<ArtPage>(
              future: _future,
              builder: (context, snapshot) {
                // LOADING: menunggu respons server.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingView();
                }
                // ERROR: permintaan gagal atau data tidak dapat diproses.
                if (snapshot.hasError) {
                  return ErrorView(
                    error: snapshot.error!,
                    onRetry: _reload,
                  );
                }
                // SUCCESS: data siap disajikan.
                final page = snapshot.data!;
                if (page.items.isEmpty) return const EmptyView();
                return RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: ArtGrid(
                    key: ValueKey(_generation),
                    first: page,
                    service: _service,
                    query: _query,
                    type: _type,
                    pageSize: _pageSize,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
