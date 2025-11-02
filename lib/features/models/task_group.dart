import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'task_item.dart';

part 'task_group.g.dart';

@HiveType(typeId: 0)
class TaskGroup extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final List<TaskItem> tasks;

  @HiveField(3)
  final int? progressColorValue;

  TaskGroup({
    required this.name,
    required this.description,
    List<TaskItem>? tasks,
    Color? progressColor,
  })  : tasks = tasks ?? [],
        progressColorValue = progressColor?.value;

  // Getter for color
  Color? get progressColor =>
      progressColorValue != null ? Color(progressColorValue!) : null;

  // Getter for progress tracking
  int get totalTasks => tasks.length;
  int get completedCount => tasks.where((t) => t.isCompleted).length;
  double get progress => totalTasks == 0 ? 0.0 : completedCount / totalTasks;

  // Copy method for updates
  TaskGroup copyWith({
    String? name,
    String? description,
    List<TaskItem>? tasks,
    Color? progressColor,
  }) {
    return TaskGroup(
      name: name ?? this.name,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
      progressColor: progressColor ?? this.progressColor,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'tasks': tasks.map((t) => t.toJson()).toList(),
        'progressColorValue': progressColorValue,
      };
}
