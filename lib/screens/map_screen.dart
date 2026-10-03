import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/indonesia_data.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  
  // Lokasi User (Senopati / Kebayoran Baru, Jakarta Selatan)
  LatLng _userLocation = const LatLng(-6.2250, 106.8080);
  final double _zoomLevel = 14.0;

  bool _isSearching = false;
  Professional? _assignedProfessional;
  String? _activeServiceTitle;

  @override
  void initState() {
    super.initState();
    _checkActiveBooking();
  }

  // Cek apakah user sudah punya pesanan aktif dari transaksi pembayaran
  void _checkActiveBooking() {
    final activeBookings = AppState().bookings.where(
      (b) => b.status != BookingStatus.dibatalkan && b.status != BookingStatus.selesai
    ).toList();

    if (activeBookings.isNotEmpty) {
      final latestBooking = activeBookings.first;
      _assignedProfessional = latestBooking.professional;
      _activeServiceTitle = latestBooking.service.title;
    }
  }

  void _moveToCity(IndonesianCity city) {
    AppState().setCity(city);
    setState(() {
      _userLocation = LatLng(city.latitude, city.longitude);
      _assignedProfessional = null;
      _mapController.move(_userLocation, 14.0);
    });
  }

  // Bottom Sheet Pilihan Kategori Layanan (Jika pesan langsung dari Peta)
  void _showCategoryPickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pilih Spesialisasi Layanan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Text(
                'Sistem akan mencocokkan mitra teknisi yang ahli di bidang yang Anda pilih.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: IndonesiaData.categories.length,
                  itemBuilder: (context, index) {
                    final cat = IndonesiaData.categories[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(cat.icon, color: AppTheme.primary, size: 20),
                        ),
                        title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('${cat.itemCount} Jenis Layanan', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.primary),
                        onTap: () {
                          Navigator.pop(context);
                          _startSearchingTechnicianForCategory(cat);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Simulasi Pencarian Teknisi Spesialis dari Peta
  void _startSearchingTechnicianForCategory(ServiceCategory category) {
    setState(() {
      _activeServiceTitle = category.name;
      _isSearching = true;
    });

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
                  Icon(category.icon, size: 34, color: AppTheme.primary),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Mencari Teknisi ${category.name}...',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sistem sedang menghubungkan Anda dengan mitra teknisi siaga di area sekitar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
        setState(() {
          _isSearching = false;
          _assignedProfessional = IndonesiaData.professionals[0];
          
          _mapController.move(
            LatLng(
              (_userLocation.latitude + _assignedProfessional!.latitude) / 2,
              (_userLocation.longitude + _assignedProfessional!.longitude) / 2,
            ),
            13.5,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text('Teknisi ${_assignedProfessional!.name} (${category.name}) ditemukan & menuju lokasi!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _resetBooking() {
    setState(() {
      _assignedProfessional = null;
      _activeServiceTitle = null;
      _mapController.move(_userLocation, 14.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState();
    _checkActiveBooking(); // Selalu sync dengan AppState

    final List<LatLng> routePoints = _assignedProfessional != null
        ? [
            LatLng(_assignedProfessional!.latitude, _assignedProfessional!.longitude),
            _userLocation,
          ]
        : [];

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: _zoomLevel,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.finehome.indonesia.app',
              ),

              if (_assignedProfessional != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4.5,
                      color: AppTheme.primary,
                    ),
                  ],
                ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: _userLocation,
                    width: 60,
                    height: 60,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Lokasi Saya',
                            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_pin_circle_rounded, color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                  ),

                  if (_assignedProfessional != null)
                    Marker(
                      point: LatLng(_assignedProfessional!.latitude, _assignedProfessional!.longitude),
                      width: 65,
                      height: 65,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _assignedProfessional!.name.split(' ')[0],
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.secondary, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(_assignedProfessional!.avatarUrl),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Header Top
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Wilayah Terpilih', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                            Text(
                              '${state.selectedCity.name}, ${state.selectedCity.province}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<IndonesianCity>(
                        icon: const Icon(Icons.swap_horiz_rounded, color: AppTheme.primary),
                        tooltip: 'Ganti Wilayah',
                        onSelected: _moveToCity,
                        itemBuilder: (context) {
                          return IndonesiaData.cities.map((city) {
                            return PopupMenuItem(
                              value: city,
                              child: Text(city.name),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating Button GPS Centering
          Positioned(
            right: 16,
            bottom: _assignedProfessional != null ? 250 : 110,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              onPressed: () {
                _mapController.move(_userLocation, 14.0);
              },
              child: const Icon(Icons.my_location_rounded),
            ),
          ),

          // BOTTOM SHEET 1: Belum Ada Pesanan Aktif (Opsi Pesan Langsung dari Peta)
          if (_assignedProfessional == null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.flash_on_rounded, color: AppTheme.primary),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Layanan Cepat Terdekat',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                'Pilih kategori layanan dan sistem akan otomatis mencarikan teknisi terbaik.',
                                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.search_rounded),
                        label: const Text('Pilih Layanan & Cari Teknisi'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isSearching ? null : _showCategoryPickerSheet,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // BOTTOM SHEET 2: Ada Pesanan Aktif / Teknisi Ditemukan (Status Tracking Live)
          if (_assignedProfessional != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.directions_bike_rounded, size: 20, color: Color(0xFF059669)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Teknisi ${_activeServiceTitle ?? 'Siaga'} Menuju Lokasi',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '~ 15 Menit',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(_assignedProfessional!.avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _assignedProfessional!.name,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified_rounded, size: 16, color: AppTheme.secondary),
                                ],
                              ),
                              Text(
                                '${_assignedProfessional!.role} • ⭐ ${_assignedProfessional!.rating}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                            label: const Text('Chat Teknisi'),
                            onPressed: () => context.push('/chat'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                            ),
                            icon: const Icon(Icons.close_rounded, size: 18),
                            label: const Text('Selesai / Batal'),
                            onPressed: _resetBooking,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
