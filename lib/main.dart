import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        fontFamily: 'Quicksand',
      ),
      // rota inicial
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const Placeholder(), // troque pela sua tela
        AppRoutes.home: (_) => const Placeholder(),  // troque pela sua tela
        // …demais rotas
      },
    );
  }
}
