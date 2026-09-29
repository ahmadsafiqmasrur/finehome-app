import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
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
  Professional? _selectedProfessional;

  // Koordinat Jakarta Selatan (Senopati / Kebayoran Baru)
  LatLng _centerLocation = const LatLng(-6.2250, 106.8080);
  final double _zoomLevel = 13.5;

  @override
  void initState() {
    super.initState();
    _selectedProfessional = IndonesiaData.professionals[0];
  }

  void _moveToCity(IndonesianCity city) {
    AppState().setCity(city);
    setState(() {
      _centerLocation = LatLng(city.latitude, city.longitude);
      _mapController.move(_centerLocation, 13.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return Scaffold(
      body: Stack(
        children: [
          // FlutterMap OpenStreetMap Indonesia
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centerLocation,
              initialZoom: _zoomLevel,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.fixy.indonesia.app',
              ),
              MarkerLayer(
                markers: [
                  // Marker Lokasi Pelanggan (Rumah)
                  Marker(
                    point: _centerLocation,
                    width: 50,
                    height: 50,
                    child: Container(
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
                      child: const Icon(Icons.person_pin_circle_rounded, color: Colors.white, size: 28),
                    ),
                  ),

                  // Marker Teknisi-Teknisi Indonesia
                  ...IndonesiaData.professionals.map((pro) {
                    final isSelected = _selectedProfessional?.id == pro.id;
                    return Marker(
                      point: LatLng(pro.latitude, pro.longitude),
                      width: isSelected ? 60 : 48,
                      height: isSelected ? 60 : 48,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedProfessional = pro;
                            _mapController.move(LatLng(pro.latitude, pro.longitude), 14.5);
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF10B981) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : AppTheme.primary,
                              width: isSelected ? 3 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: isSelected ? 24 : 18,
                              backgroundImage: NetworkImage(pro.avatarUrl),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Top Header & City Switcher Pill
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.near_me_rounded, color: AppTheme.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Peta Sebaran Mitra: ${state.selectedCity.name}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const Text(
                                '6 Teknisi bersertifikat sedang standby',
                                style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w600),
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
                ],
              ),
            ),
          ),

          // Floating GPS Reset Button
          Positioned(
            right: 16,
            bottom: _selectedProfessional != null ? 240 : 30,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              onPressed: () {
                _mapController.move(_centerLocation, 14.0);
              },
              child: const Icon(Icons.my_location_rounded),
            ),
          ),

          // Bottom Sheet: Detail Teknisi Terpilih di Peta
          if (_selectedProfessional != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(_selectedProfessional!.avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _selectedProfessional!.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified_rounded, size: 16, color: AppTheme.secondary),
                                ],
                              ),
                              Text(
                                _selectedProfessional!.role,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${_selectedProfessional!.rating}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Text(
                                    ' (${_selectedProfessional!.totalReviews} Ulasan)',
                                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD1FAE5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Siaga Standby',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_bike_rounded, size: 18, color: AppTheme.primary),
                              const SizedBox(width: 6),
                              Text(
                                'Area: ${_selectedProfessional!.area}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const Text(
                            '± 15 mnt tiba',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                            label: const Text('Chat'),
                            onPressed: () => context.push('/chat'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today_rounded, size: 18),
                            label: const Text('Pesan Teknisi Ini'),
                            onPressed: () => context.push('/book/srv-ac-1?proId=${_selectedProfessional!.id}'),
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
