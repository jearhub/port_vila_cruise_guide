class Package {
  final String name;
  final String description;
  final int ticketsIncluded;
  final String price;

  const Package({
    required this.name,
    required this.description,
    required this.ticketsIncluded,
    required this.price,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ticketsIncluded: json['ticketsIncluded'] ?? 0,
      price: json['price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'ticketsIncluded': ticketsIncluded,
    'price': price,
  };
}
