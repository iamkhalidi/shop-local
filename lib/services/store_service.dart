import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../features/store/model/store_config_model.dart';

class StoreService extends GetxService {
  static StoreService get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final Rxn<StoreConfigModel> storeConfig = Rxn<StoreConfigModel>();
  final RxString storeName = 'Shop Local'.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStoreConfig();
  }

  void fetchStoreConfig() {
    try {
      isLoading.value = true;
      // 🚀 تحويل الجلب إلى مستمع مباشر (Stream) لضمان التحديث اللحظي في جميع أنحاء التطبيق
      _firestore.collection('store_profile').doc('config').snapshots().listen((doc) {
        if (doc.exists && doc.data() != null) {
          final config = StoreConfigModel.fromFirestore(doc.data()!);
          storeConfig.value = config;
          storeName.value = config.storeName;
          print("✅ Store Config Updated: ${config.storeName} | Fee: ${config.deliveryFee}");
        } else {
          print("⚠️ Store Config Document NOT FOUND at 'store_profile/config'");
        }
        isLoading.value = false;
      }, onError: (e) {
        print("❌ Stream Error in store config: $e");
        isLoading.value = false;
      });
    } catch (e) {
      print("❌ Error initializing store config stream: $e");
      isLoading.value = false;
    }
  }
}
