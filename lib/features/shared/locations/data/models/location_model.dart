class RegionModel {
  final int id;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final List<DistrictModel> districts;

  const RegionModel({
    required this.id,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    this.districts = const [],
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      nameUz: json['name_uz']?.toString() ?? '',
      nameRu: json['name_ru']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      districts: (json['districts'] as List<dynamic>?)
              ?.map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_uz': nameUz,
      'name_ru': nameRu,
      'name_en': nameEn,
      'districts': districts.map((e) => e.toJson()).toList(),
    };
  }
}

class DistrictModel {
  final String id;  // API returns '1-1', '1-2' (String, not int)
  final String nameUz;
  final String nameRu;
  final String nameEn;

  const DistrictModel({
    required this.id,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id']?.toString() ?? '',
      nameUz: json['name_uz']?.toString() ?? '',
      nameRu: json['name_ru']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_uz': nameUz,
      'name_ru': nameRu,
      'name_en': nameEn,
    };
  }
}
