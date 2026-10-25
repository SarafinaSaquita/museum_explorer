# Museum Explorer

Aplikasi mobile berbasis **Flutter dan Dart** untuk menjelajahi koleksi seni
**Cleveland Museum of Art**. Data karya (judul, seniman, tahun, teknik,
deskripsi, dan gambar) diambil secara langsung dari API terbuka museum
tersebut.

## Deskripsi Singkat
Museum Explorer memudahkan pengguna melihat koleksi museum dari ponsel tanpa
datang langsung. Pengguna dapat mencari karya, menyaring berdasarkan
kategori, membuka detail karya, dan memperbesar gambar.

## Fitur Utama
- Galeri karya seni (grid 2 kolom) dengan gambar dari API.
- Pencarian karya berdasarkan kata kunci.
- Filter kategori: Lukisan, Patung, Gambar, Tekstil, dan Cetak.
- Pemuatan bertahap (*infinite scroll*) dan tarik untuk menyegarkan.
- Halaman detail karya dan zoom gambar.
- Penanganan kondisi **loading, success, dan error** dengan `FutureBuilder`,
  lengkap dengan tombol "Coba lagi".

## Teknologi dan Package
| Teknologi / Package | Kegunaan |
|---|---|
| Flutter dan Dart | Framework dan bahasa pemrograman |
| `http` (pub.dev) | Mengirim permintaan HTTP GET ke API |
| `dart:convert` | Mengonversi JSON menjadi objek Dart |
| `FutureBuilder` | Menyesuaikan tampilan dengan kondisi pengambilan data |
| Cleveland Museum of Art Open Access API | Sumber data (`https://openaccess-api.clevelandart.org/api/artworks/`), tanpa API key |

## Struktur Folder
```
lib/
  main.dart                  # titik masuk dan tema
  models/artwork.dart        # model data + fromJson
  services/art_service.dart  # permintaan HTTP ke API
  pages/home_page.dart       # halaman utama (FutureBuilder)
  pages/detail_page.dart     # detail karya dan zoom
  widgets/                   # grid, gambar, tampilan loading/error/kosong
```

## Langkah Menjalankan
1. Pasang Flutter SDK dan VS Code (ekstensi Flutter dan Dart).
2. Buka folder project ini, lalu jalankan di terminal:
   ```
   flutter create --project-name museum_explorer .
   flutter pub get
   flutter devices
   flutter run
   ```
3. Pilih perangkat Android (atau emulator) di VS Code, lalu tekan F5.
   Gunakan perangkat Android, bukan Chrome, agar gambar dari domain lain
   tidak diblokir browser.
4. Untuk build APK release, tambahkan izin internet pada
   `android/app/src/main/AndroidManifest.xml`:
   `<uses-permission android:name="android.permission.INTERNET"/>`
