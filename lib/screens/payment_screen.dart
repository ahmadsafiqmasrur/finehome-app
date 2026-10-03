import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/indonesia_data.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const PaymentScreen({super.key, required this.bookingData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethodId = 'qris';
  bool _isProcessing = false;

  void _showSearchingDialogAndRedirect(Booking newBooking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: AppTheme.primary,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  const Icon(Icons.build_circle_rounded, size: 36, color: AppTheme.primary),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sistem sedang mencocokkan teknisi terdekat di sekitar lokasi Anda...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    // Timer 3 detik lalu redirect ke Peta
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context); // Tutup dialog
        context.go('/map'); // Redirect ke Peta!
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.bookingData['service'] as ServiceItem;
    final pro = widget.bookingData['professional'] as Professional;
    final scheduledDate = widget.bookingData['scheduledDate'] as DateTime;
    final timeSlot = widget.bookingData['timeSlot'] as String;
    final address = widget.bookingData['address'] as String;
    final notes = widget.bookingData['notes'] as String;

    final int subtotal = service.price;
    const int appFee = 5000;
    final int total = subtotal + appFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Pemesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Ringkasan Pesanan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(service.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        IndonesiaData.formatRupiah(service.price),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: AppTheme.border),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        '${IndonesiaData.formatDate(scheduledDate)} • $timeSlot',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pilihan Metode Pembayaran
            const Text(
              'Pilih Pembayaran Indonesia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: IndonesiaData.paymentMethods.length,
              itemBuilder: (context, index) {
                final method = IndonesiaData.paymentMethods[index];
                final isSelected = _selectedMethodId == method['id'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryLight : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(method['icon'] as IconData, color: isSelected ? AppTheme.primary : AppTheme.textPrimary),
                    ),
                    title: Row(
                      children: [
                        Text(
                          method['name'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                          ),
                        ),
                        if (method['isPopular'] == true) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Rekomendasi', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(method['description'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    trailing: Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                      size: 22,
                    ),
                    onTap: () => setState(() => _selectedMethodId = method['id'] as String),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Rincian Biaya
            const Text(
              'Rincian Biaya Transparan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biaya Layanan Jasa', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      Text(IndonesiaData.formatRupiah(subtotal), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biaya Layanan Aplikasi FINE', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      Text(IndonesiaData.formatRupiah(appFee), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppTheme.border),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        IndonesiaData.formatRupiah(total),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppTheme.border.withValues(alpha: 0.8))),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () async {
                    setState(() => _isProcessing = true);
                    await Future.delayed(const Duration(milliseconds: 800));
                    if (!mounted) return;

                    final newBookingId = 'FINEHOME-ID-${Random().nextInt(90000) + 10000}';
                    final selectedMethodName = IndonesiaData.paymentMethods.firstWhere(
                      (m) => m['id'] == _selectedMethodId,
                    )['name'] as String;

                    final newBooking = Booking(
                      id: newBookingId,
                      service: service,
                      professional: pro,
                      scheduledDate: scheduledDate,
                      timeSlot: timeSlot,
                      address: address,
                      city: AppState().selectedCity.name,
                      notes: notes,
                      paymentMethod: selectedMethodName,
                      totalPrice: total,
                      status: BookingStatus.menungguKonfirmasi,
                      createdAt: DateTime.now(),
                    );

                    AppState().addBooking(newBooking);
                    setState(() => _isProcessing = false);

                    // Tampilkan Dialog Cari Teknisi dan Auto Redirect ke Peta!
                    _showSearchingDialogAndRedirect(newBooking);
                  },
            child: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text('Konfirmasi & Bayar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
