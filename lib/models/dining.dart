class Dining {
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
  final bool isFavorite;
  final List<dynamic> menu;

  const Dining({
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
    required this.menu,
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
    'isFavorite': isFavorite,
    'menu': menu,
  };

  // Robust Firestore/JSON constructor
  factory Dining.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Dining(
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
      menu: List.from(data['menu'] ?? []),
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}
