import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    DevicePreview(
      enabled: true, // Selalu aktifkan DevicePreview di Vercel/Web Demo
      builder: (context) => const FineHomeApp(),
    ),
  );
}

class FineHomeApp extends StatelessWidget {
  const FineHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'FineHome - Jasa Tukang & Teknisi Rumah On-Demand',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
