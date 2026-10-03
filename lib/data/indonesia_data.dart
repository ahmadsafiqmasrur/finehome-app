import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class IndonesiaData {
  // Format Currency Rupiah
  static String formatRupiah(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format Tanggal Indonesia
  static String formatDate(DateTime date) {
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    try {
      return formatter.format(date);
    } catch (_) {
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  // Kota-Kota Layanan di Indonesia
  static const List<IndonesianCity> cities = [
    IndonesianCity(
      id: 'jkt',
      name: 'DKI Jakarta',
      province: 'DKI Jakarta',
      latitude: -6.2088,
      longitude: 106.8456,
    ),
    IndonesianCity(
      id: 'bdg',
      name: 'Bandung',
      province: 'Jawa Barat',
      latitude: -6.9175,
      longitude: 107.6191,
    ),
    IndonesianCity(
      id: 'sby',
      name: 'Surabaya',
      province: 'Jawa Timur',
      latitude: -7.2575,
      longitude: 112.7521,
    ),
    IndonesianCity(
      id: 'smg',
      name: 'Semarang',
      province: 'Jawa Tengah',
      latitude: -6.9667,
      longitude: 110.4167,
    ),
    IndonesianCity(
      id: 'dps',
      name: 'Denpasar / Badung',
      province: 'Bali',
      latitude: -8.6705,
      longitude: 115.2126,
    ),
    IndonesianCity(
      id: 'mdn',
      name: 'Medan',
      province: 'Sumatera Utara',
      latitude: 3.5952,
      longitude: 98.6722,
    ),
  ];

  // Kategori Layanan Indonesia
  static const List<ServiceCategory> categories = [
    ServiceCategory(
      id: 'ac',
      title: 'Servis AC',
      description: 'Cuci AC, isi freon, bongkar pasang, & perbaikan AC bocor',
      icon: Icons.ac_unit_rounded,
      color: Color(0xFF0284C7),
    ),
    ServiceCategory(
      id: 'plumbing',
      title: 'Pipa & Ledeng',
      description: 'Pipa bocor, kran mampet, pasang toren & instalasi pompa',
      icon: Icons.plumbing_rounded,
      color: Color(0xFF0D9488),
    ),
    ServiceCategory(
      id: 'electrical',
      title: 'Kelistrikan',
      description: 'Perbaikan korsleting, tambah titik lampu & instalasi saklar',
      icon: Icons.bolt_rounded,
      color: Color(0xFFF59E0B),
    ),
    ServiceCategory(
      id: 'cleaning',
      title: 'Bersih Rumah',
      description: 'Deep cleaning, cuci sofa/kasur, sedot tungau & fogging',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFF10B981),
    ),
    ServiceCategory(
      id: 'appliance',
      title: 'Alat Elektronik',
      description: 'Reparasi mesin cuci, kulkas, microwave & pompa air',
      icon: Icons.kitchen_rounded,
      color: Color(0xFF6366F1),
    ),
    ServiceCategory(
      id: 'carpentry',
      title: 'Renovasi & Tukang',
      description: 'Bocor atap/plafon, pasang keramik, perbaikan kusen & pintu',
      icon: Icons.home_repair_service_rounded,
      color: Color(0xFF8B5CF6),
    ),
    ServiceCategory(
      id: 'locksmith',
      title: 'Ahli Kunci',
      description: 'Buka pintu terkunci, ganti silinder & pasang smart lock',
      icon: Icons.key_rounded,
      color: Color(0xFFEC4899),
    ),
    ServiceCategory(
      id: 'painting',
      title: 'Pengecatan',
      description: 'Cat dinding interior, eksterior rumah & cat pagar anti karat',
      icon: Icons.format_paint_rounded,
      color: Color(0xFFF97316),
    ),
  ];

  // Daftar Layanan Lengkap (Harga Standar Indonesia)
  static const List<ServiceItem> services = [
    ServiceItem(
      id: 'srv-ac-1',
      categoryId: 'ac',
      title: 'Cuci AC Standard (0.5 - 2 PK)',
      subtitle: 'Pembersihan evaporator, filter, blower, & outdoor unit',
      price: 75000,
      unit: 'per unit',
      rating: 4.9,
      totalReviews: 342,
      estimatedDurationMinutes: 45,
      description:
          'Layanan cuci AC menyeluruh menggunakan steam cleaner bertekanan tinggi. Termasuk pembersihan filter debu, evaporator indoor, baling-baling blower, pipa pembuangan, dan kondensor outdoor.',
      includes: [
        'Pembersihan filter debu & cover AC indoor',
        'Steam cuci evaporator & talang air',
        'Penyemprotan pembuangan air (mencegah tetesan bocor)',
        'Pembersihan unit outdoor/kondensor',
        'Pengecekan arus listrik & tekanan freon gratis',
      ],
      warrantyPeriod: 'Garansi 30 Hari',
      isPopular: true,
      isEmergencyAvailable: false,
    ),
    ServiceItem(
      id: 'srv-ac-2',
      categoryId: 'ac',
      title: 'Tambah / Isi Freon R32 / R410A',
      subtitle: 'Pengisian ulang freon AC dingin maksimal & ramah lingkungan',
      price: 150000,
      unit: 'per unit',
      rating: 4.8,
      totalReviews: 189,
      estimatedDurationMinutes: 30,
      description:
          'Pengisian ulang gas refrigerant freon original tipe R32, R410A, atau R22 untuk mengembalikan dingin maksimal AC Anda.',
      includes: [
        'Pengecekan manifold pressure freon',
        'Deteksi kebocoran pipa tembaga',
        'Pengisian freon berkualitas tinggi berstandar pabrik',
        'Uji suhu hembusan angin AC',
      ],
      warrantyPeriod: 'Garansi 45 Hari',
      isPopular: true,
      isEmergencyAvailable: false,
    ),
    ServiceItem(
      id: 'srv-pipe-1',
      categoryId: 'plumbing',
      title: 'Perbaikan Pipa Bocor & Rembes',
      subtitle: 'Penambalan pipa PVC/PPR bocor, sambungan kran & got mampet',
      price: 120000,
      unit: 'per titik',
      rating: 4.9,
      totalReviews: 275,
      estimatedDurationMinutes: 60,
      description:
          'Penanganan cepat kebocoran pipa air bersih maupun air kotor di dinding, bawah lantai, atau plafon rumah. Menggunakan teknik sambung pipa berkualitas tinggi anti bocor kembali.',
      includes: [
        'Deteksi titik kebocoran pipa secara akurat',
        'Penyambungan pipa dengan fitting pipa standar SNI',
        'Pembersihan area pengerjaan setelah selesai',
        'Uji tekanan air setelah instalasi',
      ],
      warrantyPeriod: 'Garansi 60 Hari',
      isPopular: true,
      isEmergencyAvailable: true,
    ),
    ServiceItem(
      id: 'srv-elec-1',
      categoryId: 'electrical',
      title: 'Perbaikan Korsleting Listrik Darurat',
      subtitle: 'Pencarian sumber MCB anjlok, kabel terbakar & gangguan daya',
      price: 135000,
      unit: 'per kasus',
      rating: 4.9,
      totalReviews: 210,
      estimatedDurationMinutes: 45,
      description:
          'Layanan siaga darurat teknisi kelistrikan bersertifikasi AKLI. Menangani MCB sering jeglek, bau kabel hangus, stop kontak meletup, dan instalasi jalur kabel baru yang aman.',
      includes: [
        'Pemeriksaan instalasi panel MCB',
        'Uji grounding & isolasi kabel',
        'Perbaikan titik kabel konslet',
        'Saran pembebanan daya listrik aman',
      ],
      warrantyPeriod: 'Garansi 30 Hari',
      isPopular: true,
      isEmergencyAvailable: true,
    ),
    ServiceItem(
      id: 'srv-clean-1',
      categoryId: 'cleaning',
      title: 'Deep Cleaning Kasur & Sofa (Sedot Tungau)',
      subtitle: 'Hydro vacuum extraction & sanitasi bakteri ramah anak/hewan',
      price: 95000,
      unit: 'per kasur/sofa',
      rating: 4.8,
      totalReviews: 418,
      estimatedDurationMinutes: 60,
      description:
          'Pembersihan kasur springbed atau sofa dari debu, tungau, dan bakteri menggunakan mesin hydro-cleaning khusus. Membuat tidur keluarga lebih nyaman dan bebas alergi.',
      includes: [
        'Dry vacuuming debu & mikropartikel',
        'Sedot tungau hingga kedalaman 20cm',
        'Wet shampooing penghilang noda ringan',
        'Semprotan aroma terapi lavender sanitasi',
      ],
      warrantyPeriod: 'Kepuasan 100%',
      isPopular: true,
      isEmergencyAvailable: false,
    ),
    ServiceItem(
      id: 'srv-lock-1',
      categoryId: 'locksmith',
      title: 'Buka Pintu Terkunci / Rusak (Darurat 24 Jam)',
      subtitle: 'Penanganan kunci tertinggal di dalam tanpa merusak pintu',
      price: 110000,
      unit: 'per pintu',
      rating: 4.9,
      totalReviews: 164,
      estimatedDurationMinutes: 30,
      description:
          'Ahli kunci profesional siap datang dalam 15-30 menit untuk membuka pintu rumah, kamar mandi, atau apartemen yang terkunci dari dalam dengan alat presisi tinggi.',
      includes: [
        'Teknik pick tanpa merusak handle pintu utama',
        'Pemeriksaan kondisi silinder kunci',
        'Pelumasan mekanisme silinder',
        'Pilihan penggantian silinder baru bila diperlukan',
      ],
      warrantyPeriod: 'Garansi Pengerjaan',
      isPopular: false,
      isEmergencyAvailable: true,
    ),
    ServiceItem(
      id: 'srv-carp-1',
      categoryId: 'carpentry',
      title: 'Tukang Harian / Perbaikan Atap Bocor',
      subtitle: 'Penambalan genteng pecah, pasang waterproofing & plafon jebol',
      price: 175000,
      unit: 'per titik perbaikan',
      rating: 4.7,
      totalReviews: 130,
      estimatedDurationMinutes: 90,
      description:
          'Solusi tuntas rembesan air hujan di musim hujan. Menggunakan pelapis serat fiber dan cairan waterproofing elastis kualitas terbaik.',
      includes: [
        'Pengecekan sumber rembesan di dak / genteng',
        'Pemasangan kasa serat & pelapis waterproofing',
        'Perapian sambungan talang seng / PVC',
      ],
      warrantyPeriod: 'Garansi 90 Hari',
      isPopular: false,
      isEmergencyAvailable: true,
    ),
    ServiceItem(
      id: 'srv-app-1',
      categoryId: 'appliance',
      title: 'Servis Mesin Cuci (1 & 2 Tabung)',
      subtitle: 'Air tidak keluar, mesin berisik, tidak berputar, atau modul error',
      price: 125000,
      unit: 'per unit',
      rating: 4.8,
      totalReviews: 95,
      estimatedDurationMinutes: 60,
      description:
          'Perbaikan mesin cuci top loading dan front loading semua merk ternama (Samsung, LG, Sharp, Panasonic, Polytron).',
      includes: [
        'Pengecekan dinamo motor & v-belt',
        'Pemeriksaan selenoid valve & sensor water level',
        'Pembersihan filter kotoran saluran buang',
      ],
      warrantyPeriod: 'Garansi 30 Hari',
      isPopular: false,
      isEmergencyAvailable: false,
    ),
  ];

  // Daftar Teknisi & Mitra Berlisensi Indonesia
  static const List<Professional> professionals = [
    Professional(
      id: 'pro-1',
      name: 'Budi Santoso',
      role: 'Spesialis Servis AC & Pendingin Ruangan',
      avatarUrl: 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?w=400&auto=format&fit=crop&q=80',
      rating: 4.95,
      totalReviews: 248,
      completedJobs: 412,
      experienceYears: 8,
      city: 'Jakarta Selatan',
      area: 'Kebayoran Baru & Senopati',
      latitude: -6.2382,
      longitude: 106.8115,
      hourlyRate: 85000,
      isVerified: true,
      isAvailableNow: true,
      bio:
          'Teknisi bersertifikat BNSP pendingin ruangan dengan pengalaman lebih dari 8 tahun di Jakarta. Bekerja rapi, membawa peralatan lengkap, dan selalu mengutamakan kebersihan rumah pelanggan.',
      skills: ['Cuci AC Split/Inverter', 'Isi Freon R32/R410A', 'Bongkar Pasang AC', 'Deteksi Kebocoran Pipa'],
      phone: '+62 812-8899-2311',
    ),
    Professional(
      id: 'pro-2',
      name: 'Joko Prasetyo',
      role: 'Ahli Pipa, Pompa Air & Saluran Mampet',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80',
      rating: 4.92,
      totalReviews: 184,
      completedJobs: 320,
      experienceYears: 10,
      city: 'Jakarta Pusat',
      area: 'Menteng & Sudirman',
      latitude: -6.2000,
      longitude: 106.8229,
      hourlyRate: 90000,
      isVerified: true,
      isAvailableNow: true,
      bio:
          'Spesialis penanganan pipa bocor darurat dan instalasi toren otomatis. Cepat tanggap dalam kondisi pipa pecah atau pompa air mati total di kawasan Jakarta.',
      skills: ['Pipa Bocor Dinding', 'Instalasi Pompa Booster', 'Saluran Mampet Spiral', 'Water Heater'],
      phone: '+62 813-1122-8765',
    ),
    Professional(
      id: 'pro-3',
      name: 'Asep Hidayat',
      role: 'Teknisi Kelistrikan & Panel Rumah Tangga',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80',
      rating: 4.88,
      totalReviews: 142,
      completedJobs: 260,
      experienceYears: 6,
      city: 'Bandung',
      area: 'Dago & Sukajadi',
      latitude: -6.8833,
      longitude: 107.6167,
      hourlyRate: 75000,
      isVerified: true,
      isAvailableNow: true,
      bio:
          'Lulusan SMK Teknik Elektro dengan sertifikat K3 Listrik. Menguasai instalasi rumah pintar (smart home), perbaikan korsleting, dan perapian instalasi box MCB.',
      skills: ['Uji Beban Listrik', 'Atasi MCB Jeglek', 'Pemasangan Lampu LED/Spotlight', 'Grounding Penangkal Petir'],
      phone: '+62 856-7890-1234',
    ),
    Professional(
      id: 'pro-4',
      name: 'Siti Rahmawati',
      role: 'Supervisor Deep Cleaning & Sanitasi',
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
      rating: 4.96,
      totalReviews: 310,
      completedJobs: 520,
      experienceYears: 7,
      city: 'Jakarta Barat',
      area: 'Puri Indah & Kebon Jeruk',
      latitude: -6.1882,
      longitude: 106.7582,
      hourlyRate: 80000,
      isVerified: true,
      isAvailableNow: false,
      bio:
          'Memimpin tim kebersihan berpengalaman untuk deep cleaning apartemen dan rumah tinggal. Menggunakan chemical ramah lingkungan standar hotel bintang 5.',
      skills: ['Sedot Tungau Kasur', 'Cuci Sofa Kain/Kulit', 'Pembersihan Kamar Mandi Berkerak', 'Fogging Disinfektan'],
      phone: '+62 878-3344-9988',
    ),
    Professional(
      id: 'pro-5',
      name: 'Wayan Sudarta',
      role: 'Tukang Bangunan, Atap & Interior Kayu',
      avatarUrl: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=400&auto=format&fit=crop&q=80',
      rating: 4.85,
      totalReviews: 98,
      completedJobs: 175,
      experienceYears: 12,
      city: 'Denpasar / Badung',
      area: 'Kuta, Seminyak & Sanur',
      latitude: -8.6850,
      longitude: 115.1780,
      hourlyRate: 95000,
      isVerified: true,
      isAvailableNow: true,
      bio:
          'Tukang profesional berpengalaman pengerjaan villa dan rumah tinggal di Bali. Ahli perbaikan dak rembes, plafon gypsum, dan pertukangan kayu presisi.',
      skills: ['Waterproofing Dak', 'Plafon Gypsum & Drop Ceiling', 'Pasang Keramik/Granit', 'Perbaikan Engsel & Kusen'],
      phone: '+62 819-5566-7788',
    ),
    Professional(
      id: 'pro-6',
      name: 'Rizky Pratama',
      role: 'Spesialis Ahli Kunci & Smart Door Lock',
      avatarUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=400&auto=format&fit=crop&q=80',
      rating: 4.94,
      totalReviews: 126,
      completedJobs: 215,
      experienceYears: 5,
      city: 'Surabaya',
      area: 'Gubeng & Rungkut',
      latitude: -7.2800,
      longitude: 112.7600,
      hourlyRate: 80000,
      isVerified: true,
      isAvailableNow: true,
      bio:
          'Layanan darurat kunci pintu 24 jam di Surabaya. Terampil membuka pintu mobil dan rumah yang macet tanpa merusak bodi atau cat.',
      skills: ['Buka Pintu Terkunci', 'Duplikat Kunci Berimobilizer', 'Instalasi Smart Lock Digital', 'Ganti Rumah Kunci'],
      phone: '+62 821-4455-6677',
    ),
  ];

  // Testimoni Pengguna Indonesia
  static const List<ReviewItem> sampleReviews = [
    ReviewItem(
      id: 'rev-1',
      userName: 'Dewi Lestari',
      userAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      rating: 5.0,
      date: 'Kemarin, 14:20',
      comment:
          'Pak Budi sangat rapi dan teliti! AC kamar yang awalnya cuma keluar angin sekarang dingin semriwing lagi. Ruangan juga dibersihkan setelah selesai cuci AC. Recommended banget!',
      serviceName: 'Cuci AC Standard (0.5 - 2 PK)',
    ),
    ReviewItem(
      id: 'rev-2',
      userName: 'Hendra Gunawan',
      userAvatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&auto=format&fit=crop&q=80',
      rating: 5.0,
      date: '3 hari lalu',
      comment:
          'Luar biasa cepat! Telepon darurat jam 9 malam karena pipa di dapur jebol, Mas Joko langsung meluncur dan selesai dalam 35 menit. Selamat dari banjir lokal.',
      serviceName: 'Perbaikan Pipa Bocor & Rembes',
    ),
    ReviewItem(
      id: 'rev-3',
      userName: 'Anindya Putri',
      userAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&auto=format&fit=crop&q=80',
      rating: 4.8,
      date: '1 minggu lalu',
      comment:
          'Hasil sedot tungau kasurnya kotor banget airnya padahal kasur kelihatan bersih. Anak saya alerginya jadi berkurang sejak disedot tim FineHome. Mantap!',
      serviceName: 'Deep Cleaning Kasur & Sofa',
    ),
  ];

  // Pilihan Metode Pembayaran Indonesia
  static const List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'qris',
      'name': 'QRIS (Semua E-Wallet & Bank)',
      'description': 'GoPay, OVO, DANA, BCA, Mandiri, ShopeePay',
      'icon': Icons.qr_code_scanner_rounded,
      'isPopular': true,
    },
    {
      'id': 'gopay',
      'name': 'GoPay',
      'description': 'Pembayaran instan langsung dari saldo GoPay',
      'icon': Icons.account_balance_wallet_rounded,
      'isPopular': false,
    },
    {
      'id': 'dana',
      'name': 'DANA E-Wallet',
      'description': 'Bebas biaya admin dengan DANA',
      'icon': Icons.wallet_rounded,
      'isPopular': false,
    },
    {
      'id': 'va_bca',
      'name': 'BCA Virtual Account',
      'description': 'Transfer otomatis diverifikasi 24 jam',
      'icon': Icons.account_balance_rounded,
      'isPopular': false,
    },
    {
      'id': 'va_mandiri',
      'name': 'Mandiri Livin Virtual Account',
      'description': 'Pembayaran praktis dari Livin by Mandiri',
      'icon': Icons.account_balance_rounded,
      'isPopular': false,
    },
    {
      'id': 'cash',
      'name': 'Bayar Tunai di Tempat (COD)',
      'description': 'Bayar langsung ke teknisi setelah pekerjaan selesai',
      'icon': Icons.payments_rounded,
      'isPopular': false,
    },
  ];

  // Slot Jam Pengerjaan
  static const List<String> timeSlots = [
    '08:00 - 10:00 (Pagi)',
    '10:00 - 12:00 (Siang)',
    '13:00 - 15:00 (Siang)',
    '15:00 - 17:00 (Sore)',
    '19:00 - 21:00 (Malam)',
  ];

  // Initial Mock Booking
  static Booking get sampleActiveBooking => Booking(
        id: 'FINEHOME-ID-88219',
        service: services[0],
        professional: professionals[0],
        scheduledDate: DateTime.now().add(const Duration(hours: 2)),
        timeSlot: '13:00 - 15:00 (Siang)',
        address: 'Jl. Senopati No. 42, Kebayoran Baru, Jakarta Selatan',
        city: 'DKI Jakarta',
        notes: 'Mohon bawa tangga lipat karena unit outdoor dipasang agak tinggi.',
        paymentMethod: 'QRIS',
        totalPrice: 75000,
        status: BookingStatus.teknisiMenujuLokasi,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      );
}
