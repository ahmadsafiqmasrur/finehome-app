import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/indonesia_data.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class BookingScreen extends StatefulWidget {
  final String serviceId;
  final String? proId;
  const BookingScreen({super.key, required this.serviceId, this.proId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // State Jadwal & Pengingat
  bool _isScheduled = false; // Default: Pengerjaan langsung hari ini / secepatnya
  bool _enableReminder = true; // Pengingat otomatis
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late ServiceItem _service;
  Professional? _selectedProfessional;

  @override
  void initState() {
    super.initState();
    _service = IndonesiaData.services.firstWhere(
      (s) => s.id == widget.serviceId,
      orElse: () => IndonesiaData.services[0],
    );

    _addressController.text = AppState().userAddress;
    _selectedProfessional = IndonesiaData.professionals[0];
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Pesanan'), // 1. Judul Halaman Baru
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Ringkasan Layanan
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_service.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_service.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text('Estimasi Pengerjaan: ${_service.duration}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                        const SizedBox(height: 4),
                        Text(
                          IndonesiaData.formatRupiah(_service.price),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Alamat Lengkap
            const Text(
              'Alamat Rumah / Lokasi Pengerjaan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Contoh: Jl. Senopati No. 42, RT 02/05, Kebayoran Baru, Jakarta Selatan',
                prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.primary),
              ),
            ),

            const SizedBox(height: 20),

            // 2. SUB PILIHAN: Jadwalkan Layanan Kapan Saja
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isScheduled ? AppTheme.primary : AppTheme.border,
                  width: _isScheduled ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: AppTheme.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isScheduled ? AppTheme.primaryLight : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: _isScheduled ? AppTheme.primary : AppTheme.textSecondary,
                        size: 22,
                      ),
                    ),
                    title: const Text(
                      'Jadwalkan Layanan Kapan Saja',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _isScheduled
                          ? 'Atur tanggal & jam kedatangan teknisi di bawah'
                          : 'Nonaktif: Teknisi meluncur secepatnya hari ini',
                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                    value: _isScheduled,
                    onChanged: (val) {
                      setState(() => _isScheduled = val);
                    },
                  ),

                  // Bagian Detail Jadwal & Pengingat (Hanya tampil jika diaktifkan)
                  if (_isScheduled) ...[
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Pilih Tanggal
                          const Text('Pilih Tanggal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 30)),
                              );
                              if (picked != null) {
                                setState(() => _selectedDate = picked);
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.event_rounded, size: 18, color: AppTheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        IndonesiaData.formatDate(_selectedDate),
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const Text('Ubah', style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // 2. Pilih Jam Kedatangan
                          const Text('Pilih Jam Kedatangan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime,
                              );
                              if (pickedTime != null) {
                                setState(() => _selectedTime = pickedTime);
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_rounded, size: 18, color: AppTheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Pukul ${_selectedTime.format(context)} WIB',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const Text('Ubah Jam', style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // 3. Aktifkan Pengingat
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.notifications_active_rounded, color: AppTheme.primary, size: 20),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Aktifkan Pengingat',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                      ),
                                      Text(
                                        'Kirim notifikasi pengingat sebelum jadwal agar Anda dan tukang tidak lupa.',
                                        style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _enableReminder,
                                  activeColor: AppTheme.primary,
                                  onChanged: (val) {
                                    setState(() => _enableReminder = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Catatan Tambahan
            const Text(
              'Catatan Tambahan untuk Teknisi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Misal: Mohon bawa tangga lipat, AC di lantai 2, atau toren di dak atas.',
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estimasi Biaya', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  Text(
                    IndonesiaData.formatRupiah(_service.price),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 190,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final timeText = _isScheduled
                      ? 'Pukul ${_selectedTime.format(context)} WIB'
                      : 'Secepatnya (Hari ini)';

                  context.push(
                    '/payment',
                    extra: {
                      'service': _service,
                      'professional': _selectedProfessional,
                      'scheduledDate': _isScheduled ? _selectedDate : DateTime.now(),
                      'timeSlot': timeText,
                      'address': _addressController.text.trim().isEmpty
                          ? AppState().userAddress
                          : _addressController.text.trim(),
                      'notes': _notesController.text.trim(),
                    },
                  );
                },
                child: const Text('Lanjut Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
