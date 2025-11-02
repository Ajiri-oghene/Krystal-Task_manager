import 'package:hive/hive.dart';

part 'task_item.g.dart';

@HiveType(typeId: 1)
class TaskItem extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  TaskItem({required this.title, this.isCompleted = false});

  // For debugging / JSON export
  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
      };

  // Optional: create from JSON
  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        title: json['title'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
      );

  @override
  String toString() => 'TaskItem(title: $title, isCompleted: $isCompleted)';
}
