import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final tabs = ["Overview", "Logs", "Exports"];
  int selectedTab = 0;

  // ───────── PLANTS DATA ─────────
  final List<Map<String, dynamic>> plants = [
    {"name": "All Plants", "lines": "12 lines", "oee": "78.5%", "color": Colors.cyanAccent},
    {"name": "Plant A - North", "lines": "4 lines", "oee": "82.3%", "color": Colors.greenAccent},
    {"name": "Plant B - South", "lines": "5 lines", "oee": "75.8%", "color": Colors.orangeAccent},
    {"name": "Plant C - East", "lines": "3 lines", "oee": "77.1%", "color": Colors.yellowAccent},
  ];

  int selectedPlantIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            _selectors(),
            _tabs(),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                child: _tabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── HEADER ─────────
  Widget _header() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reports",
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text("Analytics & Export", style: TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }

  // ───────── SELECTORS ─────────
  Widget _selectors() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _plantSelector()),
          const SizedBox(width: 12),
          _pillButton(Icons.calendar_today, "This Week"),
        ],
      ),
    );
  }

  Widget _plantSelector() {
    return GestureDetector(
      onTap: _showPlantDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.factory, color: Color(0xFF22D3EE), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                plants[selectedPlantIndex]["name"],
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _pillButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF22D3EE), size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // ───────── PLANT DROPDOWN ─────────
  void _showPlantDropdown() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF0B1220),
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(plants.length, (i) {
              final p = plants[i];
              final active = selectedPlantIndex == i;

              return GestureDetector(
                onTap: () {
                  setState(() => selectedPlantIndex = i);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.cyanAccent.withOpacity(0.12)
                        : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(18),
                    border: active ? Border.all(color: Colors.cyanAccent) : null,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.factory, color: p["color"]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p["name"],
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(p["lines"],
                                style: const TextStyle(color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(p["oee"],
                              style: TextStyle(
                                  color: p["color"],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          const Text("OEE",
                              style: TextStyle(color: Colors.white38, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  // ───────── TABS ─────────
  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: List.generate(tabs.length, (i) {
            final active = selectedTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedTab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF22D3EE) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      tabs[i],
                      style: TextStyle(
                        color: active ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ───────── TAB CONTENT ─────────
  Widget _tabContent() {
    if (selectedTab == 0) return _overviewTab();
    if (selectedTab == 1) return _logsTab();
    return _exportsTab();
  }

  // ───────── OVERVIEW ─────────
  Widget _overviewTab() {
    return Column(
      children: [
        _chartCard(),
        const SizedBox(height: 16),
        Row(
          children: const [
            _statBox("5,320", "Total Production (Cases)", Color(0xFF22D3EE)),
            SizedBox(width: 12),
            _statBox("4,980", "Total Dispatch", Colors.orange),
            SizedBox(width: 12),
            _statBox("330 min", "Downtime (Monthly)", Colors.redAccent),
          ],
        ),

      ],
    );
  }

  Widget _chartCard() {
    final data = [
      _MonthlyData('Jan', 1200, 1100, 90),
      _MonthlyData('Feb', 1350, 1250, 70),
      _MonthlyData('Mar', 1280, 1200, 110),
      _MonthlyData('Apr', 1500, 1400, 60),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MONTHLY PRODUCTION OVERVIEW",
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              legend: Legend(
                isVisible: true,
                textStyle: const TextStyle(color: Colors.white70),
              ),
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(color: Colors.white54),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: const TextStyle(color: Colors.white54),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              series: <CartesianSeries<_MonthlyData, String>>[
                ColumnSeries<_MonthlyData, String>(
                  name: 'Production',
                  dataSource: data,
                  xValueMapper: (d, _) => d.month,
                  yValueMapper: (d, _) => d.production,
                  color: const Color(0xFF22D3EE),
                  borderRadius: BorderRadius.circular(6),
                ),
                ColumnSeries<_MonthlyData, String>(
                  name: 'Dispatch',
                  dataSource: data,
                  xValueMapper: (d, _) => d.month,
                  yValueMapper: (d, _) => d.dispatch,
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                LineSeries<_MonthlyData, String>(
                  name: 'Downtime',
                  dataSource: data,
                  xValueMapper: (d, _) => d.month,
                  yValueMapper: (d, _) => d.downtime,
                  color: Colors.redAccent,
                  width: 3,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            )
            ,
          ),
        ],
      ),
    );
  }

  static LineChartBarData _line(List<double> v, Color c) {
    return LineChartBarData(
      spots: List.generate(v.length, (i) => FlSpot(i.toDouble(), v[i])),
      isCurved: true,
      barWidth: 3,
      color: c,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: true, color: c.withOpacity(0.15)),
    );
  }

  // ───────── LOGS ─────────
  Widget _logsTab() {
    return _glassList(
      children: const [
        _logTile("Filler #2", "Hydraulic failure", "45 min"),
        _logTile("Labeler #1", "Label jam", "18 min"),
        _logTile("Packer #3", "Belt misalignment", "22 min"),
        _logTile("Capper #2", "Feeder jam", "35 min"),
      ],
    );
  }

  // ───────── EXPORTS ─────────
  Widget _exportsTab() {
    return _glassCard(
      title: "QUICK EXPORT",
      child: Row(
        children: const [
          _exportButton("Excel", Colors.green),
          SizedBox(width: 12),
          _exportButton("PDF", Colors.redAccent),
        ],
      ),
    );
  }

  // ───────── HELPERS ─────────
  Widget _glassCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _glassList({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(children: children),
    );
  }
}

// ───────── SMALL WIDGETS ─────────
class _statBox extends StatelessWidget {
  final String value, label;
  final Color color;
  const _statBox(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}

class _logTile extends StatelessWidget {
  final String title, subtitle, duration;
  const _logTile(this.title, this.subtitle, this.duration);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(duration, style: const TextStyle(color: Colors.orange)),
      ),
    );
  }
}

class _exportButton extends StatelessWidget {
  final String text;
  final Color color;
  const _exportButton(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          AppToast.show(
            context,
            text == "Excel"
                ? "Export started, generating EXCEL report..."
                : "Export started, generating PDF report...",
          );
        },
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(text,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
class _MonthlyData {
  final String month;
  final double production;
  final double dispatch;
  final double downtime;

  _MonthlyData(this.month, this.production, this.dispatch, this.downtime);
}
