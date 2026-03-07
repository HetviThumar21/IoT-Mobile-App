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
  final String username;

   DashboardHome({super.key, required this.userId, required this.username});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  List<Map<String, dynamic>> plants = [];
  bool isLoadingPlants = false;
  String selectedPlant = "";
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  int? selectedPlantId;

  bool isLoadingDashboard = false;

  List<dynamic> lineProduction = [];
  List<dynamic> downtime = [];
  List<dynamic> dispatchSummary = [];
  Map<String, dynamic>? batchSummary;

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }
  Future<void> fetchPlants() async {
    setState(() => isLoadingPlants = true);

    try {
      final response =
      await DioClient().get('userplants/${widget.userId}');

      final data = response.data;

      if (data != null && data is List) {
        setState(() {
          plants = List<Map<String, dynamic>>.from(data);
        });
      } else {
        AppToast.show(context, "No plants found");
      }
    } catch (e) {
      AppToast.show(context, "Unable to fetch plants");
    } finally {
      setState(() => isLoadingPlants = false);
    }
  }




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
                  const SizedBox(height: 12),
                  _dateRangeCard(),
                  const SizedBox(height: 18),
                  _quickActions(),
                  const SizedBox(height: 24),
                  _dailyProductionGraph(),
                  const SizedBox(height: 24),
                  _lineProductionGraph(),
                  const SizedBox(height: 24),
                  _dispatchGraph(),
                  const SizedBox(height: 24),
                  _downtimeGraph(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // _dailyProductionGraph(),
  // _lineProductionGraph(),
  // _dispatchGraph(),
  // _downtimeGraph(),
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
          // _iconBtn(Icons.refresh),
          // const SizedBox(width: 10),
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
          MaterialPageRoute(builder: (_) =>  SupervisorProfile (userId: widget.userId,)),
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
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFF22D3EE),
              child: Text("SK",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.username}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const Text("Supervisor",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
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
  Widget _dateRangeCard() {
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range, color: Color(0xFF22D3EE)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "${_formatDisplayDate(fromDate)}  →  ${_formatDisplayDate(toDate)}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white54)
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    if (selectedPlantId == null) {
      AppToast.show(context, "Please select plant first");
      return;
    }

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: fromDate, end: toDate),
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });

      fetchPlantDashboard(); // 🔥 CALL API
    }
  }

  String _formatDate(DateTime date) {
    return date.toUtc().toIso8601String();
  }

  String _formatDisplayDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  Future<void> fetchPlantDashboard() async {
    setState(() => isLoadingDashboard = true);

    try {
      final response = await DioClient().post(
        'plantheaddashboard/report',
        {
          "userId": widget.userId,
          "plantId": selectedPlantId,
          "fromDate": _formatDate(fromDate),
          "toDate": _formatDate(toDate),
        },
      );

      final data = response.data;

      if (data["success"] == true) {
        setState(() {
          lineProduction = data["lineProduction"] ?? [];
          downtime = data["downtime"] ?? [];
          dispatchSummary = data["dispatchSummary"] ?? [];
          batchSummary = data["batchSummary"];
        });
      } else {
        AppToast.show(context, "Failed to load data");
      }
    } catch (e) {
      AppToast.show(context, "Error loading dashboard");
    } finally {
      setState(() => isLoadingDashboard = false);
    }
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
                    selectedPlantId = plant["plantId"];
                  });
                  Navigator.pop(context);
                },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _dailyProductionGraph() {
    if (lineProduction.isEmpty) return const SizedBox();

    Map<String, int> dailyMap = {};

    for (var item in lineProduction) {
      final date = item["productionDate"].toString().split("T")[0];
      final production = item["totalProduction"] as int;

      dailyMap[date] = (dailyMap[date] ?? 0) + production;
    }

    final chartData = dailyMap.entries
        .map((e) => {"date": e.key, "value": e.value})
        .toList()
      ..sort((a, b) =>
          (a["date"] as String).compareTo(b["date"] as String));

    return _chartCard(
      "Daily Production",
      SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          SplineAreaSeries<dynamic, String>(
            dataSource: chartData,
            xValueMapper: (d, _) => d["date"],
            yValueMapper: (d, _) => d["value"],
            color: const Color(0xFF22D3EE).withOpacity(0.4),
            borderColor: const Color(0xFF22D3EE),
            borderWidth: 2,
            markerSettings: const MarkerSettings(isVisible: true),
          )
        ],
      ),
    );
  }

  Widget _lineProductionGraph() {
    if (lineProduction.isEmpty) return const SizedBox();

    return _chartCard(
      "Line Wise Production",
      SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          ColumnSeries<dynamic, String>(
            dataSource: lineProduction,
            xValueMapper: (d, _) => "Line ${d["lineId"]}",
            yValueMapper: (d, _) => d["totalProduction"],
            color: const Color(0xFF4ADE80),
            dataLabelSettings:
            const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }


  Widget _dispatchGraph() {
    if (dispatchSummary.isEmpty) return const SizedBox();

    return _chartCard(
      "Dispatch Summary",
      SfCircularChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          DoughnutSeries<dynamic, String>(
            dataSource: dispatchSummary,
            xValueMapper: (d, _) => d["batchNumber"],
            yValueMapper: (d, _) => d["totalDispatched"],
            dataLabelSettings:
            const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }

  Widget _downtimeGraph() {
    if (downtime.isEmpty) return const SizedBox();

    return _chartCard(
      "Downtime (Minutes)",
      SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          ColumnSeries<dynamic, String>(
            dataSource: downtime,
            xValueMapper: (d, _) => "Line ${d["lineNumber"]}",
            yValueMapper: (d, _) => d["totalDowntimeMinutes"],
            color: const Color(0xFFF59E0B),
          )
        ],
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



  // ───────── DISPATCH PIE CHART ─────────

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
