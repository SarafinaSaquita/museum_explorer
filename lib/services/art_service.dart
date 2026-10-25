import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/artwork.dart';

/// Hasil satu permintaan ke API.
class ArtPage {
  final List<Artwork> items; // sudah difilter (hanya yang punya gambar)
  final int rawCount; // jumlah data mentah dari API (untuk paginasi)
  ArtPage(this.items, this.rawCount);
}

/// Layanan pengambilan data dari Cleveland Museum of Art Open Access API.
class ArtService {
  static const String _host = 'openaccess-api.clevelandart.org';
  static const String _path = '/api/artworks/';

  /// Mengirim permintaan HTTP GET, memeriksa status respons, lalu
  /// mengonversi JSON menjadi daftar objek [Artwork].
  /// Melempar exception jika gagal, agar ditangani oleh FutureBuilder.
  Future<ArtPage> fetch({
    String query = '',
    String type = '',
    int skip = 0,
    int limit = 20,
  }) async {
    // 1. Menyusun URL beserta parameter permintaan.
    final params = <String, String>{
      'has_image': '1',
      'limit': '$limit',
      'skip': '$skip',
    };
    if (query.trim().isNotEmpty) params['q'] = query.trim();
    if (type.isNotEmpty) params['type'] = type;
    final uri = Uri.https(_host, _path, params);

    // 2. Mengirim permintaan (asynchronous) dengan batas waktu.
    final res = await http
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 20));

    // 3. Memeriksa status respons.
    if (res.statusCode != 200) {
      throw Exception('Server error ${res.statusCode}');
    }

    // 4. Mendekode JSON dan memastikan formatnya sesuai.
    final decoded = jsonDecode(utf8.decode(res.bodyBytes));
    if (decoded is! Map<String, dynamic> || decoded['data'] is! List) {
      throw const FormatException('Format respons API tidak sesuai');
    }
    final data = decoded['data'] as List;

    // 5. Mengonversi tiap elemen JSON menjadi objek Artwork.
    final all = data
        .whereType<Map<String, dynamic>>()
        .map(Artwork.fromJson)
        .toList();
    final withImage = all.where((a) => a.imageUrl.isNotEmpty).toList();
    return ArtPage(withImage, data.length);
  }
}
