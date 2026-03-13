import 'package:hive/hive.dart';

part 'checkin_hive_model.g.dart';

@HiveType(typeId: 1)
class CheckinHiveModel extends HiveObject {
  @HiveField(0)
  final String classId;

  @HiveField(1)
  final String className;

  @HiveField(2)
  final String classDate;

  @HiveField(3)
  final String studentId;

  @HiveField(4)
  final int moodBefore;

  @HiveField(5)
  final String checkinTime;

  @HiveField(6)
  final String? learnedToday;

  @HiveField(7)
  final String firestoreDocId; // NEW: to update Firestore on finish

  CheckinHiveModel({
    required this.classId,
    required this.className,
    required this.classDate,
    required this.studentId,
    required this.moodBefore,
    required this.checkinTime,
    required this.firestoreDocId,
    this.learnedToday,
  });
}
