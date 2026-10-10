# 🏠 FineHome Indonesia - On-Demand Home Services & Handyman App

<p align=center>
  <img src=https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800&auto=format&fit=crop&q=80 alt=FineHome Banner width=100% style=border-radius: 12px; max-height: 340px; object-fit: cover; />
</p>

<p align=center>
  <b>Aplikasi Pemesanan Jasa Tukang, Teknisi AC, Pipa Bocor, Kelistrikan, dan Perawatan Rumah On-Demand di Indonesia.</b>
</p>

<p align=center>
  <img src=https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter&logoColor=white />
  <img src=https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white />
  <img src=https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue />
  <img src=https://img.shields.io/badge/License-MIT-green />
</p>

---

## 🌟 Tentang FineHome
**FineHome** adalah platform layanan rumah tangga (*home maintenance & on-demand services*) modern yang dirancang khusus untuk pasar **Indonesia**. Dilengkapi dengan tarif transparan dalam Rupiah (Rp), peta interaktif kota-kota besar di Indonesia menggunakan OpenStreetMap, mitra teknisi berlisensi, sistem pembayaran lokal (QRIS, E-Wallet, Virtual Account), serta tombol **Siaga Darurat 24 Jam (SOS)**.

---

## 🚀 Fitur Utama

- 📍 **Peta Sebaran Teknisi Indonesia (lutter_map / OpenStreetMap):**
  - Radar posisi teknisi di kota-kota besar (DKI Jakarta, Bandung, Surabaya, Semarang, Denpasar/Bali, Medan).
  - Estimasi waktu tiba real-time dan jarak ke rumah pelanggan.
- 🛠️ **8+ Kategori Layanan Rumah Tangga Lengkap:**
  - **Servis AC:** Cuci AC 0.5 - 2 PK, Tambah/Isi Freon R32 & R410A (Garansi 30 Hari).
  - **Pipa & Saluran Air:** Penanganan pipa bocor dinding/plafon, kran mampet, toren air.
  - **Kelistrikan:** Perbaikan korsleting darurat, MCB jeglek, instalasi titik lampu.
  - **Bersih Rumah (Deep Cleaning):** Hydro vacuum sedot tungau kasur & sofa, fogging disinfektan.
  - **Ahli Kunci:** Buka pintu darurat tanpa merusak handle, pasang smart door lock.
  - **Renovasi & Bangunan:** Penambalan atap/dak bocor, plafon jebol, cat dinding.
  - **Servis Elektronik:** Kulkas, mesin cuci 1 & 2 tabung, pompa air.
- 🚨 **Layanan Siaga Darurat 24 Jam (SOS):**
  - Hotline cepat bebas pulsa & tombol WhatsApp darurat untuk kendala kritis (pipa jebol, korsleting listrik).
- 💳 **Metode Pembayaran Lokal Indonesia:**
  - QRIS (GoPay, OVO, DANA, ShopeePay, BCA, Mandiri).
  - E-Wallet langsung (GoPay & DANA).
  - Virtual Account Bank (BCA & Mandiri Livin).
  - Bayar Tunai di Tempat (COD) setelah pekerjaan selesai.
- 💬 **Live Chat Interaktif dengan Teknisi:**
  - Fitur obrolan langsung dilengkapi tombol pintasan pesan cepat (*quick replies*).
- 📋 **Pelacakan Status Pesanan Real-Time:**
  - Stepper status: *Menunggu Konfirmasi ➔ Teknisi Menuju Lokasi ➔ Sedang Dikerjakan ➔ Selesai*.
- 👤 **Manajemen Profil & Alamat:**
  - Penyimpanan alamat rumah dan kantor, dompet FinePay, serta kupon promo diskon.

---

## 🛠️ Tech Stack & Dependensi

| Kategori | Teknologi |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (Dart 3) |
| **State Management** | ChangeNotifier / Listenable Pattern |
| **Routing & Navigation** | [go_router](https://pub.dev/packages/go_router) |
| **Mapping & Geolocation** | [lutter_map](https://pub.dev/packages/flutter_map) + [latlong2](https://pub.dev/packages/latlong2) (OpenStreetMap Leaflet Tiles) |
| **Typography & Styling** | [google_fonts](https://pub.dev/packages/google_fonts) (*Plus Jakarta Sans*) |
| **Localization & Formatting** | [intl](https://pub.dev/packages/intl) (Format Rupiah & Tanggal Indonesia) |

---

## 💻 Panduan Menjalankan Proyek

### 1. Clone Repositori
`ash
git clone https://github.com/ahmadsafiqmasrur/finehome-app.git
cd finehome-app
`

### 2. Install Dependensi
`ash
flutter pub get
`

### 3. Jalankan Aplikasi

**Di Browser Chrome (Disarankan):**
`ash
flutter run -d chrome
`

**Di Android (Perangkat Fisik / Emulator):**
`ash
flutter run -d android
`

**Di Windows Desktop:**
`ash
flutter run -d windows
`

### 4. Build Production (Web)
`ash
flutter build web --release
`

---

## 📄 Lisensi
Didistribusikan di bawah lisensi MIT. Lihat file LICENSE untuk informasi lebih lanjut.

---

<p align=center>
 Developed with ❤️ by Ahmad Safiq Masrur.
</p>
