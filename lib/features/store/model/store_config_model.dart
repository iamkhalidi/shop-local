class StoreConfigModel {
  final String storeName;
  final String openTime;
  final String closeTime;
  final String callNumber;
  final int deliveryFee;
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
      storeName: json['storeName'] ?? 'متجرنا',
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
      callNumber: json['callNumber'] ?? '',
      deliveryFee: json['deliveryFee'] is int ? json['deliveryFee'] : (json['deliveryFee'] as num?)?.toInt() ?? 0,
      deliveryInfo: json['deliveryInfo'] ?? '',
      email: json['email'] ?? '',
      locationUrl: json['locationUrl'] ?? '',
      returnPolicy: json['returnPolicy'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
    );
  }
}
