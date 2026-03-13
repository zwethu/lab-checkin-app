import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lab_test_app/core/app_router.dart';
import 'package:lab_test_app/models/checkin_hive_model.dart';
import 'package:lab_test_app/providers/checkin_provider.dart';
import 'package:provider/provider.dart';
import 'core/app_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(CheckinHiveModelAdapter());
  await Hive.openBox<CheckinHiveModel>('checkin_history');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckinProvider()
        ..fetchClasses()
        ..loadHistory()
        ..syncFromFirestore(),
      child: MaterialApp.router(
      routerConfig: appRouter,
      title: 'Smart Class Check-in',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
    ),
    );
  }
}
