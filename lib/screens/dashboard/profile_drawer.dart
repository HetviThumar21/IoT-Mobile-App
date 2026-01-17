import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Column(
          children: [
            // ───────── HEADER ─────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0EA5E9),
                    Color(0xFF020617),
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF22D3EE),
                    child: Text(
                      "SK",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Suresh Kumar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Supervisor",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Online",
                          style: TextStyle(
                            color: Color(0xFF22D3EE),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ───────── MENU ITEMS ─────────
            _menuItem(Icons.person, "Manage Profile"),
            _menuItem(Icons.settings, "Settings"),
            _menuItem(Icons.security, "Security"),
            _menuItem(Icons.dark_mode, "Appearance"),
            _menuItem(Icons.help_outline, "Help & Support"),

            const Spacer(),

            // ───────── LOGOUT ─────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent),
                  gradient: LinearGradient(
                    colors: [
                      Colors.redAccent.withOpacity(0.25),
                      Colors.redAccent.withOpacity(0.05),
                    ],
                  ),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: logout logic
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "Version 1.0.0 • OEE Monitor",
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ───────── MENU TILE ─────────
  static Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white.withOpacity(0.08),
        child: Icon(icon, color: const Color(0xFF22D3EE)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing:
      const Icon(Icons.chevron_right, color: Colors.white38),
      onTap: () {},
    );
  }
}
