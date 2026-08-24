class SkillModel {
  final int id;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String? category;

  const SkillModel({required this.id, required this.nameUz, required this.nameRu, required this.nameEn, this.category});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      nameUz: json['name_uz']?.toString() ?? '',
      nameRu: json['name_ru']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      category: json['category']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name_uz': nameUz, 'name_ru': nameRu, 'name_en': nameEn, 'category': category};
  }
}
