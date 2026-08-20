class StoreConfigModel {
  final String storeName;
  final String openTime;
  final String closeTime;

  StoreConfigModel({
    required this.storeName,
    required this.openTime,
    required this.closeTime,
  });

  factory StoreConfigModel.fromFirestore(Map<String, dynamic> json) {
    return StoreConfigModel(
      storeName: json['storeName'] ?? 'متجرنا',
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
    );
  }
}
