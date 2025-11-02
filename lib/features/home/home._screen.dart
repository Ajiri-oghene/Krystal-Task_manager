// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:task_manager/features/home/component/task_group_card.dart';
// import 'package:task_manager/providers/task_provider.dart';
// import 'package:task_manager/utils/colors.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   // Font scaling
//   double fontScale(BuildContext context, double size) {
//     final isTablet = MediaQuery.of(context).size.width > 600;
//     return isTablet ? size * 1.3 : size;
//   }

//   // Responsive horizontal padding
//   double horizontalPadding(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return width > 600 ? width * 0.08 : 20.0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hp = horizontalPadding(context);

//     return Scaffold(
//       backgroundColor: AppColor.background,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: hp),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),

//               // Top Progress Card
//               Consumer<TaskProvider>(
//                 builder: (context, provider, _) {
//                   final progress = provider.globalProgress;
//                   // final fs = fontScale(context, 18);
//                   final circleSize =
//                       MediaQuery.of(context).size.width > 600 ? 100.0 : 80.0;
//                   return Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: AppColor.primaryDark,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColor.primaryLight,
//                           blurRadius: 15,
//                           offset: const Offset(0, 8),
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           child: Text(
//                             "Progress Status On\nYour Tasks",
//                             style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               color: AppColor.white,
//                               fontSize: fontScale(context, 18),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: circleSize,
//                           height: circleSize,
//                           child: Stack(
//                             children: [
//                               SizedBox(
//                                 width: circleSize,
//                                 height: circleSize,
//                                 child: CircularProgressIndicator(
//                                   value: progress,
//                                   strokeWidth: 8,
//                                   backgroundColor: AppColor.primaryLight,
//                                   color: AppColor.white,
//                                 ),
//                               ),
//                               Center(
//                                 child: Text(
//                                   "${(progress * 100).toInt()}%",
//                                   style: TextStyle(
//                                     fontFamily: 'Montserrat',
//                                     color: AppColor.white,
//                                     fontSize: fontScale(context, 20),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 32),

//               // Header: Task Groups + Count
//               Text(
//                 "Task Groups",
//                 style: TextStyle(
//                   fontFamily: 'Montserrat',
//                   fontSize: fontScale(context, 20),
//                   fontWeight: FontWeight.w800,
//                   color: AppColor.black,
//                 ),
//               ),

//               const SizedBox(height: 4),

//               Consumer<TaskProvider>(
//                 builder: (context, provider, _) => Text(
//                   "${provider.groups.length} Task Groups",
//                   style: TextStyle(
//                       fontFamily: 'Montserrat',
//                       fontSize: fontScale(context, 14),
//                       color: AppColor.textLight,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               Expanded(
//                 child: Consumer<TaskProvider>(
//                   builder: (context, provider, _) {
//                     if (!provider.isLoaded) {
//                       return const Center(
//                         child: CircularProgressIndicator(
//                           color: AppColor.primaryDark,
//                         ),
//                       );
//                     }

//                     final groups = provider.filteredGroups;

//                     return Column(
//                       children: [
//                         // Search bar
//                         TextField(
//                           onChanged: provider.setSearchQuery,
//                           decoration: InputDecoration(
//                             hintText: 'Search task groups...',
//                             prefixIcon: const Icon(Icons.search),
//                             suffixIcon: IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: provider.clearSearch,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Task group list
//                         Expanded(
//                           child: groups.isEmpty
//                               ? Center(
//                                   child: Text(
//                                     "No task groups found.",
//                                     style: TextStyle(
//                                       fontFamily: 'Montserrat',
//                                       fontSize: fontScale(context, 20),
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 )
//                               : ListView.builder(
//                                   itemCount: groups.length,
//                                   itemBuilder: (context, index) {
//                                     return TaskGroupCard(
//                                       task: groups[index],
//                                       index: index,
//                                     );
//                                   },
//                                 ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),

//       // FAB: Only show when loaded
//       floatingActionButton: Consumer<TaskProvider>(
//         builder: (context, provider, _) {
//           return provider.isLoaded
//               ? _buildFAB(context)
//               : const SizedBox.shrink();
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   // FAB
//   Widget _buildFAB(BuildContext context) {
//     return Container(
//       width: 64,
//       height: 64,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColor.primaryDark,
//       ),
//       child: FloatingActionButton(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         onPressed: () => _showAddGroupDialog(context),
//         child: const Icon(Icons.add, size: 32, color: AppColor.white),
//       ),
//     );
//   }

//   // Add Group Dialog
//   void _showAddGroupDialog(BuildContext context) {
//     final nameController = TextEditingController();
//     final descController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           "Add New Task Group",
//           style: TextStyle(
//             fontFamily: 'Montserrat',
//             fontSize: fontScale(context, 20),
//             fontWeight: FontWeight.w600,
//             color: AppColor.black,
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: "Name",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: Text(
//               "Cancel",
//               style: TextStyle(
//                 fontFamily: 'Montserrat',
//                 fontSize: fontScale(context, 13),
//                 color: AppColor.primaryDark,
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColor.primaryDark,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () async {
//               final name = nameController.text.trim();
//               final desc = descController.text.trim();
//               if (name.isNotEmpty) {
//                 await context.read<TaskProvider>().addGroup(name, desc);
//                 Navigator.pop(ctx);
//               }
//             },
//             child: const Text(
//               "Add",
//               style: TextStyle(
//                 color: AppColor.white,
//                 fontFamily: 'Montserrat',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// FILE: lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/features/home/component/task_group_card.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/utils/colors.dart';

/// Main home screen – shows global progress, task group count, search, list, and FAB
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Scales font size based on device width (tablet vs phone)
  double fontScale(BuildContext context, double size) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return isTablet ? size * 1.3 : size;
  }

  /// Calculates responsive horizontal padding (8% on tablets, 20px on phones)
  double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? width * 0.08 : 20.0;
  }

  /// Builds the full Scaffold with SafeArea, progress card, list, and FAB
  @override
  Widget build(BuildContext context) {
    final hp = horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Global progress card with circular indicator
              Consumer<TaskProvider>(
                builder: (context, provider, _) {
                  final progress = provider.globalProgress;
                  final circleSize =
                      MediaQuery.of(context).size.width > 600 ? 100.0 : 80.0;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColor.primaryDark,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryLight,
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Progress Status On\nYour Tasks",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: AppColor.white,
                              fontSize: fontScale(context, 18),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: circleSize,
                                height: circleSize,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 8,
                                  backgroundColor: AppColor.primaryLight,
                                  color: AppColor.white,
                                ),
                              ),
                              Center(
                                child: Text(
                                  "${(progress * 100).toInt()}%",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: AppColor.white,
                                    fontSize: fontScale(context, 20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Section title: "Task Groups"
              Text(
                "Task Groups",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: fontScale(context, 20),
                  fontWeight: FontWeight.w800,
                  color: AppColor.black,
                ),
              ),

              const SizedBox(height: 4),

              // Dynamic count of task groups
              Consumer<TaskProvider>(
                builder: (context, provider, _) => Text(
                  "${provider.groups.length} Task Groups",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: fontScale(context, 14),
                      color: AppColor.textLight,
                      fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 16),

              // Search + List area (takes remaining space)
              Expanded(
                child: Consumer<TaskProvider>(
                  builder: (context, provider, _) {
                    // Show loading spinner while data is loading
                    if (!provider.isLoaded) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primaryDark,
                        ),
                      );
                    }

                    final groups = provider.filteredGroups;

                    return Column(
                      children: [
                        // Search bar with clear button
                        TextField(
                          onChanged: provider.setSearchQuery,
                          decoration: InputDecoration(
                            hintText: 'Search task groups...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: provider.clearSearch,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // List of task group cards or empty message
                        Expanded(
                          child: groups.isEmpty
                              ? Center(
                                  child: Text(
                                    "No task groups found.",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: fontScale(context, 20),
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: groups.length,
                                  itemBuilder: (context, index) {
                                    return TaskGroupCard(
                                      task: groups[index],
                                      index: index,
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button – only visible when data is loaded
      floatingActionButton: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          return provider.isLoaded
              ? _buildFAB(context)
              : const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Builds the circular FAB with plus icon
  Widget _buildFAB(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.primaryDark,
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => _showAddGroupDialog(context),
        child: const Icon(Icons.add, size: 32, color: AppColor.white),
      ),
    );
  }

  /// Shows dialog to add a new task group with name and description fields
  void _showAddGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Add New Task Group",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: fontScale(context, 20),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: fontScale(context, 13),
                color: AppColor.primaryDark,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          // Add button – validates name and calls provider
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final name = nameController.text.trim();
              final desc = descController.text.trim();
              if (name.isNotEmpty) {
                await context.read<TaskProvider>().addGroup(name, desc);
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              "Add",
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
