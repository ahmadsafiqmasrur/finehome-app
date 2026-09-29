import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/indonesia_data.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Daftar Pesanan Saya'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: AppState(),
        builder: (context, _) {
          final allBookings = AppState().bookings;
          final activeBookings = allBookings
              .where((b) => b.status != BookingStatus.selesai && b.status != BookingStatus.dibatalkan)
              .toList();
          final completedBookings =
              allBookings.where((b) => b.status == BookingStatus.selesai).toList();
          final cancelledBookings =
              allBookings.where((b) => b.status == BookingStatus.dibatalkan).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingList(activeBookings, isActive: true),
              _buildBookingList(completedBookings),
              _buildBookingList(cancelledBookings),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingList(List<Booking> list, {bool isActive = false}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inbox_rounded, size: 64, color: AppTheme.textMuted),
            SizedBox(height: 12),
            Text('Belum ada pesanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Pesanan jasa perbaikan rumah Anda akan muncul di sini', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      booking.id,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: booking.status.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        booking.status.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: booking.status.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20, color: AppTheme.border),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(booking.professional.avatarUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.service.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            'Mitra: ${booking.professional.name}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${IndonesiaData.formatDate(booking.scheduledDate)} (${booking.timeSlot})',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${IndonesiaData.formatRupiah(booking.totalPrice)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary),
                    ),
                    if (isActive)
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              AppState().cancelBooking(booking.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pesanan berhasil dibatalkan.')),
                              );
                            },
                            child: const Text('Batalkan', style: TextStyle(color: AppTheme.emergency, fontSize: 12)),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                            label: const Text('Chat', style: TextStyle(fontSize: 12)),
                            onPressed: () => context.push('/chat'),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
