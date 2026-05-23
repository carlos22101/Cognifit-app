import 'package:flutter/material.dart';
import '../../../domain/entities/student.dart';
import '../../../../../core/theme/app_colors.dart';

class StudentListTile extends StatelessWidget {
  final Student student;

  const StudentListTile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: _buildAvatar(),
        title: Text(
          student.name,
          style: const TextStyle(
            color: AppColors.inkDark,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          student.lastActivity,
          style: const TextStyle(
            color: AppColors.inkLight,
            fontSize: 12,
          ),
        ),
        trailing: _buildRiskChip(),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          student.avatarInitials,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildRiskChip() {
    final (label, bg, fg) = switch (student.riskLevel) {
      RiskLevel.none => ('Sin indicadores', AppColors.riskGreenBg, AppColors.riskGreen),
      RiskLevel.attention => ('Atención', AppColors.riskAmberBg, AppColors.riskAmber),
      RiskLevel.critical => ('Canalizar', AppColors.riskRedBg, AppColors.riskRed),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
