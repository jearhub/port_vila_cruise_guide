class MoneyExchangeLocation {
  final String name;
  final String address;
  final String note;
  final double lat;
  final double lng;

  MoneyExchangeLocation({
    required this.name,
    required this.address,
    required this.note,
    required this.lat,
    required this.lng,
  });

  factory MoneyExchangeLocation.fromMap(Map<String, String> map) {
    return MoneyExchangeLocation(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      note: map['note'] ?? '',
      lat: double.tryParse(map['lat'] ?? '') ?? 0.0,
      lng: double.tryParse(map['lng'] ?? '') ?? 0.0,
    );
  }
}
