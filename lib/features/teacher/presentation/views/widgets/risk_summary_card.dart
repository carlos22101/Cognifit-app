import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class RiskSummaryCard extends StatelessWidget {
  final int total;
  final int atRisk;
  final int needsAttention;

  const RiskSummaryCard({
    super.key,
    required this.total,
    required this.atRisk,
    required this.needsAttention,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A73E8), Color(0xFF2B87FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen del grupo',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStat('$total', 'Alumnos', Colors.white),
              _buildDivider(),
              _buildStat('$needsAttention', 'Atención', const Color(0xFFFFD95A)),
              _buildDivider(),
              _buildStat('$atRisk', 'Canalizar', const Color(0xFFFF7B7B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
