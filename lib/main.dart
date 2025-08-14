import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'routes/app_routes.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const EmaidApp());
}

class EmaidApp extends StatelessWidget {
  const EmaidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Maid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),

      // >>> Escolha apenas um caminho de arranque (initialRoute OU home) <<<
      initialRoute: AppRoutes.splash,

      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login : (_) => const LoginScreen(),
        AppRoutes.home  : (_) => const HomeScreen(),
      },
    );
  }
}
