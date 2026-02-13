import 'package:flutter/material.dart';
import 'operator_home.dart';
import 'operator_downtime.dart';
import 'operator_maintenance.dart';
import 'profile_screen_opertaor.dart';

class OperatorDashboard extends StatefulWidget {
  final int userId;

  const OperatorDashboard({Key? key, required this.userId}) : super(key: key);
  @override
  State<OperatorDashboard> createState() => _OperatorDashboardState();
}

class _OperatorDashboardState extends State<OperatorDashboard> {
  int _currentIndex = 0;

  // 🔑 SINGLE SOURCE OF TRUTH
  String selectedPlant = "Plant A - North";
  String selectedLine = "Line 2";
  String selectedBatch = "BATCH-4587";

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      OperatorHome(
        plant: selectedPlant,
        line: selectedLine,
        batch: selectedBatch,
        onContextChanged: (plant, line, batch) {
          setState(() {
            selectedPlant = plant;
            selectedLine = line;
            selectedBatch = batch;
          });
        },
      ),
      OperatorDowntime(),
      const OperatorMaintenance(),
      const OperatorProfile(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF0B1220),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.warning_amber), label: "Downtime"),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), label: "Maintenance"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
