class WalkStop {
  final String id;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final String? tip;
  final String? openHours;
  final double? latitude;
  final double? longitude;
  bool isVisited;

  WalkStop({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    this.tip,
    this.openHours,
    this.latitude,
    this.longitude,
    this.isVisited = false,
  });

  factory WalkStop.fromFirestore(String id, Map<String, dynamic> data) {
    return WalkStop(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      tip: data['tip'],
      openHours: data['openHours'],
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }
}
