class City {
  final int id;
  final int governorateId;
  final String nameAr;
  final String nameEn;

  City({
    required this.id,
    required this.governorateId,
    required this.nameAr,
    required this.nameEn,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: int.parse(json['id']),
      governorateId: int.parse(json['governorate_id']),
      nameAr: json['city_name_ar'],
      nameEn: json['city_name_en'],
    );
  }
}
