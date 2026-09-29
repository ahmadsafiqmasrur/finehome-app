import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FixyIndonesiaApp());
}

class FixyIndonesiaApp extends StatelessWidget {
  const FixyIndonesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FineHome - Jasa Tukang & Teknisi Rumah On-Demand',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
