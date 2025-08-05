class Activity {
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
  final List<String> tags;
  final bool isFavorite;

  const Activity({
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
    required this.tags,
    this.isFavorite = false,
  });
}
