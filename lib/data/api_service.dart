import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../domain/models/cat.dart';

class ApiService {
  static const String _apiKey =
      'live_8KK4VsmoWJDm94Mm2f5Ts5nf0sukUT4wAMOMFfYF8h16Xn0ALFPiK9a9gsiyb3zo';

  static Future<Cat?> fetchCat() async {
    final url = Uri.https(
      'api.thecatapi.com',
      '/v1/images/search',
      {'has_breeds': '1'},
    );

    try {
      final response = await http.get(url, headers: {'x-api-key': _apiKey});
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final catData = data[0];
          if (catData['breeds'] != null && (catData['breeds'] as List).isNotEmpty) {
            final breed = catData['breeds'][0];
            return Cat(
              imageUrl: catData['url'] ?? '',
              breedName: breed['name'] ?? 'Неизвестно',
              breedDescription: breed['description'] ?? 'Нет описания',
              breedTemperament: breed['temperament'] ?? 'Нет информации',
              breedOrigin: breed['origin'] ?? 'Неизвестно',
            );
          }
        }
      } else {
        debugPrint('Ошибка запроса: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Ошибка: $e');
      throw Exception('Ошибка сети');
    }
    return null;
  }

}
