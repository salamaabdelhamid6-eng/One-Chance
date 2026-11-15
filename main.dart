import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

const navy = Color(0xFF0B1F3A), blue = Color(0xFF1E5EFF), sky = Color(0xFF5CC8FF);
const green = Color(0xFF22C55E), coral = Color(0xFFFF6B5A), bg = Color(0xFFF7F9FC);
const ink = Color(0xFF111827), muted = Color(0xFF6B7280);
const grad = LinearGradient(colors: [blue, sky]);

class Drill {
  final String t, tip;
  final List<String> s;
  const Drill(this.t, this.tip, this.s);
}

const drills = [
  Drill('حرف R الأمريكي', 'اسحب اللسان للخلف دون لمس سقف الفم، ولا تدحرج الحرف.',
      ['The red car is really rare.', 'Rory ran around the room.']),
  Drill('T المرنة (Flap T)', 'بين حرفين متحركين تُنطق T مثل D خفيفة: water ≈ wadder.',
      ['I got a better water bottle.', 'Get it a little later.']),
  Drill('صوت TH', 'ضع طرف اللسان بين الأسنان وانفخ الهواء.',
      ['I think this is the right path.', 'Thank you for the three gifts.']),
  Drill('Schwa', 'صوت قصير وضعيف في المقاطع غير المشدَّدة.',
      ['About a banana today.', 'The family has a problem.']),
  Drill('Minimal pairs', 'انتبه لطول الصوت بين ship وsheep.',
      ['The ship is near the sheep.', 'Please leave, I live here.']),
];

void main() => runApp(const OneChance());

class OneChance extends StatelessWidget {
  const OneChance({super.key});
  @override
  Widget build(BuildContext c) => MaterialApp(
        title: 'One Chance',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: blue),
          scaffoldBackgroundColor: bg,
          textTheme: GoogleFonts.cairoTextTheme(),
        ),
        home: const Splash(),
      );
}

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashS();
}

class _SplashS extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController a =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Shell()));
      }
    });
  }

  @override
  void dispose() {
    a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        backgroundColor: navy,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            AnimatedBuilder(
              animation: a,
              builder: (_, __) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  7,
                  (i) => Container(
                    width: 8,
                    height: 12 + 36 * sin(a.value * 2 * pi + i).abs(),
                    margin: const EdgeInsets.all(3),
                    decoration:
                        BoxDecoration(gradient: grad, borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('One Chance',
                style: GoogleFonts.manrope(
                    color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('فرصتك لإتقان الإنجليزية الأمريكية بثقة',
                style: GoogleFonts.cairo(color: sky)),
          ]),
        ),
      );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellS();
}

class _ShellS extends State<Shell> {
  int i = 0;
  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(child: [const Home(), const Lab(), const Progress()][i]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.graphic_eq_rounded), label: 'Accent Lab'),
            NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'التقدم'),
          ],
        ),
      );
}

Widget tile(IconData i, String t, String s, bool on, [VoidCallback? tap]) => Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: tap,
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(i, color: on ? blue : muted, size: 30),
        title: Text(t, style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
        subtitle: Text(s),
        trailing: on ? null : const Chip(label: Text('قريباً')),
      ),
    );

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext c) => ListView(padding: const EdgeInsets.all(20), children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(gradient: grad, borderRadius: BorderRadius.circular(24)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('One Chance',
                style: GoogleFonts.manrope(
                    color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('خطتك اليوم: 10 دقائق نطق أمريكي',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ]),
        ),
        const SizedBox(height: 16),
        tile(Icons.graphic_eq_rounded, 'Accent Lab', 'تمارين R وT-flap وSchwa', true),
        tile(Icons.record_voice_over_rounded, 'مدرب المحادثة AI', 'يتطلب Backend — المرحلة 2', false),
        tile(Icons.menu_book_rounded, 'المفردات والتعابير', 'SRS — المرحلة 3', false),
      ]);
}

class Lab extends StatelessWidget {
  const Lab({super.key});
  @override
  Widget build(BuildContext c) => ListView(padding: const EdgeInsets.all(20), children: [
        Text('Accent Lab',
            style: GoogleFonts.manrope(fontSize: 26, fontWeight: FontWeight.w800, color: ink)),
        const SizedBox(height: 12),
        for (final d in drills)
          tile(Icons.mic_rounded, d.t, d.tip, true,
              () => Navigator.push(c, MaterialPageRoute(builder: (_) => DrillPage(d)))),
      ]);
}

Future<void> bump() async {
  final p = await SharedPreferences.getInstance();
  p.setInt('done', (p.getInt('done') ?? 0) + 1);
  final now = DateTime.now();
  final today = now.toIso8601String().substring(0, 10);
  if (p.getString('last') != today) {
    final y = now.subtract(const Duration(days: 1)).toIso8601String().substring(0, 10);
    p.setInt('streak', p.getString('last') == y ? (p.getInt('streak') ?? 0) + 1 : 1);
    p.setString('last', today);
  }
}

class DrillPage extends StatefulWidget {
  final Drill d;
  const DrillPage(this.d, {super.key});
  @override
  State<DrillPage> createState() => _DrillS();
}

class _DrillS extends State<DrillPage> {
  final tts = FlutterTts();
  final stt = SpeechToText();
  int k = 0;
  int? score;
  String heard = '';
  bool on = false;

  @override
  void initState() {
    super.initState();
    tts.setLanguage('en-US');
    tts.setSpeechRate(0.45);
  }

  List<String> n(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z ]'), ' ')
      .split(RegExp(r'\s+'))
      .where((e) => e.isNotEmpty)
      .toList();

  Future<void> rec() async {
    if (!await stt.initialize()) {
      setState(() => heard = 'الميكروفون غير متاح');
      return;
    }
    setState(() {
      on = true;
      score = null;
    });
    stt.listen(
      localeId: 'en_US',
      listenFor: const Duration(seconds: 8),
      onResult: (r) async {
        if (!r.finalResult) return;
        final h = n(r.recognizedWords), t = n(widget.d.s[k]);
        final s = (100 * t.where(h.contains).length / t.length).round();
        if (s >= 70) await bump();
        if (mounted) {
          setState(() {
            on = false;
            heard = r.recognizedWords;
            score = s;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext c) {
    final d = widget.d;
    return Scaffold(
      appBar: AppBar(title: Text(d.t)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: sky.withOpacity(.15), borderRadius: BorderRadius.circular(16)),
            child: Text(d.tip),
          ),
          const SizedBox(height: 24),
          Text(d.s[k],
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w700, color: ink)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlinedButton.icon(
                onPressed: () => tts.speak(d.s[k]),
                icon: const Icon(Icons.volume_up),
                label: const Text('استمع')),
            const SizedBox(width: 12),
            FilledButton.icon(
                onPressed: on ? null : rec,
                icon: Icon(on ? Icons.hearing : Icons.mic),
                label: Text(on ? 'أستمع...' : 'تحدّث')),
          ]),
          const SizedBox(height: 20),
          if (score != null) ...[
            Text('$score%',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 44, fontWeight: FontWeight.w800, color: score! >= 70 ? green : coral)),
            Text(heard,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted)),
          ],
          const Spacer(),
          TextButton(
              onPressed: () => setState(() {
                    k = (k + 1) % d.s.length;
                    score = null;
                  }),
              child: const Text('الجملة التالية')),
        ]),
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({super.key});
  @override
  Widget build(BuildContext c) => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (_, s) {
          final p = s.data;
          return ListView(padding: const EdgeInsets.all(20), children: [
            Text('تقدّمك',
                style: GoogleFonts.cairo(fontSize: 26, fontWeight: FontWeight.w800, color: ink)),
            const SizedBox(height: 12),
            tile(Icons.local_fire_department, '${p?.getInt('streak') ?? 0} يوم', 'سلسلة الأيام', true),
            tile(Icons.check_circle, '${p?.getInt('done') ?? 0}', 'جمل أتقنتها', true),
          ]);
        },
      );
}
