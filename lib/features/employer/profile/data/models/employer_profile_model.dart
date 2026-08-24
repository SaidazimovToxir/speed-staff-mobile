import 'package:speed_staff_mobile/features/employer/profile/domain/entities/employer_profile.dart';

class EmployerProfileModel extends EmployerProfile {
  const EmployerProfileModel({
    super.id,
    super.userId,
    required super.restaurantName,
    super.description,
    super.logoUrl,
    super.city,
    super.district,
    super.address,
    super.latitude,
    super.longitude,
    super.phone,
    super.website,
    super.isVerified,
    super.rating,
    super.totalReviews,
    super.createdAt,
    super.updatedAt,
  });

  factory EmployerProfileModel.fromJson(Map<String, dynamic> json) {
    return EmployerProfileModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      restaurantName: json['restaurant_name'] as String? ?? json['name'] as String? ?? '',
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      totalReviews: json['total_reviews'] as int?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_name': restaurantName,
      'description': description,
      'logo_url': logoUrl,
      'city': city,
      'district': district,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'website': website,
      'is_verified': isVerified,
      'rating': rating,
      'total_reviews': totalReviews,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
