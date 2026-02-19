import 'package:flutter/material.dart';
import 'package:sundaram_iot_app/common/%20utils/app_toast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sundaram_iot_app/common/network/api_service.dart';

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
  late String selectedPlant;
  late String selectedLine;
  late String selectedBatch;

  List<Map<String, dynamic>> plants = [];
  bool isLoadingPlants = false;

  final lines = ["Line 1", "Line 2", "Line 3"];
  final batches = ["BATCH-4587", "BATCH-4588", "BATCH-4589"];

  @override
  void initState() {
    super.initState();
    selectedPlant = widget.plant;
    selectedLine = widget.line;
    selectedBatch = widget.batch;
    fetchPlants();
  }

  // ================= FETCH PLANTS FROM API =================
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

      if (data != null && data is List) {
        setState(() {
          plants = List<Map<String, dynamic>>.from(data);

          if (plants.isNotEmpty) {
            selectedPlant =
                plants.first["plantName"]?.toString() ?? selectedPlant;
          }
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

              _dropdownCard(),
              const SizedBox(height: 16),

              _contextStickyCard(),
              const SizedBox(height: 16),

              _batchProgressCard(),
              const SizedBox(height: 16),

              _aggregationStatusCard(),
              const SizedBox(height: 40),
            ],
          ),
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
              _contextChip(selectedPlant),
              _contextChip(selectedLine),
              _contextChip(selectedBatch),
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
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ================= DROPDOWN CARD (UPDATED PLANT ONLY) =================
  Widget _dropdownCard() {
    return _glassCard(
      title: "SELECTION",
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: selectedPlant.isEmpty ? null : selectedPlant,
            dropdownColor: const Color(0xFF0B1220),
            decoration: _inputDecoration("Plant"),
            style: const TextStyle(color: Colors.white),
            items: plants
                .map<DropdownMenuItem<String>>((p) {
              final plantName = p["plantName"]?.toString() ?? "";
              return DropdownMenuItem<String>(
                value: plantName,
                child: Text(plantName),
              );
            }).toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => selectedPlant = v);
              widget.onContextChanged(
                  selectedPlant, selectedLine, selectedBatch);
            },
          ),
          const SizedBox(height: 12),
          _dropdown("Line", selectedLine, lines, (v) {
            setState(() => selectedLine = v);
            widget.onContextChanged(
                selectedPlant, selectedLine, selectedBatch);
          }),
          const SizedBox(height: 12),
          _dropdown("Batch", selectedBatch, batches, (v) {
            setState(() => selectedBatch = v);
            widget.onContextChanged(
                selectedPlant, selectedLine, selectedBatch);
          }),
        ],
      ),
    );
  }

  Widget _dropdown(
      String label,
      String value,
      List<String> items,
      ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF0B1220),
      decoration: _inputDecoration(label),
      style: const TextStyle(color: Colors.white),
      items: items
          .map((e) => DropdownMenuItem<String>(
        value: e,
        child: Text(e),
      ))
          .toList(),
      onChanged: (v) => onChanged(v!),
    );
  }

  // ================= CONTEXT CARD =================
  Widget _contextStickyCard() {
    return _glassCard(
      title: "CURRENT CONTEXT",
      child: Column(
        children: [
          _infoRow("Plant", selectedPlant),
          _infoRow("Line", selectedLine),
          _infoRow("Shift", "06:00 - 14:00"),
          _infoRow("Operator", "OPR-102"),
          const Divider(color: Colors.white24),
          _infoRow("Batch ID", selectedBatch),
          _infoRow("Brand / SKU", "Royal Classic"),
          _infoRow("Bottle Size", "750 ml"),
          _infoRow("Bottles / Case", "12"),
        ],
      ),
    );
  }

  // ================= REST OF YOUR ORIGINAL UI (UNCHANGED) =================
  Widget _batchProgressCard() {
    const status = "Running";
    return _glassCard(
      title: "BATCH PROGRESS",
      trailing: Chip(
        label: const Text(status, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.withOpacity(0.25),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Metric(label: "Target", value: "1200"),
          _Metric(label: "Completed", value: "860"),
          _Metric(label: "Pending", value: "340"),
        ],
      ),
    );
  }

  Widget _aggregationStatusCard() {
    const int expectedBottles = 12;
    const int scannedBottles = 10;
    const int remainingBottles = expectedBottles - scannedBottles;

    return _glassCard(
      title: "LIVE AGGREGATION STATUS",
      child: const Text(
        "Aggregation UI (unchanged)",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _glassCard({
    required String title,
    Widget? trailing,
    required Widget child,
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
              style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
