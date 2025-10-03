class MyDeal {
  final String id;
  final String popupTitle;
  final String popupDescription;
  final String imageUrl;

  MyDeal({
    required this.id,
    required this.popupTitle,
    required this.popupDescription,
    required this.imageUrl,
  });

  factory MyDeal.fromFirestore(Map<String, dynamic> json, String docId) {
    return MyDeal(
      id: docId,
      popupTitle: json['popupTitle'] ?? '',
      popupDescription: json['popupDescription'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
