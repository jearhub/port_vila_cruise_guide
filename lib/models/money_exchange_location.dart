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

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'note': note,
    'lat': lat,
    'lng': lng,
  };

  factory MoneyExchangeLocation.fromMap(Map map) {
    return MoneyExchangeLocation(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      note: map['note'] ?? '',
      lat: double.tryParse(map['lat'] ?? '') ?? 0.0,
      lng: double.tryParse(map['lng'] ?? '') ?? 0.0,
    );
  }
}
