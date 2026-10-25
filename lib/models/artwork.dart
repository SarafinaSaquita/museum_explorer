class Artwork {
  final int id;
  final String title;
  final String date;
  final String artist;
  final String type;
  final String department;
  final String technique;
  final String culture;
  final String description;
  final String creditLine;
  final String imageUrl; // ukuran web (untuk grid)
  final String detailImageUrl; // ukuran lebih besar (untuk halaman detail)
  final String museumUrl;

  const Artwork({
    required this.id,
    required this.title,
    required this.date,
    required this.artist,
    required this.type,
    required this.department,
    required this.technique,
    required this.culture,
    required this.description,
    required this.creditLine,
    required this.imageUrl,
    required this.detailImageUrl,
    required this.museumUrl,
  });

  static String _s(dynamic v) => v == null ? '' : v.toString().trim();

  static String _stripHtml(String s) => s
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();

  factory Artwork.fromJson(Map<String, dynamic> json) {
    final images = json['images'];
    String web = '';
    String print = '';
    if (images is Map) {
      web = _s((images['web'] as Map?)?['url']);
      print = _s((images['print'] as Map?)?['url']);
    }

    String artist = 'Seniman tidak diketahui';
    final creators = json['creators'];
    if (creators is List && creators.isNotEmpty && creators.first is Map) {
      final d = _s((creators.first as Map)['description']);
      if (d.isNotEmpty) artist = d;
    }

    String culture = '';
    final c = json['culture'];
    if (c is List && c.isNotEmpty) culture = c.map((e) => e.toString()).join(', ');

    return Artwork(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: _s(json['title']).isEmpty ? 'Tanpa judul' : _s(json['title']),
      date: _s(json['creation_date']),
      artist: artist,
      type: _s(json['type']),
      department: _s(json['department']),
      technique: _s(json['technique']),
      culture: culture,
      description: _stripHtml(_s(json['description'])),
      creditLine: _s(json['creditline']),
      imageUrl: web,
      detailImageUrl: print.isNotEmpty ? print : web,
      museumUrl: _s(json['url']),
    );
  }
}
