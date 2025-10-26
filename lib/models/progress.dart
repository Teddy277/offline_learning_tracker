import 'package:hive/hive.dart';

part 'progress.g.dart';

@HiveType(typeId: 1)
class Progress extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String activityId;

  @HiveField(3)
  late int answer;

  @HiveField(4)
  late bool isCorrect;

  @HiveField(5)
  late DateTime completedAt;

  @HiveField(6)
  late bool isSynced;

  Progress({
    required this.id,
    required this.userId,
    required this.activityId,
    required this.answer,
    required this.isCorrect,
    required this.completedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'activityId': activityId,
    'answer': answer,
    'isCorrect': isCorrect,
    'completedAt': completedAt.toIso8601String(),
    'isSynced': isSynced,
  };

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    id: json['id'],
    userId: json['userId'],
    activityId: json['activityId'],
    answer: json['answer'],
    isCorrect: json['isCorrect'],
    completedAt: DateTime.parse(json['completedAt']),
    isSynced: json['isSynced'] ?? false,
  );
}