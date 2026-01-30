import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
                  LiveLineCard(
                    line: "Line 1 - Aggregation & Scanning",
                    plant: "Plant A - North",
                    status: "Running",
                    product: "Premium Cola",
                    sku: "SKU-1001",
                    scanned: 12450,
                    target: 15000,
                    aggregated: 11420,
                    rejected: 320,
                    upm: 185,
                    operators: ["John Smith", "Sarah Johnson"],
                  ),
                  LiveLineCard(
                    line: "Line 2 - Aggregation & Scanning",
                    plant: "Plant A - North",
                    status: "Idle",
                    product: "Energy Drink",
                    sku: "SKU-2045",
                    scanned: 8200,
                    target: 12000,
                    aggregated: 0,
                    rejected: 0,
                    upm: 0,
                    operators: ["Maria Garcia"],
                  ),
                  LiveLineCard(
                    line: "Line 3 - Packaging",
                    plant: "Plant B - South",
                    status: "Running",
                    product: "Sparkling Water",
                    sku: "SKU-3022",
                    scanned: 9800,
                    target: 14000,
                    aggregated: 9120,
                    rejected: 180,
                    upm: 165,
                    operators: ["David Chen", "Mike Wilson"],
                  ),
                  LiveLineCard(
                    line: "Line 4 - Assembly",
                    plant: "Plant B - South",
                    status: "Critical",
                    product: "Juice Box",
                    sku: "SKU-4018",
                    scanned: 3200,
                    target: 10000,
                    aggregated: 2700,
                    rejected: 410,
                    upm: 72,
                    operators: ["Lisa Park"],
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
                  "Live Production",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Real-time barcode & aggregation status",
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

class LiveLineCard extends StatelessWidget {
  final String line;
  final String plant;
  final String status;
  final String product;
  final String sku;
  final int scanned;
  final int aggregated;
  final int rejected;
  final int upm;
  final int target;
  final List<String> operators;

  const LiveLineCard({
    super.key,
    required this.line,
    required this.plant,
    required this.status,
    required this.product,
    required this.sku,
    required this.scanned,
    required this.aggregated,
    required this.rejected,
    required this.upm,
    required this.target,
    required this.operators,
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
    final data = [
      _ProdMetric("Scanned", scanned.toDouble()),
      _ProdMetric("Aggregated", aggregated.toDouble()),
      _ProdMetric("Rejected", rejected.toDouble()),
      _ProdMetric("UPM", upm.toDouble()),
    ];

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
            ],
          ),

          const SizedBox(height: 16),

          // KPI CHART
          SizedBox(
            height: 160,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(color: Colors.white60),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
              ),
              series: <CartesianSeries<_ProdMetric, String>>[
                BarSeries<_ProdMetric, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.value,
                  borderRadius: BorderRadius.circular(6),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  pointColorMapper: (d, _) {
                    switch (d.label) {
                      case "Scanned":
                        return const Color(0xFF22D3EE);
                      case "Aggregated":
                        return Colors.greenAccent;
                      case "Rejected":
                        return Colors.redAccent;
                      default:
                        return Colors.orangeAccent;
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

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
              const Text("Scanned vs Target",
                  style: TextStyle(color: Colors.white60)),
              Text(
                "$scanned / $target",
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
              value: scanned / target,
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor:
              const AlwaysStoppedAnimation(Color(0xFF22D3EE)),
            ),
          ),

          const SizedBox(height: 12),

          // OPERATORS
          Wrap(
            spacing: 14,
            children: operators
                .map(
                  (o) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person,
                      size: 14, color: Colors.white38),
                  const SizedBox(width: 4),
                  Text(o,
                      style: const TextStyle(
                          color: Colors.white38)),
                ],
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
      child:
      Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

// ───────────────────────────────────────────────

class _ProdMetric {
  final String label;
  final double value;

  _ProdMetric(this.label, this.value);
}
