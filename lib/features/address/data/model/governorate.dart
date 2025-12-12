class Governorate {
  final int id;
  final String nameAr;
  final String nameEn;

  Governorate({required this.id, required this.nameAr, required this.nameEn});

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(
      id: int.parse(json['id']),
      nameAr: json['governorate_name_ar'],
      nameEn: json['governorate_name_en'],
    );
  }
}
