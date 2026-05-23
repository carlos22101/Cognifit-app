enum RiskLevel { none, attention, critical }

class Student {
  final String id;
  final String name;
  final String avatarInitials;
  final RiskLevel riskLevel;
  final double lastScore;
  final String lastActivity;

  const Student({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.riskLevel,
    required this.lastScore,
    required this.lastActivity,
  });
}
