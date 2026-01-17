import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/screens/admin/admin_home.dart' show AdminHome;
import 'package:sundaram_iot_app/screens/admin/admin_main.dart';
import 'package:sundaram_iot_app/screens/dashboard/dashboard_home.dart';
import 'package:sundaram_iot_app/screens/dashboard/dashboard_main.dart';
import 'package:sundaram_iot_app/screens/intro_screen.dart';
import 'package:sundaram_iot_app/screens/operator/operator_dashboard.dart';
import 'package:sundaram_iot_app/screens/operator/operator_home.dart';
import '../core/constant/GridBackground.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DashboardMain()),

    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌈 GRADIENT BACKGROUND (same as Login)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B1220),
                  Color(0xFF0F172A),
                ],
              ),
            ),
          ),

          // 🧩 GRID BACKGROUND
          // const GridBackground(),

          // 🌊 RIPPLE + LOGO
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripple rings
                ...List.generate(3, (i) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      final v = (_controller.value + i * 0.3) % 1;
                      return Container(
                        width: 140 + v * 120,
                        height: 140 + v * 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF22D3EE)
                                .withOpacity(1 - v),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  );
                }),

                // 🔷 CENTER ICON (NO ROTATION)
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7C7CFF),
                        Color(0xFF22D3EE),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C7CFF).withOpacity(0.45),
                        blurRadius: 30,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.factory_rounded,
                    size: 42,
                    color: Color(0xFF0B1220), // 👈 DARK ICON (premium)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
