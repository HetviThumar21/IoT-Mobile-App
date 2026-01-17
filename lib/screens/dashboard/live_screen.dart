import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                children: const [
                  _LiveLineCard(
                    line: "Line 1 - Bottling",
                    plant: "Plant A - North",
                    status: "Running",
                    product: "Premium Cola",
                    sku: "SKU-1001",
                    progress: 12450,
                    target: 15000,
                    operators: ["John Smith", "Sarah Johnson"],
                    values: [85.2, 94.5, 88.1, 98.7],
                  ),
                  _LiveLineCard(
                    line: "Line 2 - Canning",
                    plant: "Plant A - North",
                    status: "Idle",
                    product: "Energy Drink",
                    sku: "SKU-2045",
                    progress: 8200,
                    target: 12000,
                    operators: ["Maria Garcia", "Sarah Johnson"],
                    values: [0, 0, 0, 100],
                  ),
                  _LiveLineCard(
                    line: "Line 3 - Packaging",
                    plant: "Plant B - South",
                    status: "Running",
                    product: "Sparkling Water",
                    sku: "SKU-3022",
                    progress: 9800,
                    target: 14000,
                    operators: ["David Chen", "Mike Wilson"],
                    values: [72.8, 85.2, 82.5, 97.8],
                  ),
                  _LiveLineCard(
                    line: "Line 4 - Assembly",
                    plant: "Plant B - South",
                    status: "Critical",
                    product: "Juice Box",
                    sku: "SKU-4018",
                    progress: 3200,
                    target: 10000,
                    operators: ["Lisa Park", "Mike Wilson"],
                    values: [45.2, 62.1, 71.2, 95.5],
                  ),
                  _LiveLineCard(
                    line: "Line 5 - Labeling",
                    plant: "Plant C - East",
                    status: "Running",
                    product: "Mineral Water",
                    sku: "SKU-5033",
                    progress: 11200,
                    target: 12000,
                    operators: ["Tom Brown", "Emily Davis"],
                    values: [91.5, 97.2, 93.1, 99.2],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                Text(
                  "Live Status",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "3 lines running",
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
          _statusChip("LIVE", Colors.greenAccent),
          const SizedBox(width: 10),
          _iconButton(Icons.refresh_rounded),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
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

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi, size: 14, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────

class _LiveLineCard extends StatelessWidget {
  final String line;
  final String plant;
  final String status;
  final String product;
  final String sku;
  final int progress;
  final int target;
  final List<String> operators;
  final List<double> values;

  const _LiveLineCard({
    required this.line,
    required this.plant,
    required this.status,
    required this.product,
    required this.sku,
    required this.progress,
    required this.target,
    required this.operators,
    required this.values,
  });

  Color get statusColor {
    switch (status) {
      case "Running":
        return Colors.greenAccent;
      case "Idle":
        return Colors.orangeAccent;
      case "Critical":
        return Colors.redAccent;
      default:
        return Colors.white24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(22),
        border: Border(left: BorderSide(color: statusColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(plant,
                        style:
                        const TextStyle(color: Colors.white60)),
                  ],
                ),
              ),
              _chip(status, statusColor),
              const Icon(Icons.chevron_right,
                  color: Colors.white38),
            ],
          ),

          const SizedBox(height: 16),

          // KPI RINGS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ring("OEE", values[0]),
              _ring("AVAIL", values[1]),
              _ring("PERF", values[2]),
              _ring("QUALITY", values[3]),
            ],
          ),

          const SizedBox(height: 16),

          // PRODUCT
          Row(
            children: [
              const Icon(Icons.inventory_2,
                  size: 16, color: Colors.cyanAccent),
              const SizedBox(width: 6),
              Text(product,
                  style:
                  const TextStyle(color: Colors.cyanAccent)),
              const SizedBox(width: 10),
              Text("SKU: $sku",
                  style:
                  const TextStyle(color: Colors.white60)),
            ],
          ),

          const SizedBox(height: 12),

          // PROGRESS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Production Progress",
                  style: TextStyle(color: Colors.white60)),
              Text(
                "$progress / $target",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / target,
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF22D3EE)),
            ),
          ),

          const SizedBox(height: 12),

          // OPERATORS
          Row(
            children: operators
                .map(
                  (o) => Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Row(
                  children: [
                    const Icon(Icons.person,
                        size: 14, color: Colors.white38),
                    const SizedBox(width: 4),
                    Text(o,
                        style: const TextStyle(
                            color: Colors.white38)),
                  ],
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Widget _ring(String label, double value) {
    final Color ringColor = value >= 90
        ? Colors.greenAccent
        : value >= 70
        ? Colors.orangeAccent
        : Colors.redAccent;

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 30,
          lineWidth: 5,
          percent: (value / 100).clamp(0.0, 1.0),
          progressColor: ringColor,
          backgroundColor: Colors.white12,
          center: Text(
            value.toStringAsFixed(1),
            style: const TextStyle(
                color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style:
            const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}
