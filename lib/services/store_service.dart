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

  Future<void> fetchStoreConfig() async {
    try {
      isLoading.value = true;
      final doc = await _firestore.collection('store_profile').doc('config').get();

      if (doc.exists && doc.data() != null) {
        final config = StoreConfigModel.fromFirestore(doc.data()!);
        storeConfig.value = config;
        storeName.value = config.storeName;
        print("✅ Store Config Loaded Successfully: ${config.storeName}");
      } else {
        print("⚠️ Store Config Document NOT FOUND at 'store_profile/config'");
      }
    } catch (e) {
      print("❌ Error fetching store config: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
