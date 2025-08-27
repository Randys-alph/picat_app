import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://tohpati.pythonanywhere.com';

  // --- FUNGSI PREDIKSI YANG DIPERBARUI ---
  Future<Map<String, dynamic>> predictGenre({
    required String category, // Parameter ini sekarang sangat penting
    required String title,
    required String description,
    required double threshold,
  }) async {
    // 1. URL DIBUAT SECARA DINAMIS
    // Menggunakan nama kategori untuk membangun path URL yang benar.
    // .toLowerCase() mengubah "Movies" menjadi "movie", dll.
    final String apiUrl = '$_baseUrl/predict/${category.toLowerCase()}';
    print('Menghubungi API: $apiUrl'); // Untuk debugging

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'threshold': threshold,
        }),
      );

      // 2. PENANGANAN KODE STATUS YANG LEBIH DETAIL
      if (response.statusCode == 200) {
        // SUKSES: Permintaan berhasil.
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 400) {
        // ERROR 400: Permintaan tidak valid.
        throw Exception('Invalid request. Make sure your input correct.');
      } else if (response.statusCode == 500) {
        // ERROR 500: Masalah di server.
        throw Exception('Problem on server. Try again later.');
      } else {
        // Error lainnya.
        throw Exception('Failed to get prediction. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Error koneksi atau lainnya.
      throw Exception('Failed to connect server. Check your internet.');
    }
  }
}