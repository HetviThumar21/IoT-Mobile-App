import 'package:flutter/material.dart';

class AdminProfileDrawer extends StatelessWidget {
  const AdminProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF020617),
      child: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF22D3EE),
                    child: Text("SK",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Suresh Kumar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text("Supervisor",
                          style: TextStyle(color: Colors.grey)),
                      Text("Online",
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),

            const Divider(color: Colors.grey),

            _drawerItem(Icons.person, "Manage Profile"),
            _drawerItem(Icons.settings, "Settings"),
            _drawerItem(Icons.security, "Security"),
            _drawerItem(Icons.palette, "Appearance"),
            _drawerItem(Icons.help_outline, "Help & Support"),

            const Spacer(),

            /// LOGOUT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text("Logout",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const Text("Version 1.0.0 • OEE Monitor",
                style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  static Widget _drawerItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing:
      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }
}
