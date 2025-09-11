class Activity {
  final String name;
  final String category;
  final String address;
  final String description;
  final String imageUrl;
  final String openingHours;
  final double rating;
  final int reviews;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String price;
  final List<dynamic> tags;
  final bool isFavorite;

  const Activity({
    required this.name,
    required this.category,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.openingHours,
    required this.rating,
    required this.reviews,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.tags,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'address': address,
    'description': description,
    'imageUrl': imageUrl,
    'openingHours': openingHours,
    'rating': rating,
    'reviews': reviews,
    'phoneNumber': phoneNumber,
    'latitude': latitude,
    'longitude': longitude,
    'price': price,
    'tags': tags,
    'isFavorite': isFavorite,
  };

  // Robust Firestore/JSON constructor
  factory Activity.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Activity(
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      openingHours: data['openingHours'] ?? '',

      rating:
          (data['rating'] is int)
              ? (data['rating'] as int).toDouble()
              : (data['rating'] ?? 0.0),
      reviews: data['reviews'] ?? 0,
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      latitude:
          (data['latitude'] is int)
              ? (data['latitude'] as int).toDouble()
              : (data['latitude'] ?? 0.0),
      longitude:
          (data['longitude'] is int)
              ? (data['longitude'] as int).toDouble()
              : (data['longitude'] ?? 0.0),
      price: data['price'] ?? '',
      tags: List.from(data['tags'] ?? []),
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}
