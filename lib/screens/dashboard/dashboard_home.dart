import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';
import 'package:sundaram_iot_app/screens/dashboard/profile_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sundaram_iot_app/screens/dashboard/team_screen.dart';
import 'package:sundaram_iot_app/screens/dashboard/lines_screen.dart';
import 'alerts_screen.dart';
import 'profile_drawer.dart';

class DashboardHome extends StatefulWidget {
  final int userId;

   DashboardHome({super.key, required this.userId});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  List<Map<String, dynamic>> plants = [];
  bool isLoadingPlants = false;
  String selectedPlant = "";


  @override
  void initState() {
    super.initState();
    fetchPlants();
  }
  Future<void> fetchPlants() async {
    setState(() => isLoadingPlants = true);

    try {
      final response = await DioClient().post(
        '/Plant/list',
        {
          "userId": widget.userId,
        },
      );

      final data = response.data;

      if (data != null) {
        setState(() {
          plants = List<Map<String, dynamic>>.from(data);
          selectedPlant =
          plants.isNotEmpty ? plants.first["plantName"] : "";
        });
      } else {
        AppToast.show(context, "No plants found");
      }
    } catch (e) {
      print("Plant API Error: $e");
      AppToast.show(context, "Unable to fetch plants");
    } finally {
      setState(() => isLoadingPlants = false);
    }
  }


  /// Batch wise data
  final Map<String, List<_BatchData>> batchData = {
    "Plant A - North": [
      _BatchData("B1", 1200),
      _BatchData("B2", 980),
      _BatchData("B3", 1450),
    ],
    "Plant B - South": [
      _BatchData("B1", 860),
      _BatchData("B2", 1120),
      _BatchData("B3", 940),
    ],
    "Plant C - East": [
      _BatchData("B1", 1500),
      _BatchData("B2", 1380),
      _BatchData("B3", 1600),
    ],
  };

  /// Line wise production data
  final Map<String, List<_LineData>> lineData = {
    "Plant A - North": [
      _LineData("Line 1", 420),
      _LineData("Line 2", 380),
      _LineData("Line 3", 460),
    ],
    "Plant B - South": [
      _LineData("Line 1", 310),
      _LineData("Line 2", 360),
      _LineData("Line 3", 340),
    ],
    "Plant C - East": [
      _LineData("Line 1", 480),
      _LineData("Line 2", 520),
      _LineData("Line 3", 500),
    ],
  };

  /// Dispatch data (today)
  final Map<String, List<_DispatchData>> dispatchData = {
    "Plant A - North": [
      _DispatchData("Dispatched", 820, Color(0xFF22D3EE)),
      _DispatchData("Pending", 180, Color(0xFFF59E0B)),
      _DispatchData("Target Remaining", 200, Color(0xFFEF4444)),
    ],
    "Plant B - South": [
      _DispatchData("Dispatched", 640, Color(0xFF22D3EE)),
      _DispatchData("Pending", 260, Color(0xFFF59E0B)),
      _DispatchData("Target Remaining", 300, Color(0xFFEF4444)),
    ],
    "Plant C - East": [
      _DispatchData("Dispatched", 910, Color(0xFF22D3EE)),
      _DispatchData("Pending", 140, Color(0xFFF59E0B)),
      _DispatchData("Target Remaining", 150, Color(0xFFEF4444)),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _profileCard(),
                  const SizedBox(height: 14),
                  _plantSelector(),
                  const SizedBox(height: 18),
                  _quickActions(),
                  const SizedBox(height: 24),
                  _batchChart(),
                  const SizedBox(height: 24),
                  _lineChart(),
                  const SizedBox(height: 24),
                  _dispatchChart(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── HEADER ─────────
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Supervisor Dashboard",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Shift Morning",
                    style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
          _iconBtn(Icons.refresh),
          const SizedBox(width: 10),
          _iconBtn(Icons.notifications),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  // ───────── PROFILE ─────────
  Widget _profileCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SupervisorProfile ()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF0EA5E9), Color(0xFF020617)],
          ),
        ),
        child: Row(
          children: const [
            CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFF22D3EE),
              child: Text("SK",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Suresh Kumar",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text("Supervisor",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Text("06:00 - 14:00",
                style: TextStyle(
                    color: Color(0xFF22D3EE),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ───────── PLANT SELECTOR ─────────
  Widget _plantSelector() {
    return GestureDetector(
      onTap: _showPlantBottomSheet,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.factory, color: Color(0xFF22D3EE)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(selectedPlant,
                  style: const TextStyle(color: Colors.white)),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  // void _showPlantBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: const BoxDecoration(
  //         color: Color(0xFF0B1220),
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: plants.map((p) {
  //           return ListTile(
  //             title: Text(p, style: const TextStyle(color: Colors.white)),
  //             onTap: () {
  //               setState(() => selectedPlant = p);
  //               Navigator.pop(context);
  //             },
  //           );
  //         }).toList(),
  //       ),
  //     ),
  //   );
  // }
  void _showPlantBottomSheet() {
    if (isLoadingPlants) {
      AppToast.show(context, "Loading plants...");
      return;
    }

    if (plants.isEmpty) {
      AppToast.show(context, "No plants available");
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF0B1220),
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: plants.map((plant) {
            return ListTile(
              title: Text(
                plant["plantName"],
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  selectedPlant = plant["plantName"];
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // ───────── QUICK ACTIONS ─────────
  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.bar_chart,
            label: "Lines",
            color: const Color(0xFF0EA5E9),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LinesScreen(plant: selectedPlant),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.warning_amber,
            label: "Alerts",
            color: const Color(0xFFF59E0B),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AlertsScreen(plant: selectedPlant),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.groups,
            label: "Team",
            color: const Color(0xFF38BDF8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TeamScreen(plant: selectedPlant),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ───────── BATCH CHART ─────────
  Widget _batchChart() {
    return _chartCard(
      "Batch Wise Production",
      SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries<_BatchData, String>>[
          ColumnSeries<_BatchData, String>(
            dataSource: batchData[selectedPlant] ?? [],
          xValueMapper: (d, _) => d.batch,
            yValueMapper: (d, _) => d.units,
            color: const Color(0xFF22D3EE),
          ),
        ],
      ),
    );
  }

  // ───────── LINE CHART ─────────
  Widget _lineChart() {
    final colors = [
      const Color(0xFF22D3EE),
      const Color(0xFF4ADE80),
      const Color(0xFFF59E0B),
    ];

    return _chartCard(
      "Line Wise Production (Real-Time)",
      SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<_LineData, String>>[
          ColumnSeries<_LineData, String>(
            dataSource: lineData[selectedPlant]??[],
            xValueMapper: (d, _) => d.line,
            yValueMapper: (d, _) => d.units,
            pointColorMapper: (d, index) => colors[index % colors.length],
            dataLabelSettings:
            const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  // ───────── DISPATCH PIE CHART ─────────
  Widget _dispatchChart() {
    final data = dispatchData[selectedPlant]??[];

    final dispatchedItem = data.where((e) => e.status == "Dispatched").toList();

    final int dispatched =
    dispatchedItem.isNotEmpty ? dispatchedItem.first.value : 0;


    return _chartCard(
      "Today's Dispatch Status",
      SfCircularChart(
        margin: EdgeInsets.zero,
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : point.y cases',
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
          textStyle: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$dispatched",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Dispatched",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
        series: <CircularSeries<_DispatchData, String>>[
          DoughnutSeries<_DispatchData, String>(
            dataSource: data,
            xValueMapper: (d, _) => d.status,
            yValueMapper: (d, _) => d.value,
            pointColorMapper: (d, _) => d.color,
            radius: '85%',
            innerRadius: '65%', // ✅ DONUT LOOK
            explode: true,
            explodeIndex: 0,
            animationDuration: 900,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          SizedBox(height: 220, child: chart),
        ],
      ),
    );
  }
}

// ───────── QUICK ACTION WIDGET ─────────
class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _controller.forward();
        await _controller.reverse();
        widget.onTap();
      },
      child: Column(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(widget.icon, color: widget.color),
          ),
          const SizedBox(height: 8),
          Text(widget.label,
              style: const TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ───────── MODELS ─────────
class _BatchData {
  final String batch;
  final int units;
  _BatchData(this.batch, this.units);
}

class _LineData {
  final String line;
  final int units;
  _LineData(this.line, this.units);
}

class _DispatchData {
  final String status;
  final int value;
  final Color color;
  _DispatchData(this.status, this.value, this.color);
}
