import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart' show AppToast;
import 'package:sundaram_iot_app/common/network/api_service.dart' show ApiService;

import 'package:sundaram_iot_app/core/constant/GridBackground.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';
import 'package:sundaram_iot_app/screens/admin/admin_main.dart';

import 'dashboard/dashboard_main.dart';
import 'operator/operator_dashboard.dart';
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
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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



  Future<void> _login() async {
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty) {
      AppToast.show(context, "Username required");
      return;
    }

    if (!_loginWithOtp && password.isEmpty) {
      AppToast.show(context, "Password required");
      return;
    }

    if (_loginWithOtp) {

      if (username.isEmpty) {
        AppToast.show(context, "Email required");
        return;
      }

      setState(() => _loading = true);

      try {
        final response = await DioClient().post(
          '/otp/send',
          {
            "email": username,
          },
        );

        final data = response.data;

        if (data != null && data["isSuccess"] == true) {

          AppToast.show(context, data["message"] ?? "OTP Sent Successfully");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OTPScreen(email: username),
            ),
          );

        } else {
          AppToast.show(
            context,
            data?["message"] ?? "Failed to send OTP",
          );
        }

      } catch (e) {
        print("OTP Error: $e");
        AppToast.show(context, "Unable to send OTP");
      } finally {
        setState(() => _loading = false);
      }

      return;
    }


    setState(() => _loading = true);

    try {
      final response = await DioClient().post(
        '/login',
        {
          "loginName": username,
          "password": password,
        },
      );

      final data = response.data;

      if (data != null && data["isSuccess"] == true) {

        final String token = data["token"] ?? "";
        final Map<String, dynamic> user = data["user"] ?? {};

        final int roleId = user["roleId"] ?? 0;
        final int userId = user["userId"] ?? 0;
        final String roleName = user["roleName"] ?? "";

        /// 🔐 Save token & user info securely
        await _storage.write(key: "auth_token", value: token);
        await _storage.write(key: "role_id", value: roleId.toString());
        await _storage.write(key: "user_id", value: userId.toString());

        AppToast.show(context, data["message"] ?? "Login successful");

        print("Saved Token: $token");
        print("Role ID: $roleId");

        /// 🎯 Role Based Navigation
        Widget nextScreen;

        if (roleId == 11) {
          nextScreen = AdminMain( userId: userId,);      // Admin
        } else if (roleId == 14) {
          nextScreen =  DashboardMain(userId: userId,); // Supervisor
        } else if (roleId == 15) {
          nextScreen =  OperatorDashboard(userId: userId,);   // Operator
        }
        else {
          nextScreen =  DashboardMain(userId: userId,);       // Default
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
        );

      } else {
        AppToast.show(
          context,
          data?["message"] ?? "Invalid username or password",
        );
      }

    } catch (e) {
      print('Login Error: $e');
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
          "iManufactory",
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