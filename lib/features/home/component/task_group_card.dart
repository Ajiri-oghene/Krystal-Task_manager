// FILE: lib/features/home/task_group_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/features/home/task_detail.dart';
import 'package:task_manager/features/models/task_group.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/utils/colors.dart';
import 'package:task_manager/utils/navigation.dart';

/// Displays a single task group as a card with progress, task count, name, description, and delete option
class TaskGroupCard extends StatefulWidget {
  final TaskGroup task;
  final int index;

  const TaskGroupCard({
    super.key,
    required this.task,
    required this.index,
  });

  @override
  State<TaskGroupCard> createState() => _TaskGroupCardState();
}

class _TaskGroupCardState extends State<TaskGroupCard> {
  // Controls visibility of the delete button when long-pressed
  bool _showDelete = false;

  /// Scales font size based on device width (tablet vs phone)
  double _fontscale(double size) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return isTablet ? size * 1.3 : size;
  }

  /// Builds the interactive card with tap, long-press, and delete confirmation
  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();

    // Use custom progress color or fallback to first color in palette
    final Color progressColor =
        widget.task.progressColor ?? provider.colorPalette[0];

    return InkWell(
      borderRadius: BorderRadius.circular(20),

      // Tap: Navigate to task detail screen (disabled when delete is shown)
      onTap: _showDelete
          ? null
          : () => Navigation.gotoWidget(
                context,
                TaskDetailScreen(groupIndex: widget.index),
              ),

      // Long press: Show delete button
      onLongPress: () => setState(() => _showDelete = true),

      // Tap down: Hide delete button if tap is outside the delete area
      onTapDown: _showDelete
          ? (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset local = box.globalToLocal(details.globalPosition);
              final Size size = box.size;

              const double buttonWidth = 100;
              const double buttonHeight = 50;

              final bool inDeleteArea = local.dx > size.width - buttonWidth &&
                  local.dy < buttonHeight;

              if (!inDeleteArea) {
                setState(() => _showDelete = false);
              }
            }
          : null,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main row: Progress circle + task count + name/description
            Row(
              children: [
                Row(
                  children: [
                    // Circular progress with percentage
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(
                              value: widget.task.progress,
                              strokeWidth: 5,
                              backgroundColor: progressColor.withAlpha(51),
                              valueColor: AlwaysStoppedAnimation(progressColor),
                            ),
                          ),
                          Center(
                            child: Text(
                              "${(widget.task.progress * 100).toInt()}%",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: _fontscale(11),
                                fontWeight: FontWeight.bold,
                                color: progressColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Task count label
                    Text(
                      "${widget.task.totalTasks} Tasks",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: _fontscale(13),
                        color: AppColor.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),

                // Group name and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.name,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: _fontscale(16),
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.task.description,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: _fontscale(14),
                          color: AppColor.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Delete button (shown only when _showDelete is true)
            if (_showDelete)
              Positioned(
                top: 8,
                right: 8,
                child: ElevatedButton.icon(
                  // Show confirmation dialog before deletion
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          "Delete Task Group?",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: _fontscale(20),
                            color: AppColor.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        content: Text(
                          "Do you want to delete this task group? This action cannot be undone.",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: _fontscale(16),
                            color: AppColor.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        actions: [
                          // Cancel deletion
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: _fontscale(14),
                                color: AppColor.primaryLight,
                              ),
                            ),
                          ),

                          // Confirm deletion
                          ElevatedButton(
                            onPressed: () async {
                              await provider.deleteGroup(widget.index);
                              Navigation.goBack(ctx);
                              setState(() => _showDelete = false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.activeRed,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: _fontscale(14),
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.activeRed,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  icon: Icon(Icons.delete_outline,
                      size: _fontscale(16), color: AppColor.white),
                  label: Text(
                    "Delete",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: _fontscale(13),
                      color: AppColor.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
