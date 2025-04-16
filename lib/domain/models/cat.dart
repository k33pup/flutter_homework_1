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
}
