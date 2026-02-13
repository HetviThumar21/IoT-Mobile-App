import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';

import '../ui/glass_system.dart';
import 'admin/admin_main.dart';
import 'dashboard/dashboard_main.dart';
import 'operator/operator_dashboard.dart';

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {

  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _loading = false;

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

  // 🔥 VERIFY OTP API CALL
  Future<void> _verifyOtp() async {
    final enteredOtp = _controllers.map((e) => e.text).join();

    if (enteredOtp.length != 4) {
      AppToast.show(context, "Enter complete OTP");
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await DioClient().post(
        '/otp/verify',
        {
          "email": widget.email,
          "otp": enteredOtp,
        },
      );

      final data = response.data;
    print('reponse--$data');


      if (data != null && data["isSuccess"] == true) {

        final String token = data["token"] ?? "";
        final Map<String, dynamic> user = data["user"] ?? {};

        final int roleId = user["roleId"] ?? 0;
        final int userId = user["userId"] ?? 0;

        // 🔐 Save token securely
        await _storage.write(key: "auth_token", value: token);
        await _storage.write(key: "role_id", value: roleId.toString());
        await _storage.write(key: "user_id", value: userId.toString());

        AppToast.show(context, data["message"] ?? "Login successful");

        // 🎯 Role Based Navigation
        Widget nextScreen;

        // if (roleId == 11) {
        //   nextScreen = const AdminMain();
        // } else if (roleId == 14) {
        //   nextScreen = const DashboardMain();
        // } else if (roleId == 15) {
        //   nextScreen = const OperatorDashboard();
        // } else {
        //   nextScreen = const DashboardMain();
        // }

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

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
              (route) => false,
        );

      } else {
        _shakeController.forward(from: 0);
        AppToast.show(context, data?["message"] ?? "Invalid OTP");
      }

    } catch (e) {
      print("OTP Verify Error: $e");
      AppToast.show(context, "Unable to verify OTP");
    } finally {
      setState(() => _loading = false);
    }
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
                    Text(
                      "Enter the 4-digit code sent to ${widget.email}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, _otpBox),
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
                        onPressed: _loading ? null : _verifyOtp,
                        child: _loading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                            : const Text(
                          "Verify",
                          style: TextStyle(
                              fontWeight:
                              FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextButton(
                      onPressed: () {
                        AppToast.show(
                            context, "OTP resend feature coming soon");
                      },
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
        style: const TextStyle(
            color: Colors.white, fontSize: 20),
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
