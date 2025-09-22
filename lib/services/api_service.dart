import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://tohpati.pythonanywhere.com';

  Future<Map<String, dynamic>> predictGenre({
    required String category,
    required String title,
    required String description,
    required double threshold,
  }) async {
    final String apiUrl = '$_baseUrl/predict/${category.toLowerCase()}';

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request. Make sure your input correct.');
      } else if (response.statusCode == 500) {
        throw Exception('Problem on server. Try again later.');
      } else {
        throw Exception('Failed to get prediction. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect server.');
    }
  }
}