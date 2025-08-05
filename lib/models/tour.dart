class Tour {
  final String name;
  final String description;
  final String imageUrl;
  final String openingHours;
  final String entryFee;
  final String duration;
  final bool skipLine;
  final bool pickupAvailable;
  final double rating;
  final int reviews;
  final String price;
  final List<String> category;
  final bool isFavorite;

  const Tour({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.openingHours,
    required this.entryFee,
    required this.duration,
    required this.skipLine,
    required this.pickupAvailable,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.category,
    this.isFavorite = false,
  });
}
