import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/screens/login_screen.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  // 🔹 Example admin data (replace with API response)
  final Map<String, String> user = const {
    "name": "Rajesh Patel",
    "role": "Plant Head",
    "username": "planthead_tata",
    "email": "planthead@tata.com",
    "phone": "+91 9111111111",
    "designation": "Quality Engineer",
    "scope": "CUSTOMER",
    "entityId": "1",
    "joined": "Jan 12, 2022",
  };

  final Map<String, String> stats = const {
    "lastLogin": "Feb 01, 2026",
    "active": "Yes",
    "token": "TEMP_JWT_TOKEN",
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
              _header(),
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
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Admin Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("Manage your admin account",
                style: TextStyle(color: Colors.grey)),
          ],
        ),

      ],
    );
  }

  // ───────── PROFILE CARD ─────────
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1C2E), Color(0xFF060B16)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: const Color(0xFF22D3EE),
            child: Text(
              user["name"]!.substring(0, 2).toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(user["name"]!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22D3EE).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(user["role"]!,
                style: const TextStyle(color: Color(0xFF22D3EE))),
          ),
          const SizedBox(height: 6),

          _statsRow(),
        ],
      ),
    );
  }

  // ───────── STATS ─────────
  Widget _statsRow() {
    return Row(
      children: [
        // _statCard("Last Login", stats["lastLogin"]!),
        // const SizedBox(width: 10),
        // _statCard("Active", stats["active"]!),
        // const SizedBox(width: 10),
        // _statCard("Token", stats["token"]!.substring(0, 8) + "..."),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1220),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── PERSONAL INFO ─────────
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
          const Text("Admin Information",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          _infoRow(Icons.email, "Email", user["email"]!),
          _infoRow(Icons.phone, "Phone", user["phone"]!),
          _infoRow(Icons.work, "Designation", user["designation"]!),
          _infoRow(Icons.security, "Role", user["role"]!),

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
                Text(label,
                    style:
                    const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value,
                    style: const TextStyle(color: Colors.white)),
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
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
