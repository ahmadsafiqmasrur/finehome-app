import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/indonesia_data.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';

class ProfessionalsScreen extends StatelessWidget {
  const ProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Daftar Teknisi & Tukang Berlisensi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined, color: AppTheme.primary, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '100% Teknisi FINE Indonesia telah lulus uji kompetensi, cek latar belakang (SKCK), dan verifikasi KTP.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textPrimary, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          ...IndonesiaData.professionals.map((pro) {
            return ProfessionalCard(professional: pro);
          }),
        ],
      ),
    );
  }
}

class ProfessionalDetailScreen extends StatelessWidget {
  final String professionalId;
  const ProfessionalDetailScreen({super.key, required this.professionalId});

  @override
  Widget build(BuildContext context) {
    final pro = IndonesiaData.professionals.firstWhere(
      (p) => p.id == professionalId,
      orElse: () => IndonesiaData.professionals[0],
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(pro.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bio Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(pro.avatarUrl),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pro.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded, color: AppTheme.secondary, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pro.role,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.border),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Rating', '${pro.rating} ★', const Color(0xFFF59E0B)),
                      _buildStatColumn('Pekerjaan', '${pro.completedJobs}', AppTheme.primary),
                      _buildStatColumn('Pengalaman', '${pro.experienceYears} Thn', AppTheme.secondary),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bio
            const Text(
              'Profil Singkat & Pengalaman',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                pro.bio,
                style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, height: 1.5),
              ),
            ),

            const SizedBox(height: 16),

            // Keahlian Khusus
            const Text(
              'Keahlian Spesialisasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pro.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_rounded, size: 16, color: AppTheme.primary),
                      const SizedBox(width: 6),
                      Text(skill, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
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
              child: OutlinedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Chat'),
                onPressed: () => context.push('/chat'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => context.push('/book/srv-ac-1?proId=${pro.id}'),
                child: const Text('Pesan Teknisi Ini'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}
