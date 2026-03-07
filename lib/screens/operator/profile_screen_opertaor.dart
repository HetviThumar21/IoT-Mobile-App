import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';
import 'package:sundaram_iot_app/screens/login_screen.dart';

class OperatorProfile extends StatefulWidget {
  final int userId;

  const OperatorProfile({super.key, required this.userId});

  @override
  State<OperatorProfile> createState() => _OperatorProfileState();
}

class _OperatorProfileState extends State<OperatorProfile> {

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response =
      await DioClient().get('getuserprofile/${widget.userId}');

      final data = response.data;

      if (data != null && data["success"] == true) {
        setState(() {
          userData = data["data"];
          isLoading = false;
        });
      } else {
        AppToast.show(context, data?["message"] ?? "Failed to load profile");
        setState(() => isLoading = false);
      }
    } catch (e) {
      AppToast.show(context, "Unable to fetch profile");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B1220),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
    final name = userData?["fullName"] ?? "-";
    final designation = userData?["designationName"] ?? "-";
    final roleName = userData?["roleName"] ?? "-";
    final username = userData?["username"] ?? "-";

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1C2E), Color(0xFF060B16)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22D3EE).withOpacity(0.08),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [

          // 🔹 Avatar with Glow Ring
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF22D3EE), Color(0xFF0EA5E9)],
              ),
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: const Color(0xFF0B1220),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "-",
                style: const TextStyle(
                  color: Color(0xFF22D3EE),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // 🔹 Full Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 6),

          // 🔹 Designation Badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF22D3EE), Color(0xFF06B6D4)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              designation,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 🔹 Divider Line
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withOpacity(0.08),
          ),

          const SizedBox(height: 14),

          // 🔹 Role + Username Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniInfo("Role", roleName),
              _miniInfo("Username", username),
            ],
          ),
        ],
      ),
    );
  }
  Widget _miniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

          _infoRow(Icons.email, "Email",
              userData?["email"] ?? "-"),

          _infoRow(Icons.phone, "Mobile",
              userData?["mobileNo"] ?? "-"),

          _infoRow(Icons.badge, "Role",
              userData?["roleName"] ?? "-"),

          _infoRow(Icons.work, "Designation",
              userData?["designationName"] ?? "-"),

          _infoRow(Icons.security, "Scope",
              userData?["userScope"] ?? "-"),

          _infoRow(Icons.verified_user, "Active",
              userData?["isActive"] == true ? "Yes" : "No"),

          _infoRow(Icons.login, "First Login",
              userData?["isFirstLogin"] == true ? "Yes" : "No"),
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
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12)),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
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