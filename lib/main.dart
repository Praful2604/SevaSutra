import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sevasutra_flutter/models/user.dart';
import 'package:sevasutra_flutter/screens/splash/splash_screen.dart';
import 'package:isar/isar.dart';

import 'firebase_options.dart';
import 'models/employee.dart';

late Isar isar;

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dir = await getApplicationDocumentsDirectory();

  /// ✅ FIX: Open Isar ONCE with ALL schemas
  isar = await Isar.open(
    [
      UserSchema,
      EmployeeSchema, // 🔥 REQUIRED (this was missing)
    ],
    directory: dir.path,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}