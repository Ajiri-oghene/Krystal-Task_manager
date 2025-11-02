import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/utils/colors.dart';
import 'package:task_manager/utils/navigation.dart';

class TaskDetailScreen extends StatefulWidget {
  final int groupIndex;

  const TaskDetailScreen({super.key, required this.groupIndex});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _controller = TextEditingController();
  int _filterMode = 0; // 0 = All, 1 = To Do, 2 = Completed

  double fontScale(double size) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return isTablet ? size * 1.3 : size;
  }

  // Responsive padding
  EdgeInsets get padding {
    final width = MediaQuery.of(context).size.width;
    return EdgeInsets.all(width > 600 ? 28 : 20);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Filter Chip
  Widget _buildFilterChip(String label, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterMode = label == "All"
              ? 0
              : label == "Pending"
                  ? 1
                  : 2;
        });
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: fontScale(13),
            color: selected ? AppColor.white : AppColor.primaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: selected ? AppColor.primaryDark : AppColor.ashButton,
        padding: EdgeInsets.symmetric(horizontal: fontScale(8)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: selected ? AppColor.primaryDark : Colors.transparent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final group = provider.groups[widget.groupIndex];
        final pendingCount = group.tasks.where((t) => !t.isCompleted).length;
        final completedCount = group.tasks.where((t) => t.isCompleted).length;

        final tasks = _filterMode == 0
            ? group.tasks
            : _filterMode == 1
                ? group.tasks.where((t) => !t.isCompleted).toList()
                : group.tasks.where((t) => t.isCompleted).toList();

        return Scaffold(
          backgroundColor: AppColor.background,
          body: SafeArea(
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigation.goBack(context),
                        child: SvgPicture.asset(
                          'assets/svg/Arrow_back.svg',
                          width: fontScale(35),
                          height: fontScale(35),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            group.name,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: fontScale(22),
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit,
                            size: fontScale(28), color: AppColor.primaryDark),
                        onPressed: () => _showEditGroupDialog(
                          context,
                          group.name,
                          group.description,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    group.description,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: fontScale(16),
                      color: AppColor.textLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${group.totalTasks} Tasks",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: fontScale(18),
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Pending: $pendingCount    Completed: $completedCount",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: fontScale(14),
                            color: AppColor.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildFilterChip("All", _filterMode == 0),
                      const SizedBox(width: 8),
                      _buildFilterChip("Pending", _filterMode == 1),
                      const SizedBox(width: 8),
                      _buildFilterChip("Completed", _filterMode == 2),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(fontSize: fontScale(15)),
                          decoration: InputDecoration(
                            hintText: "Add a task...",
                            hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: fontScale(15),
                                color: AppColor.textLight),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: fontScale(16),
                              vertical: fontScale(14),
                            ),
                          ),
                          onSubmitted: (value) async {
                            if (value.trim().isNotEmpty) {
                              await provider.addTask(widget.groupIndex, value);
                              _controller.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.add_circle, size: fontScale(36)),
                        color: AppColor.primaryDark,
                        onPressed: () async {
                          if (_controller.text.trim().isNotEmpty) {
                            await provider.addTask(
                                widget.groupIndex, _controller.text);
                            _controller.clear();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: tasks.isEmpty
                        ? Center(
                            child: Text(
                              _filterMode == 0
                                  ? "No tasks yet"
                                  : _filterMode == 1
                                      ? "No pending tasks"
                                      : "No completed tasks",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: fontScale(18),
                                color: AppColor.primaryLight,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (ctx, i) {
                              final task = tasks[i];
                              final realIndex = group.tasks.indexOf(task);
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: fontScale(16),
                                    vertical: fontScale(8),
                                  ),
                                  leading: Checkbox(
                                    value: task.isCompleted,
                                    activeColor: AppColor.primaryDark,
                                    onChanged: (_) async {
                                      await provider.toggleTask(
                                          widget.groupIndex, realIndex);
                                    },
                                  ),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: fontScale(16),
                                      color: task.isCompleted
                                          ? AppColor.shadow
                                          : AppColor.black,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        size: fontScale(20)),
                                    color: AppColor.activeRed,
                                    onPressed: () async {
                                      await provider.deleteTask(
                                          widget.groupIndex, realIndex);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditGroupDialog(
      BuildContext context, String currentName, String currentDesc) {
    final nameController = TextEditingController(text: currentName);
    final descController = TextEditingController(text: currentDesc);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Edit Task Group",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: fontScale(20),
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Description",
                hintStyle: TextStyle(fontFamily: 'Montserrat'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigation.goBack(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: fontScale(13),
                color: AppColor.primaryDark,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final newName = nameController.text.trim();
              final newDesc = descController.text.trim();
              if (newName.isNotEmpty) {
                await context.read<TaskProvider>().updateGroup(
                      widget.groupIndex,
                      newName,
                      newDesc,
                    );
                Navigation.goBack(context);
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: AppColor.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
