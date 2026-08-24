class EmployerProfile {
  final String? id;
  final String? userId;
  final String restaurantName;
  final String? description;
  final String? logoUrl;
  final String? city;
  final String? district;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? website;
  final bool? isVerified;
  final double? rating;
  final int? totalReviews;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EmployerProfile({
    this.id,
    this.userId,
    required this.restaurantName,
    this.description,
    this.logoUrl,
    this.city,
    this.district,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.website,
    this.isVerified,
    this.rating,
    this.totalReviews,
    this.createdAt,
    this.updatedAt,
  });
}
