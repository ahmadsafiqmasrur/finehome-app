import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Akun Saya'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      state.userName.substring(0, 1),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              state.userName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('Gold Member', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(state.userPhone, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                        Text(state.userEmail, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppTheme.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ubah profil pengguna.')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Dompet FineHomePay & Kupon Diskon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: const [
                      Text('Saldo FinePay', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      SizedBox(height: 4),
                      Text('Rp 250.000', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(height: 30, width: 1, color: Colors.white24),
                  Column(
                    children: const [
                      Text('Kupon Diskon', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      SizedBox(height: 4),
                      Text('3 Kupon Aktif', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(height: 30, width: 1, color: Colors.white24),
                  Column(
                    children: const [
                      Text('Poin Reward', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      SizedBox(height: 4),
                      Text('1.250 Poin', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Pengaturan Akun
            _buildSectionTitle('Alamat & Lokasi'),
            _buildMenuItem(
              icon: Icons.home_outlined,
              title: 'Alamat Rumah Utama',
              subtitle: state.userAddress,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.business_outlined,
              title: 'Alamat Kantor',
              subtitle: 'Pacific Century Place Lt. 24, SCBD, Jakarta Selatan',
              onTap: () {},
            ),

            const SizedBox(height: 16),

            _buildSectionTitle('Preferensi & Keamanan'),
            _buildMenuItem(
              icon: Icons.language_rounded,
              title: 'Bahasa Aplikasi',
              subtitle: 'Bahasa Indonesia (ID)',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.security_rounded,
              title: 'Keamanan & PIN Transaksi',
              subtitle: 'PIN aktif untuk konfirmasi pemesanan',
              onTap: () {},
            ),

            const SizedBox(height: 16),

            _buildSectionTitle('Pusat Bantuan & Mitra'),
            _buildMenuItem(
              icon: Icons.chat_outlined,
              title: 'Layanan Pelanggan WhatsApp 24 Jam',
              subtitle: '+62 811-9988-7766 (Fast Response)',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka WhatsApp Customer Care Finehome...')),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.handyman_outlined,
              title: 'Daftar Jadi Mitra Teknisi FINE',
              subtitle: 'Dapatkan penghasilan harian fleksibel',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka portal pendaftaran mitra teknisi...')),
                );
              },
            ),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.emergency,
                  side: const BorderSide(color: AppTheme.emergency),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar dari Akun'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Keluar Akun?'),
                      content: const Text('Apakah Anda yakin ingin keluar dari aplikasi FINE Indonesia?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emergency),
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.go('/auth');
                          },
                          child: const Text('Keluar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
            const Text('FineHome Indonesia v1.0.0 (Build ID)', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
        onTap: onTap,
      ),
    );
  }
}
