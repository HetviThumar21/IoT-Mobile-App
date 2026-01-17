import 'package:flutter/material.dart';
import 'maintenance_requests_screen.dart';

class AdminMaintenance extends StatefulWidget {
  const AdminMaintenance({super.key});

  @override
  State<AdminMaintenance> createState() => _AdminMaintenanceState();
}

class _AdminMaintenanceState extends State<AdminMaintenance> {
  final List<String> filters = ["All", "Critical", "Warning", "Healthy"];
  int selectedFilter = 0;

  final List<Map<String, dynamic>> machines = [
    {"name": "Hydraulic Pump", "machine": "Filler #2", "status": "Critical"},
    {"name": "Drive Motor", "machine": "Conveyor 1", "status": "Warning"},
    {"name": "Label Applicator", "machine": "Labeler #1", "status": "Healthy"},
    {"name": "Servo Motor", "machine": "Packer #3", "status": "Healthy"},
  ];

  List<Map<String, dynamic>> get filteredMachines {
    if (selectedFilter == 0) return machines;
    return machines
        .where((m) => m["status"] == filters[selectedFilter])
        .toList();
  }

  int get criticalCount =>
      machines.where((m) => m["status"] == "Critical").length;
  int get warningCount =>
      machines.where((m) => m["status"] == "Warning").length;
  int get healthyCount =>
      machines.where((m) => m["status"] == "Healthy").length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// 🔥 STICKY HEADER
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFF0B1220),
              elevation: 0,
              title: const Text(
                "Maintenance",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    /// 🔥 CLICKABLE REQUEST CARD
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const MaintenanceRequestsScreen(),
                          ),
                        );
                      },
                      child: _maintenanceRequestSummary(),
                    ),

                    const SizedBox(height: 24),

                    _circularHealthGraph(),

                    const SizedBox(height: 24),

                    _filters(),

                    const SizedBox(height: 16),

                    ...filteredMachines.map(_machineCard).toList(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= REQUEST SUMMARY CARD =================
  Widget _maintenanceRequestSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: const [
          Icon(Icons.assignment, color: Color(0xFF22D3EE), size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Maintenance Requests",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "View & approve pending requests",
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              color: Colors.white38, size: 16),
        ],
      ),
    );
  }

  // ================= CIRCULAR GRAPH =================
  Widget _circularHealthGraph() {
    final total = machines.length.toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Text(
            "Equipment Health Overview",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: _DonutPainter(
                critical: criticalCount / total,
                warning: warningCount / total,
                healthy: healthyCount / total,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTERS =================
  Widget _filters() {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final active = selectedFilter == i;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = i),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF22D3EE)
                    : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                filters[i],
                style:
                TextStyle(color: active ? Colors.black : Colors.white70),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= MACHINE CARD =================
  Widget _machineCard(Map<String, dynamic> m) {
    final statusColor = m["status"] == "Critical"
        ? Colors.redAccent
        : m["status"] == "Warning"
        ? Colors.orangeAccent
        : Colors.greenAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m["name"],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(m["machine"],
                      style: const TextStyle(color: Colors.white60)),
                ]),
          ),
          Text(m["status"],
              style: TextStyle(
                  color: statusColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// ================= DONUT PAINTER =================
class _DonutPainter extends CustomPainter {
  final double critical;
  final double warning;
  final double healthy;

  _DonutPainter(
      {required this.critical,
        required this.warning,
        required this.healthy});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 3;
    double start = -1.5708;

    void draw(double sweep, Color color) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start,
          sweep, false, paint);
      start += sweep;
    }

    draw(critical * 6.283, Colors.redAccent);
    draw(warning * 6.283, Colors.orangeAccent);
    draw(healthy * 6.283, Colors.greenAccent);
  }

  @override
  bool shouldRepaint(_) => true;
}
