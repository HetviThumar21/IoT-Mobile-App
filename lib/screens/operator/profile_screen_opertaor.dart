import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/screens/login_screen.dart';

class OperatorProfile extends StatelessWidget {
  const OperatorProfile({super.key});

  // 🔹 Future-ready user data
  final Map<String, String> user = const {
    "name": "Rajesh Kumar",
    "role": "Plant Operator",
    "empId": "EMP-2024-0156",
    "email": "rajesh.kumar@company.com",
    "phone": "+91 98765 43210",
    "department": "Production",
    "plant": "Plant A - Mumbai",
    "shift": "Day Shift (6:00 AM - 2:00 PM)",
    "joined": "Jan 12, 2022",
  };

  final Map<String, String> stats = const {
    "days": "892",
    "shifts": "1,284",
    "issues": "156",
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
            Text("Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("Manage your account",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        Icon(Icons.notifications, color: Colors.white),
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
            child: const Text(
              "RK",
              style: TextStyle(
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
          Text(user["empId"]!,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          _statsRow(),
        ],
      ),
    );
  }

  // ───────── STATS ─────────
  Widget _statsRow() {
    return Row(
      children: [
        _statCard("Days Active", stats["days"]!),
        const SizedBox(width: 10),
        _statCard("Shifts Completed", stats["shifts"]!),
        const SizedBox(width: 10),
        _statCard("Issues Resolved", stats["issues"]!),
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
                    fontSize: 18)),
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
          const Text("Personal Information",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          _infoRow(Icons.email, "Email", user["email"]!),
          _infoRow(Icons.phone, "Phone", user["phone"]!),
          _infoRow(Icons.business, "Department", user["department"]!),
          _infoRow(Icons.location_on, "Plant Location", user["plant"]!),
          _infoRow(Icons.schedule, "Current Shift", user["shift"]!),
          _infoRow(Icons.calendar_today, "Joined", user["joined"]!),
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
      "OEE Monitor v1.0.0 • Build 2024.01",
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }
}
