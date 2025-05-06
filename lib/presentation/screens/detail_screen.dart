import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/models/cat.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;

  const DetailScreen({required this.cat, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cat.breedName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: cat.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (ctx, url) =>
                      const Center(child: CircularProgressIndicator()),
              errorWidget: (ctx, url, err) => const Icon(Icons.error),
            ),
            SizedBox(height: 20),
            Text(
              "Порода: ${cat.breedName}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Описание: ${cat.breedDescription}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Темперамент: ${cat.breedTemperament}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Происхождение: ${cat.breedOrigin}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
