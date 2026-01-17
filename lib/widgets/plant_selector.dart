import 'package:flutter/material.dart';

class PlantSelector extends StatefulWidget {
  final String selectedPlant;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const PlantSelector({
    super.key,
    required this.selectedPlant,
    required this.onChanged,
  });

  @override
  State<PlantSelector> createState() => _PlantSelectorState();
}

class _PlantSelectorState extends State<PlantSelector> {
  bool open = false;

  final List<Map<String, dynamic>> plants = [
    {
      "name": "All Plants",
      "oee": "78.5%",
      "lines": "12 lines",
    },
    {
      "name": "Plant A - North",
      "oee": "82.3%",
      "lines": "4 lines",
    },
    {
      "name": "Plant B - South",
      "oee": "75.8%",
      "lines": "5 lines",
    },
    {
      "name": "Plant C - East",
      "oee": "77.1%",
      "lines": "3 lines",
    },
  ];

  Map<String, dynamic> get current =>
      plants.firstWhere(
            (p) => p["name"] == widget.selectedPlant,
        orElse: () => plants.first,
      );


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔥 SELECTED PLANT (FULL WIDTH)
        GestureDetector(
          onTap: () => setState(() => open = !open),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0E7490),
                  Color(0xFF020617),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.factory, color: Color(0xFF22D3EE)),
                const SizedBox(width: 12),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        current["lines"],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                /// OEE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      current["oee"],
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "OEE",
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),

                const SizedBox(width: 10),
                Icon(
                  open
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),

        /// 🔽 DROPDOWN LIST
        if (open)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              children: plants.map((plant) {
                final selected = plant["name"] == widget.selectedPlant;

                return InkWell(
                  onTap: () {
                    widget.onChanged(plant);
                    setState(() => open = false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF0F2A3C)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.factory,
                          color: selected
                              ? const Color(0xFF22D3EE)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant["name"],
                                style: TextStyle(
                                  color: selected
                                      ? const Color(0xFF22D3EE)
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                plant["lines"],
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              plant["oee"],
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "OEE",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
