import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart' show AppToast;
import 'package:sundaram_iot_app/common/network/api_service.dart' show ApiService;

import 'package:sundaram_iot_app/core/constant/GridBackground.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';

import 'dashboard/dashboard_main.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _loginWithOtp = false;
  bool _loading = false;

  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  // ───────────────── LOGIN (API BASED) ─────────────────
  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty) {
      AppToast.show(context, "Username required");
      return;
    }

    if (!_loginWithOtp && _passwordController.text.trim().isEmpty) {
      AppToast.show(context, "Password required");
      return;
    }

    if (_loginWithOtp) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OTPScreen()),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await DioClient().post(
        '/PostLogin',
        {
          "UserName": _emailController.text.trim(),
          "Password": _passwordController.text.trim(),
        },
      );
      print('response---$response');

      final data = response.data;

      if (data is Map<String, dynamic> && data["Result"] == true) {
        AppToast.show(context, "Login successful");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardMain(),
          ),
        );
      } else {
        AppToast.show(context, "Invalid username or password");
      }
    } catch (e) {
      print('error---$e');
      AppToast.show(context, "Unable to connect to server");
    } finally {
      setState(() => _loading = false);
    }
  }

  // ───────────────── BUILD ─────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _animatedIcon(),
                    const SizedBox(height: 28),
                    _title(),
                    const SizedBox(height: 36),
                    _loginCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── BACKGROUND ─────────────────
  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0B1220),
            Color(0xFF0F172A),
            Color(0xFF020617),
          ],
        ),
      ),
      child: CustomPaint(child: GridBackground()),
    );
  }

  // ───────────────── ICON ─────────────────
  Widget _animatedIcon() {
    return Container(
      height: 78,
      width: 78,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF22D3EE), Color(0xFF0EA5E9)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.45),
            blurRadius: 32,
          ),
        ],
      ),
      child: const Icon(Icons.factory_rounded,
          color: Colors.black, size: 38),
    );
  }

  // ───────────────── TITLE ─────────────────
  Widget _title() {
    return const Column(
      children: [
        Text(
          "OEE MONITOR",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Manufacturing Excellence Platform",
          style: TextStyle(color: Colors.white60),
        ),
      ],
    );
  }

  // ───────────────── LOGIN CARD ─────────────────
  Widget _loginCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          _field(
            controller: _emailController,
            hint: "Username",
            icon: Icons.person_outline,
          ),
          if (!_loginWithOtp) ...[
            const SizedBox(height: 16),
            _field(
              controller: _passwordController,
              hint: "Password",
              icon: Icons.lock_outline,
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white54,
                ),
                onPressed: () =>
                    setState(() => _obscure = !_obscure),
              ),
            ),
          ],
          const SizedBox(height: 24),
          _primaryButton(),
          const SizedBox(height: 18),
          _otpToggle(),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _primaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _loading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF22D3EE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _loading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black,
          ),
        )
            : const Text(
          "Sign In",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _otpToggle() {
    return TextButton(
      onPressed: () =>
          setState(() => _loginWithOtp = !_loginWithOtp),
      child: Text(
        _loginWithOtp
            ? "Login with Password"
            : "Sign in with OTP",
        style: const TextStyle(color: Colors.cyanAccent),
      ),
    );
  }
}
