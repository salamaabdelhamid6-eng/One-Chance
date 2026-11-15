#!/usr/bin/env bash
# يُشغَّل بعد: flutter create --org com.onechance --project-name one_chance --platforms android .
set -e
M=android/app/src/main/AndroidManifest.xml
G=$(ls android/app/build.gradle.kts android/app/build.gradle 2>/dev/null | head -1)

# الصلاحيات المطلوبة فقط + اسم التطبيق + دعم التعرف على الصوت
sed -i 's#<application#<uses-permission android:name="android.permission.RECORD_AUDIO"/><uses-permission android:name="android.permission.INTERNET"/><uses-permission android:name="android.permission.POST_NOTIFICATIONS"/><application#' $M
sed -i 's#<queries>#<queries><intent><action android:name="android.speech.RecognitionService"/></intent>#' $M
sed -i 's#android:label="one_chance"#android:label="One Chance"#' $M

# minSdk 24 (مطلوب لـ speech_to_text) + اسم الحزمة
sed -i 's/minSdk = flutter.minSdkVersion/minSdk = 24/; s/minSdkVersion flutter.minSdkVersion/minSdkVersion 24/' $G
sed -i 's/applicationId = "com.onechance.one_chance"/applicationId = "com.onechance.app"/; s/applicationId "com.onechance.one_chance"/applicationId "com.onechance.app"/' $G

# توقيع Release عبر أسرار البيئة (إن وُجدت)، وإلا يُوقَّع بمفتاح debug للتجربة
if [ -n "$KEYSTORE_B64" ] && [[ "$G" == *.kts ]]; then
  echo "$KEYSTORE_B64" | base64 -d > android/app/upload.jks
  python3 - <<'PY'
p='android/app/build.gradle.kts'
s=open(p).read()
cfg='''    signingConfigs {
        create("release") {
            storeFile = file("upload.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = System.getenv("KEY_ALIAS")
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }
'''
s=s.replace('    buildTypes {',cfg+'    buildTypes {',1)
s=s.replace('signingConfigs.getByName("debug")','signingConfigs.getByName("release")')
open(p,'w').write(s)
PY
fi
