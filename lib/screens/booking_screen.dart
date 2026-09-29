import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/indonesia_data.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class BookingScreen extends StatefulWidget {
  final String serviceId;
  final String? initialProfessionalId;

  const BookingScreen({
    super.key,
    required this.serviceId,
    this.initialProfessionalId,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late ServiceItem _service;
  late Professional _selectedProfessional;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeSlot = IndonesiaData.timeSlots[0];
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = IndonesiaData.services.firstWhere(
      (s) => s.id == widget.serviceId,
      orElse: () => IndonesiaData.services[0],
    );

    if (widget.initialProfessionalId != null) {
      _selectedProfessional = IndonesiaData.professionals.firstWhere(
        (p) => p.id == widget.initialProfessionalId,
        orElse: () => IndonesiaData.professionals[0],
      );
    } else {
      _selectedProfessional = IndonesiaData.professionals[0];
    }

    _addressController.text = AppState().userAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Jadwalkan Layanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Layanan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.handyman_rounded, color: AppTheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _service.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          IndonesiaData.formatRupiah(_service.price),
                          style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pilih Tanggal
            const Text(
              'Pilih Tanggal Pengerjaan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        IndonesiaData.formatDate(_selectedDate),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
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
                    child: const Text('Ubah'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pilih Slot Waktu
            const Text(
              'Pilih Waktu Kedatangan Teknisi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: IndonesiaData.timeSlots.map((slot) {
                final isSelected = _selectedTimeSlot == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryLight,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedTimeSlot = slot);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Alamat Lengkap di Indonesia
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

            const SizedBox(height: 20),

            // Pilihan Teknisi Mitra
            const Text(
              'Pilih Mitra Teknisi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Professional>(
                  isExpanded: true,
                  value: _selectedProfessional,
                  items: IndonesiaData.professionals.map((pro) {
                    return DropdownMenuItem<Professional>(
                      value: pro,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(pro.avatarUrl),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${pro.name} (${pro.rating} ★ - ${pro.city})',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (pro) {
                    if (pro != null) setState(() => _selectedProfessional = pro);
                  },
                ),
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
                  // Navigate to Payment
                  context.push(
                    '/payment',
                    extra: {
                      'service': _service,
                      'professional': _selectedProfessional,
                      'scheduledDate': _selectedDate,
                      'timeSlot': _selectedTimeSlot,
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
