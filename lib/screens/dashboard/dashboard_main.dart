import 'dart:ui';
import 'package:flutter/material.dart';
import 'dashboard_home.dart';
import 'downtime_screen.dart';
import 'maintenance_screen.dart';
import 'live_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

class DashboardMain extends StatefulWidget {
  final int userId;
  final String username;

   DashboardMain({Key? key, required this.userId, required this.username}) : super(key: key);

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  int _index = 0;

  late final screens =  [
    DashboardHome(userId: widget.userId, username: widget.username),
    DowntimeScreen(),
    MaintenanceScreen(),
    LiveScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    print("userid..${widget.userId}");

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _bottomNav() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 72,
            color: const Color(0xFF111827).withOpacity(0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.grid_view_rounded, "Dashboard", 0),
                _navItem(Icons.warning_rounded, "Downtime", 1, ),
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

  Widget _navItem(
      IconData icon,
      String label,
      int index, {
        String? badge,
      }) {
    final isActive = _index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _index = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(icon,
                    size: 24,
                    color: isActive
                        ? const Color(0xFF38BDF8)
                        : Colors.grey),
                if (badge != null)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(badge,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)),
                    ),
                  )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10,
                  color: isActive
                      ? const Color(0xFF38BDF8)
                      : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
