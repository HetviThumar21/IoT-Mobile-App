import 'dart:ui';

import 'package:flutter/material.dart';

import 'admin_home.dart';
import 'admin_downtime.dart';
import 'admin_maintenance.dart';
import 'admin_live.dart';
import 'admin_profile_screen.dart';
import 'admin_reports.dart';
import 'admin_profile_drawer.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AdminHome(
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (
                  _) => const AdminProfile(), // <-- your AdminProfile screen
            ),
          );
        },
      ),

      const AdminDowntime(),
      const AdminMaintenance(),
      const AdminLive(),
      const ReportsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0B1220),

      // 🔥 PROFILE SCREEN (drawer removed, use navigation instead)
      body: _screens[_currentIndex],

      // Modern Bottom Navigation
      bottomNavigationBar: _bottomNav(),
    );
  }

// ───────── MODERN BOTTOM NAVIGATION ─────────
  Widget _bottomNav() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 65,
            color: const Color(0xFF111827).withOpacity(0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.grid_view_rounded, "Dashboard", 0),
                _navItem(Icons.warning_rounded, "Downtime", 1),
                _navItem(Icons.build_rounded, "Maintenance", 2),
                _navItem(Icons.monitor_heart_rounded, "Live", 3),
                _navItem(Icons.description_rounded, "Reports", 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon,
      String label,
      int index, {
        String? badge,
      }) {
    final isActive = _currentIndex == index; // ✅ use _currentIndex

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        // ✅ update _currentIndex
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: 20, // smaller icon
                  color: isActive ? const Color(0xFF38BDF8) : Colors.grey,
                ),
                if (badge != null)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: Colors.red,
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // prevent wrapping
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10, // smaller font
                color: isActive ? const Color(0xFF38BDF8) : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}