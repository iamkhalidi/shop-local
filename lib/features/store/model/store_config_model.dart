class StoreConfigModel {
  final String storeName;
  final String openTime;
  final String closeTime;
  final String callNumber;
  final double deliveryFee;
  final String deliveryInfo;
  final String email;
  final String locationUrl;
  final String returnPolicy;
  final String whatsappNumber;

  StoreConfigModel({
    required this.storeName,
    required this.openTime,
    required this.closeTime,
    required this.callNumber,
    required this.deliveryFee,
    required this.deliveryInfo,
    required this.email,
    required this.locationUrl,
    required this.returnPolicy,
    required this.whatsappNumber,
  });

  factory StoreConfigModel.fromFirestore(Map<String, dynamic> json) {
    return StoreConfigModel(
      storeName: (json['storeName'] ?? 'متجرنا').toString(),
      openTime: (json['openTime'] ?? '').toString(),
      closeTime: (json['closeTime'] ?? '').toString(),
      callNumber: (json['callNumber'] ?? '').toString(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      deliveryInfo: (json['deliveryInfo'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      locationUrl: (json['locationUrl'] ?? '').toString(),
      returnPolicy: (json['returnPolicy'] ?? '').toString(),
      whatsappNumber: (json['whatsappNumber'] ?? '').toString(),
    );
  }
}
