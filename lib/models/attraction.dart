class Attraction {
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
  final bool isFavorite;

  Attraction({
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
    this.isFavorite = false,
  });
}
