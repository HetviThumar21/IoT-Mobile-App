import 'package:flutter/material.dart';

import 'admin_home.dart';
import 'admin_downtime.dart';
import 'admin_maintenance.dart';
import 'admin_live.dart';
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
          _scaffoldKey.currentState?.openDrawer();
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

      /// 🔥 PROFILE DRAWER
      drawer: const AdminProfileDrawer(),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF10182C),
        selectedItemColor: const Color(0xFF22D3EE),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.timer), label: "Downtime"),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), label: "Maintenance"),
          BottomNavigationBarItem(
              icon: Icon(Icons.monitor), label: "Live"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: "Reports"),
        ],
      ),
    );
  }
}
