import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const ServiceCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class ServiceItem {
  final String id;
  final String categoryId;
  final String title;
  final String subtitle;
  final int price; // In Rupiah
  final String unit; // e.g. "per unit", "per titik", "per jam", "per m²"
  final double rating;
  final int totalReviews;
  final int estimatedDurationMinutes;
  final String description;
  final List<String> includes;
  final String warrantyPeriod;
  final bool isPopular;
  final bool isEmergencyAvailable;

  const ServiceItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.unit,
    required this.rating,
    required this.totalReviews,
    required this.estimatedDurationMinutes,
    required this.description,
    required this.includes,
    required this.warrantyPeriod,
    this.isPopular = false,
    this.isEmergencyAvailable = false,
  });
}

class Professional {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final double rating;
  final int totalReviews;
  final int completedJobs;
  final int experienceYears;
  final String city;
  final String area;
  final double latitude;
  final double longitude;
  final int hourlyRate; // In Rupiah
  final bool isVerified;
  final bool isAvailableNow;
  final String bio;
  final List<String> skills;
  final String phone;

  const Professional({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.rating,
    required this.totalReviews,
    required this.completedJobs,
    required this.experienceYears,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    this.isVerified = true,
    this.isAvailableNow = true,
    required this.bio,
    required this.skills,
    required this.phone,
  });
}

class ReviewItem {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String date;
  final String comment;
  final String serviceName;

  const ReviewItem({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.date,
    required this.comment,
    required this.serviceName,
  });
}

enum BookingStatus {
  menungguKonfirmasi,
  teknisiMenujuLokasi,
  sedangDikerjakan,
  selesai,
  dibatalkan,
}

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.menungguKonfirmasi:
        return 'Menunggu Konfirmasi';
      case BookingStatus.teknisiMenujuLokasi:
        return 'Teknisi Menuju Lokasi';
      case BookingStatus.sedangDikerjakan:
        return 'Sedang Dikerjakan';
      case BookingStatus.selesai:
        return 'Selesai';
      case BookingStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.menungguKonfirmasi:
        return const Color(0xFFF59E0B);
      case BookingStatus.teknisiMenujuLokasi:
        return const Color(0xFF0284C7);
      case BookingStatus.sedangDikerjakan:
        return const Color(0xFF8B5CF6);
      case BookingStatus.selesai:
        return const Color(0xFF10B981);
      case BookingStatus.dibatalkan:
        return const Color(0xFFEF4444);
    }
  }
}

class Booking {
  final String id;
  final ServiceItem service;
  final Professional professional;
  final DateTime scheduledDate;
  final String timeSlot;
  final String address;
  final String city;
  final String notes;
  final String paymentMethod;
  final int totalPrice;
  final BookingStatus status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.service,
    required this.professional,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    required this.city,
    required this.notes,
    required this.paymentMethod,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  Booking copyWith({
    BookingStatus? status,
  }) {
    return Booking(
      id: id,
      service: service,
      professional: professional,
      scheduledDate: scheduledDate,
      timeSlot: timeSlot,
      address: address,
      city: city,
      notes: notes,
      paymentMethod: paymentMethod,
      totalPrice: totalPrice,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

class ChatMessage {
  final String id;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isFromUser;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isFromUser,
  });
}

class IndonesianCity {
  final String id;
  final String name;
  final String province;
  final double latitude;
  final double longitude;

  const IndonesianCity({
    required this.id,
    required this.name,
    required this.province,
    required this.latitude,
    required this.longitude,
  });
}
