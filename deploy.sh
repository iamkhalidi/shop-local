#!/bin/bash

# الحصول على التاريخ الحالي
CURRENT_DATE=$(date +"%Y/%m/%d %I:%M %p")

# تحديث ملف الـ version
cat <<EOF > lib/core/utils/version_constants.dart
class AppVersion {
  static const String buildDate = "$CURRENT_DATE";
}
EOF

echo "✅ Shop Local Version updated: $CURRENT_DATE"

# بناء نسخة الويب
echo "🚀 Building Shop Web..."
flutter build web --release

# الرفع إلى Firebase
echo "🔥 Deploying to Firebase..."
firebase deploy

echo "✨ Done! Shop is live with version stamp."
