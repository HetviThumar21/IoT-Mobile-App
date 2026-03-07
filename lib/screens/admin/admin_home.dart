import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../dashboard/alerts_screen.dart';
import 'admin_user_management.dart';
import '../../widgets/shift_oee_card.dart';
import '../../widgets/downtime_category_chart.dart';
import 'alert_screen.dart';
import 'daily_downtime_line_chart.dart';

class AdminHome extends StatefulWidget {
  final VoidCallback onProfileTap;
  final int userId;
  final String username;

  const AdminHome({super.key, required this.onProfileTap,required this.userId,required this.username});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool showPlants = false;
  List<Map<String, dynamic>> plants = [];
  bool isLoadingPlants = false;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String selectedPlant = "Select Plant";
  int? selectedPlantId;   // keep null initially

  bool isLoadingDashboard = false;

  Map<String, dynamic>? batchSummary;
  List<dynamic> lineProduction = [];
  List<dynamic> downtime = [];
  List<dynamic> dispatchSummary = [];
  String _formatDate(DateTime date) {
    return date.toUtc().toIso8601String();
  }
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
    print("userId${widget.userId}");
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          /// ================= STICKY HEADER =================
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF0B1220),
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Admin Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Real-time OEE Monitoring",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            actions: const [
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(width: 16),
              Stack(
                children: [
                  Icon(Icons.notifications, color: Colors.white),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(radius: 5, backgroundColor: Colors.red),
                  )
                ],
              ),
              SizedBox(width: 16),
            ],
          ),

          /// ================= BODY =================
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _profileCard(),
                  const SizedBox(height: 16),
                  _plantSelector(),
                  const SizedBox(height: 12),
                  _dateSelectionCard(),   // 👈 ADD THIS
                  if (showPlants) ...[
                    const SizedBox(height: 8),
                    _plantList(),
                  ],
                  const SizedBox(height: 20),
                  _systemControlCard(),
                  const SizedBox(height: 24),
                  // ShiftOeeCard(plant: selectedPlant),
                  _dailyProductionChart(),
                  const SizedBox(height: 40),
                  _batchProductionChart(),
                  const SizedBox(height: 24),
                  _downtimeChart(),
                  const SizedBox(height: 24),
                  _dispatchChart(),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _dailyProductionChart() {
    if (lineProduction.isEmpty) return const SizedBox();

    // 🔥 Group production by date
    Map<String, double> dailyMap = {};

    for (var item in lineProduction) {
      String date =
      item["productionDate"].toString().substring(0, 10);

      double production =
      (item["totalProduction"] ?? 0).toDouble();

      if (dailyMap.containsKey(date)) {
        dailyMap[date] = dailyMap[date]! + production;
      } else {
        dailyMap[date] = production;
      }
    }

    // Convert map to list
    final chartData = dailyMap.entries
        .map((e) => {
      "date": e.key,
      "production": e.value,
    })
        .toList()
      ..sort((a, b) {
        final dateA = a["date"]?.toString() ?? "";
        final dateB = b["date"]?.toString() ?? "";
        return dateA.compareTo(dateB);
      });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Production (Date Wise)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(color: Colors.grey),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(color: Colors.grey),
            ),
            series: <CartesianSeries>[
              LineSeries<dynamic, String>(
                dataSource: chartData,
                xValueMapper: (data, _) => data["date"],
                yValueMapper: (data, _) => data["production"],
                color: const Color(0xFF22D3EE),
                markerSettings:
                const MarkerSettings(isVisible: true),
                dataLabelSettings:
                const DataLabelSettings(isVisible: false),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// ================= PROFILE CARD =================
  Widget _profileCard() {
    return GestureDetector(
      onTap: widget.onProfileTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0E7490), Color(0xFF020617)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFF22D3EE),
              child: Text("SK",
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.username}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const Text("Admin", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  /// ================= PLANT SELECTOR =================
  Widget _plantSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          isExpanded: true,
          dropdownColor: const Color(0xFF0B1220),
          value: selectedPlantId,
          hint: const Text(
            "Select Plant",
            style: TextStyle(color: Colors.grey),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text("Select Plant"),
            ),
            ...plants.map((plant) {
              return DropdownMenuItem<int?>(
                value: plant["plantId"],
                child: Row(
                  children: [
                    const Icon(Icons.factory,
                        color: Color(0xFF22D3EE), size: 18),
                    const SizedBox(width: 10),
                    Text(plant["plantName"]),
                  ],
                ),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              selectedPlantId = value;

              if (value != null) {
                final selected = plants.firstWhere(
                        (p) => p["plantId"] == value);
                selectedPlant = selected["plantName"];
              } else {
                selectedPlant = "Select Plant";
              }
            });

            if (value != null) {
              fetchPlantHeadDashboard(); // ✅ call API only after selection
            }
          },
        ),
      ),
    );
  }

  Widget _dateSelectionCard() {
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF020617),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range, color: Color(0xFF22D3EE)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "${_formatDisplayDate(fromDate)}  →  ${_formatDisplayDate(toDate)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: fromDate,
        end: toDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF22D3EE),
              onPrimary: Colors.black,
              surface: Color(0xFF0B1220),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF0B1220),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });
      print("Selected Plant ID: $selectedPlantId");
      // ✅ AUTO CALL API AFTER SELECTING RANGE
      fetchPlantHeadDashboard();
    }
  }

  String _formatDisplayDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  Future<void> fetchPlantHeadDashboard() async {
    if (selectedPlantId == null) return;

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

      print('data--$data');

      if (data != null && data["success"] == true) {
        setState(() {
          batchSummary = data["batchSummary"];
          lineProduction = data["lineProduction"] ?? [];
          downtime = data["downtime"] ?? [];
          dispatchSummary = data["dispatchSummary"] ?? [];
        });
      } else {
        AppToast.show(context, data?["message"] ?? "Dashboard failed");
      }
    } catch (e) {
      AppToast.show(context, "Unable to fetch dashboard");
    } finally {
      setState(() => isLoadingDashboard = false);
    }
  }

  Widget _dateField(String label, DateTime date, bool isFrom) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          setState(() {
            if (isFrom) {
              fromDate = picked;
            } else {
              toDate = picked;
            }
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            "${date.year}-${date.month}-${date.day}",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }


  Widget _batchProductionChart() {
    if (lineProduction.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Batch Wise Production",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries>[
              ColumnSeries<dynamic, String>(
                dataSource: lineProduction,
                xValueMapper: (data, _) =>
                data["batchNumber"],
                yValueMapper: (data, _) =>
                data["totalProduction"],
                color: const Color(0xFF22D3EE),
                dataLabelSettings:
                const DataLabelSettings(isVisible: false),
              )
            ],
          ),
        ],
      ),
    );
  }
  Widget _downtimeChart() {
    if (downtime.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Planned vs Unplanned Downtime",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: true),
            series: <CartesianSeries>[
              StackedColumnSeries<dynamic, String>(
                dataSource: downtime,
                xValueMapper: (data, _) =>
                    data["eventDate"].toString().substring(0, 10),
                yValueMapper: (data, _) =>
                data["plannedDowntimeMinutes"],
                name: "Planned",
                color: Colors.orange,
              ),
              StackedColumnSeries<dynamic, String>(
                dataSource: downtime,
                xValueMapper: (data, _) =>
                    data["eventDate"].toString().substring(0, 10),
                yValueMapper: (data, _) =>
                data["unplannedDowntimeMinutes"],
                name: "Unplanned",
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dispatchChart() {
    if (dispatchSummary.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1C2E), Color(0xFF060B16)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Batch Wise Dispatch vs Remaining",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Compare dispatched quantity with remaining stock",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            legend: Legend(isVisible: true),
            primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(color: Colors.grey),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(color: Colors.grey),
            ),
            series: <CartesianSeries>[
              ColumnSeries<dynamic, String>(
                name: "Dispatched",
                dataSource: dispatchSummary,
                xValueMapper: (data, _) => data["batchNumber"],
                yValueMapper: (data, _) =>
                    (data["totalDispatched"] ?? 0).toDouble(),
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              ColumnSeries<dynamic, String>(
                name: "Remaining",
                dataSource: dispatchSummary,
                xValueMapper: (data, _) => data["batchNumber"],
                yValueMapper: (data, _) =>
                    (data["remainingAfterDispatch"] ?? 0).toDouble(),
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ],
      ),
    );
  }  /// ================= PLANT LIST =================
  // Widget _plantList() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF020617),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: const Color(0xFF1E293B)),
  //     ),
  //     child: Column(
  //       children: plants.map((plant) {
  //         final isSelected = plant["name"] == selectedPlant;
  //         return GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               selectedPlant = plant["name"]!;
  //               showPlants = false;
  //             });
  //           },
  //           child: Container(
  //             padding: const EdgeInsets.all(14),
  //             decoration: BoxDecoration(
  //               color: isSelected
  //                   ? const Color(0xFF0F2A3C)
  //                   : Colors.transparent,
  //             ),
  //             child: Row(
  //               children: [
  //                 Icon(Icons.factory,
  //                     color: isSelected
  //                         ? const Color(0xFF22D3EE)
  //                         : Colors.grey),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(plant["name"]!,
  //                           style: TextStyle(
  //                               color: isSelected
  //                                   ? const Color(0xFF22D3EE)
  //                                   : Colors.white,
  //                               fontWeight: FontWeight.w600)),
  //                       Text(plant["lines"]!,
  //                           style: const TextStyle(
  //                               color: Colors.grey, fontSize: 12)),
  //                     ],
  //                   ),
  //                 ),
  //                 Column(
  //                   children: [
  //                     Text(plant["oee"]!,
  //                         style: const TextStyle(
  //                             color: Colors.orange,
  //                             fontWeight: FontWeight.bold)),
  //                     const Text("OEE",
  //                         style:
  //                         TextStyle(color: Colors.grey, fontSize: 11)),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
  Widget _plantList() {
    if (isLoadingPlants) {
      return const Center(child: CircularProgressIndicator());
    }

    if (plants.isEmpty) {
      return const Center(
        child: Text(
          "No Plants Available",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: plants.map((plant) {
          final isSelected = plant["plantName"] == selectedPlant;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPlant = plant["plantName"];
                selectedPlantId = plant["plantId"];  // 🔥 THIS IS REQUIRED
                showPlants = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              color: isSelected
                  ? const Color(0xFF0F2A3C)
                  : Colors.transparent,
              child: Row(
                children: [
                  Icon(Icons.factory,
                      color: isSelected
                          ? const Color(0xFF22D3EE)
                          : Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      plant["plantName"],
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF22D3EE)
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ================= SYSTEM CONTROL =================
  Widget _systemControlCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.admin_panel_settings,
                  color: Color(0xFF22D3EE)),
              const SizedBox(width: 8),
              const Text("System Control",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
                const Text("Active", style: TextStyle(color: Colors.green)),
              )
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _SystemCard(
                    title: "User Management",
                    subtitle: "Users • Roles • Access",
                    icon: Icons.group,
                    gradient: const [
                      Color(0xFF0E7490),
                      Color(0xFF020617),
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminUserManagement(),
                        ),
                      );
                    },
                  ),

                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _SystemCard(
                    title: "Alerts",
                    subtitle: "3 Active alerts",
                    icon: Icons.notifications_active,
                    gradient: const [
                      Color(0xFF8A5A12),
                      Color(0xFF020617)
                    ],
                    iconColor: Colors.orange,
                    subtitleColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AlertsScreen(plant: 'Alerts',),
                        ),
                      );
                    },
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

/// ================= REUSABLE SYSTEM CARD =================
class _SystemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final Color iconColor;
  final Color subtitleColor;
  final VoidCallback? onTap;

  const _SystemCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.iconColor = Colors.white,
    this.subtitleColor = Colors.grey,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center( // ✅ IMPORTANT
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ CRITICAL FIX
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 30),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.15, // ✅ font metric fix
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                      height: 1.15, // ✅ font metric fix
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

