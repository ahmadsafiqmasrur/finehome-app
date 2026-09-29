import 'package:flutter/material.dart';
import '../data/indonesia_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';

class ServicesScreen extends StatefulWidget {
  final String? initialCategory;
  const ServicesScreen({super.key, this.initialCategory});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late String _selectedCategoryId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategory ?? 'all';
  }

  @override
  Widget build(BuildContext context) {
    List<ServiceItem> filtered = IndonesiaData.services.where((service) {
      final matchCategory = _selectedCategoryId == 'all' || service.categoryId == _selectedCategoryId;
      final matchSearch = _searchQuery.isEmpty ||
          service.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Katalog Layanan & Jasa'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari jasa: AC, pipa, kelistrikan...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Horizontal Category Filter Chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Semua Layanan'),
                    selected: _selectedCategoryId == 'all',
                    onSelected: (_) => setState(() => _selectedCategoryId = 'all'),
                    selectedColor: AppTheme.primaryLight,
                    checkmarkColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: _selectedCategoryId == 'all' ? AppTheme.primary : AppTheme.textPrimary,
                      fontWeight: _selectedCategoryId == 'all' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                ...IndonesiaData.categories.map((cat) {
                  final isSelected = _selectedCategoryId == cat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      avatar: Icon(cat.icon, size: 16, color: isSelected ? AppTheme.primary : cat.color),
                      label: Text(cat.title),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategoryId = cat.id),
                      selectedColor: AppTheme.primaryLight,
                      checkmarkColor: AppTheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Count & Sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ditemukan ${filtered.length} layanan',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: const [
                    Icon(Icons.tune_rounded, size: 16, color: AppTheme.primary),
                    SizedBox(width: 4),
                    Text('Filter', style: TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          // Service Items List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off_rounded, size: 64, color: AppTheme.textMuted),
                        SizedBox(height: 12),
                        Text('Layanan tidak ditemukan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Coba kata kunci lain atau pilih kategori lain', style: TextStyle(color: AppTheme.textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ServiceCard(service: filtered[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
