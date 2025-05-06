class Cat {
  final String imageUrl;
  final String breedName;
  final String breedDescription;
  final String breedTemperament;
  final String breedOrigin;
  final DateTime? likedDate;

  Cat({
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
    required this.breedTemperament,
    required this.breedOrigin,
    this.likedDate,
  });

  Cat copyWith({DateTime? likedDate}) {
    return Cat(
      imageUrl: imageUrl,
      breedName: breedName,
      breedDescription: breedDescription,
      breedTemperament: breedTemperament,
      breedOrigin: breedOrigin,
      likedDate: likedDate ?? this.likedDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
    'breedName': breedName,
    'breedDescription': breedDescription,
    'breedTemperament': breedTemperament,
    'breedOrigin': breedOrigin,
    'likedDate': likedDate?.toIso8601String(),
  };

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
    imageUrl: json['imageUrl'],
    breedName: json['breedName'],
    breedDescription: json['breedDescription'],
    breedTemperament: json['breedTemperament'],
    breedOrigin: json['breedOrigin'],
    likedDate:
        json['likedDate'] != null ? DateTime.parse(json['likedDate']) : null,
  );

  static Cat sample() {
    return Cat(
      imageUrl: 'https://cdn2.thecatapi.com/images/jyjEWK7xp.jpg',
      breedName: 'TestBreed',
      breedDescription: 'Test description',
      breedTemperament: 'Playful',
      breedOrigin: 'Testland',
      likedDate: DateTime.now(),
    );
  }
}
