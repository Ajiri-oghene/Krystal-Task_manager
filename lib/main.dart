// FILE: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/features/landing_page.dart';
import 'package:task_manager/features/models/task_group.dart';
import 'package:task_manager/features/models/task_item.dart';
import 'package:task_manager/providers/task_provider.dart';

/// App entry point – initializes storage and splash screen
void main() async {
  // Preserve splash screen until app is ready
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Hive for local data storage
  await Hive.initFlutter();

  // Register custom data models
  Hive.registerAdapter(TaskGroupAdapter());
  Hive.registerAdapter(TaskItemAdapter());

  // Open database boxes
  final groupBox = await Hive.openBox<TaskGroup>('task_groups');
  final settingsBox = await Hive.openBox('app_settings');

  // Start the app
  runApp(MyApp(groupBox: groupBox, settingsBox: settingsBox));
}

/// Root widget – provides state management only
class MyApp extends StatefulWidget {
  final Box<TaskGroup> groupBox;
  final Box settingsBox;

  const MyApp({super.key, required this.groupBox, required this.settingsBox});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Remove splash screen after first frame
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  /// Build MaterialApp with default theme (no custom styling)
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Make TaskProvider available app-wide
      create: (_) => TaskProvider(widget.groupBox, widget.settingsBox),
      child: const MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        home: OnboardingScreen(),
      ),
    );
  }
}
