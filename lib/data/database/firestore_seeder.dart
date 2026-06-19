import 'package:cloud_firestore/cloud_firestore.dart';



// ملف حقن البيانات
// من خلال اضافته في splash controller
// الوظيفة تحت في تعليق


class FirestoreSeeder {
  static Future<void> seedAllGroceryData() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    print("====== جاري بدء رفع البيانات المدعومة بالـ Batch إلى Firestore... ======");

    final List<Map<String, dynamic>> completeGroceryData = [
      {
        "id": "juices",
        "name_ar": "عصيرات",
        "name_en": "Juices",
        "icon": "local_drink",
        "color": "FFFCEBE2",
        "products": [
          { "id": "j1", "name_": "عصير برتقال المراعي طازج", "description": "عصير برتقال طبيعي طازج 100% بدون سكر مضاف", "original_price": 9.00, "current_price": 7.50, "has_discount": true, "stock_quantity": 45, "unit_type": "liter", "size_volume": 1.4, "image_url": "https://placeholder.com/juices/almarai_orange.png" },
          { "id": "j2", "name_": "عصير مانجو ندى نكتار", "description": "عصير نكتار المانجو الفاخر بقوام غني ولذيذ", "original_price": 8.50, "current_price": 8.50, "has_discount": false, "stock_quantity": 30, "unit_type": "liter", "size_volume": 1.35, "image_url": "https://placeholder.com/juices/nada_mango.png" },
          { "id": "j3", "name_": "عصير تفاح كي دي دي", "description": "عصير تفاح طبيعي مصنع من أجود أنواع التفاح", "original_price": 2.50, "current_price": 2.50, "has_discount": false, "stock_quantity": 120, "unit_type": "ml", "size_volume": 250.0, "image_url": "https://placeholder.com/juices/kdd_apple.png" },
          { "id": "j4", "name_": "عصير أناناس سيزر", "description": "عصير أناناس مصفى فاخر خالي من السكر والمواد الحافظة", "original_price": 5.00, "current_price": 4.25, "has_discount": true, "stock_quantity": 60, "unit_type": "ml", "size_volume": 250.0, "image_url": "https://placeholder.com/juices/caesar_pineapple.png" },
          { "id": "j5", "name_": "شراب راني حبيبات خوخ", "description": "عصير خوخ منعش يحتوي على قطع خوخ طبيعية حقيقية", "original_price": 3.00, "current_price": 3.00, "has_discount": false, "stock_quantity": 150, "unit_type": "ml", "size_volume": 240.0, "image_url": "https://placeholder.com/juices/rani_peach.png" },
          { "id": "j6", "name_": "عصير فلوريدا ناتشورال برتقال", "description": "عصير برتقال طبيعي نقي 100% مستورد ومبستر ممتاز", "original_price": 18.00, "current_price": 14.95, "has_discount": true, "stock_quantity": 25, "unit_type": "ml", "size_volume": 900.0, "image_url": "https://placeholder.com/juices/florida_orange.png" },
          { "id": "j7", "name_": "عصير المراعي توت مشكل", "description": "شراب نكتار التوت المشكل المنعش من المراعي", "original_price": 9.00, "current_price": 9.00, "has_discount": false, "stock_quantity": 40, "unit_type": "liter", "size_volume": 1.4, "image_url": "https://placeholder.com/juices/almarai_berry.png" },
          { "id": "j8", "name_": "عصير ربيع سعودي برتقال", "description": "عصير البرتقال الكلاسيكي المفضل للأطفال علبة صغيرة", "original_price": 1.50, "current_price": 1.25, "has_discount": true, "stock_quantity": 200, "unit_type": "ml", "size_volume": 125.0, "image_url": "https://placeholder.com/juices/rabea_orange.png" },
          { "id": "j9", "name_": "عصير سن توب مشكل", "description": "شراب الفواكه المشكلة سن توب الخالي من المواد الحافظة", "original_price": 2.00, "current_price": 2.00, "has_discount": false, "stock_quantity": 180, "unit_type": "ml", "size_volume": 250.0, "image_url": "https://placeholder.com/juices/suntop.png" },
          { "id": "j10", "name_": "عصير نادك كابتن فواكه", "description": "عصير فواكه مشكلة مدعم بالفيتامينات ومخصص للأطفال", "original_price": 1.50, "current_price": 1.50, "has_discount": false, "stock_quantity": 220, "unit_type": "ml", "size_volume": 200.0, "image_url": "https://placeholder.com/juices/nadec_captain.png" }
        ]
      },
      {
        "id": "chips",
        "name_ar": "شيبسات",
        "name_en": "Chips",
        "icon": "lunch_dining",
        "color": "FFEAF2F8",
        "products": [
          { "id": "c1", "name_": "بطاطس ليز بالملح كلاسيك", "description": "رقائق بطاطس مقرمشة وطبيعية بنكهة ملح البحر الكلاسيكية", "original_price": 5.00, "current_price": 5.00, "has_discount": false, "stock_quantity": 100, "unit_type": "grams", "size_volume": 160.0, "image_url": "https://placeholder.com/chips/lays_salt.png" },
          { "id": "c2", "name_": "بطاطس ليز ماكس بالفلفل الحار", "description": "رقائق بطاطس مموجة وحارة جداً لعشاق النكهات القوية", "original_price": 6.00, "current_price": 4.95, "has_discount": true, "stock_quantity": 85, "unit_type": "grams", "size_volume": 140.0, "image_url": "https://placeholder.com/chips/lays_max.png" },
          { "id": "c3", "name_": "شيبس برينجلز الأصلي", "description": "رقائق بطاطس برينجلز الشهيرة بنكهتها الأصلية الفريدة", "original_price": 12.50, "current_price": 9.95, "has_discount": true, "stock_quantity": 50, "unit_type": "grams", "size_volume": 165.0, "image_url": "https://placeholder.com/chips/pringles_original.png" },
          { "id": "c4", "name_": "دوريتوس بنكهة جبنة الناتشو", "description": "رقائق تورتيلا الذرة المقرمشة بنكهة جبنة الناتشو الغنية", "original_price": 5.00, "current_price": 5.00, "has_discount": false, "stock_quantity": 90, "unit_type": "grams", "size_volume": 165.0, "image_url": "https://placeholder.com/chips/doritos_nacho.png" },
          { "id": "c5", "name_": "بطاطس تسالي بنكهة الكاتشب", "description": "شيبس تسالي السعودي التقليدي والأكثر طلباً بنكهة الكاتشب", "original_price": 3.00, "current_price": 3.00, "has_discount": false, "stock_quantity": 140, "unit_type": "grams", "size_volume": 95.0, "image_url": "https://placeholder.com/chips/tasali_ketchup.png" },
          { "id": "c6", "name_": "شيبس مرامي بالملح والخل", "description": "رقائق بطاطس محلية بنكهة الخل اللاذع والملح المتوازنة", "original_price": 2.50, "current_price": 2.00, "has_discount": true, "stock_quantity": 110, "unit_type": "grams", "size_volume": 80.0, "image_url": "https://placeholder.com/chips/marami_vinegar.png" },
          { "id": "c7", "name_": "شيبس بوقلز بيليتس حار نار", "description": "قوارع ذرة مقرمشة مخروطية الشكل بنكهة الفلفل الحار", "original_price": 3.00, "current_price": 3.00, "has_discount": false, "stock_quantity": 75, "unit_type": "grams", "size_volume": 85.0, "image_url": "https://placeholder.com/chips/bugles_hot.png" },
          { "id": "c8", "name_": "بطاطس ليز بالجبنة الفرنسية", "description": "رقائق بطاطس طبيعية خفيفة بنكهة الجبنة الفرنسية المعتدلة", "original_price": 5.00, "current_price": 5.00, "has_discount": false, "stock_quantity": 95, "unit_type": "grams", "size_volume": 160.0, "image_url": "https://placeholder.com/chips/lays_cheese.png" },
          { "id": "c9", "name_": "شيبس برينجلز الحار والمتبل", "description": "علبة برينجلز بطاطس بنكهة البهارات الحارة واللاذعة", "original_price": 12.50, "current_price": 12.50, "has_discount": false, "stock_quantity": 40, "unit_type": "grams", "size_volume": 165.0, "image_url": "https://placeholder.com/chips/pringles_spicy.png" },
          { "id": "c10", "name_": "شيتوس كرانشي جبنة حار نار", "description": "مقرمشات الذرة الشهيرة شيتوس بالجبنة والبهارات الحارة جداً", "original_price": 5.00, "current_price": 4.50, "has_discount": true, "stock_quantity": 130, "unit_type": "grams", "size_volume": 150.0, "image_url": "https://placeholder.com/chips/cheetos_flamin.png" }
        ]
      },
      {
        "id": "vegetables",
        "name_ar": "خضار",
        "name_en": "Vegetables",
        "icon": "eco",
        "color": "FFE8F8ED",
        "products": [
          { "id": "v1", "name_": "طماطم محلي طازج", "description": "طماطم حمراء طازجة قطاف اليوم من المزارع السعودية المحلية", "original_price": 5.50, "current_price": 3.95, "has_discount": true, "stock_quantity": 150, "unit_type": "kg", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/tomatoes.png" },
          { "id": "v2", "name_": "بطاطس كيس محلي", "description": "كيس بطاطس بيضاء ممتازة ومناسبة للطبخ والقلي العميق", "original_price": 4.95, "current_price": 4.95, "has_discount": false, "stock_quantity": 200, "unit_type": "kg", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/potatoes.png" },
          { "id": "v3", "name_": "بصل أحمر كيس وسط", "description": "كيس بصل أحمر طازج عالي الجودة أساسي لكل مطبخ", "original_price": 6.00, "current_price": 4.50, "has_discount": true, "stock_quantity": 180, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/onions.png" },
          { "id": "v4", "name_": "خيار طازج فلج", "description": "خيار أخضر مقرمش ممتاز للسلطات والوجبات اليومية", "original_price": 4.50, "current_price": 4.50, "has_discount": false, "stock_quantity": 100, "unit_type": "kg", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/cucumbers.png" },
          { "id": "v5", "name_": "جزر مستورد محلي علبة", "description": "علبة جزر طازج ونظيف مبرد غني بالفوائد ومقرمش", "original_price": 5.00, "current_price": 5.00, "has_discount": false, "stock_quantity": 80, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/carrots.png" },
          { "id": "v6", "name_": "فلفل رومي أخضر بارد", "description": "حبات فلفل حلو رومي أخضر طازج ومثالي للحشو والطبخ", "original_price": 7.00, "current_price": 5.95, "has_discount": true, "stock_quantity": 90, "unit_type": "kg", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/bell_pepper.png" },
          { "id": "v7", "name_": "خس مدور كابوتشا", "description": "حبة خس مدور طازجة ونظيفة ممتازة لسلطة القيصر والبرجر", "original_price": 3.50, "current_price": 3.50, "has_discount": false, "stock_quantity": 65, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/lettuce.png" },
          { "id": "v8", "name_": "ثوم شبك ثلاث حبات", "description": "ربطة شبك تحتوي على 3 حبات ثوم أبيض جاف وممتاز", "original_price": 2.50, "current_price": 2.50, "has_discount": false, "stock_quantity": 140, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/garlic.png" },
          { "id": "v9", "name_": "باذنجان أسود محلي", "description": "باذنجان أسود طازج ذو قشرة لامعة وممتاز للمحاشي والمقالي", "original_price": 5.00, "current_price": 3.50, "has_discount": true, "stock_quantity": 85, "unit_type": "kg", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/eggplant.png" },
          { "id": "v10", "name_": "كوسة محلي طازج بالوزن", "description": "كوسة خضراء طازجة صغيرة الحجم وممتازة للطبخ والمحشي", "original_price": 6.50, "current_price": 6.50, "has_discount": false, "stock_quantity": 70, "unit_type": "kg", "size_volume": 0.0, "image_url": "https://placeholder.com/vegetables/zucchini.png" }
        ]
      },
      {
        "id": "dairy",
        "name_ar": "الألبان والأجبان",
        "name_en": "Dairy & Cheese",
        "icon": "water_drop",
        "color": "FFF3E5F5",
        "products": [
          { "id": "d1", "name_": "حليب المراعي طازج كامل الدسم", "description": "حليب بقري نقي 100% طازج ومبستر عالي الجودة يومي", "original_price": 11.00, "current_price": 11.00, "has_discount": false, "stock_quantity": 80, "unit_type": "liter", "size_volume": 2.85, "image_url": "https://placeholder.com/dairy/almarai_milk.png" },
          { "id": "d2", "name_": "لبن المراعي طازج كامل الدسم", "description": "لبن طازج منعش بالطعم التقليدي الأصيل الغني بالكالسيوم", "original_price": 8.50, "current_price": 8.50, "has_discount": false, "stock_quantity": 95, "unit_type": "liter", "size_volume": 2.0, "image_url": "https://placeholder.com/dairy/almarai_laban.png" },
          { "id": "d3", "name_": "زبادي نادك طازج كامل الدسم", "description": "علبة زبادي طازج من نادك قوام متмаسك وطعم غني ومميز", "original_price": 1.50, "current_price": 1.50, "has_discount": false, "stock_quantity": 300, "unit_type": "grams", "size_volume": 170.0, "image_url": "https://placeholder.com/dairy/nadec_yogurt.png" },
          { "id": "d4", "name_": "جبنة كرافت شيدر علبة معدن", "description": "جبنة شيدر كرافت المطبوخة الأصلية بالطعم التاريخي المميز", "original_price": 7.50, "current_price": 5.95, "has_discount": true, "stock_quantity": 110, "unit_type": "grams", "size_volume": 100.0, "image_url": "https://placeholder.com/dairy/kraft_cheddar.png" },
          { "id": "d5", "name_": "جبنة بوك كاسات كريم بيضاء", "description": "جبنة كريم مطبوخة قابلة للدهن في كاسات زجاجية ممتازة", "original_price": 23.00, "current_price": 18.50, "has_discount": true, "stock_quantity": 65, "unit_type": "grams", "size_volume": 500.0, "image_url": "https://placeholder.com/dairy/puck_cheese.png" },
          { "id": "d6", "name_": "قشطة التاج سادة علب", "description": "قشطة التاج الصافية والمعقمة للطبخ والحلويات الشرقية", "original_price": 6.50, "current_price": 6.50, "has_discount": false, "stock_quantity": 160, "unit_type": "grams", "size_volume": 155.0, "image_url": "https://placeholder.com/dairy/altaj_cream.png" },
          { "id": "d7", "name_": "زبادي يوناني نادك سادة", "description": "زبادي يوناني كريمي غني بالبروتين وخالي من السكر المضاف", "original_price": 5.00, "current_price": 4.00, "has_discount": true, "stock_quantity": 85, "unit_type": "grams", "size_volume": 160.0, "image_url": "https://placeholder.com/dairy/nadec_greek.png" },
          { "id": "d8", "name_": "جبنة موزاريلا المراعي مبشورة", "description": "جبنة موزاريلا طبيعية مبشورة مثالية للبيتزا والمعكرونة والطهي", "original_price": 14.00, "current_price": 11.50, "has_discount": true, "stock_quantity": 70, "unit_type": "grams", "size_volume": 200.0, "image_url": "https://placeholder.com/dairy/almarai_mozzarella.png" },
          { "id": "d9", "name_": "زبدة لورباك غير مملحة", "description": "قالب زبدة لورباك الدنماركية الفاخرة للطبخ والخبز المنزلي", "original_price": 6.50, "current_price": 6.50, "has_discount": false, "stock_quantity": 90, "unit_type": "grams", "size_volume": 100.0, "image_url": "https://placeholder.com/dairy/lurpak_butter.png" },
          { "id": "d10", "name_": "لبنة بينار تركية أصلية", "description": "لبنة تركية طازجة وكريمية ممتازة للفطور وزيت الزيتون", "original_price": 19.50, "current_price": 16.95, "has_discount": true, "stock_quantity": 40, "unit_type": "grams", "size_volume": 400.0, "image_url": "https://placeholder.com/dairy/pinar_labneh.png" }
        ]
      },
      {
        "id": "bakery",
        "name_ar": "المخبوزات",
        "name_en": "Bakery",
        "icon": "bakery_dining",
        "color": "FFE0F2F1",
        "products": [
          { "id": "b1", "name_": "خبز توست أبيض لوزين", "description": "شرائح خبز توست أبيض طري جداً وطازج بشكل يومي للفرش", "original_price": 5.00, "current_price": 5.00, "has_discount": false, "stock_quantity": 75, "unit_type": "piece", "size_volume": 600.0, "image_url": "https://placeholder.com/bakery/lusine_toast.png" },
          { "id": "b2", "name_": "خبز صامولي لوزين 6 حبات", "description": "كيس خبز صامولي أبيض تقليدي طازج ومثالي للسندويشات", "original_price": 1.50, "current_price": 1.50, "has_discount": false, "stock_quantity": 140, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/bakery/lusine_samoon.png" },
          { "id": "b3", "name_": "خبز برجر يومي سادة", "description": "خبز برجر إسفنجي طري متناسق الدائرة، كيس يحتوي 6 حبات", "original_price": 4.00, "current_price": 3.50, "has_discount": true, "stock_quantity": 90, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/bakery/yaumi_burger.png" },
          { "id": "b4", "name_": "كرواسون سفن دايز بحشوة الكاكاو", "description": "كرواسون مخبوز وهش محشو بكريمة الكاكاو الغنية واللذيذة", "original_price": 2.00, "current_price": 2.00, "has_discount": false, "stock_quantity": 160, "unit_type": "grams", "size_volume": 55.0, "image_url": "https://placeholder.com/bakery/7days_chocolate.png" },
          { "id": "b5", "name_": "خبز مفرود لبناني أبيض محلي", "description": "ربطة خبز مفرود لبناني أبيض طازج من مخابزنا اليومية 5 أرغفة", "original_price": 1.25, "current_price": 1.25, "has_discount": false, "stock_quantity": 250, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/bakery/lebanese_bread.png" },
          { "id": "b6", "name_": "شابورة هيرفي بالقمح الكامل", "description": "شابورة هيرفي المقرمشة المصنوعة من البر والقمح الكامل الصحي", "original_price": 9.00, "current_price": 7.50, "has_discount": true, "stock_quantity": 55, "unit_type": "grams", "size_volume": 375.0, "image_url": "https://placeholder.com/bakery/herfy_rusks.png" },
          { "id": "b7", "name_": "كيك دافيدو بار ميني فانيليا", "description": "قطع كيك صغيرة إسفنجية مغطاة ومحشوة بكريمة الفانيليا", "original_price": 2.00, "current_price": 2.00, "has_discount": false, "stock_quantity": 110, "unit_type": "grams", "size_volume": 40.0, "image_url": "https://placeholder.com/bakery/cake_bar.png" },
          { "id": "b8", "name_": "فطيرة لوزين بحشوة الجبنة", "description": "فطيرة لوزين المخبوزة الخفيفة والمحشوة بجبنة الفيتا اللذيذة", "original_price": 1.50, "current_price": 1.50, "has_discount": false, "stock_quantity": 180, "unit_type": "grams", "size_volume": 70.0, "image_url": "https://placeholder.com/bakery/lusine_cheese.png" },
          { "id": "b9", "name_": "علبة تحتوي على كب كيك إسفنجي محشو بصلصة الشوكولاتة 18 حبة", "description": "علبة تحتوي على كب كيك إسفنجي محشو بصلصة الشوكولاتة 18 حبة", "original_price": 15.00, "current_price": 12.95, "has_discount": true, "stock_quantity": 45, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/bakery/lusine_cupcake_box.png" },
          { "id": "b10", "name_": "خبز التورتيلا فوشية سادة", "description": "كيس خبز تورتيلا فوشية ناصع وطري ممتاز لعمل الشاورما والتاكو", "original_price": 8.00, "current_price": 6.50, "has_discount": true, "stock_quantity": 70, "unit_type": "piece", "size_volume": 250.0, "image_url": "https://placeholder.com/fuchsya_tortilla.png" }
        ]
      },
      {
        "id": "sweets",
        "name_ar": "الحلويات والشوكولاتة",
        "name_en": "Sweets & Chocolates",
        "icon": "cookie",
        "color": "FFFFEAEA",
        "products": [
          { "id": "s1", "name_": "شوكولاتة جالكسي ناعمة بالحليب", "description": "لوح شوكولاتة جالكسي الفاخرة والمصنوعة من الحليب الصافي الناعم", "original_price": 4.50, "current_price": 4.50, "has_discount": false, "stock_quantity": 150, "unit_type": "grams", "size_volume": 36.0, "image_url": "https://placeholder.com/sweets/galaxy_milk.png" },
          { "id": "s2", "name_": "بسكويت أوريو الأصلي كرتون", "description": "علبة كرتون تحتوي على زبادي وبسكويت أوريو بالشوكولاتة والكريمة", "original_price": 16.00, "current_price": 12.95, "has_discount": true, "stock_quantity": 60, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/sweets/oreo_box.png" },
          { "id": "s3", "name_": "جلي هاريبيو كولا الدببة", "description": "حلوى الجيلاتين المطاطية الشهيرة من هاريبو بنكهة التوت والكولا", "original_price": 5.50, "current_price": 5.50, "has_discount": false, "stock_quantity": 90, "unit_type": "grams", "size_volume": 80.0, "image_url": "https://placeholder.com/sweets/haribo_cola.png" },
          { "id": "s4", "name_": "شوكولاتة كيت كات 4 أصابع", "description": "أصابع بسكويت الويفر المقرمش والمغطى بطبقة غنية من شوكولاتة الحليب", "original_price": 3.50, "current_price": 2.75, "has_discount": true, "stock_quantity": 200, "unit_type": "grams", "size_volume": 41.5, "image_url": "https://placeholder.com/sweets/kitkat_4fingers.png" },
          { "id": "s5", "name_": "بسكويت ديمة بالتمر كرتون", "description": "بسكويت ديمة الوطني السعودي المحشو بعجينة التمر الطبيعية الفاخرة", "original_price": 10.00, "current_price": 10.00, "has_discount": false, "stock_quantity": 85, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/sweets/deemah_dates.png" },
          { "id": "s6", "name_": "شوكولاتة نوتيلا برطمان صغير", "description": "كريمة النوتيلا الشهيرة القابلة للدهن بنكهة البندق والكاكاو الغني", "original_price": 15.00, "current_price": 12.50, "has_discount": true, "stock_quantity": 40, "unit_type": "grams", "size_volume": 200.0, "image_url": "https://placeholder.com/sweets/nutella_200.png" },
          { "id": "s7", "name_": "باطس غندور بك ون ويفر", "description": "ويفر غندور كلاسيك المغطى بالشوكولاتة بطعم الذكريات الرائع", "original_price": 1.00, "current_price": 1.00, "has_discount": false, "stock_quantity": 300, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/sweets/gandour_pikone.png" },
          { "id": "s8", "name_": "علك غندور مستكة كرتون", "description": "علك غندور التقليدي بنكهة المستكة الطبيعية المفضلة محلياً", "original_price": 5.00, "current_price": 5.00, "has_discount": false, "stock_quantity": 100, "unit_type": "piece", "size_volume": 0.0, "image_url": "https://placeholder.com/sweets/gandour_chiclets.png" },
          { "id": "s9", "name_": "شوكولاتة سنيكرز سنغل لوح", "description": "لوح شوكولاتة سنيكرز المحشو بالنوجا والكراميل والفول السوداني المقرمش", "original_price": 3.50, "current_price": 3.00, "has_discount": true, "stock_quantity": 170, "unit_type": "grams", "size_volume": 50.0, "image_url": "https://placeholder.com/sweets/snickers.png" },
          { "id": "s10", "name_": "ماكنتوش كواليتي ستريت علبة", "description": "علبة حديد تحتوي على تشكيلة شوكولاتة وتوفي كواليتي ستريت الفاخرة", "original_price": 45.00, "current_price": 39.95, "has_discount": true, "stock_quantity": 20, "unit_type": "grams", "size_volume": 375.0, "image_url": "https://placeholder.com/sweets/quality_street.png" }
        ]
      }
    ];

    try {
      // استخدام WriteBatch لضمان سرعة وموثوقية الرفع في طلب واحد متكامل
      WriteBatch batch = db.batch();

      for (var category in completeGroceryData) {
        String categoryId = category['id'];
        List products = category['products'];

        // مرجع مستند الفئة الرئيسي
        DocumentReference categoryDocRef = db.collection('categories').doc(categoryId);

        batch.set(categoryDocRef, {
          "name_ar": category['name_ar'],
          "name_en": category['name_en'],
          "icon": category['icon'],
          "color": category['color'],
        });

        // رفع المنتجات الفرعية داخل الـ Subcollection
        for (var product in products) {
          String productId = product['id'];

          DocumentReference productDocRef = categoryDocRef.collection('products').doc(productId);

          // تأكيد معالجة حقل size_volume المستبدل من قيمة null لتجنب أي تعارض في الفايربيس
          Map<String, dynamic> cleanProduct = Map<String, dynamic>.from(product);
          if (cleanProduct['size_volume'] == null) {
            cleanProduct['size_volume'] = 0.0;
          }

          batch.set(productDocRef, cleanProduct);
        }
      }

      // إرسال الـ Batch بالكامل دفعة واحدة إلى السيرفر
      await batch.commit();
      print("====== 🎉 مبروك يا خالد! تم حقن الـ 6 فئات والـ 60 منتجاً معاً بنجاح كامل! ======");

    } catch (e) {
      print("❌ حدث خطأ أثناء عملية رفع الـ Batch للبيانات: $e");
    }
  }
}


/// above navigateToHome() : splash_controller
// // 2. 🔥 تشغيل حقن البيانات في الخلفية فوراً عند فتح التطبيق
// injectDataOnStartup();

/// under onInit() : splash_controller
// // 👇 دالة مستقلة للحقن حتى لا تعطل الأنميشن أو الانتقال
// Future<void> injectDataOnStartup() async {
//   try {
//     print("⏳ [Seeder] بدأت عملية حقن البيانات من الـ SplashController خلف الكواليس...");
//     await FirestoreSeeder.seedAllGroceryData();
//     print("🏁 [Seeder] اكتملت محاولة حقن البيانات بنجاح.");
//   } catch (e) {
//     print("❌ [Seeder] فشل الحقن من الـ Splash بسبب: $e");
//   }
// }