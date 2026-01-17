import 'package:flutter/material.dart';
import 'login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  void _next() {
    if (_index < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _goLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        // 🌈 SAME GRADIENT AS SPLASH / LOGIN / OTP
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
              Color(0xFF0B1220),
              Color(0xFF0F172A),
            ]
                : const [
              Color(0xFFF2EEFF),
              Color(0xFFE3DCFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ─────────────── PAGES ───────────────
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: [
                    _page(
                      context,
                      title: "Track IoT Devices",
                      subtitle:
                      "Monitor machines, sensors, and production data in real time.",
                      image: "assets/images/intro1.png",
                    ),
                    _page(
                      context,
                      title: "Live Insights",
                      subtitle:
                      "Get instant alerts, analytics, and performance metrics.",
                      image: "assets/images/intro2.png",
                    ),
                    _page(
                      context,
                      title: "Manufacturing Excellence",
                      subtitle:
                      "Secure, reliable, and intelligent industrial monitoring.",
                      image: "assets/images/intro3.png",
                    ),
                  ],
                ),
              ),

              // ─────────────── DOT INDICATOR ───────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: _index == i ? 22 : 6,
                    decoration: BoxDecoration(
                      color: _index == i
                          ? Color(0xFF22D3EE)
                          : Color(0xFF22D3EE).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ─────────────── BUTTON ───────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _index == 2 ? _goLogin : _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF22D3EE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      _index == 2 ? "Get Started" : "Next",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────── INTRO PAGE UI ───────────────
  Widget _page(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String image,
      }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 280),
        const SizedBox(height: 28),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
