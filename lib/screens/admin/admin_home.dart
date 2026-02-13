import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';
import '../dashboard/alerts_screen.dart';
import 'admin_user_management.dart';
import '../../widgets/shift_oee_card.dart';
import '../../widgets/downtime_category_chart.dart';
import 'alert_screen.dart';
import 'daily_downtime_line_chart.dart';

class AdminHome extends StatefulWidget {
  final VoidCallback onProfileTap;
  final int userId;

  const AdminHome({super.key, required this.onProfileTap,required this.userId});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool showPlants = false;
  String selectedPlant = "All Plants";
  List<Map<String, dynamic>> plants = [];
  bool isLoadingPlants = false;

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
                  if (showPlants) ...[
                    const SizedBox(height: 8),
                    _plantList(),
                  ],
                  const SizedBox(height: 20),
                  _systemControlCard(),
                  const SizedBox(height: 24),
                  ShiftOeeCard(plant: selectedPlant),
                  const SizedBox(height: 40),
                  DailyDowntimeLineChart(plant: selectedPlant),
                  const SizedBox(height: 24),
                  DowntimeCategoryChart(plant: selectedPlant),

                ],
              ),
            ),
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Suresh Kumar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text("Admin • Plant A", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Current Shift", style: TextStyle(color: Colors.grey)),
                Text("06:00 - 14:00",
                    style: TextStyle(
                        color: Color(0xFF22D3EE),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= PLANT SELECTOR =================
  Widget _plantSelector() {
    return GestureDetector(
      onTap: () => setState(() => showPlants = !showPlants),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF020617),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            const Icon(Icons.factory, color: Color(0xFF22D3EE)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(selectedPlant,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ),
            Icon(
              showPlants
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  /// ================= PLANT LIST =================
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

