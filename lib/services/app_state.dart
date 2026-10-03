import 'package:flutter/material.dart';
import '../data/indonesia_data.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    _bookings.add(IndonesiaData.sampleActiveBooking);
    _initChat();
  }

  // Selected Location
  IndonesianCity _selectedCity = IndonesiaData.cities[0];
  String _userAddress = 'Jl. Senopati No. 42, Kebayoran Baru, Jakarta Selatan';
  final String _userName = 'Aditya Pratama';
  final String _userPhone = '0812-3456-7890';
  final String _userEmail = 'aditya.pratama@email.com';

  IndonesianCity get selectedCity => _selectedCity;
  String get userAddress => _userAddress;
  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userEmail => _userEmail;

  void setCity(IndonesianCity city) {
    _selectedCity = city;
    notifyListeners();
  }

  void updateAddress(String address) {
    _userAddress = address;
    notifyListeners();
  }

  // Bookings
  final List<Booking> _bookings = [];
  List<Booking> get bookings => List.unmodifiable(_bookings);

  void addBooking(Booking booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }

  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: BookingStatus.dibatalkan);
      notifyListeners();
    }
  }

  // Favorites
  final Set<String> _favoriteServiceIds = {'srv-ac-1', 'srv-pipe-1'};
  Set<String> get favoriteServiceIds => _favoriteServiceIds;

  bool isFavorite(String serviceId) => _favoriteServiceIds.contains(serviceId);

  void toggleFavorite(String serviceId) {
    if (_favoriteServiceIds.contains(serviceId)) {
      _favoriteServiceIds.remove(serviceId);
    } else {
      _favoriteServiceIds.add(serviceId);
    }
    notifyListeners();
  }

  // Live Chat with Technician
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void _initChat() {
    _messages.addAll([
      ChatMessage(
        id: 'msg-1',
        senderName: 'Budi Santoso',
        message: 'Halo Selamat siang Pak Aditya, saya Budi teknisi AC FineHome yang ditugaskan.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isFromUser: false,
      ),
      ChatMessage(
        id: 'msg-2',
        senderName: 'Aditya Pratama',
        message: 'Siang Pak Budi. Kira-kira estimasi sampai lokasi jam berapa ya?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        isFromUser: true,
      ),
      ChatMessage(
        id: 'msg-3',
        senderName: 'Budi Santoso',
        message: 'Saat ini saya sudah di sekitar Jl. Suryo, sekitar 10 menit lagi sampai di Senopati Pak. Mohon disiapkan akses ke stop kontak dekat AC ya.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        isFromUser: false,
      ),
    ]);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _messages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        senderName: _userName,
        message: text.trim(),
        timestamp: DateTime.now(),
        isFromUser: true,
      ),
    );
    notifyListeners();

    // Auto reply simulation from Indonesian technician
    Future.delayed(const Duration(seconds: 2), () {
      _messages.add(
        ChatMessage(
          id: 'msg-reply-${DateTime.now().millisecondsSinceEpoch}',
          senderName: 'Budi Santoso',
          message: 'Baik Pak Aditya, pesan diterima. Saya segera meluncur ke lokasi sesuai titik GPS.',
          timestamp: DateTime.now(),
          isFromUser: false,
        ),
      );
      notifyListeners();
    });
  }
}
