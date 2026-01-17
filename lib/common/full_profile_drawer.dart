import 'package:flutter/material.dart';

class FullProfileDrawer extends StatelessWidget {
  const FullProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF22D3EE),
                child: Text("SA"),
              ),
              title: const Text("System Admin",
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text("Administrator",
                  style: TextStyle(color: Colors.white60)),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const Divider(color: Colors.white12),

            _menu(Icons.group, "User Management"),
            _menu(Icons.security, "Security"),
            _menu(Icons.settings, "Settings"),
            _menu(Icons.logout, "Logout", color: Colors.redAccent),
          ],
        ),
      ),
    );
  }

  static Widget _menu(IconData icon, String title,
      {Color color = Colors.white}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
    );
  }
}
