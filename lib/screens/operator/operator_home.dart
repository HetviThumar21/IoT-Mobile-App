import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class OperatorHome extends StatefulWidget {
  final int userId;
  final String plant;
  final String line;
  final String batch;
  final Function(String plant, String line, String batch) onContextChanged;

  const OperatorHome({
    super.key,
    required this.userId,
    required this.plant,
    required this.line,
    required this.batch,
    required this.onContextChanged,
  });

  @override
  State<OperatorHome> createState() => _OperatorHomeState();
}

class _OperatorHomeState extends State<OperatorHome> {

  String? selectedPlant;
  String? selectedLine;
  String? selectedBatch;

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  bool isLoadingDashboard = false;

  Map<String, dynamic>? operatorData;
  List<dynamic> batchSummary = [];
  List<dynamic> lineProduction = [];
  List<dynamic> oeeSummary = [];

  List<String> availableLines = [];
  List<String> availableBatches = [];

  @override
  void initState() {
    super.initState();
    fetchDashboardReport();
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> fetchDashboardReport() async {
    setState(() => isLoadingDashboard = true);

    try {
      final response = await DioClient().post(
        'operatordashboard/report',
        {
          "userId": widget.userId,
          "fromDate": _formatDate(fromDate),
          "toDate": _formatDate(toDate),
        },
      );

      final data = response.data;

      if (data != null && data["success"] == true) {
        final dashboard = data["data"];

        final operator = dashboard["operator"];
        final batches = dashboard["batchSummary"] ?? [];
        final lines = dashboard["lineProduction"] ?? [];
        final oee = dashboard["oeeSummary"] ?? [];

        final uniqueLines = lines
            .map<String>((e) => "Line ${e["lineId"]}")
            .toSet()
            .toList();

        setState(() {
          operatorData = operator;
          batchSummary = batches;
          lineProduction = lines;
          oeeSummary = oee;

          selectedPlant = operator?["plantName"];

          availableLines = uniqueLines;
          selectedLine = null;
          selectedBatch = null;
          availableBatches = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _modernHeader(),
              const SizedBox(height: 20),

              _dateSelectionCard(),
              const SizedBox(height: 16),


              _dropdownCard(),
              const SizedBox(height: 16),

              _contextStickyCard(),
              const SizedBox(height: 16),

              _oeeChartCard(),
              const SizedBox(height: 16),

              _batchProgressCard(),
              // _oeeChartCard(),
              const SizedBox(height: 40),


            ],
          ),
        ),
      ),
    );
  }

  // ================= DATE CARD =================

  Widget _dateSelectionCard() {
    return _glassCard(
      title: "DATE RANGE",
      trailing: IconButton(
        icon: const Icon(Icons.refresh, color: Colors.cyanAccent),
        onPressed: fetchDashboardReport,
      ),
      child: Row(
        children: [
          Expanded(child: _dateField("From", fromDate, true)),
          const SizedBox(width: 12),
          Expanded(child: _dateField("To", toDate, false)),
        ],
      ),
    );
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
          fetchDashboardReport();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1220),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF22D3EE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(_formatDate(date),
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ================= MODERN HEADER =================

  Widget _modernHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7490), Color(0xFF020617)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 14),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF22D3EE),
                child: Icon(Icons.factory, color: Colors.black),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Operator Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _contextChip(selectedPlant ?? "-"),
              _contextChip(selectedLine ?? "-"),
              _contextChip(selectedBatch ?? "-"),
            ],
          )
        ],
      ),
    );
  }

  Widget _contextChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22D3EE), width: 0.8),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  // ================= DROPDOWN CARD =================

  Widget _dropdownCard() {
    if (selectedPlant == null) {
      return _glassCard(
        title: "SELECTION",
        child: const Text("No Plant Assigned",
            style: TextStyle(color: Colors.white)),
      );
    }

    return _glassCard(
      title: "SELECTION",
      child: Column(
        children: [

          _infoRow("Plant", selectedPlant!),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: selectedLine,
            dropdownColor: const Color(0xFF0B1220),
            decoration: _inputDecoration("Line"),
            style: const TextStyle(color: Colors.white),
            items: availableLines
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              if (v == null) return;

              final lineId = int.parse(v.replaceAll("Line ", ""));

              final filteredBatches = batchSummary
                  .where((b) => lineProduction.any((l) =>
              l["lineId"] == lineId &&
                  l["batchNumber"] == b["batchNumber"]))
                  .map<String>((e) => e["batchNumber"].toString())
                  .toSet()
                  .toList();

              setState(() {
                selectedLine = v;
                availableBatches = filteredBatches;
                selectedBatch = null;
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: selectedBatch,
            dropdownColor: const Color(0xFF0B1220),
            decoration: _inputDecoration("Batch"),
            style: const TextStyle(color: Colors.white),
            items: availableBatches
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: selectedLine == null
                ? null
                : (v) {
              setState(() => selectedBatch = v);
            },
          ),
        ],
      ),
    );
  }

  // ================= CONTEXT =================

  Widget _contextStickyCard() {

    int batchSize = 0;

    if (selectedBatch != null) {
      final filtered = batchSummary
          .where((e) => e["batchNumber"] == selectedBatch)
          .toList();

      batchSize = filtered.fold<int>(
          0, (sum, e) => sum + ((e["batchSize"] as num?)?.toInt() ?? 0));
    }

    return _glassCard(
      title: "CURRENT CONTEXT",
      child: Column(
        children: [
          _infoRow("Plant", selectedPlant ?? "-"),
          _infoRow("Line", selectedLine ?? "-"),
          _infoRow("Operator", operatorData?["fullName"] ?? "-"),
          _infoRow("Batch ID", selectedBatch ?? "-"),
          _infoRow("Batch Size", batchSize == 0 ? "-" : batchSize.toString()),
        ],
      ),
    );
  }


  Widget _oeeChartCard() {

    if (selectedLine == null) {
      return _glassCard(
        title: "OEE SUMMARY",
        child: const Text(
          "Select Line to View OEE",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final lineId = int.parse(selectedLine!.replaceAll("Line ", ""));

    final filteredOee = oeeSummary
        .where((e) =>
    e["lineNumber"] == lineId &&
        _isWithinSelectedDate(e["eventDate"]))
        .toList();

    if (filteredOee.isEmpty) {
      return _glassCard(
        title: "OEE SUMMARY",
        child: const Text(
          "No OEE Data",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return _glassCard(
      title: "OEE SUMMARY",
      child: SizedBox(
        height: 300,
        child: SfCartesianChart(
          backgroundColor: Colors.transparent,
          primaryXAxis: CategoryAxis(),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            ColumnSeries<dynamic, String>(
              name: "Planned",
              dataSource: filteredOee,
              xValueMapper: (data, _) =>
                  data["eventDate"].toString().substring(0, 10),
              yValueMapper: (data, _) =>
              (data["plannedDowntimeMinutes"] as num?)?.toDouble() ?? 0,
              color: Colors.green,
            ),
            ColumnSeries<dynamic, String>(
              name: "Unplanned",
              dataSource: filteredOee,
              xValueMapper: (data, _) =>
                  data["eventDate"].toString().substring(0, 10),
              yValueMapper: (data, _) =>
              (data["unplannedDowntimeMinutes"] as num?)?.toDouble() ?? 0,
              color: Colors.red,
            ),
            ColumnSeries<dynamic, String>(
              name: "Total",
              dataSource: filteredOee,
              xValueMapper: (data, _) =>
                  data["eventDate"].toString().substring(0, 10),
              yValueMapper: (data, _) =>
              (data["totalDowntimeMinutes"] as num?)?.toDouble() ?? 0,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  bool _isWithinSelectedDate(String eventDate) {
    final event = DateTime.parse(eventDate);

    return event.isAfter(fromDate.subtract(const Duration(days: 1))) &&
        event.isBefore(toDate.add(const Duration(days: 1)));
  }

  // ================= BATCH PROGRESS =================

  Widget _batchProgressCard() {
    if (selectedBatch == null) {
      return _glassCard(
        title: "BATCH PROGRESS",
        child: const Text("No Batch Selected",
            style: TextStyle(color: Colors.white)),
      );
    }

    final filtered = batchSummary
        .where((e) => e["batchNumber"] == selectedBatch)
        .toList();

    final target = filtered.fold<int>(
        0, (sum, e) => sum + ((e["batchSize"] as num?)?.toInt() ?? 0));

    final produced = filtered.fold<int>(
        0, (sum, e) => sum + ((e["totalProduced"] as num?)?.toInt() ?? 0));

    final remaining = filtered.fold<int>(
        0, (sum, e) => sum + ((e["remainingQuantity"] as num?)?.toInt() ?? 0));

    return _glassCard(
      title: "BATCH PROGRESS",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Metric(label: "Target", value: target.toString()),
          _Metric(label: "Produced", value: produced.toString()),
          _Metric(label: "Remaining", value: remaining.toString()),
        ],
      ),
    );
  }

  Widget _aggregationStatusCard() {
    return _glassCard(
      title: "LIVE AGGREGATION STATUS",
      child: const Text("Aggregation UI (unchanged)",
          style: TextStyle(color: Colors.white)),
    );
  }

  Widget _glassCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        gradient:
        LinearGradient(colors: [Color(0xFF0F1C2E), Color(0xFF060B16)]),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFF0B1220),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF22D3EE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
        const BorderSide(color: Color(0xFF22D3EE), width: 1.5),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}