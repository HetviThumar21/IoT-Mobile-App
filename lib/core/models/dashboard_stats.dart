class DashboardStats {
  final int totalMachines;
  final int activeMachines;
  final int faultyMachines;
  final int alertsToday;

  DashboardStats({
    required this.totalMachines,
    required this.activeMachines,
    required this.faultyMachines,
    required this.alertsToday,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalMachines: json['total_machines'],
      activeMachines: json['active_machines'],
      faultyMachines: json['faulty_machines'],
      alertsToday: json['alerts_today'],
    );
  }
}
