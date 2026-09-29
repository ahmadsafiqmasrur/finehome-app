import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/indonesia_data.dart';
import '../models/models.dart';
import '../screens/auth_screen.dart';
import '../screens/booking_confirmation_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/emergency_screen.dart';
import '../screens/main_nav_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/professionals_screen.dart';
import '../screens/service_detail_screen.dart';
import '../screens/services_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavScreen(initialIndex: 0),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MainNavScreen(initialIndex: 1),
    ),
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const MainNavScreen(initialIndex: 2),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const MainNavScreen(initialIndex: 3),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MainNavScreen(initialIndex: 4),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) {
        final cat = state.uri.queryParameters['cat'];
        return ServicesScreen(initialCategory: cat);
      },
    ),
    GoRoute(
      path: '/services/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'srv-ac-1';
        return ServiceDetailScreen(serviceId: id);
      },
    ),
    GoRoute(
      path: '/professionals',
      builder: (context, state) => const ProfessionalsScreen(),
    ),
    GoRoute(
      path: '/professionals/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'pro-1';
        return ProfessionalDetailScreen(professionalId: id);
      },
    ),
    GoRoute(
      path: '/book/:serviceId',
      builder: (context, state) {
        final serviceId = state.pathParameters['serviceId'] ?? 'srv-ac-1';
        final proId = state.uri.queryParameters['proId'];
        return BookingScreen(serviceId: serviceId, initialProfessionalId: proId);
      },
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final details = state.extra as Map<String, dynamic>? ??
            {
              'service': IndonesiaData.services[0],
              'professional': IndonesiaData.professionals[0],
              'scheduledDate': DateTime.now().add(const Duration(days: 1)),
              'timeSlot': IndonesiaData.timeSlots[0],
              'address': 'Jl. Senopati No. 42, Kebayoran Baru, Jakarta Selatan',
              'notes': '',
            };
        return PaymentScreen(bookingDetails: details);
      },
    ),
    GoRoute(
      path: '/booking-confirmation',
      builder: (context, state) {
        final booking = state.extra as Booking? ?? IndonesiaData.sampleActiveBooking;
        return BookingConfirmationScreen(booking: booking);
      },
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const EmergencyScreen(),
    ),
    GoRoute(
      path: '/professional-registration',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Daftar Mitra Teknisi Fixy')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bergabung Jadi Mitra Teknisi Fixy Indonesia 🛠️',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Dapatkan penghasilan harian hingga Rp 8.000.000+/bulan dengan jam kerja fleksibel dan jaminan asuransi kerja.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap (sesuai KTP)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nomor WhatsApp Aktif',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Keahlian Utama (AC / Pipa / Listrik / Bangunan)',
                  prefixIcon: Icon(Icons.handyman_outlined),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pendaftaran mitra berhasil diajukan! Tim Fixy akan menghubungi Anda via WhatsApp.'),
                      ),
                    );
                    context.pop();
                  },
                  child: const Text('Kirim Formulir Kemitraan'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);
