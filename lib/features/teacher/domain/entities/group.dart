import 'student.dart';

class Group {
  final String id;
  final String name;
  final String grade;
  final List<Student> students;

  const Group({
    required this.id,
    required this.name,
    required this.grade,
    required this.students,
  });

  int get totalStudents => students.length;
  int get atRisk =>
      students.where((s) => s.riskLevel == RiskLevel.critical).length;
  int get needsAttention =>
      students.where((s) => s.riskLevel == RiskLevel.attention).length;
}
