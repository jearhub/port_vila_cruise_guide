class MoneyExchangeLocation {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? type;
  final String? note;

  MoneyExchangeLocation({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.type,
    this.note,
  });

  factory MoneyExchangeLocation.fromFirestore(Map<String, dynamic> data) {
    return MoneyExchangeLocation(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      type: data['type'],
      note: data['note'],
    );
  }
}
