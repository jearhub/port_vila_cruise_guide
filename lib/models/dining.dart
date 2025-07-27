class Dining {
  final String name;
  final String category;
  final String address;
  final String description;
  final String imageUrl;
  final String openingHours;
  //final String website;
  final double rating;
  final int reviews;
  final String price;
  final bool isFavorite;

  const Dining({
    required this.name,
    required this.category,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.openingHours,
    //required this.website,
    required this.rating,
    required this.reviews,
    required this.price,
    this.isFavorite = false,
  });
}
