class WalkStop {
  final String name;
  final String description;
  final String imageUrl;
  final String? tip;
  final String? openHours;
  final double? latitude;
  final double? longitude;

  const WalkStop({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.tip,
    this.openHours,
    this.latitude,
    this.longitude,
  });
}
