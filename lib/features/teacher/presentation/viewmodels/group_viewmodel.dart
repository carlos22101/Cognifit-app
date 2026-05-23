import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/group.dart';

final groupProvider = Provider<Group>((ref) {
  return const Group(
    id: 'g1',
    name: '3º A',
    grade: 'Tercer grado',
    students: [
      Student(
        id: 's1',
        name: 'Valentina Torres',
        avatarInitials: 'VT',
        riskLevel: RiskLevel.none,
        lastScore: 92,
        lastActivity: 'Dictado · hace 1 día',
      ),
      Student(
        id: 's2',
        name: 'Emiliano Ruiz',
        avatarInitials: 'ER',
        riskLevel: RiskLevel.attention,
        lastScore: 64,
        lastActivity: 'Comprensión · hace 2 días',
      ),
      Student(
        id: 's3',
        name: 'Sofía Mendoza',
        avatarInitials: 'SM',
        riskLevel: RiskLevel.none,
        lastScore: 88,
        lastActivity: 'Dictado · hace 1 día',
      ),
      Student(
        id: 's4',
        name: 'Mateo González',
        avatarInitials: 'MG',
        riskLevel: RiskLevel.critical,
        lastScore: 41,
        lastActivity: 'Comprensión · hace 5 días',
      ),
      Student(
        id: 's5',
        name: 'Isabella Reyes',
        avatarInitials: 'IR',
        riskLevel: RiskLevel.none,
        lastScore: 95,
        lastActivity: 'Dictado · hoy',
      ),
      Student(
        id: 's6',
        name: 'Lucas Herrera',
        avatarInitials: 'LH',
        riskLevel: RiskLevel.critical,
        lastScore: 38,
        lastActivity: 'Dictado · hace 6 días',
      ),
      Student(
        id: 's7',
        name: 'Camila Jiménez',
        avatarInitials: 'CJ',
        riskLevel: RiskLevel.attention,
        lastScore: 58,
        lastActivity: 'Comprensión · hace 3 días',
      ),
      Student(
        id: 's8',
        name: 'Sebastián López',
        avatarInitials: 'SL',
        riskLevel: RiskLevel.none,
        lastScore: 79,
        lastActivity: 'Dictado · hoy',
      ),
    ],
  );
});
