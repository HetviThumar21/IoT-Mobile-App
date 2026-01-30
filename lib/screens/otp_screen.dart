import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import '../ui/glass_system.dart';
import '../screens/dashboard/dashboard_main.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final String _correctOtp = "1234"; // dummy OTP

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 80,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black.withOpacity(0.65),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

  void _verifyOtp() {
    final enteredOtp =
    _controllers.map((e) => e.text).join();

    if (enteredOtp != _correctOtp) {
      _shakeController.forward(from: 0);
      AppToast.show(context,"Invalid OTP");
      return;
    }

    AppToast.show(context,"Login successful");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardMain(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F172A),
              Color(0xFF020617),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (_, child) => Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: child,
              ),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Enter the 4-digit code sent to your email",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 28),

                    // ✅ NO OVERFLOW: Row wrapped with SizedBox + spaceEvenly
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children:
                        List.generate(4, _otpBox),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF22D3EE),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: _verifyOtp,
                        child: const Text(
                          "Verify",
                          style:
                          TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextButton(
                      onPressed: () =>
                          _showToast("OTP resent"),
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: Color(0xFF22D3EE),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🟦 OTP BOX (BORDER + CURSOR COLOR FIXED)
  Widget _otpBox(int index) {
    return SizedBox(
      width: 56,
      height: 56,
      child: TextField(
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        cursorColor: const Color(0xFF22D3EE),
        style:
        const TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white.withOpacity(0.10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF22D3EE),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF22D3EE),
              width: 2,
            ),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
          if (v.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}