import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/features/models/task_group.dart';
import 'package:task_manager/features/models/task_item.dart';
import 'package:task_manager/utils/colors.dart';

class TaskProvider extends ChangeNotifier {
  final Box<TaskGroup> _groupBox;
  final Box _settingsBox;
  final List<TaskGroup> _groups = [];
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  final List<Color> _colorPalette = [
    AppColor.red,
    AppColor.teal,
    AppColor.orange,
    AppColor.darkTeal,
    AppColor.primary,
    AppColor.blue
  ];

  String _searchQuery = '';
  int _colorIndex = 0;
  static const String _colorIndexKey = 'next_color_index';

  TaskProvider(this._groupBox, this._settingsBox) {
    _loadGroups();
  }

  // GETTERS
  List<TaskGroup> get groups => List.unmodifiable(_groups);

  List<TaskGroup> get filteredGroups {
    if (_searchQuery.isEmpty) return _groups;
    return _groups
        .where((group) =>
            group.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            group.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  double get globalProgress {
    if (_groups.isEmpty) return 0.0;
    final total = _groups.fold<double>(0, (sum, g) => sum + g.progress);
    return total / _groups.length;
  }

  // EXPOSE COLOR PALETTE TO WIDGETS
  List<Color> get colorPalette => List.unmodifiable(_colorPalette);

  // SEARCH
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // LOAD GROUPS + FIX NULL COLORS + RESTORE INDEX
  Future<void> _loadGroups() async {
    _groups.clear();
    final storedGroups = _groupBox.values.toList();

    for (var group in storedGroups) {
      if (group.progressColor == null) {
        final color = _getNextColor();
        _groups.add(group.copyWith(progressColor: color));
      } else {
        _groups.add(group);
      }
    }

    // Restore saved color index
    _colorIndex = _settingsBox.get(_colorIndexKey, defaultValue: 0) as int;
    if (_colorIndex >= _colorPalette.length) _colorIndex = 0;

    // Continue from last used color
    if (_groups.isNotEmpty) {
      final lastColorValue = _groups.last.progressColorValue;
      if (lastColorValue != null) {
        final lastIndex =
            _colorPalette.indexWhere((c) => c.value == lastColorValue);
        if (lastIndex != -1) {
          _colorIndex = (lastIndex + 1) % _colorPalette.length;
        }
      }
    }

    await _settingsBox.put(_colorIndexKey, _colorIndex);
    _isLoaded = true;
    notifyListeners();
  }

  // SAVE ALL GROUPS
  Future<void> _saveGroups() async {
    await _groupBox.clear();
    for (int i = 0; i < _groups.length; i++) {
      await _groupBox.put(i, _groups[i]);
    }
  }

  // ADD GROUP
  Future<void> addGroup(String name, String description) async {
    if (!_isLoaded || name.trim().isEmpty) return;

    final color = _getNextColor();
    final group = TaskGroup(
      name: name.trim(),
      description: description.trim(),
      tasks: [],
      progressColor: color,
    );

    _groups.add(group);
    await _saveGroups();
    notifyListeners();
  }

  // GET NEXT COLOR + SAVE INDEX
  Color _getNextColor() {
    final color = _colorPalette[_colorIndex];
    _colorIndex = (_colorIndex + 1) % _colorPalette.length;
    _settingsBox.put(_colorIndexKey, _colorIndex);
    return color;
  }

  // UPDATE GROUP
  Future<void> updateGroup(
      int index, String newName, String newDescription) async {
    if (index >= _groups.length || newName.trim().isEmpty) return;

    final group = _groups[index];
    _groups[index] = group.copyWith(
      name: newName.trim(),
      description: newDescription.trim(),
    );

    await _saveGroups();
    notifyListeners();
  }

  // ADD TASK
  Future<void> addTask(int groupIndex, String title) async {
    if (title.trim().isEmpty || groupIndex >= _groups.length) return;
    final group = _groups[groupIndex];
    final updated = [...group.tasks, TaskItem(title: title.trim())];
    _groups[groupIndex] = group.copyWith(tasks: updated);
    await _saveGroups();
    notifyListeners();
  }

  // TOGGLE TASK
  Future<void> toggleTask(int groupIndex, int taskIndex) async {
    if (groupIndex >= _groups.length ||
        taskIndex >= _groups[groupIndex].tasks.length) return;

    final group = _groups[groupIndex];
    final task = group.tasks[taskIndex];
    final updated = [...group.tasks];
    updated[taskIndex] =
        TaskItem(title: task.title, isCompleted: !task.isCompleted);

    _groups[groupIndex] = group.copyWith(tasks: updated);
    await _saveGroups();
    notifyListeners();
  }

  // DELETE TASK
  Future<void> deleteTask(int groupIndex, int taskIndex) async {
    if (groupIndex >= _groups.length ||
        taskIndex >= _groups[groupIndex].tasks.length) return;

    final group = _groups[groupIndex];
    final updated = [...group.tasks]..removeAt(taskIndex);
    _groups[groupIndex] = group.copyWith(tasks: updated);
    await _saveGroups();
    notifyListeners();
  }

  // DELETE GROUP
  Future<void> deleteGroup(int index) async {
    if (index >= _groups.length) return;
    _groups.removeAt(index);
    await _saveGroups();
    notifyListeners();
  }
}
