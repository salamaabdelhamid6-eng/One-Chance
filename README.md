# One Chance — فرصتك لإتقان الإنجليزية الأمريكية بثقة

*One Chance — Your One Chance to Speak American English with Confidence.*

## 1. ملخص المنتج (PRD)
- **الفئة:** ناطقون بالعربية، من مبتدئ إلى متقدم، يريدون لهجة General American وطلاقة.
- **الفكرة:** تدريب صوتي تفاعلي (نطق، محادثة، استماع، مفردات) مع تغذية راجعة فورية.
- **نجاح MVP:** المستخدم يتدرّب يومياً على النطق ويرى تقدمه وسلسلة أيامه.
- **مدرب المحادثة AI:** يحتاج Backend وسيط (لا مفاتيح API داخل التطبيق) — المرحلة 2.

## 2. الشاشات
Splash · Onboarding (الهدف + اختبار المستوى) · الرئيسية (خطة اليوم) · المحادثة (سيناريوهات + تقرير) · Accent Lab · الطلاقة · المفردات (SRS) · الاستماع · التقدم · الإعدادات (الخصوصية، حذف التسجيلات، اللغة).
**المنفّذ في MVP الحالي:** Splash، الرئيسية، Accent Lab (5 تمارين بتقييم صوتي)، التقدم (سلسلة الأيام وعدد الجمل).

## 3. User flows
1. **أول استخدام:** Splash ← اختيار الهدف ← اختبار مستوى صوتي ← خطة يومية ← الرئيسية.
2. **تمرين نطق:** Accent Lab ← تمرين ← استماع للنموذج ← تسجيل ← نسبة ووصف ← الجملة التالية.
3. **محادثة AI:** اختيار سيناريو ← محادثة صوتية ← تصحيح لطيف ← تقرير (WPM، توقفات، نطق).
4. **مراجعة يومية:** بطاقات SRS المستحقة ← تقييم ← جدولة.

## 4. نموذج البيانات
- `users(id, goal, level, locale, created_at)`
- `sessions(id, user_id, type, scenario, started_at, duration_s, wpm, fluency, pronunciation, audio_url)`
- `utterances(id, session_id, text, corrections jsonb, scores jsonb)`
- `vocab_items(id, phrase, kind, example, audio_url)` · `srs_cards(user_id, item_id, due_at, ease, interval)`
- `progress_daily(user_id, date, minutes, streak)` · `badges(user_id, code, earned_at)`

## 5. APIs
`POST /auth` · `POST /placement/start|submit` · `GET /plan/today` · `POST /sessions` (توكن realtime) · `POST /sessions/:id/audio` · `GET /sessions/:id/report` · `POST /pronunciation/assess` · `GET /srs/due` · `POST /srs/review` · `GET /progress` · `DELETE /me/audio`

## 6. هيكل المشروع
```
lib/main.dart        واجهة MVP (يُقسَّم لاحقاً: features/ core/ data/)
scripts/android_setup.sh   صلاحيات، minSdk، اسم الحزمة، توقيع Release
.github/workflows/build-apk.yml   بناء APK على GitHub
```
**الصلاحيات:** الميكروفون، الإنترنت، الإشعارات فقط. **اسم الحزمة:** `com.onechance.app`.

## 7. خطة التنفيذ
- **أسبوع 1–2 (MVP الحالي +):** Onboarding، حفظ الهدف، المزيد من تمارين Accent Lab، شاشة الخصوصية وموافقة التسجيل.
- **أسبوع 3–4:** Backend (FastAPI + PostgreSQL)، المصادقة، Azure Pronunciation Assessment.
- **أسبوع 5–6:** مدرب المحادثة (STT + LLM + TTS أمريكي) وتقرير الطلاقة.
- **بعدها:** SRS، الاستماع، التحفيز والإشعارات، الدفع (RevenueCat).

## 8. البناء والتثبيت
**محلياً** (Flutter 3.22+ وJDK 17):
```
flutter create --org com.onechance --project-name one_chance --platforms android .
bash scripts/android_setup.sh
flutter pub get
flutter build apk --release
```
الناتج: `build/app/outputs/flutter-apk/app-release.apk`

**عبر GitHub:** ارفع المشروع، ثم Actions ← Build APK ← Run workflow، ونزّل `one-chance-apk`.
**للتوقيع الحقيقي** أضف أسرار المستودع: `KEYSTORE_B64` (ملف jks بصيغة base64) و`KEYSTORE_PASSWORD` و`KEY_ALIAS` و`KEY_PASSWORD`. بدونها يُوقَّع APK بمفتاح debug للتجربة فقط.

**التثبيت:** انقل الملف للهاتف، واسمح بالتثبيت من مصدر غير معروف، ثم افتحه.

## ملاحظات
- لم يُختبر البناء داخل المحادثة (لا يوجد Flutter SDK هنا)، لذا شغّل الـ workflow وأخبرني بأي خطأ لأصلحه.
- الأيقونة والخطوط: الخط يُحمَّل عبر `google_fonts`. الأيقونة تُضاف بحزمة `flutter_launcher_icons` في الخطوة التالية.
