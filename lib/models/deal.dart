class Deal {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String popupTitle;
  final String popupDescription;

  Deal({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.popupTitle,
    required this.popupDescription,
  });

  factory Deal.fromFirestore(Map<String, dynamic> json, String docId) {
    return Deal(
      id: docId,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      popupTitle: json['popupTitle'] ?? "",
      popupDescription: json['popupDescription'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'popupTitle': popupTitle,
      'popupDescription': popupDescription,
    };
  }
}
