import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../domain/models/cat.dart';

class ApiService {
  static http.Client client = http.Client();

  static final String _apiKey = dotenv.env['THE_CAT_API_KEY']!;
  static final Uri url = Uri.https('api.thecatapi.com', '/v1/images/search', {
    'has_breeds': '1',
  });

  static Future<Cat?> fetchCat() async {
    try {
      final response = await client.get(url, headers: {'x-api-key': _apiKey});
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final m = data[0] as Map<String, dynamic>;
          if ((m['breeds'] as List).isNotEmpty) {
            final breed = m['breeds'][0] as Map<String, dynamic>;
            return Cat(
              imageUrl: m['url'] ?? '',
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
