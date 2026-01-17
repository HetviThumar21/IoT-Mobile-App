import 'package:flutter/material.dart';
import '../../screens/dashboard/dashboard_main.dart';

class NavigationConfig {
  static Widget destinationForLogin(Map<String, dynamic> data) {
    /// 🔥 Backend-driven routing
    final role = data["Role"]?.toString().toLowerCase();

    switch (role) {
      case "admin":
      case "supervisor":
      case "manager":
      default:
        return const DashboardMain();
    }
  }
}
