import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/screens/login_screen.dart';

class SupervisorProfile extends StatelessWidget {
  const SupervisorProfile({super.key});

  /// 🔹 Supervisor data (replace with API later)
  final Map<String, String> user = const {
    "name": "Suresh Kumar",
    "role": "Supervisor",
    "designation": "Production Supervisor",
    "plant": "Plant A - North",
    "email": "suresh.kumar@company.com",
    "phone": "+91 9888888888",
    "joined": "Mar 08, 2023",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _header(context),
              const SizedBox(height: 20),
              _profileCard(),
              const SizedBox(height: 20),
              _personalInfo(),
              const SizedBox(height: 30),
              _logoutButton(context),
              const SizedBox(height: 14),
              _versionInfo(),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── HEADER ─────────
  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Supervisor Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Your account details",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // ───────── PROFILE CARD ─────────
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF101B2F),
            Color(0xFF050914),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF22D3EE).withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          /// AVATAR WITH RING
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF22D3EE),
                  Color(0xFF0EA5E9),
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFF020617),
              child: Text(
                user["name"]!.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF22D3EE),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// NAME
          Text(
            user["name"]!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 6),

          /// ROLE CHIP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF22D3EE).withOpacity(0.25),
                  const Color(0xFF22D3EE).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF22D3EE).withOpacity(0.4),
              ),
            ),
            child: Text(
              user["role"]!,
              style: const TextStyle(
                color: Color(0xFF22D3EE),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ───────── SUPERVISOR INFO ─────────
  Widget _personalInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1C2E), Color(0xFF060B16)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Supervisor Information",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(Icons.work, "Designation", user["designation"]!),
          _infoRow(Icons.factory, "Plant", user["plant"]!),
          _infoRow(Icons.email, "Email", user["email"]!),
          _infoRow(Icons.phone, "Phone", user["phone"]!),
          _infoRow(Icons.date_range, "Joined On", user["joined"]!),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF22D3EE)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────── LOGOUT ─────────
  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        icon: const Icon(Icons.logout),
        label: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ───────── VERSION ─────────
  Widget _versionInfo() {
    return const Text(
      "OEE Monitor v1.0.0 • Build 2026.01",
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }
}
